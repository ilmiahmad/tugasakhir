module OrN #(
  parameter int WIDTH = 4  // Default number of inputs
)(
  input  logic [WIDTH-1:0] in,
  output logic         out
);

  always_comb begin
    out = |in;  // Reduction OR
  end

endmodule
