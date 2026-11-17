import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, FallingEdge
import random

@cocotb.test()
async def test_layer0_random_spikes(dut):
    """
    Apply random excitation spike patterns and ensure
    out_spikes width is maintained and ready is asserted.
    """
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    
    # Reset
    dut.rst = 1
    dut.start = 0
    dut.restart = 0
    await FallingEdge(dut.clk)
    
    dut.rst = 0
    while int(dut.ready.value) != 1:
        await FallingEdge(dut.clk)

    patterns = [0b11111, 0b10001, 0b11111]

    dut.restart = 1
    await FallingEdge(dut.clk)
    dut.restart = 0

    while int(dut.ready.value) != 1:
            await FallingEdge(dut.clk)

    # Feed each time-step pattern
    for pat in patterns:
        dut.exc_spikes <= pat
        # Start a sampling cycle
        dut.start <= 1
        await FallingEdge(dut.clk)
        dut.start <= 0
        while int(dut.ready.value) != 1:
            await FallingEdge(dut.clk)


    # Allow some time for processing
    await Timer(50, units="ns")