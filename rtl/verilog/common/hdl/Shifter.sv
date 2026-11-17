module Shifter #(
  parameter WIDTH = 8,
  parameter SHIFT = 2
)(
  input logic signed [WIDTH-1:0] shifter_in,
  output logic signed [WIDTH-1:0] shifted_out
);

  assign shifted_out = shifter_in >>> SHIFT;  // Arithmetic shift

endmodule
