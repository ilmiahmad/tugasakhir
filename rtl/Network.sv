module Network (
  input  logic                  clk,
  input  logic                  rst,
  input  logic                  start,
  input  logic                  restart,
  input  logic                  sample_ready,
  input  logic [4:0] in_spikes,
  output logic                  ready,
  output logic                  sample,
  output logic [9:0] out_spikes
);

  // === Internal Signals ===
  logic                         restart_all;
  logic                         start_all;
  logic                         s_wire_cycle_stop;
  logic                         [9:0] layer_ready;
  logic                         reduce_layer_ready;

  logic                         s_wire_cnt_rst;
  logic                         s_wire_cnt_en;


  assign reduce_layer_ready = &layer_ready & sample_ready;

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
    .s_out_ready       (ready)
  );

  // === Timing Controller ===
  NetworkDataPath #(
    .CYCLES_CNT_BITWIDTH(5),
    .N_CYCLES(3)
  ) dp (
    .clk           (clk),
    .rst           (rst),
    .s_in_cnt_en   (s_wire_cnt_en),
    .s_in_cnt_rst  (s_wire_cnt_rst),
    .s_out_stop    (s_wire_cycle_stop)
  );

  // === Intermediate Spike Signals ===

  // Avoid combinational loop
  RegSync #(.WIDTH(1)) ready_latch (
    .clk    (clk),
    .rst    (rst),
    .en     (1'b1), //cek nanti
    .in     (reduce_layer_ready),
    .out    (sample)
  );

  logic [9:0] spikes1;
  logic [9:0] spikes2;

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
