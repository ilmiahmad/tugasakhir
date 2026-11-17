// -----------------------------------------------------------------------------
// LIFControlUnit: FSM controlling neuron operation
// -----------------------------------------------------------------------------
module LIFControlUnit #(
  parameter int WIDTH = 16
) (
  input  logic         clk,
  input  logic         rst,
  input  logic         restart,
  input  logic         exc,
  input  logic         leak,
  input  logic         exceed_v_th,
  input  logic         exc_spike,


  output logic [1:0]   update_sel,
  output logic         add_or_sub,
  output logic         v_en,
  output logic         v_rst,
  output logic         neuron_ready,
  output logic         out_spike
);
  typedef enum logic [2:0] {RESET=3'b000, IDLE=3'b001, INIT=3'b010,
                             EXCITE=3'b011, FIRE=3'b101, LEAK=3'b110} state_t;
  state_t present_state, next_state;

  always_comb begin
    // Default outputs
    next_state    = present_state;
    update_sel    = 2'b01; // LEAK
    add_or_sub    = 1'b0;
    v_en          = 1'b0;
    v_rst         = 1'b0;
    neuron_ready  = 1'b0;
    out_spike     = 1'b0;

    case (present_state)
      RESET:   
        begin 
            v_rst = 1'b1;    
            next_state = IDLE;   
        end
      INIT:    
        begin 
            v_rst = 1'b1;    
            next_state = IDLE;   
        end
      IDLE:    
        begin 
            neuron_ready = 1'b1;
            if (restart)      next_state = INIT;
            else if (exc)     next_state = EXCITE;
            else if (leak)    next_state = LEAK;
        end
      LEAK:    
        begin 
            v_en = 1'b1; 
            update_sel = 2'b01; 
            add_or_sub = 1'b1; 
            next_state = FIRE; 
        end
      EXCITE:  
        begin 
            v_en = 1'b1; update_sel = 2'b10;
            if (exc)         next_state = EXCITE;
            else             next_state = FIRE;
        end
      FIRE:    
        begin 
            if (exceed_v_th) 
            begin
                v_en       = 1'b1;
                update_sel = 2'b00; // RESET
                add_or_sub = 1'b1;
                out_spike  = 1'b1;
            end
            
            next_state = IDLE;
        end
        
      default: next_state = RESET;
    endcase
  end

  always_ff @(posedge clk) begin
    if (rst) present_state <= RESET;
    else     present_state <= next_state;
  end
endmodule