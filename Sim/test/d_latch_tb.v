`timescale 1ns / 1ps
module d_latch_tb;

  // Declare input signals as registers and output signals as wires
  reg enable, data;
  wire q, not_q;

  // Instantiate the DUT (Device Under Test)
  d_latch uut (
      .enable(enable),
      .data(data),
      .q(q),
      .q_not(not_q)
  );


  initial begin

    $dumpfile("./simulation/testbench_master.vcd");  // VCD file for waveform generation
    $dumpvars(0, d_latch_tb);

    // case 1 (no data)
    enable = 0;
    data   = 0;
    #10;

    // case 2 (data with no enable)
    enable = 0;
    data   = 1;
    #10;

    // case 3 (data with enable)
    enable = 1;
    data   = 1;
    #10;

    // case 4 (data off with enable off)
    enable = 0;
    data   = 0;
    #10;

    // case 5 (enable on and data off)
    enable = 1;
    data   = 0;
    #10;

    $finish;  // End simulation
  end
endmodule

