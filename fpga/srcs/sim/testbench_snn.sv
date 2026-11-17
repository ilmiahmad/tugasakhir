`timescale 1ns/1ps

module testbench_snn;

  parameter int M_IN = 32;
  parameter int M_OUT = 3;
  parameter int TIMESTEPS = 50;

  logic clk = 0;
  logic rst;
  logic start;
  logic sample_ready;
  logic [M_IN-1:0] in_spikes_buffer [0:TIMESTEPS-1];
  logic ready;
  logic [M_OUT-1:0] out_spikes_buffer [0:TIMESTEPS-1];

  // Clock generation
  always #5 clk = ~clk;

  // Instantiate DUT
  SNN #(
    .M_IN(M_IN),
    .M_OUT(M_OUT),
    .TIMESTEPS(TIMESTEPS)
  ) uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .sample_ready(sample_ready),
    .in_spikes_buffer(in_spikes_buffer),
    .ready(ready),
    .out_spikes_buffer(out_spikes_buffer)
  );

  initial begin
    // Reset logic
    rst = 1;
    start = 0;
    sample_ready = 0;
    #20;
    rst = 0;
    #10;

    // Stimulus: Set input spike patterns for all timesteps
    for (int t = 0; t < TIMESTEPS; t++) begin
      // Set a simple pattern (customize as needed)
      in_spikes_buffer[t] = 32'hFFFF0000 >> (t % 8);  // Example shifting pattern
    end

    sample_ready = 1;
    #10;

    wait (ready);
    
    #20;
    // Start processing
    wait (ready);
    #5;
    start = 1;
    #10;
    start = 0;
    #50;

    // Update input buffer and capture outputs
    while (!ready) begin
      @(posedge clk);
    end

    // Wait for final output
    #10
    wait (ready);
    #10;

    // Display output
    $display("\n=== SNN Output Spikes ===");
    for (int t = 0; t < TIMESTEPS; t++) begin
      $display("Timestep %0d: %b", t, out_spikes_buffer[t]);
    end

    $finish;
  end

endmodule
