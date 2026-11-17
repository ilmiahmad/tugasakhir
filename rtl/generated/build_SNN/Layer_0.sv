module Layer_0 (
  input  logic                      clk,
  input  logic                      rst,
  input  logic                      start,
  input  logic                      restart,
  input  logic [31:0]   exc_spikes,
  output logic                      ready,
  output logic [63:0]  out_spikes
);
  // Ilmi
  // Internal signals
  logic [4:0]           exc_cnt;
  logic [7:0]        exc_weights [63:0];
  logic [63:0]         ready_bus;
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

  // ROM instance (32x64)
  ROM32x64Split rom_32x64 (
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
  logic [63:0] bar_in;
  logic [63:0] bar_out;

  RegSync #(.WIDTH(64)) bar (
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
    .v_th          (8'd20),
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
    .v_th          (8'd20),
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
    .v_th          (8'd20),
    .exc_weight    (exc_weights[2]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[2]),
    .out_spike     (bar_in[2])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_3 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[3]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[3]),
    .out_spike     (bar_in[3])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_4 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[4]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[4]),
    .out_spike     (bar_in[4])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_5 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[5]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[5]),
    .out_spike     (bar_in[5])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_6 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[6]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[6]),
    .out_spike     (bar_in[6])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_7 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[7]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[7]),
    .out_spike     (bar_in[7])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_8 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[8]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[8]),
    .out_spike     (bar_in[8])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_9 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[9]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[9]),
    .out_spike     (bar_in[9])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_10 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[10]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[10]),
    .out_spike     (bar_in[10])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_11 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[11]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[11]),
    .out_spike     (bar_in[11])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_12 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[12]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[12]),
    .out_spike     (bar_in[12])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_13 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[13]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[13]),
    .out_spike     (bar_in[13])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_14 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[14]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[14]),
    .out_spike     (bar_in[14])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_15 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[15]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[15]),
    .out_spike     (bar_in[15])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_16 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[16]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[16]),
    .out_spike     (bar_in[16])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_17 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[17]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[17]),
    .out_spike     (bar_in[17])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_18 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[18]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[18]),
    .out_spike     (bar_in[18])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_19 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[19]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[19]),
    .out_spike     (bar_in[19])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_20 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[20]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[20]),
    .out_spike     (bar_in[20])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_21 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[21]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[21]),
    .out_spike     (bar_in[21])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_22 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[22]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[22]),
    .out_spike     (bar_in[22])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_23 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[23]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[23]),
    .out_spike     (bar_in[23])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_24 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[24]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[24]),
    .out_spike     (bar_in[24])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_25 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[25]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[25]),
    .out_spike     (bar_in[25])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_26 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[26]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[26]),
    .out_spike     (bar_in[26])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_27 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[27]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[27]),
    .out_spike     (bar_in[27])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_28 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[28]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[28]),
    .out_spike     (bar_in[28])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_29 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[29]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[29]),
    .out_spike     (bar_in[29])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_30 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[30]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[30]),
    .out_spike     (bar_in[30])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_31 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[31]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[31]),
    .out_spike     (bar_in[31])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_32 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[32]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[32]),
    .out_spike     (bar_in[32])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_33 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[33]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[33]),
    .out_spike     (bar_in[33])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_34 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[34]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[34]),
    .out_spike     (bar_in[34])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_35 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[35]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[35]),
    .out_spike     (bar_in[35])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_36 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[36]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[36]),
    .out_spike     (bar_in[36])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_37 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[37]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[37]),
    .out_spike     (bar_in[37])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_38 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[38]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[38]),
    .out_spike     (bar_in[38])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_39 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[39]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[39]),
    .out_spike     (bar_in[39])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_40 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[40]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[40]),
    .out_spike     (bar_in[40])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_41 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[41]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[41]),
    .out_spike     (bar_in[41])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_42 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[42]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[42]),
    .out_spike     (bar_in[42])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_43 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[43]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[43]),
    .out_spike     (bar_in[43])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_44 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[44]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[44]),
    .out_spike     (bar_in[44])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_45 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[45]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[45]),
    .out_spike     (bar_in[45])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_46 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[46]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[46]),
    .out_spike     (bar_in[46])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_47 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[47]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[47]),
    .out_spike     (bar_in[47])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_48 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[48]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[48]),
    .out_spike     (bar_in[48])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_49 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[49]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[49]),
    .out_spike     (bar_in[49])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_50 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[50]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[50]),
    .out_spike     (bar_in[50])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_51 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[51]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[51]),
    .out_spike     (bar_in[51])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_52 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[52]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[52]),
    .out_spike     (bar_in[52])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_53 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[53]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[53]),
    .out_spike     (bar_in[53])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_54 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[54]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[54]),
    .out_spike     (bar_in[54])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_55 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[55]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[55]),
    .out_spike     (bar_in[55])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_56 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[56]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[56]),
    .out_spike     (bar_in[56])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_57 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[57]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[57]),
    .out_spike     (bar_in[57])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_58 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[58]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[58]),
    .out_spike     (bar_in[58])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_59 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[59]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[59]),
    .out_spike     (bar_in[59])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_60 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[60]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[60]),
    .out_spike     (bar_in[60])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_61 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[61]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[61]),
    .out_spike     (bar_in[61])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_62 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[62]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[62]),
    .out_spike     (bar_in[62])
  );
  LIF #(.WIDTH(8), .SHIFT(7)) neuron_63 (
    .clk           (clk),
    .rst           (rst),
    .v_th          (8'd20),
    .exc_weight    (exc_weights[63]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[63]),
    .out_spike     (bar_in[63])
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
