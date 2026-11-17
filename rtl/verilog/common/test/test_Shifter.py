# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0
# Cocotb tests for the Shifter module
import os
import random
from pathlib import Path

import cocotb
from cocotb.runner import get_runner
from cocotb.triggers import Timer


def shifter_model(val: int, width: int, shift: int) -> int:
    """Model of arithmetic right shift with sign extension."""
    mask = (1 << width) - 1
    val_masked = val & mask
    # Interpret as signed
    if val_masked & (1 << (width - 1)):
        signed = val_masked - (1 << width)
    else:
        signed = val_masked
    # Arithmetic shift right
    shifted = signed >> shift
    # Convert back to unsigned masked result
    return shifted & mask


@cocotb.test()
async def shifter_basic_test(dut):
    """Basic tests for fixed patterns."""
    width = len(dut.shifter_in)
    shift = 2  # default SHIFT parameter

    tests = [
        0xFF,  # -1 signed: remains -1
        0x80,  # -128 signed: >>2 => -32 => 0xE0
        0x7F,  # 127 signed: >>2 => 31 => 0x1F
        0x01,  # 1 >>2 => 0
        0x00,  # 0
    ]
    for idx, inp in enumerate(tests, start=1):
        dut._log.info(f"[Basic {idx}] Applying input=0x{inp:02X}")
        dut.shifter_in.value = inp
        await Timer(2, units="ns")
        out = int(dut.shifted_out.value)
        exp = shifter_model(inp, width, shift)
        dut._log.info(f"[Basic {idx}] shifted_out=0x{out:02X}, expected=0x{exp:02X}")
        assert out == exp, f"Basic test {idx} failed: {inp:02X} >>> {shift} => {out:02X} != {exp:02X}"


@cocotb.test()
async def shifter_randomised_test(dut):
    """Randomised tests over full range."""
    width = len(dut.shifter_in)
    shift = 2
    mask = (1 << width) - 1

    for i in range(20):
        inp = random.randint(0, mask)
        dut._log.info(f"[Random {i+1}] Applying input=0x{inp:02X}")
        dut.shifter_in.value = inp
        await Timer(2, units="ns")
        out = int(dut.shifted_out.value)
        exp = shifter_model(inp, width, shift)
        dut._log.info(f"[Random {i+1}] shifted_out=0x{out:02X}, expected=0x{exp:02X}")
        assert out == exp, f"Random test {i+1} failed: {inp:02X} >>> {shift} => {out:02X} != {exp:02X}"


def test_my_design_runner():
    sim = os.getenv("SIM", "verilator")
    proj_path = Path(__file__).resolve().parent
    sources = [proj_path / "../hdl/Shifter.sv"]

    print(f"Building Shifter with simulator={sim} and sources={sources}")
    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel="Shifter",
    )
    runner.test(
        hdl_toplevel="Shifter",
        test_module="test_Shifter",
    )


if __name__ == "__main__":
    test_my_design_runner()
