`timescale 1ns / 1ps `default_nettype none

module ram_tb;

  reg [7:0] dipswitch_data;
  reg [3:0] dipswitch_addr;
  reg [7:0] bus_in;
  reg addr_select;
  reg prog_mode;
  reg bus_enable_n;
  reg write_enable_n;
  reg control_signal;
  reg load_mar_reg_n;
  reg clear_mar_reg;
  reg clk;
  wire [7:0] bus_out;

  // Instantiate the RAM module
  ram uut (
      .dipswitch_data(dipswitch_data),
      .dipswitch_addr(dipswitch_addr),
      .bus_in(bus_in),
      .addr_select(addr_select),
      .prog_mode(prog_mode),
      .bus_enable_n(bus_enable_n),
      .write_enable_n(write_enable_n),
      .control_signal(control_signal),
      .load_mar_reg_n(load_mar_reg_n),
      .clear_mar_reg(clear_mar_reg),
      .clk(clk),
      .bus_out(bus_out)
  );

  // Clock signal generation: 50% duty cycle with a period of 10 time units
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns clock period
  end

  initial begin
    $dumpfile("./simulation/ram_tb.vcd");  // VCD file for waveform generation
    $dumpvars(0, ram_tb);
    // Initialize inputs
    bus_in         = 8'b11110111;
    addr_select    = 0;  // load address from dip switch
    prog_mode      = 0;  // set to dipswitch_data
    load_mar_reg_n = 0;  // load address
    clear_mar_reg  = 0;  // Don't clear mar's qff
    bus_enable_n   = 0;  // enable output on bus
    control_signal = 0;  // disable control signal

    /*********** MAR TEST **********/
    dipswitch_addr = 4'b1010;
    #15;
    addr_select = 1;  // load address from bus
    #10;

    /*********** RAM TEST **********/

    // write from dipswitch
    load_mar_reg_n = 1;  // stop loading address
    dipswitch_data = 8'b11001111;
    write_enable_n = 0;
    #1 write_enable_n = 1;
    #9;

    // write from bus
    prog_mode = 1;
    control_signal = 1;
    #9;
    $finish;
  end

endmodule
