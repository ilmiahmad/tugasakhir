// Auto-generated ROM split module: ROM64x32Split
// Wraps ROM64x32 and splits its 256-bit output into 32x8-bit outputs
// Also provides the full 'total' output

module ROM64x32Split (
  input  logic                   clk,
  input  logic                   rst,
  input  logic [5:0] addr,
  output logic [7:0]             dout [31:0]

);

  logic [255:0] rom_data;

  // Instantiate base ROM
  ROM64x32 rom_inst (
    .clk   (clk),
    .rst   (rst),
    .addr  (addr),
    .data  (rom_data)
  );

  // Split into 8-bit chunks (MSB-first)
  genvar i;
  generate
    for (i = 0; i < 32; i++) begin
      assign dout[i] = rom_data[255 - 8*i -: 8];
    end
  endgenerate


endmodule
