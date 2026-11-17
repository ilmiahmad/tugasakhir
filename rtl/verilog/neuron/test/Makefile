# This file is public domain, it can be freely copied without restrictions.
# SPDX-License-Identifier: CC0-1.0

# Makefile

# defaults
SIM ?= verilator
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += $(PWD)/../hdl/LIF.sv
VERILOG_SOURCES += $(PWD)/../hdl/LIFDataPath.sv
VERILOG_SOURCES += $(PWD)/../hdl/LIFControlUnit.sv

VERILOG_SOURCES += $(PWD)/../../common/hdl/RegSync.sv
VERILOG_SOURCES += $(PWD)/../../common/hdl/MuxN.sv
VERILOG_SOURCES += $(PWD)/../../common/hdl/Shifter.sv
VERILOG_SOURCES += $(PWD)/../../common/hdl/AddSub.sv
VERILOG_SOURCES += $(PWD)/../../common/hdl/CompareGt.sv
VERILOG_SOURCES += $(PWD)/../../common/hdl/AndMask.sv

VERILOG_SOURCES += $(PWD)/../../weights/hdl/ROM5x10.sv
VERILOG_SOURCES += $(PWD)/../../weights/hdl/ROM5x10Split.sv
# use VHDL_SOURCES for VHDL files

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = LIF

# MODULE is the basename of the Python test file(s)
MODULE = test_LIF

EXTRA_ARGS += --trace --trace-structs

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim