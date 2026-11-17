// Auto-generated ROM split module: ROM32x64Split
// Wraps ROM32x64 and splits its 512-bit output into 64x8-bit outputs
// Also provides the full 'total' output

module ROM32x64Split (
  input  logic                   clk,
  input  logic                   rst,
  input  logic [4:0] addr,
  output logic [7:0]             dout [63:0]

);

  logic [511:0] rom_data;

  // Instantiate base ROM
  ROM32x64 rom_inst (
    .clk   (clk),
    .rst   (rst),
    .addr  (addr),
    .data  (rom_data)
  );


  // Split into 8-bit chunks (MSB-first)
  genvar i;
  generate
    for (i = 0; i < 64; i++) begin
      assign dout[i] = rom_data[511 - 8*i -: 8];
    end
  endgenerate


endmodule
