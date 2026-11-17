module NetworkDataPath #(
    parameter CYCLES_CNT_BITWIDTH = 32, // Bitwidth for the counter
    parameter N_CYCLES = 51,           // Number of cycles
    parameter int M_IN = 32,                   // Number of input spikes
    parameter int M_OUT = 3,                  // Number of output spikes
    parameter int TIMESTEPS = 50

)(
    input logic                 clk,             // Clock signal
    input logic                 rst,             // Reset signal
    input logic                 s_in_cnt_en,     // Enable signal for the counter
    input logic                 s_in_cnt_rst,    // Active-high rst
    input  logic                latch_input,                  // Control signals from snn top FSM
    input  logic                latch_output,
    input  logic [M_OUT-1:0]    out_spikes,
    input  logic [M_IN-1:0]     in_spikes_buffer [0:TIMESTEPS-1],
    output logic [M_OUT-1:0]    out_spikes_buffer [0:TIMESTEPS-1],
//    input  logic [M_IN*TIMESTEPS-1:0]     in_spikes_buffer,
//    output logic [M_OUT*TIMESTEPS-1:0]    out_spikes_buffer,
    output logic                s_out_stop,      // Goes high when count reaches n_cycles + 1
    output logic [M_IN-1:0]     in_spikes
);

    // === Internal signals ===
    logic [CYCLES_CNT_BITWIDTH-1:0] cycle_cnt; // Internal counter value
    logic cmp_out_cycle; // Comparator output
    logic [CYCLES_CNT_BITWIDTH-1:0] cycle_cnt_delayed_1;
    logic [CYCLES_CNT_BITWIDTH-1:0] cycle_cnt_delayed_2;
    
    
    // === Counter Module ===
    Counter #(
        .WIDTH(CYCLES_CNT_BITWIDTH) // Set the bit width for the counter
    ) counter_inst (
        .clk(clk),
        .rst(s_in_cnt_rst),
        .en(s_in_cnt_en),
        .out(cycle_cnt)
    );

    // === CompareEqual Module ===
    CompareEq #(
        .WIDTH(CYCLES_CNT_BITWIDTH) // Set the width for the comparison
    ) compareeq_inst (
        .in0(cycle_cnt),
        .in1(N_CYCLES), // Compare with the N_CYCLES parameter
        .cmp_out(cmp_out_cycle) // Comparator result
    );
    
    RegSync #(.WIDTH(CYCLES_CNT_BITWIDTH)) regsync_1_inst (
    .clk (clk),
    .rst (rst),
    .en  (s_in_cnt_en),
    .in   (cycle_cnt),
    .out   (cycle_cnt_delayed_1)
  );
  
    RegSync #(.WIDTH(CYCLES_CNT_BITWIDTH)) regsync_2_inst (
    .clk (clk),
    .rst (rst),
    .en  (s_in_cnt_en),
    .in   (cycle_cnt_delayed_1),
    .out   (cycle_cnt_delayed_2)
  );
  
    DataSelector #(
        .M_IN(M_IN),
        .M_OUT(M_OUT),
        .CYCLES_CNT_BITWIDTH(CYCLES_CNT_BITWIDTH),
        .N_CYCLES(N_CYCLES),
        .TIMESTEPS(TIMESTEPS)
        
    ) data_selector_inst (
        .clk(clk),
        .rst(rst),
        .latch_input(latch_input),
        .latch_output(latch_output),
        .index_input(cycle_cnt),
        .index_output(cycle_cnt_delayed_2),
        .in_spikes_buffer(in_spikes_buffer),
        .out_spikes_buffer(out_spikes_buffer),
        .in_spikes(in_spikes),
        .out_spikes(out_spikes)
    );

    // === Output assignments ===
    assign s_out_stop = cmp_out_cycle;      // Stop output goes high when the counter reaches N_CYCLES
    // assign s_wire_cycle_cnt = cycle_cnt; // Assign the current counter value

endmodule
