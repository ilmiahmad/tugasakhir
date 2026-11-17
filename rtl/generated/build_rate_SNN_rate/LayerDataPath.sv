module LayerDataPath #(
    parameter int N_EXC_INPUTS = 4,
    parameter int EXC_CNT_BITWIDTH = 2
)(
    input  logic                      clk,
    input  logic                      rst,
    input  logic [N_EXC_INPUTS-1:0]   d_in_exc_spikes,
    input  logic                      s_in_sample_en,
    input  logic                      s_in_sample_rst,

    input  logic [EXC_CNT_BITWIDTH-1:0] d_in_exc_cnt,
    input  logic                      s_in_exc_en,
    input  logic                      s_in_mux_en,

    output logic                      s_out_exc_yes,
    output logic                      s_out_exc_spike,
    output logic                      s_out_cnt_stop
    // output logic [EXC_CNT_BITWIDTH-1:0] d_out_exc_cnt
);

    // Sampled spike register
    logic [N_EXC_INPUTS-1:0] sampled_spikes;

    RegSync #(.WIDTH(N_EXC_INPUTS)) reg_sampled (
        .clk         (clk),
        .rst         (s_in_sample_rst),
        .en          (s_in_sample_en),
        .in           (d_in_exc_spikes),
        .out           (sampled_spikes)
    );

    // OR gate over spike input
    OrN #(.WIDTH(N_EXC_INPUTS)) logic_or (
        .in  (d_in_exc_spikes),
        .out (s_out_exc_yes)
    );

    // Counter stop comparator (cmp against N_EXC_INPUTS - 1)
    CompareEq #(.WIDTH(EXC_CNT_BITWIDTH)) logic_cmp (
        .in0     (d_in_exc_cnt),
        .in1     (EXC_CNT_BITWIDTH'((N_EXC_INPUTS - 1))),
        .cmp_out (s_out_cnt_stop)
    );

    // Mux to select one sampled spike
    ENMuxN #(.WIDTH(1), .N(N_EXC_INPUTS)) mux_spike (
        .in  (sampled_spikes),
        .sel (d_in_exc_cnt),
        .en  (s_in_mux_en),
        .out (s_out_exc_spike)
    );

    // Counter passthrough
    // assign d_out_exc_cnt = d_in_exc_cnt;

endmodule
