# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0
# Cocotb tests for the CompareGreaterThan module
import os
import random
from pathlib import Path

import cocotb
from cocotb.runner import get_runner
from cocotb.triggers import Timer


def compare_gt_model(in0: int, in1: int, width: int) -> int:
    """Model of signed greater-than: returns 1 if in0 > in1 else 0."""
    # Interpret as signed
    max_pos = 2**(width-1) - 1
    min_neg = -2**(width-1)
    # Convert to signed range
    def signed(val):
        if val > max_pos:
            val = val - 2**width
        return val
    s0 = signed(in0)
    s1 = signed(in1)
    return 1 if s0 > s1 else 0


@cocotb.test()
async def compare_gt_basic_test(dut):
    """Basic tests for CompareGreaterThan."""
    width = len(dut.in0)

    tests = [
        (0, 0),
        (1, 0),
        (0, 1),
        (2**(width-1)-1, -(2**(width-1))),  # max_pos > min_neg
        (-(2**(width-1)), 0),               # min_neg not > 0
    ]
    for idx, (a, b) in enumerate(tests, start=1):
        dut._log.info(f"[Basic {idx}] in0={a if a<2**(width-1)else a-2**width} (raw {a}), in1={b if b<2**(width-1)else b-2**width} (raw {b})")
        dut.in0.value = a
        dut.in1.value = b
        await Timer(2, units="ns")
        out = int(dut.cmp_out.value)
        exp = compare_gt_model(a, b, width)
        dut._log.info(f"[Basic {idx}] cmp_out={out}, expected={exp}")
        assert out == exp, f"Test {idx} failed: {a} > {b}? => {out} != {exp}"


@cocotb.test()
async def compare_gt_randomised_test(dut):
    """Randomised test for 32 iterations."""
    width = len(dut.in0)
    for i in range(32):
        a = random.randint(0, 2**width - 1)
        b = random.randint(0, 2**width - 1)
        dut._log.info(f"[Random {i+1}] in0=raw {a}, in1=raw {b}")
        dut.in0.value = a
        dut.in1.value = b
        await Timer(2, units="ns")
        out = int(dut.cmp_out.value)
        exp = compare_gt_model(a, b, width)
        dut._log.info(f"[Random {i+1}] cmp_out={out}, expected={exp}")
        assert out == exp, f"Random test {i+1} failed: raw {a} > raw {b}? => {out} != {exp}"


def test_my_design_runner():
    sim = os.getenv("SIM", "verilator")
    proj_path = Path(__file__).resolve().parent
    sources = [proj_path / "../hdl/CompareGt.sv"]

    print(f"Building CompareGreaterThan with simulator={sim}")
    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel="CompareGt",
    )
    runner.test(
        hdl_toplevel="CompareGt",
        test_module="test_CompareGt",
    )


if __name__ == "__main__":
    test_my_design_runner()
