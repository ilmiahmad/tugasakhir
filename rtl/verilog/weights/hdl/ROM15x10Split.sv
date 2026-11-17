module ROM5x15Split (
  input  logic        clk,
  input  logic        reset,
  input  logic [2:0]  addra,     // 3-bit address (5 entries)

  output logic [7:0]  dout0,
  output logic [7:0]  dout1,
  output logic [7:0]  dout2,
  output logic [7:0]  dout3,
  output logic [7:0]  dout4,
  output logic [7:0]  dout5,
  output logic [7:0]  dout6,
  output logic [7:0]  dout7,
  output logic [7:0]  dout8,
  output logic [7:0]  dout9,
  output logic [7:0]  dout10,
  output logic [7:0]  dout11,
  output logic [7:0]  dout12,
  output logic [7:0]  dout13,
  output logic [7:0]  dout14
);

  // Internal signal to hold ROM output (120 bits = 15 x 8 bits)
  logic [119:0] rom_douta;

  // ROM instance (assumed already defined elsewhere)
  ROM5x15 rom_inst (
    .clk    (clk),
    .reset  (reset),
    .addra  (addra),
    .douta  (rom_douta)
  );

  // Split the 120-bit output into 15 bytes
  always_comb begin
    dout0  = rom_douta[  7:  0];
    dout1  = rom_douta[ 15:  8];
    dout2  = rom_douta[ 23: 16];
    dout3  = rom_douta[ 31: 24];
    dout4  = rom_douta[ 39: 32];
    dout5  = rom_douta[ 47: 40];
    dout6  = rom_douta[ 55: 48];
    dout7  = rom_douta[ 63: 56];
    dout8  = rom_douta[ 71: 64];
    dout9  = rom_douta[ 79: 72];
    dout10 = rom_douta[ 87: 80];
    dout11 = rom_douta[ 95: 88];
    dout12 = rom_douta[103: 96];
    dout13 = rom_douta[111:104];
    dout14 = rom_douta[119:112];
  end

endmodule
