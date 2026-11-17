// -----------------------------------------------------------------------------
// Top-level LIF neuron module
// -----------------------------------------------------------------------------
module LIF #(
  parameter int WIDTH     = 16,
  parameter int SHIFT     = 8
) (
  input  logic         clk,
  input  logic         rst,
  input  logic         restart,
  input  logic         exc,
  input  logic         leak,
  input  logic         exc_spike,
  input  logic signed [WIDTH-1:0] v_th,
  input  logic signed [WIDTH-1:0] exc_weight,

  output logic         neuron_ready,
  output logic         out_spike
);
  logic [1:0] update_sel;
  logic       add_or_sub, v_en, v_rst, exceed_v_th;
  logic signed [WIDTH-1:0] masked_exc, v;
  
  AndMask #(.WIDTH(WIDTH)) mask_inst (
    .input_bits (exc_weight),
    .mask_bit   (exc_spike),
    .output_bits(masked_exc)
  );

  LIFControlUnit #(.WIDTH(WIDTH)) ctrl (
    .clk         (clk),
    .rst         (rst),
    .restart     (restart),
    .exc         (exc),
    .leak        (leak),
    .exceed_v_th (exceed_v_th),
    .exc_spike   (exc_spike),
    .update_sel  (update_sel),
    .add_or_sub  (add_or_sub),
    .v_en        (v_en),
    .v_rst       (v_rst),
    .neuron_ready(neuron_ready),
    .out_spike   (out_spike)
  );

  LIFDataPath #(.WIDTH(WIDTH), .SHIFT(SHIFT)) dp (
    .clk          (clk),
    .rst          (rst),
    .v_th         (v_th),
    .exc_weight   (masked_exc),
    .update_sel   (update_sel),
    .add_or_sub   (add_or_sub),
    .v_en         (v_en),
    .v_rst        (v_rst),
    .exceed_v_th  (exceed_v_th),
    .v            (v)
  );
endmodule
