module CompareEq #(
  parameter int WIDTH = 2
) (
  input  logic signed[WIDTH-1:0] in0,
  input  logic signed[WIDTH-1:0] in1,
  output logic               cmp_out
);

  // Combinational comparison logic
  assign cmp_out = (in0 == in1) ? 1'b1 : 1'b0;

endmodule
