                
                
module Layer_2 (
  input  logic                      clk,
  input  logic                      rst,
  input  logic                      start,
  input  logic                      restart,
  input  logic [31:0]   exc_spikes,
  output logic                      ready,
  output logic [2:0]  out_spikes
);
  // Ilmi
  // Internal signals
  logic [4:0]           exc_cnt;
  logic [7:0]        exc_weights [2:0];
  logic [2:0]         ready_bus;
  logic                             exc_spike;
  logic                             exc_en;
  logic                             leak_en;
  logic                             mux_en;
  logic                             sample_en;
  logic                             sample_rst;
  logic                             restart_neur;
  logic                             out_sample;
  logic                             exc_stop;
  logic                             exc_yes;

  // ROM instance (32x3)
  ROM32x3Split rom_32x3 (
    .clk   (clk),
    .rst   (rst),
    .addr  (exc_cnt),
    .dout  (exc_weights)
  );

  // Control Unit
  logic                             ctrl_exc_cnt_en;
  logic                             ctrl_exc_cnt_rst;
  logic                             ctrl_exc_en;
  logic                             ctrl_leak_en;
  logic                             ctrl_sample_en;
  logic                             ctrl_sample_rst;
  logic                             ctrl_mux_en;
  logic                             ctrl_sample_out;
  logic                             ctrl_neuron_restart;
  logic                             ctrl_ready;
  logic                             ctrl_neurons_ready;

  LayerControlUnit ctrl (
    .clk                 (clk),
    .rst                 (rst),
    .s_in_start          (start),
    .s_in_restart        (restart),
    .s_in_exc_yes        (exc_yes),
    .s_in_exc_stop       (exc_stop),
    .s_in_neurons_ready  (ctrl_neurons_ready),
    .s_out_exc_cnt_en    (ctrl_exc_cnt_en),
    .s_out_exc_cnt_rst   (ctrl_exc_cnt_rst),
    .s_out_exc_en        (ctrl_exc_en),
    .s_out_leak_en       (ctrl_leak_en),
    .s_out_sample_en     (ctrl_sample_en),
    .s_out_sample_rst    (ctrl_sample_rst),
    .s_out_mux_en        (ctrl_mux_en),
    .s_out_sample_out    (ctrl_sample_out),
    .s_out_neuron_restart(ctrl_neuron_restart),
    .s_out_ready         (ctrl_ready)
  );

  assign exc_en       = ctrl_exc_en;
  assign leak_en      = ctrl_leak_en;
  assign sample_en    = ctrl_sample_en;
  assign sample_rst   = ctrl_sample_rst;
  assign mux_en       = ctrl_mux_en;
  assign out_sample   = ctrl_sample_out;
  assign restart_neur = ctrl_neuron_restart;
  assign ready        = ctrl_ready;

  // Counter
  Counter #(.WIDTH(5)) counter (
    .clk        (clk),
    .rst        (ctrl_exc_cnt_rst),
    .en         (ctrl_exc_cnt_en),
    .out        (exc_cnt)
  );

  // Delay register for exc_cnt
  logic [4:0] cnt_delay_out;
  RegSync #(.WIDTH(5)) cnt_delay (
    .clk    (clk),
    .rst    (ctrl_exc_cnt_rst),
    .en     (ctrl_exc_cnt_en),
    .in     (exc_cnt),
    .out    (cnt_delay_out)
  );

  // Datapath
  logic dp_exc_spike;
  logic dp_exc_stop;
  logic dp_exc_yes;

  LayerDataPath #(.N_EXC_INPUTS(32), .EXC_CNT_BITWIDTH(5)) dp (
    .clk             (clk),
    .rst             (rst),
    .d_in_exc_spikes (exc_spikes),
    .s_in_sample_en  (sample_en),
    .s_in_sample_rst (sample_rst),
    .s_in_exc_en     (exc_en),
    .s_in_mux_en     (mux_en),
    .d_in_exc_cnt    (cnt_delay_out), //perubahan
    .s_out_exc_spike (dp_exc_spike),
    .s_out_cnt_stop  (dp_exc_stop),
    .s_out_exc_yes   (dp_exc_yes)
  );

  assign exc_spike = dp_exc_spike;
  assign exc_stop  = dp_exc_stop;
  assign exc_yes   = dp_exc_yes;

  // Spike Barrier
  logic [2:0] bar_in;
  logic [2:0] bar_out;

  RegSync #(.WIDTH(3)) bar (
    .clk    (clk),
    .rst    (restart),
    .en     (out_sample),
    .in     (bar_in),
    .out    (bar_out)
  );

  assign out_spikes = bar_out;

  // Neuron bank
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_0 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd68),
    .exc_weight    (exc_weights[0]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[0]),
    .out_spike     (bar_in[0])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_1 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd68),
    .exc_weight    (exc_weights[1]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[1]),
    .out_spike     (bar_in[1])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_2 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd68),
    .exc_weight    (exc_weights[2]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[2]),
    .out_spike     (bar_in[2])
  );

  // Reduce Ready
  assign ctrl_neurons_ready = &ready_bus;
  //logic reduce_ready_bus;

  //assign reduce_ready_bus = &ready_bus;

  // Avoid combinational loop
  //RegSync #(.WIDTH(1)) ready_latch (
  //  .clk    (clk),
  //  .rst    (rst),
  //  .en     (1'b1), // cek nanti
  //  .in     (reduce_ready_bus),
  //  .out    (ctrl_neurons_ready)
  //);

endmodule
