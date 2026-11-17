
module MuxN #(
  parameter int WIDTH      = 8,
  parameter int N          = 2,
  // Ensure at least 1-bit select width
  parameter int SEL_WIDTH  = (N > 1) ? $clog2(N) : 1
) (
  // Array of N input buses
  input  logic [WIDTH-1:0] in  [N],
  // Selection signal
  input  logic [SEL_WIDTH-1:0] sel,
  // Output bus
  output logic [WIDTH-1:0]      out
);

  // Combinational multiplexer logic
  assign out = in[sel];

endmodule
