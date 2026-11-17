module Reg #(
  parameter WIDTH = 16
) (
  input  logic        clk,
  input  logic        rst,   // synchronous active-high reset
  input  logic [WIDTH-1:0] in,    // data input
  output logic [WIDTH-1:0] out     // data output
);

  // Internal register
  logic [WIDTH-1:0] reg_out;

  // Synchronous register with enable and reset
  always_ff @(posedge clk) begin
    if (rst) begin
      reg_out <= '0;
    end
    reg_out <= in;
  end

  // Output assignment
  assign out = reg_out;

endmodule
