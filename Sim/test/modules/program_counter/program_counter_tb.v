`timescale 1ns / 1ps `default_nettype none
module program_counter_tb;

  reg clear_n;
  reg clk;
  reg enable;
  reg jump_n;
  reg [3:0] bus_in;
  reg bus_enable_n;

  wire [3:0] instruction_pointer;
  wire [3:0] bus_out;


  program_counter uut (
      .clear_n(clear_n),
      .clk(clk),
      .enable(enable),
      .jump_n(jump_n),
      .bus_in(bus_in),
      .bus_enable_n(bus_enable_n),
      .instruction_pointer(instruction_pointer),
      .bus_out(bus_out)
  );

  // Enable clock
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns clock period
  end

  initial begin
    $dumpfile("./simulation/program_counter_tb.vcd");
    $dumpvars(0, program_counter_tb);

    // Set everything to default
    jump_n = 1;
    enable = 1;
    bus_in = 4'b0000;
    bus_enable_n = 0;

    // Clear data
    clear_n = 0;
    #10 clear_n = 1;
    #10

    // Count up
    repeat (5)
    @(posedge clk);

    // Disable bus
    bus_enable_n = 1;
    #10

    // Enable bus
    bus_enable_n = 0;
    #10

    // jump
    bus_in = 4'b0101;
    jump_n = 0;
    #5;  // short active-low pulse
    jump_n = 1;
    #20;
    repeat (4) @(posedge clk);

    $finish;

  end

endmodule
