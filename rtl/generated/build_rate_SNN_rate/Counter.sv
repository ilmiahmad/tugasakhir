module Counter #(
  parameter int WIDTH = 8,                             // Bit-width
  parameter logic [WIDTH-1:0] RST_VALUE = '0           // Reset value
)(
  input  logic             clk,         // Clock
  input  logic             rst,         // Synchronous reset
  input  logic             en,          // Enable
  output logic [WIDTH-1:0] out          // Output
);


  // Sequential logic
  always_ff @(posedge clk) begin
    if (rst) begin
      out <= RST_VALUE;
    end 
    else if (en) begin
      out <= out + 1'b1;
    end
  end

endmodule
