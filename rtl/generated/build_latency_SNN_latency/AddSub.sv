
module AddSub #(
  parameter int WIDTH = 8
) (
  input  logic signed [WIDTH-1:0] in0,
  input  logic signed [WIDTH-1:0] in1,
  input  logic               add_or_sub,   // '0' for add, '1' for subtract
  output logic signed [WIDTH-1:0] out
);

  // Saturation limits
  localparam signed [WIDTH-1:0] SAT_UP   = (1 << (WIDTH-1)) - 1;
  localparam signed [WIDTH-1:0] SAT_DOWWIDTH = -(1 << (WIDTH-1));

  // Extended signals for sign extension and result
  logic signed [WIDTH:0] local_in0;
  logic signed [WIDTH:0] local_in1;
  logic signed [WIDTH:0] local_out;

  // Combinational logic block
  always_comb begin
    // Sign-extension
    local_in0 = { in0[WIDTH-1], in0 };
    local_in1 = { in1[WIDTH-1], in1 };

    // Add or subtract
    if ( add_or_sub == 1'b0 ) begin
      local_out = local_in0 + local_in1;
    end else begin
      local_out = local_in0 - local_in1;
    end

    // Overflow detection: if MSB and next bit differ
    if ( local_out[WIDTH] != local_out[WIDTH-1] ) begin
      if ( local_out[WIDTH] == 1'b1 )
        out = SAT_DOWWIDTH;  // WIDTHegative overflow
      else
        out = SAT_UP;    // Positive overflow
    end else begin
      // WIDTHo overflow: take lower WIDTH bits
      out = local_out[WIDTH-1:0];
    end
  end

endmodule
