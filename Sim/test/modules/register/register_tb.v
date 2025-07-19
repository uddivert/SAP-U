`timescale 1ns / 1ps

module register_tb;

  // Inputs
  reg load_n;
  reg clr;
  reg clk;
  reg bus_enable_n;
  reg [7:0] bus_in;

  // Output
  wire [7:0] q;
  wire [7:0] bus_out;

  // Instantiate the Unit Under Test (UUT)
  register uut (
      .load_n(load_n),
      .clr(clr),
      .clk(clk),
      .bus_enable_n(bus_enable_n),
      .bus_in(bus_in),
      .q(q),
      .bus_out(bus_out)
  );

  // Clock generation: 50% duty cycle with a period of 10 time units
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns clock period
  end

  // Testbench stimulus
  initial begin
    $dumpfile("./simulation/register.vcd");  // VCD file for waveform generation
    $dumpvars(0, register_tb);

    // Initialize all inputs
    load_n = 0;  // enable load
    bus_enable_n = 1;  // disable bus output
    bus_in = 8'b00000000;
    clr = 1;  // Start with clear active
    #12;

    // Case 1: clr deasserted, load is high, bus_in is 1
    clr = 0;
    bus_in = 8'b11111111;  // only lower 4 bits should show
    #10;

    // Case 2: Load is low, holding the previous bus_in
    bus_enable_n = 0;
    load_n = 1;  // disable load
    bus_in = 8'b01010101;  // should not show up
    #10;

    // Case 3: Load the new bus_in
    load_n = 0;  // enable load
    bus_in = 8'b00000011;
    #10;

    // Case 5: Activate clr, observe q goes to 0
    clr = 1;
    #10;

    $finish;
  end
endmodule

