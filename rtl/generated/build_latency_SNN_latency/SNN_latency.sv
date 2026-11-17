module SNN_latency #(
    parameter int M_IN = 83,                   // Number of input spikes
    parameter int M_OUT = 3,                  // Number of output spikes
    parameter int TIMESTEPS = 10
)(
  input  logic                  clk,
  input  logic                  rst,
  input  logic                  start,
  input  logic                  sample_ready,
  // input  logic  [M_IN*TIMESTEPS-1:0]           in_spikes_buffer,
  // output logic                  ready,
  // output logic  [M_OUT*TIMESTEPS-1:0]           out_spikes_buffer

  input  logic [M_IN-1:0]     in_spikes_buffer [0:TIMESTEPS-1],
  output logic ready,
  output logic [M_OUT-1:0]    out_spikes_buffer [0:TIMESTEPS-1]
);

  // === Internal Signals ===
  logic                         restart_all;
  logic                         start_all;
  logic                         s_wire_cycle_stop;
  logic        [2:0]           layer_ready;
  logic                         sample;
  logic                         s_wire_cnt_rst;
  logic                         s_wire_cnt_en;
  logic  [M_IN-1:0]             in_spikes;
  logic  [M_OUT-1:0]            out_spikes;
  logic                         latch_output;
  logic                         latch_input;

  assign sample = &layer_ready & sample_ready;

  // === Control Unit ===
  NetworkControlUnit ctrl (
    .clk               (clk),
    .rst               (rst),
    .s_in_start        (start),
    .s_in_all_ready    (sample),
    .s_in_stop         (s_wire_cycle_stop),
  
    .s_out_cnt_en      (s_wire_cnt_en),
    .s_out_cnt_rst     (s_wire_cnt_rst),
    .s_out_start_all   (start_all),
    .s_out_restart_all (restart_all),
    .s_out_ready       (ready),
    .s_out_latch_output(latch_output),
    .s_out_latch_input (latch_input)
  );

  // === Network Data Path ===
  NetworkDataPath #(
    .CYCLES_CNT_BITWIDTH(5),
    .N_CYCLES(TIMESTEPS+5),
    .M_IN(M_IN),
    .M_OUT(M_OUT),
    .TIMESTEPS(TIMESTEPS)
  ) dp (
    .clk            (clk),
    .rst            (rst),
    .s_in_cnt_en    (s_wire_cnt_en),
    .s_in_cnt_rst   (s_wire_cnt_rst),
    .latch_input    (latch_input),
    .latch_output   (latch_output),

    .in_spikes_buffer(in_spikes_buffer),
    .out_spikes_buffer(out_spikes_buffer),

    .s_out_stop     (s_wire_cycle_stop),
    .in_spikes      (in_spikes),
    .out_spikes     (out_spikes)
  );
  logic [63:0] spikes1;
  logic [31:0] spikes2;

  // === Layer Instances ===
  Layer_0 layer0 (
    .clk         (clk),
    .rst         (rst),
    .start       (start_all),
    .restart     (restart_all),
    .exc_spikes  (in_spikes),
    .ready       (layer_ready[0]),
    .out_spikes  (spikes1)
  );
  Layer_1 layer1 (
    .clk         (clk),
    .rst         (rst),
    .start       (start_all),
    .restart     (restart_all),
    .exc_spikes  (spikes1),
    .ready       (layer_ready[1]),
    .out_spikes  (spikes2)
  );
  Layer_2 layer2 (
    .clk         (clk),
    .rst         (rst),
    .start       (start_all),
    .restart     (restart_all),
    .exc_spikes  (spikes2),
    .ready       (layer_ready[2]),
    .out_spikes  (out_spikes)
  );
endmodule
