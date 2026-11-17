`timescale 1ns/1ps

// -----------------------------------------------------------------------------
// Top-level LIF neuron and submodules, importing common modules from common/hdl
// -----------------------------------------------------------------------------

// Include 

// `include "RegSync.sv"
// `include "MuxN.sv"
// `include "Shifter.sv"
// `include "AddSub.sv"
// `include "CompareGt.sv"
// `include "AndMask.sv"

// -----------------------------------------------------------------------------
// LIFDataPath: Data path for LIF neuron
// -----------------------------------------------------------------------------
module LIFDataPath #(
  parameter int WIDTH     = 16,
  parameter int SHIFT = 8
) (
  input  logic         clk,
  input  logic         rst,
  input  logic signed [WIDTH-1:0] v_th,
  input  logic signed [WIDTH-1:0] exc_weight,
  input  logic [1:0]           update_sel,
  input  logic                 add_or_sub,
  input  logic                 v_en,
  input  logic                 v_rst,

  output logic                 exceed_v_th,
  output logic signed [WIDTH-1:0]  v
);
  logic signed [WIDTH-1:0] v_shifted, update, v_value;

  Shifter #(.WIDTH(WIDTH), .SHIFT(SHIFT)) shifter_inst (
    .shifter_in  (v),
    .shifted_out (v_shifted)
  );

  MuxN #(.WIDTH(WIDTH), .N(3)) mux_inst (
    .in  ({v_th, v_shifted, exc_weight}),
    .sel (update_sel),
    .out (update)
  );

  AddSub #(.WIDTH(WIDTH)) addsub_inst (
    .in0       (v),
    .in1       (update),
    .add_or_sub(add_or_sub),
    .out       (v_value)
  );

  RegSync #(.WIDTH(WIDTH)) regsync_inst (
    .clk (clk),
    .rst (v_rst),
    .en  (v_en),
    .in   (v_value),
    .out   (v)
  );

  CompareGt #(.WIDTH(WIDTH)) cmp_inst (
    .in0    (v),
    .in1    (v_th),
    .cmp_out(exceed_v_th)
  );
endmodule