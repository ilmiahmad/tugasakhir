# import math
# import os

# def generate_network_sv(directory, module_name="Network", num_inputs=5, num_outputs=10,
#                         num_outputs_per_layer=[1, 1, 1], cycles_cnt_bitwidth=5, n_cycles=3):
#     os.makedirs(directory, exist_ok=True)

#     with open(f"{directory}/{module_name}.sv", "w") as f:
#         f.write(f"""\
# module {module_name} (
#   input  logic                  clk,
#   input  logic                  rst,
#   input  logic                  start,
#   input  logic                  restart,
#   input  logic                  sample_ready,
#   input  logic [{num_inputs-1}:0] in_spikes,
#   output logic                  ready,
#   output logic                  sample,
#   output logic [{num_outputs-1}:0] out_spikes
# );

#   // === Internal Signals ===
#   logic                         restart_all;
#   logic                         start_all;
#   logic                         s_wire_cycle_stop;
#   logic                         [{len(num_outputs_per_layer)-1}:0] layer_ready;
#   logic                         reduce_layer_ready;

#   logic                         s_wire_cnt_rst;
#   logic                         s_wire_cnt_en;

#   assign reduce_layer_ready = &layer_ready & sample_ready;

#   // === Control Unit ===
#   NetworkControlUnit ctrl (
#     .clk               (clk),
#     .rst               (rst),
#     .s_in_start        (start),
#     .s_in_all_ready    (sample),
#     .s_in_stop         (s_wire_cycle_stop),

#     .s_out_cnt_en      (s_wire_cnt_en),
#     .s_out_cnt_rst     (s_wire_cnt_rst),
#     .s_out_start_all   (start_all),
#     .s_out_restart_all (restart_all),
#     .s_out_ready       (ready)
#   );

#   // === Timing Controller ===
#   NetworkDataPath #(
#     .CYCLES_CNT_BITWIDTH({cycles_cnt_bitwidth}),
#     .N_CYCLES({n_cycles+1})
#   ) dp (
#     .clk           (clk),
#     .rst           (rst),
#     .s_in_cnt_en   (s_wire_cnt_en),
#     .s_in_cnt_rst  (s_wire_cnt_rst),
#     .s_out_stop    (s_wire_cycle_stop)
#   );

#   // === Intermediate Spike Signals ===
# """)

#         # Intermediate wires between layers
#         for i in range(1, len(num_outputs_per_layer)):
#             width = num_outputs_per_layer[i - 1]
#             f.write(f"  logic [{width - 1}:0] spikes{i};\n")

#         f.write("""\
#   // Avoid combinational loop
#   RegSync #(.WIDTH(1)) ready_latch (
#     .clk    (clk),
#     .rst    (rst),
#     .en     (1'b1), // constant enable
#     .in     (reduce_layer_ready),
#     .out    (sample)
#   );

#   // === Layer Instances ===
# """)

#         for i in range(len(num_outputs_per_layer)):
#             input_sig = "in_spikes" if i == 0 else f"spikes{i}"
#             output_sig = "out_spikes" if i == len(num_outputs_per_layer) - 1 else f"spikes{i+1}"

#             f.write(f"""\
#   Layer_{i} layer{i} (
#     .clk         (clk),
#     .rst         (rst),
#     .start       (start_all),
#     .restart     (restart_all),
#     .exc_spikes  ({input_sig}),
#     .ready       (layer_ready[{i}]),
#     .out_spikes  ({output_sig})
#   );
# """)

#         f.write("endmodule\n")


import math
import os

import os

def generate_network_sv(
    directory,
    module_name="Network",
    num_inputs=5,
    num_outputs=10,
    num_outputs_per_layer=None,
    cycles_cnt_bitwidth=5,
    n_cycles=3
):
    """
    Generate a parameterized SystemVerilog SNN wrapper with arbitrary layers.

    Args:
        directory (str): Output directory.
        module_name (str): Top-level module name.
        num_inputs (int): M_IN for layer0.
        num_outputs (int): M_OUT for final layer.
        num_outputs_per_layer (List[int]): widths of each layer; len = num_layers.
        cycles_cnt_bitwidth (int): bitwidth for cycle counter.
        n_cycles (int): TIMESTEPS parameter.
    """
    if num_outputs_per_layer is None:
        # default two layers: inputs->outputs
        num_outputs_per_layer = [num_inputs, num_outputs]
    num_layers = len(num_outputs_per_layer)

    os.makedirs(directory, exist_ok=True)
    filepath = f"{directory}/{module_name}.sv"
    with open(filepath, "w") as f:
        f.write(f"""module {module_name} #(
    parameter int M_IN = {num_inputs},                   // Number of input spikes
    parameter int M_OUT = {num_outputs},                  // Number of output spikes
    parameter int TIMESTEPS = {n_cycles}
)(
  input  logic                  clk,
  input  logic                  rst,
  input  logic                  start,
  input  logic                  sample_ready,
  input  logic  [M_IN*TIMESTEPS-1:0]           in_spikes_buffer,
  output logic                  ready,
  output logic  [M_OUT*TIMESTEPS-1:0]           out_spikes_buffer
);

  // === Internal Signals ===
  logic                         restart_all;
  logic                         start_all;
  logic                         s_wire_cycle_stop;
  logic        [{num_layers-1}:0]           layer_ready;
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
    .CYCLES_CNT_BITWIDTH({cycles_cnt_bitwidth}),
    .N_CYCLES(TIMESTEPS+1),
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
""")
        # Intermediate wires
        for i in range(1, num_layers):
            width = num_outputs_per_layer[i-1]
            f.write(f"  logic [{width-1}:0] spikes{i};\n")

        f.write("\n  // === Layer Instances ===\n")
        for i in range(num_layers):
            in_sig = 'in_spikes' if i == 0 else f"spikes{i}"
            out_sig = 'out_spikes' if i == num_layers-1 else f"spikes{i+1}"
            f.write(f"  Layer_{i} layer{i} (\n")
            f.write(f"    .clk         (clk),\n")
            f.write(f"    .rst         (rst),\n")
            f.write(f"    .start       (start_all),\n")
            f.write(f"    .restart     (restart_all),\n")
            f.write(f"    .exc_spikes  ({in_sig}),\n")
            f.write(f"    .ready       (layer_ready[{i}]),\n")
            f.write(f"    .out_spikes  ({out_sig})\n")
            f.write(f"  );\n")

        f.write("endmodule\n")


