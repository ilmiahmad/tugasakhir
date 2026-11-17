module ROM15x10Split (
  input  logic        clk,
  input  logic        reset,
  input  logic [3:0]  addra,     // 4-bit address

  output logic [7:0]  dout0,
  output logic [7:0]  dout1,
  output logic [7:0]  dout2,
  output logic [7:0]  dout3,
  output logic [7:0]  dout4,
  output logic [7:0]  dout5,
  output logic [7:0]  dout6,
  output logic [7:0]  dout7,
  output logic [7:0]  dout8,
  output logic [7:0]  dout9
);

  // Internal signal to hold ROM output (assume 80-bit)
  logic [79:0] rom_douta;

  // ROM instantiation (connect clock, reset, and address)
  ROM15x10 rom_inst (
    .clk    (clk),
    .reset  (reset),
    .addra  (addra),
    .douta  (rom_douta)
  );

  // Split the ROM output into 10 bytes
  always_comb begin
    dout0 = rom_douta[ 7: 0];
    dout1 = rom_douta[15: 8];
    dout2 = rom_douta[23:16];
    dout3 = rom_douta[31:24];
    dout4 = rom_douta[39:32];
    dout5 = rom_douta[47:40];
    dout6 = rom_douta[55:48];
    dout7 = rom_douta[63:56];
    dout8 = rom_douta[71:64];
    dout9 = rom_douta[79:72];
  end

endmodule
