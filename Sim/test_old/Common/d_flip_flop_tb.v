`timescale 1ns / 1ps
module d_flip_flop_tb;

  // Declare input signals as registers and output signals as wires
  reg clk, data, reset;
  wire q, not_q;

  // Instantiate the DUT (Device Under Test)
  d_flip_flop uut (
      .clk  (clk),    // Clock signal
      .data (data),   // Data input
      .reset(reset),  // Reset
      .q    (q),      // Output Q
      .q_not(not_q)   // Output Not Q
  );

  // Clock signal generation: 50% duty cycle with a period of 10 time units
  always begin
    clk = 0;
    #5;  // Clock low for 5 time units
    clk = 1;
    #5;  // Clock high for 5 time units
  end

  // Testbench logic
  initial begin
    $dumpvars(0, d_flip_flop_tb);  // Correct instance name

    // case 1: No data
    data  = 0;
    reset = 1;
    #10;

    // case 2: Data high
    data  = 1;
    reset = 0;
    #10;

    // case 3: Data remains high
    data = 1;
    #10;

    // case 4: Data goes low
    data = 0;
    #10;

    // case 5: Data remains low
    data = 0;
    #10;

    // case 7: Reset high
    data = 1;
    #5;
    reset = 1;
    #5;


    $finish;  // End simulation
  end
endmodule
