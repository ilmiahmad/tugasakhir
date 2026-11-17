module ROM5x10 (
  input  logic [2:0]  addr,     // 3-bit address input
  input  logic        clk,      // clock
  input  logic        rst,    // active-high reset
  output logic [79:0] data     // 120-bit output
);

  // ROM with 5 entries of 120 bits
  logic [79:0] rom [0:4];
  logic [79:0] dout;

  // Initialize the ROM contents
  initial begin
    rom[0] = 80'b11111010_10110000_00001111_00110111_00001110_00001101_11101110_01010001_11110100_00011011;
    rom[1] = 80'b00101100_01011110_10000000_10100001_01000011_00100111_11100110_11101000_00001101_00101100;
    rom[2] = 80'b11101011_11100000_00010010_11101001_01000101_00010000_00010110_11100111_00010110_00010101;
    rom[3] = 80'b00111011_00001010_00101111_10010110_11110011_10000000_00110011_00100100_00101011_10000101;
    rom[4] = 80'b00000011_00110110_00100110_00101100_10010111_00100101_00011010_11001110_00000010_00001110;
   
  end

  // Sequential logic: update `dout` on clock edge
  always_ff @(posedge clk) begin
    if (rst)
      dout <= 80'd0;
    else if (addr < 3'd5)
      dout <= rom[addr];
    else
      dout <= 80'd0;
  end

  // Combinational output
  assign data = dout;

endmodule
