// Auto-generated ROM split module: ROM64x3Split
// Wraps ROM64x3 and splits its 24-bit output into 3x8-bit outputs
// Also provides the full 'total' output

module ROM64x3Split (
  input  logic                   clk,
  input  logic                   rst,
  input  logic [5:0] addr,
  output logic [7:0]             dout [2:0]

);

  logic [23:0] rom_data;

  // Instantiate base ROM
  ROM64x3 rom_inst (
    .clk   (clk),
    .rst   (rst),
    .addr  (addr),
    .data  (rom_data)
  );

  // Split into 8-bit chunks (MSB-first)
  genvar i;
  generate
    for (i = 0; i < 3; i++) begin
      assign dout[i] = rom_data[23 - 8*i -: 8];
    end
  endgenerate


endmodule
