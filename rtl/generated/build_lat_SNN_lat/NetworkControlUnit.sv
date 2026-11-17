module NetworkControlUnit
(
    input logic         clk,              // Clock
    input logic         rst,              // Reset
    input logic         s_in_start,       // Start signal
    input logic         s_in_all_ready,   // All ready signal
    input logic         s_in_stop,        // Stop signal
    
    output logic        s_out_cnt_en,     // Counter enable
    output logic        s_out_cnt_rst,    // Counter rst
    output logic        s_out_ready,      // Ready signal
    output logic        s_out_restart_all,// Restart all signal
    output logic        s_out_start_all,   // Start all signal,
    output logic        s_out_latch_output,
    output logic        s_out_latch_input
);

    // === FSM State Declaration ===
    typedef enum logic [2:0] {
        RESET          = 3'd0,
        IDLE_WAIT      = 3'd1,
        IDLE           = 3'd2,
        INIT           = 3'd3,
        CYCLE_WAIT     = 3'd4,
        NETWORK_UPDATE = 3'd5,
        NETWORK_WAIT   = 3'd6
    } state_t;

    state_t present_state, next_state;

    // === Combinational Logic ===
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            present_state <= RESET;
        end else begin
            present_state <= next_state;
        end
    end

    always_comb begin
        // Default values
        s_out_cnt_en      = 0;
        s_out_cnt_rst     = 0;
        s_out_ready       = 0;
        s_out_restart_all = 0;
        s_out_start_all   = 0;
        s_out_latch_output =0;
        s_out_latch_input = 0;
        
        next_state        = present_state;

        case (present_state)
            RESET: begin
                s_out_cnt_rst = 1;
                next_state = IDLE_WAIT;
            end

            IDLE_WAIT: begin
                if (s_in_all_ready) begin
                    next_state = IDLE;
                end
            end

            IDLE: begin
                s_out_ready = 1;
                s_out_cnt_rst = 1;
                if (s_in_start) begin
                    next_state = INIT;
                end
            end

            INIT: begin
                s_out_restart_all = 1;
                next_state = CYCLE_WAIT;
            end

            CYCLE_WAIT: begin
                if (s_in_all_ready) begin
                    if (s_in_stop) begin
                        next_state = IDLE;
                    end else begin
                        next_state = NETWORK_UPDATE;
                    end
                    s_out_latch_input=1;
                end
            end

            NETWORK_UPDATE: begin
                s_out_cnt_en = 1;
                s_out_start_all = 1;
                next_state = NETWORK_WAIT;
            end
            
            NETWORK_WAIT: begin
                if (s_in_all_ready) begin
                    if (s_in_stop) begin
                        next_state = IDLE;
                    end else begin
                        next_state = CYCLE_WAIT;
                    end
                    s_out_latch_output = 1;
                end
            end
            default: begin
                next_state = RESET;
            end
        endcase
    end

endmodule
