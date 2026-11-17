module ENMuxN #(
  parameter int N = 4,                    // Number of inputs
  parameter int WIDTH = 8                 // Bit-width of each input
)(
  input  logic [N-1:0][WIDTH-1:0] in,    // N inputs, each WIDTH-bit
  input  logic [$clog2(N)-1:0]    sel,    // Select line
  input  logic                    en,     // Enable signal
  output logic [WIDTH-1:0]        out     // Output
);

  always_comb begin
    if (en)
      out = in[sel];
    else
      out = 1'b0;
  end

endmodule
