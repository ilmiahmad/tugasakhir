import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
from cocotb.handle import SimHandleBase


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


# === State Map for Logging ===
state_map = {
    0: "RESET",
    1: "IDLE_WAIT",
    2: "IDLE",
    3: "INIT_WAIT",
    4: "INIT",
    5: "SAMPLE",
    6: "EXC_WAIT",
    7: "EXC_UPDATE",
    8: "LEAK_WAIT",
    9: "SAMPLE_OUT"
}

neuron_s = {
        0b000: "RESET",
        0b001: "IDLE",
        0b010: "INIT",
        0b011: "EXCITE",
        0b101: "CHECK_FIRE",
        0b110: "LEAK"
    }

def get_state_name(state_map, value):
    return state_map.get(value, f"UNKNOWN({value})")


# === FSM Logger Coroutine ===
@cocotb.coroutine
async def log_fsm_state(dut: SimHandleBase, state_map: dict):
    while True:
        await RisingEdge(dut.clk)
        try:
            state_val = int(dut.ctrl.present_state.value)
            state_str = get_state_name(state_map, state_val)
        
            # === Layer-wide state
            layer_state_log = f"""[layer state]
- FSM State   : {state_str}
- Signals     : rst={int(dut.rst.value)}, start={int(dut.start.value)}, restart={int(dut.restart.value)}, cnt={int(dut.exc_cnt.value)}
- Exc Spikes  : {bin(int(dut.exc_spikes.value))}
- Ctrl Flags  : exc_en={int(dut.exc_en.value)}, leak_en={int(dut.leak_en.value)}, sample_en={int(dut.sample_en.value)}
- Outputs     : out_spikes={bin(int(dut.out_spikes.value))}, ready={int(dut.ready.value)}
"""

            # === Neuron 0 state (adjust hierarchy if needed)
            # These should exist: dut.dp.neuron0.v, neuron_ready[0], etc.

            state_val = int(dut.neuron_0.ctrl.present_state.value)
            state_str = get_state_name(neuron_s, state_val)

            neuron_state_log = f"""[neuron 0 state]
- FSM State   : 
- Spike In    : {int(dut.exc_spike.value)}
- W           : {to_float(int(dut.neuron_0.exc_weight.value),8, 6)}
- Membrane V  : {to_float(int(dut.neuron_0.v.value), 8, 6)}
- Spike Out   : {bin(int(dut.out_spikes.value))}

"""

            # Combine logs
            dut._log.info(f"{layer_state_log}\n{neuron_state_log}")

        except Exception as e:
            dut._log.warning(f"[FSM LOG ERROR] {e}")



# === Main Test ===
@cocotb.test()
async def test_layer0_basic(dut):
    """Basic test for Layer0 module."""

    # Start clock
    clock = Clock(dut.clk, 1, units="ns")  # 1ns period
    cocotb.start_soon(clock.start())

    # Start FSM logger
    cocotb.start_soon(log_fsm_state(dut, state_map))


    # Reset sequence
    dut.rst.value = 1
    dut.start.value = 0
    dut.restart.value = 0
    dut.exc_spikes.value = 0
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    # Wait in IDLE
    for _ in range(5):
        await RisingEdge(dut.clk)

    # === Stimulus Phase ===
    # Excitatory pattern: 5-bit input, e.g., '10101' = 0b10101 = 21
    dut.exc_spikes.value = 0b11111
    
    # Start spike processing
    dut.start.value = 1
    await RisingEdge(dut.clk)
    dut.start.value = 0

    # Let it process
    for _ in range(20):
        await RisingEdge(dut.clk)

    # Optional restart
    dut.restart.value = 1
    await RisingEdge(dut.clk)
    dut.restart.value = 0

    # Observe for a while after restart
    for _ in range(5):
        await RisingEdge(dut.clk)

    dut._log.info("Test completed.")
