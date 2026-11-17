import math
import os

def generate_layer_sv(directory, module_name, num_inputs, num_outputs, neuron_width=8, neuron_shift=4, neuron_vth=64):
    # Calculate counter bitwidth based on number of inputs
    cnt_width = max(3, math.ceil(math.log2(num_inputs)))
    
    with open(f"{directory}/{module_name}.sv", "w") as f:
        f.write(f"""\
                
                
module {module_name} (
  input  logic                      clk,
  input  logic                      rst,
  input  logic                      start,
  input  logic                      restart,
  input  logic [{num_inputs-1}:0]   exc_spikes,
  output logic                      ready,
  output logic [{num_outputs-1}:0]  out_spikes
);
  // Ilmi
  // Internal signals
  logic [{cnt_width-1}:0]           exc_cnt;
  logic [{neuron_width-1}:0]        exc_weights [{num_outputs-1}:0];
  logic [{num_outputs-1}:0]         ready_bus;
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

  // ROM instance ({num_inputs}x{num_outputs})
  ROM{num_inputs}x{num_outputs}Split rom_{num_inputs}x{num_outputs} (
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
  Counter #(.WIDTH({cnt_width})) counter (
    .clk        (clk),
    .rst        (ctrl_exc_cnt_rst),
    .en         (ctrl_exc_cnt_en),
    .out        (exc_cnt)
  );

  // Delay register for exc_cnt
  logic [{cnt_width-1}:0] cnt_delay_out;
  RegSync #(.WIDTH({cnt_width})) cnt_delay (
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

  LayerDataPath #(.N_EXC_INPUTS({num_inputs}), .EXC_CNT_BITWIDTH({cnt_width})) dp (
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
  logic [{num_outputs-1}:0] bar_in;
  logic [{num_outputs-1}:0] bar_out;

  RegSync #(.WIDTH({num_outputs})) bar (
    .clk    (clk),
    .rst    (restart),
    .en     (out_sample),
    .in     (bar_in),
    .out    (bar_out)
  );

  assign out_spikes = bar_out;

  // Neuron bank
""")
        # Manual instantiation of neurons using Python loop
        for i in range(num_outputs):
            f.write(f"""\
  LIF #(.WIDTH({neuron_width}), .SHIFT({neuron_shift})) neuron_{i} (
    .clk           (clk),
    .rst           (rst),
    .v_th          ({neuron_width}'d{neuron_vth}),
    .exc_weight    (exc_weights[{i}]),
    .restart       (restart_neur),
    .exc           (exc_en),
    .leak          (leak_en),
    .exc_spike     (exc_spike),
    .neuron_ready  (ready_bus[{i}]),
    .out_spike     (bar_in[{i}])
  );
""")

        f.write(f"""\

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
""")