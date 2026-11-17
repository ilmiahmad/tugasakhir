# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

# Makefile

# defaults
SIM ?= verilator
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += $(PWD)/RegSync.sv
VERILOG_SOURCES += $(PWD)/MuxN.sv
VERILOG_SOURCES += $(PWD)/Shifter.sv
VERILOG_SOURCES += $(PWD)/AddSub.sv
VERILOG_SOURCES += $(PWD)/CompareGt.sv
VERILOG_SOURCES += $(PWD)/CompareEq.sv
VERILOG_SOURCES += $(PWD)/AndMask.sv
VERILOG_SOURCES += $(PWD)/OrN.sv
VERILOG_SOURCES += $(PWD)/ENMuxN.sv
VERILOG_SOURCES += $(PWD)/Counter.sv

VERILOG_SOURCES += $(PWD)/ROM83x64.sv
VERILOG_SOURCES += $(PWD)/ROM83x64Split.sv

VERILOG_SOURCES += $(PWD)/ROM64x32.sv
VERILOG_SOURCES += $(PWD)/ROM64x32Split.sv

VERILOG_SOURCES += $(PWD)/ROM32x3.sv
VERILOG_SOURCES += $(PWD)/ROM32x3Split.sv

VERILOG_SOURCES += $(PWD)/LIF.sv
VERILOG_SOURCES += $(PWD)/LIFDataPath.sv
VERILOG_SOURCES += $(PWD)/LIFControlUnit.sv

VERILOG_SOURCES += $(PWD)/LayerControlUnit.sv
VERILOG_SOURCES += $(PWD)/LayerDataPath.sv

VERILOG_SOURCES += $(PWD)/NetworkControlUnit.sv
VERILOG_SOURCES += $(PWD)/NetworkDataPath.sv
VERILOG_SOURCES += $(PWD)/DataSelector.sv

VERILOG_SOURCES += $(PWD)/Layer_0.sv
VERILOG_SOURCES += $(PWD)/Layer_1.sv
VERILOG_SOURCES += $(PWD)/Layer_2.sv


VERILOG_SOURCES += $(PWD)/SNN_lat.sv


# use VHDL_SOURCES for VHDL files

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = SNN_lat

# MODULE is the basename of the Python test file(s)
MODULE = test_SNN

EXTRA_ARGS += -Wno-fatal
# EXTRA_ARGS += --trace --trace-structs -Wno-fatal
# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim