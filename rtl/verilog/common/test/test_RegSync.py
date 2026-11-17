# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0
# Cocotb tests for the RegSync module (updated to wait extra cycle when loading)
import os
import random
from pathlib import Path

import cocotb
from cocotb.triggers import Timer, RisingEdge
from cocotb.clock import Clock
from cocotb.runner import get_runner


def regsync_model(prev_q, d, en, rst):
    """Model for synchronous register with enable and reset."""
    if rst:
        return 0
    return d if en else prev_q


@cocotb.test()
async def regsync_basic_test(dut):
    """Basic test: reset behavior, enable update, and hold when disabled."""
    # Start clock
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # Assert reset for two cycles
    dut.rst.value = 1
    dut.en.value = 0
    dut.d.value = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut._log.info("[Basic] After reset cycles")
    assert int(dut.q.value) == 0, "Reset did not clear register"

    # Release reset and apply new data with enable
    test_val = 0xA5
    dut.rst.value = 0
    dut.en.value = 1
    dut.d.value = test_val
    dut._log.info(f"[Basic] Applying en=1, d=0x{test_val:02X}")
    await RisingEdge(dut.clk)  # first edge to latch new d/en
    await RisingEdge(dut.clk)  # second edge to update output q
    out = int(dut.q.value)
    dut._log.info(f"[Basic] q=0x{out:02X}")
    assert out == test_val, "Register did not load input when enabled"

    # Test hold when disabled
    hold_val = 0x5A
    dut.en.value = 0
    dut.d.value = hold_val
    dut._log.info(f"[Basic] Applying en=0, d changes to 0x{hold_val:02X} (should hold prev)")
    await RisingEdge(dut.clk)
    out2 = int(dut.q.value)
    dut._log.info(f"[Basic] q=0x{out2:02X}")
    assert out2 == test_val, "Register did not hold value when disabled"


@cocotb.test()
async def regsync_randomised_test(dut):
    """Randomised test: verify behavior over multiple cycles."""
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # Release reset
    dut.rst.value = 0
    expected = 0

    # Run random sequences over 20 cycles
    for i in range(20):
        en = random.randint(0, 1)
        d = random.randint(0, 2**len(dut.d) - 1)
        dut.en.value = en
        dut.d.value = d
        dut._log.info(f"[Random {i+1}] en={en}, d=0x{d:02X}, prev_q=0x{expected:02X}")

        # Wait for data to latch and propagate
        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)
        expected = regsync_model(expected, d, en, int(dut.rst.value))
        out = int(dut.q.value)
        dut._log.info(f"[Random {i+1}] q=0x{out:02X}, expected=0x{expected:02X}")
        assert out == expected, f"Mismatch at cycle {i+1}: got 0x{out:02X}, expected 0x{expected:02X}"


def test_my_design_runner():
    """Helper to run tests with a simulator via command line."""
    sim = os.getenv("SIM", "verilator")
    proj_path = Path(__file__).resolve().parent
    sources = [proj_path / "../hdl/RegSync.sv"]

    print(f"Building RegSync with simulator={sim} and sources={sources}")
    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel="RegSync",
    )
    runner.test(
        hdl_toplevel="RegSync",
        test_module="test_RegSync",
    )


if __name__ == "__main__":
    test_my_design_runner()
