module AndMask #(
  parameter int WIDTH = 8
) (
  input  logic [WIDTH-1:0]  input_bits,
  input  logic              mask_bit,
  output logic [WIDTH-1:0]  output_bits
);

  // Combinational mask logic
  assign output_bits = mask_bit ? input_bits : '0;

endmodule
