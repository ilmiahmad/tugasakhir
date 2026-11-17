// Auto-generated ROM split module: ROM15x10Split
// Wraps ROM15x10 and splits its 80-bit output into 10x8-bit outputs
// Also provides the full 'total' output

module ROM15x10Split (
  input  logic                   clk,
  input  logic                   rst,
  input  logic [3:0] addr,
  output logic [7:0]             dout [9:0]

);

  logic [79:0] rom_data;

  // Instantiate base ROM
  ROM15x10 rom_inst (
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
