# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0
# Simple tests for an adder module
import os
import random
import sys
from pathlib import Path

import cocotb
from cocotb.runner import get_runner
from cocotb.triggers import Timer

def adder_model(a: int, b: int) -> int:
    """model of adder"""
    return a + b

@cocotb.test()
async def adder_basic_test(dut):
    """Test for 5 + 10"""

    A = 5
    B = 10

    dut.A.value = A
    dut.B.value = B

    await Timer(2, units="ns")

    assert dut.X.value == adder_model(
        A, B
    ), f"Adder result is incorrect: {dut.X.value} != 15"


@cocotb.test()
async def adder_randomised_test(dut):
    """Test for adding 2 random numbers multiple times"""

    for i in range(10):

        A = random.randint(0, 15)
        B = random.randint(0, 15)

        dut.A.value = A
        dut.B.value = B

        await Timer(2, units="ns")

        assert dut.X.value == adder_model(
            A, B
        ), "Randomised test failed with: {A} + {B} = {X}".format(
            A=dut.A.value, B=dut.B.value, X=dut.X.value
        )


def test_my_design_runner():
    sim = os.getenv("SIM", "icarus")

    proj_path = Path(__file__).resolve().parent

    sources = [proj_path / "../hdl/adder.sv"]

    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel="adder",
    )

    runner.test(hdl_toplevel="adder", test_module="test_adder,")


if __name__ == "__main__":
    test_my_design_runner()