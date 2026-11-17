module DataSelector #(
  parameter int M_IN  = 5,
  parameter int M_OUT = 10,
  parameter int CYCLES_CNT_BITWIDTH  = 5,
  parameter int N_CYCLES = 4,
  parameter int TIMESTEPS = 3
)(
  input  logic                           clk,
  input  logic                           rst,
  input  logic                           latch_input,
  input  logic                           latch_output,
  input  logic [CYCLES_CNT_BITWIDTH-1:0] index_input,  // Driven externally by SNN
  input  logic [CYCLES_CNT_BITWIDTH-1:0] index_output,
  input  logic [M_IN-1:0]                in_spikes_buffer  [0:TIMESTEPS-1],
  input  logic [M_OUT-1:0]               out_spikes,
  output logic [M_OUT-1:0]               out_spikes_buffer [0:TIMESTEPS-1],
  output logic [M_IN-1:0]                in_spikes
);
  
  always_ff @(posedge clk) begin
    if (latch_input && (index_input < TIMESTEPS)) begin
      in_spikes <= in_spikes_buffer[index_input];
    end
  end


  always_ff @(posedge clk) begin
    if (latch_output && (index_output < TIMESTEPS)) begin  
      out_spikes_buffer[index_output] <= out_spikes;
    end
  end

endmodule



//module DataSelector #(
//  parameter int M_IN  = 5,
//  parameter int M_OUT = 10,
//  parameter int CYCLES_CNT_BITWIDTH  = 5,
//  parameter int N_CYCLES = 4,
//  parameter int TIMESTEPS = 3
//)(
//  input  logic                           clk,
//  input  logic                           rst,
//  input  logic                           latch_input,
//  input  logic                           latch_output,
//  input  logic [CYCLES_CNT_BITWIDTH-1:0] index_input,   // Driven externally by SNN
//  input  logic [CYCLES_CNT_BITWIDTH-1:0] index_output,
//  input  logic [M_IN*TIMESTEPS-1:0]      in_spikes_buffer,
//  input  logic [M_OUT-1:0]               out_spikes,
//  output logic [M_OUT*TIMESTEPS-1:0]     out_spikes_buffer,
//  output logic [M_IN-1:0]                in_spikes
//);

//  // Input selector: extract slice from flattened input buffer
//  always_ff @(posedge clk) begin
//    if (latch_input && (index_input < TIMESTEPS)) begin
//      in_spikes <= in_spikes_buffer[index_input*M_IN +: M_IN];
//    end
//  end

//  // Output selector: insert out_spikes into flattened output buffer
//  always_ff @(posedge clk) begin
//    if (latch_output && (index_output < TIMESTEPS)) begin
//      out_spikes_buffer[index_output*M_OUT +: M_OUT] <= out_spikes;
//    end
//  end

//endmodule
