`timescale 1ns / 1ps

module register_tb;

  // Inputs
  reg load;
  reg enable;
  reg clr;
  reg clk;
  reg [7:0] data;

  // Output
  wire [7:0] q;

  // Instantiate the Unit Under Test (UUT)
  register uut (
      .load(load),
      .enable(enable),
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
    $dumpfile("./simulation/register.vcd");  // VCD file for waveform generation
    $dumpvars(0, register_tb);

    // Initialize all inputs
    load = 0;  // enable load
    enable = 0;  // enable output
    data = 8'b00000000;
    clr = 1;  // Start with clear active
    #12;

    // Case 1: clr deasserted, load is high, data is 1
    clr  = 0;
    data = 8'b11111111;  // only lower 4 bits should show
    #10;

    // Case 2: Load is low, holding the previous data
    load = 1;  // disable load
    data = 8'b01010101;  // should not show up
    #10;

    // Case 3: Load the new data
    load = 0;  // enable load
    data = 8'b00000011;
    #10;

    // Case 4: Disable output
    enable = 1;  // disable output
    #10;

    // Case 5: Activate clr, observe q goes to 0
    clr = 1;
    #10;

    $finish;
  end
endmodule

