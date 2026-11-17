module LayerControlUnit #(
  parameter int STATE_WIDTH = 4
)(
  input  logic clk,
  input  logic rst,

  // Inputs
  input  logic s_in_restart,
  input  logic s_in_start,
  input  logic s_in_neurons_ready,
  input  logic s_in_exc_yes,
  input  logic s_in_exc_stop,

  // Outputs
  output logic s_out_exc_cnt_en,
  output logic s_out_exc_cnt_rst,
  output logic s_out_exc_en,
  output logic s_out_leak_en,
  output logic s_out_sample_en,
  output logic s_out_sample_rst,
  output logic s_out_neuron_restart,
  output logic s_out_ready,
  output logic s_out_mux_en,
  output logic s_out_sample_out
);

  typedef enum logic [STATE_WIDTH-1:0] {
    RESET        = 4'd0,
    IDLE_WAIT    = 4'd1,
    IDLE         = 4'd2,
    INIT_WAIT    = 4'd3,
    INIT         = 4'd4,
    SAMPLE       = 4'd5,
    EXC_WAIT     = 4'd6,
    EXC_UPDATE   = 4'd7,
    LEAK_WAIT    = 4'd8,
    SAMPLE_OUT   = 4'd9
  } state_t;

  state_t present_state, next_state;

  // FSM combinational logic
  always_comb begin
    // Default next state is current state
    next_state = present_state;

    // Default outputs
    s_out_exc_cnt_en     = 0;
    s_out_exc_cnt_rst    = 0;
    s_out_exc_en         = 0;
    s_out_leak_en        = 0;
    s_out_sample_en      = 0;
    s_out_sample_rst     = 0;
    s_out_neuron_restart = 0;
    s_out_ready          = 0;
    s_out_mux_en         = 0;
    s_out_sample_out     = 0;

    case (present_state)

      RESET: begin
        s_out_sample_rst = 1;
        next_state = IDLE_WAIT;
      end

      IDLE_WAIT: begin
        if (s_in_neurons_ready)
          next_state = IDLE;
      end

      IDLE: begin
        s_out_ready       = 1;
        s_out_sample_rst  = 1;
        s_out_exc_cnt_rst = 1;
        if (s_in_restart)
          next_state = INIT_WAIT;
        else if (s_in_start)
          next_state = SAMPLE;
      end

      INIT_WAIT: begin
        if (s_in_neurons_ready)
          next_state = INIT;
      end

      INIT: begin
        s_out_neuron_restart = 1;
        next_state = IDLE;
      end

      SAMPLE: begin
        s_out_sample_en = 1;
        if (s_in_exc_yes)
          next_state = EXC_WAIT;
        else
          next_state = LEAK_WAIT;
      end

      LEAK_WAIT: begin
        if (s_in_neurons_ready) begin
          s_out_leak_en = 1;
          next_state = IDLE;
        end
      end

      EXC_WAIT: begin
        if (s_in_neurons_ready) begin
          s_out_exc_cnt_en = 1;
          s_out_exc_en     = 1;
          next_state = EXC_UPDATE;
        end
      end

      EXC_UPDATE: begin
        s_out_exc_cnt_en = 1;
        s_out_mux_en     = 1;
        if (s_in_exc_stop)
          next_state = SAMPLE_OUT;
        else begin
          s_out_exc_en = 1;
          next_state = EXC_UPDATE;
        end
      end

      SAMPLE_OUT: begin
        s_out_sample_out = 1;
        next_state = IDLE;
      end

      default: begin
        next_state = RESET;
      end

    endcase
  end

  // FSM sequential logic
  always_ff @(posedge clk) begin
    if (rst)
      present_state <= RESET;
    else
      present_state <= next_state;
  end

endmodule
