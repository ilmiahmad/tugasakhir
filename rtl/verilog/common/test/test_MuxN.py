# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0
# Cocotb tests for the MuxN module (fixed reserved keyword usage)
import os
import random
from pathlib import Path

import cocotb
from cocotb.runner import get_runner
from cocotb.triggers import Timer


def muxn_model(inputs, sel):
    """Model of N-input mux: output = inputs[sel]"""
    return inputs[sel]


@cocotb.test()
async def muxn_basic_test(dut):
    """Basic test for default parameters (WIDTH=8, N=2)"""
    # Access the port named 'in' via getattr to avoid Python keyword
    in_ports = getattr(dut, "in")

    # Extract parameters
    N = len(in_ports)
    WIDTH = len(in_ports[0])

    # Prepare two distinct test patterns
    inputs = [0xAA, 0x55] if N >= 2 else [0xFF]

    # Apply and test sel=0
    sel0 = 0
    dut._log.info(f"[Basic] Applying inputs={inputs} sel={sel0}")
    for idx, val in enumerate(inputs):
        in_ports[idx].value = val
    dut.sel.value = sel0
    await Timer(2, units="ns")
    out0 = int(dut.out.value)
    exp0 = muxn_model(inputs, sel0)
    dut._log.info(f"[Basic] Output=0x{out0:02X}, expected=0x{exp0:02X}")
    assert out0 == exp0, f"MuxN basic failed: sel={sel0} => {out0} != {exp0}"

    # Apply and test sel=1 (if exists)
    if N > 1:
        sel1 = 1
        dut._log.info(f"[Basic] Applying inputs={inputs} sel={sel1}")
        for idx, val in enumerate(inputs):
            in_ports[idx].value = val
        dut.sel.value = sel1
        await Timer(2, units="ns")
        out1 = int(dut.out.value)
        exp1 = muxn_model(inputs, sel1)
        dut._log.info(f"[Basic] Output=0x{out1:02X}, expected=0x{exp1:02X}")
        assert out1 == exp1, f"MuxN basic failed: sel={sel1} => {out1} != {exp1}"


@cocotb.test()
async def muxn_randomised_test(dut):
    """Randomised test for various input sets and selectors."""
    in_ports = getattr(dut, "in")
    N = len(in_ports)
    WIDTH = len(in_ports[0])
    max_val = 2**WIDTH - 1

    for i in range(20):
        inputs = [random.randint(0, max_val) for _ in range(N)]
        sel = random.randint(0, N-1)
        dut._log.info(f"[Random {i+1}] inputs={[hex(x) for x in inputs]} sel={sel}")
        for idx, val in enumerate(inputs):
            in_ports[idx].value = val
        dut.sel.value = sel
        await Timer(2, units="ns")

        out = int(dut.out.value)
        exp = muxn_model(inputs, sel)
        dut._log.info(f"[Random {i+1}] Output=0x{out:02X}, expected=0x{exp:02X}")
        assert out == exp, f"MuxN random test {i+1} failed: sel={sel}, out={out} != {exp}"


def test_my_design_runner():
    sim = os.getenv("SIM", "verilator")
    proj_path = Path(__file__).resolve().parent
    sources = [proj_path / "../hdl/MuxN.sv"]

    print(f"Building MuxN with simulator={sim} and sources={sources}")
    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel="MuxN",
    )
    runner.test(
        hdl_toplevel="MuxN",
        test_module="test_MuxN",
    )


if __name__ == "__main__":
    test_my_design_runner()
