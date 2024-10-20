`timescale 1ns / 1ps

module sn54173_quad_flip_flop_tb;

  // Inputs
  reg m;
  reg n;
  reg g1;
  reg g2;
  reg clr;
  reg clk;
  reg [3:0] data;

  // Outputs
  wire [3:0] q;

  // Instantiate the Unit Under Test (UUT)
  sn54173_quad_flip_flop uut (
      .m(m),
      .n(n),
      .g1(g1),
      .g2(g2),
      .clr(clr),
      .clk(clk),
      .data(data),
      .q(q)
  );

  // Clock generation: 50% duty cycle with a period of 10 time units
  always begin
    clk = 0;
    #5 clk = 1;
    #5 clk = 0;  // 10ns clock period (100 MHz)
  end

  // Testbench stimulus
  initial begin
    $dumpfile("./simulation/testbench_master.vcd");  // VCD file for waveform generation
    $dumpvars(0, sn54173_quad_flip_flop_tb);

    // Initialize all inputs
    {g1, g2} = 0;  // enable load
    {m, n} = 0;  // enable output
    data = 4'b0000;
    clr = 1;  // Start with clear active
    #15;  // Wait a bit to see the clr effect

    // Case 1: clr deasserted, load is high, data is set
    clr  = 0;
    data = 4'b1010;
    #10;  // Wait for a clock edge

    // Case 2: Load is low, holding the previous data
    {g1, g1} = 1;  // disable load
    data = 4'b1100;  // should not show up
    #10;  // Wait for a clock edge

    // Case 3: Load the new data
    {g1, g1} = 0;  // enable load
    data = 4'b1111;
    #10;  // Wait for a clock edge

    // Case 4: Disable output
    {m, n} = 1;  // disable output
    #10;  // Wait for a clock edge

    // Case 5: Activate clr, observe q goes to 0
    clr = 1;
    #10;  // Wait for a clock edge

    // End simulation
    $finish;
  end
endmodule

