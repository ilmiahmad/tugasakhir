import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer


@cocotb.test()
async def test_snn_basic(dut):
    """Basic test for the snn module."""

    # Create clock (10ns period = 100 MHz)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset logic
    dut.rst.value = 1
    dut.start.value = 0
    dut.restart.value = 0
    dut.sample_ready.value = 0
    dut.in_spikes.value = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst.value = 0

    # Apply stimulus
    dut.sample_ready.value = 1
    dut.start.value = 1
    dut.in_spikes.value = 0b10101  # Example spikes pattern

    await RisingEdge(dut.clk)
    dut.start.value = 0  # Deassert start after one cycle

    # Wait for 'ready' and 'sample' signals
    for _ in range(100):  # Max 100 clock cycles
        await RisingEdge(dut.clk)
        if dut.ready.value == 1 and dut.sample.value == 1:
            break

    # Print output for observation
    cocotb.log.info(f"out_spikes: {dut.out_spikes.value}")
    # assert dut.ready.value == 1, "Ready should be high"
    # assert dut.sample.value == 1, "Sample should be high"
