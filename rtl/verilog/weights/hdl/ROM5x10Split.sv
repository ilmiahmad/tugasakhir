// Auto-generated ROM split module: ROM5x10Split
// Wraps ROM5x80 and splits its 80-bit output into 10x8-bit outputs

module ROM5x10Split (
  input  logic                   clk,
  input  logic                   rst,
  input  logic [2:0] addr,
  output logic [7:0]             dout [9:0]
);

  logic [79:0] rom_data;

  // Instantiate base ROM
  ROM5x80 rom_inst (
    .clk   (clk),
    .rst   (rst),
    .addr  (addr),
    .data  (rom_data)
  );

  // Split into 8-bit chunks (MSB-first)
  genvar i;
  generate
    for (i = 0; i < 10; i++) begin
      assign dout[i] = rom_data[79 - 8*i -: 8];
    end
  endgenerate

endmodule
