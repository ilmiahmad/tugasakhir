# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0
# Cocotb tests for the LIF neuron top-level module
import os
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
from cocotb.runner import get_runner


neuron_s = {
        0b000: "RESET",
        0b001: "IDLE",
        0b010: "INIT",
        0b011: "EXCITE",
        0b101: "CHECK_FIRE",
        0b110: "LEAK"
    }

def get_state_name(state_map, state_val):
    val = int(state_val)
    return state_map.get(val, f"UNKNOWN({val:#03b})")


@cocotb.coroutine
async def log_fsm_state(dut, state_map):
    while True:
        await RisingEdge(dut.clk)
        state_str = get_state_name(state_map, dut.ctrl.present_state.value)
        dut._log.info(f"""
        [{state_str}]
        -IN(SIG)    : rst={int(dut.rst.value)}, exc={int(dut.exc.value)}, leak={int(dut.leak.value)}
        -IN(DAT)    : spike_in={int(dut.exc_spike.value)}, weight={to_float(int(dut.exc_weight.value),8, 6)}, v_th={to_float(int(dut.v_th.value),8, 6)}
        -INTERNAL   : mem={to_float(int(dut.dp.v.value), 8, 6)}
        -OUT        : neuron_ready={int(dut.neuron_ready.value)}, out_spike={int(dut.out_spike.value)}
        """)

@cocotb.test()
async def lif_reset_and_idle(dut):
    """Test reset and idle behavior."""
    # Start clock
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())
    cocotb.start_soon(log_fsm_state(dut, neuron_s))


    dut._log.info(f"Start Test")
    
    # Initialize inputs and assert reset
    """Initialize all inputs to zero."""
    dut.restart.value    = 0
    dut.exc.value        = 0
    dut.leak.value       = 0
    dut.exc_spike.value  = 0
    dut.v_th.value       = 0
    dut.exc_weight.value = 0
    await RisingEdge(dut.clk) # 0
    assert int(dut.neuron_ready.value) == 0, "During reset, neuron_ready should be 0"
    assert int(dut.out_spike.value)  == 0, "During reset, out_spike should be 0"


    #input at time from t0 to t1
    dut.rst.value = 1
    #evaluate at rising edge t0 to t1
    await RisingEdge(dut.clk) # 1
    assert int(dut.neuron_ready.value) == 1, "During reset, neuron_ready should be 0"
    assert int(dut.out_spike.value)  == 0, "During reset, out_spike should be 0"


    dut.rst.value = 0
    await RisingEdge(dut.clk) # 2
    assert int(dut.neuron_ready.value) == 0, "During reset, neuron_ready should be 1"
    assert int(dut.out_spike.value)  == 0, "During reset, out_spike should be 0"


    dut.rst.value = 0
    # always +1 clock to evaluate last data
    await RisingEdge(dut.clk) # 3
    assert int(dut.neuron_ready.value) == 1, "During reset, neuron_ready should be 0"
    assert int(dut.out_spike.value)  == 0, "During reset, out_spike should be 0"

    # always +1 clock to evaluate last data
    await RisingEdge(dut.clk) # 3
    await RisingEdge(dut.clk) # 3

def to_float(fixed_val: int, total_bits: int, frac_bits: int, signed=True) -> float:
    """
    Convert fixed-point integer to float.

    Args:
        fixed_val (int): The fixed-point integer value.
        total_bits (int): Total number of bits in the fixed-point format.
        frac_bits (int): Number of fractional bits.
        signed (bool): Whether the value is signed or not.

    Returns:
        float: The corresponding float value.
    """
    if signed:
        # Handle two's complement if negative
        if fixed_val & (1 << (total_bits - 1)):
            fixed_val -= (1 << total_bits)
    return fixed_val / (2 ** frac_bits)


def to_fixed(value: float, total_bits: int, frac_bits: int) -> int:
    """
    Convert a float to fixed-point representation as an integer.
    
    Parameters:
        value (float): The float value to convert.
        total_bits (int): Total number of bits in the fixed-point number.
        frac_bits (int): Number of fractional bits.

    Returns:
        int: Integer representation of the fixed-point value.
    """
    scaling_factor = 1 << frac_bits  # same as 2**frac_bits
    fixed_val = int(round(value * scaling_factor))

    # Optional: wrap around for signed values
    max_val = (1 << (total_bits - 1)) - 1
    min_val = - (1 << (total_bits - 1))

    if fixed_val > max_val or fixed_val < min_val:
        raise ValueError(f"Value {value} out of range for {total_bits}-bit signed fixed-point.")

    return fixed_val


@cocotb.test()
async def lif_excitation_to_spike(dut):
    """Test neuron firing with spike pattern 10110, weight=0.2, v_th=1.0"""

    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())

    cocotb.start_soon(log_fsm_state(dut, neuron_s))

    # Configure parameters
    threshold = to_fixed(1.0, 8, 6)
    weight    = to_fixed(0.2, 8, 6)

    dut.v_th.value       = threshold
    dut.exc_weight.value = weight

    # continue from prev test
    await RisingEdge(dut.clk)

    # Input spike pattern: 1 0 1 1 0 1 1
    spike_pattern = [1, 0, 1, 1, 0, 1, 1]
    dut.exc.value = 1  # Activate excitation mode,current state [IDLE] next state [EXCITE]

    await RisingEdge(dut.clk)

    for bit in spike_pattern:
        dut.exc_spike.value = bit
        await RisingEdge(dut.clk)
    
    # Stop excitation
    dut.exc.value = 0 
    dut.exc_spike.value = 0
    await RisingEdge(dut.clk) 

    await RisingEdge(dut.clk) #transition from [EXCITE] TO [CHECK_FIRE]
    assert int(dut.out_spike.value) == 1, "Neuron should fire spike with input pattern 1011011 and weight 0.2"

    await RisingEdge(dut.clk) #transition from [CHECK_FIRE] TO [IDLE]



def test_my_design_runner():
    """Helper to run tests via command line."""
    sim = os.getenv("SIM", "verilator")
    proj_path = Path(__file__).resolve().parent
    sources = [proj_path / "../hdl/LIF.sv",
               proj_path / "../../common/hdl/RegSync.sv",
               proj_path / "../../common/hdl/MuxN.sv",
               proj_path / "../../common/hdl/Shifter.sv",
               proj_path / "../../common/hdl/AddSub.sv",
               proj_path / "../../common/hdl/CompareGt.sv",
               proj_path / "../../common/hdl/AndMask.sv"

               
               ]

    print(f"Building LIF with simulator={sim} and sources={sources}")


    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel="LIF",
    )
    runner.test(
        hdl_toplevel="LIF",
        test_module="test_LIF",
        waves=True,
        
    )


if __name__ == "__main__":
    test_my_design_runner()
