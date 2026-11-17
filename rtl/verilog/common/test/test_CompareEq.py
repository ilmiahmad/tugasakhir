# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0
# Cocotb tests for the CompareEqual module
import os
import random
from pathlib import Path

import cocotb
from cocotb.runner import get_runner
from cocotb.triggers import Timer


def compare_equal_model(in0: int, in1: int) -> int:
    """Model of CompareEqual: returns 1 if inputs are equal, else 0."""
    return 1 if in0 == in1 else 0


@cocotb.test()
async def compare_equal_basic_test(dut):
    """Basic test: verify eq and neq cases."""
    # Test equal case
    dut._log.info("[Basic Test] Checking equal inputs")
    dut.in0.value = 2
    dut.in1.value = 2
    await Timer(2, units="ns")
    out = int(dut.cmp_out.value)
    dut._log.info(f"[Basic Test] in0=2, in1=2 => cmp_out={out}")
    assert out == compare_equal_model(2, 2), f"Expected 1, got {out}"

    # Test not equal case
    dut._log.info("[Basic Test] Checking non-equal inputs")
    dut.in0.value = 1
    dut.in1.value = 3
    await Timer(2, units="ns")
    out = int(dut.cmp_out.value)
    dut._log.info(f"[Basic Test] in0=1, in1=3 => cmp_out={out}")
    assert out == compare_equal_model(1, 3), f"Expected 0, got {out}"


@cocotb.test()
async def compare_equal_randomised_test(dut):
    """Randomised test: verify for 16 random pairs."""
    # Determine bitwidth from dut port; assume width bits
    width = len(dut.in0)
    max_val = 2**width - 1
    for i in range(16):
        a = random.randint(0, max_val)
        b = random.randint(0, max_val)
        dut._log.info(f"[Random Test {i+1}] in0=0x{a:X}, in1=0x{b:X}")
        dut.in0.value = a
        dut.in1.value = b
        await Timer(2, units="ns")
        out = int(dut.cmp_out.value)
        exp = compare_equal_model(a, b)
        dut._log.info(f"[Random Test {i+1}] cmp_out={out}, expected={exp}")
        assert out == exp, \
            f"Mismatch: {a} == {b}? => {out} != {exp}"


def test_my_design_runner():
    sim = os.getenv("SIM", "verilator")
    proj_path = Path(__file__).resolve().parent
    sources = [proj_path / "../hdl/CompareEq.sv"]

    print(f"Building CompareEqual with simulator={sim}")
    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel="CompareEq",
    )
    runner.test(
        hdl_toplevel="CompareEq",
        test_module="test_CompareEq",
    )


if __name__ == "__main__":
    test_my_design_runner()
