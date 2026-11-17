# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0
# Simple tests for the AndMask module with enhanced logging
import os
import random
from pathlib import Path

import cocotb
from cocotb.runner import get_runner
from cocotb.triggers import Timer


def andmask_model(input_bits: int, mask_bit: int) -> int:
    """Model of AndMask: pass input when mask=1, else zero."""
    return input_bits if mask_bit else 0


@cocotb.test()
async def andmask_basic_test(dut):
    """Basic test: mask=1 passes input; mask=0 zeros output."""
    A = 0xA5  # example value
    dut._log.info(f"[Basic Test] Starting with input_bits=0x{A:02X}")

    # Test pass-through
    dut._log.info("[Basic Test] Applying mask_bit=1 (pass-through)")
    dut.input_bits.value = A
    dut.mask_bit.value = 1
    await Timer(10, units="ns")
    out1 = int(dut.output_bits.value)
    dut._log.info(f"[Basic Test] Output: 0x{out1:02X}")
    assert out1 == andmask_model(A, 1), \
        f"AndMask failed for mask=1: {out1} != {andmask_model(A,1)}"

    # Test zeroing
    dut._log.info("[Basic Test] Applying mask_bit=0 (zeroing)")
    dut.mask_bit.value = 0
    await Timer(10, units="ns")
    out0 = int(dut.output_bits.value)
    dut._log.info(f"[Basic Test] Output: 0x{out0:02X}")
    assert out0 == andmask_model(A, 0), \
        f"AndMask failed for mask=0: got {out0}, expected 0"


@cocotb.test()
async def andmask_randomised_test(dut):
    """Randomised test: verify for 10 random inputs with logging."""
    for i in range(10):
        A = random.randint(0, 2**8 - 1)
        M = random.randint(0, 1)
        dut._log.info(f"[Random Test {i+1}] Applying input_bits=0x{A:02X}, mask_bit={M}")

        dut.input_bits.value = A
        dut.mask_bit.value = M
        await Timer(10, units="ns")

        out = int(dut.output_bits.value)
        expected = andmask_model(A, M)
        dut._log.info(f"[Random Test {i+1}] Output: 0x{out:02X}, Expected: 0x{expected:02X}")
        assert out == expected, \
            f"Random test failed: input=0x{A:02X}, mask={M} => {out} != {expected}"


def test_my_design_runner():
    sim = os.getenv("SIM", "verilator")
    proj_path = Path(__file__).resolve().parent
    sources = [proj_path / "../hdl/AndMask.sv"]

    # Log runner configuration
    print(f"Building AndMask with simulator={sim} and sources={sources}")

    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel="AndMask",
        
    )
    runner.test(
        hdl_toplevel="AndMask",
        test_module="test_AndMask",
    )


if __name__ == "__main__":
    test_my_design_runner()
