// Auto-generated ROM split module: ROM5x15Split
// Wraps ROM5x15 and splits its 120-bit output into 15x8-bit outputs
// Also provides the full 'total' output

module ROM5x15Split (
  input  logic                   clk,
  input  logic                   rst,
  input  logic [2:0] addr,
  output logic [7:0]             dout [14:0]

);

  logic [119:0] rom_data;

  // Instantiate base ROM
  ROM5x15 rom_inst (
    .clk   (clk),
    .rst   (rst),
    .addr  (addr),
    .data  (rom_data)
  );

  // Split into 8-bit chunks (MSB-first)
  genvar i;
  generate
    for (i = 0; i < 15; i++) begin
      assign dout[i] = rom_data[119 - 8*i -: 8];
    end
  endgenerate


endmodule
