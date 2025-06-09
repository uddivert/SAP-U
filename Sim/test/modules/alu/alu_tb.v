`timescale 1ns / 1ps

module alu_tb ();
  reg [7:0] a;
  reg [7:0] b;
  reg bus_enable_n;
  reg subtract;
  reg flag_fi_n;  // controls if flag is holding value or updating
  reg flag_clear_n;  // clears flags
  reg clk;
  wire [1:0] flag_out;
  wire [7:0] bus_out;

  alu uut (
      .a(a),
      .b(b),
      .bus_enable_n(bus_enable_n),
      .subtract(subtract),
      .bus_out(bus_out),
      .flag_fi_n(flag_fi_n),  // low to update
      .flag_clear_n(flag_clear_n),  // clear flag
      .clk(clk),
      .flag_out(flag_out)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns clock period
  end

  // Testbench stimulus
  initial begin
    $dumpfile("./simulation/alu.vcd");  // VCD file for waveform generation
    $dumpvars(0, alu_tb);

    flag_fi_n = 0;  // set flag register to update
    flag_clear_n = 0;  // set flags cleared
    #10;

    // Test 1: Addition with bus_enable_n = 0, subtract = 0 (expected result = a + b)
    a        = 8'b00000001;  // a = 1
    b        = 8'b00000001;  // b = 1
    bus_enable_n   = 0;  // bus_enable_n ALU
    subtract = 0;  // addition
    #10;

    // Test 2: Subtraction with bus_enable_n = 0, subtract = 1 (expected result = a - b)
    a        = 8'b00000100;  // a = 4
    b        = 8'b00000001;  // b = 1
    bus_enable_n   = 0;  // bus_enable_n ALU
    subtract = 1;  // subtraction
    #10;

    // Test 3: Addition with bus_enable_n = 1, subtract = 0 (expected result = 0, ALU disabled)
    a        = 8'b00000101;  // a = 5
    b        = 8'b00000001;  // b = 1
    bus_enable_n   = 1;  // disable ALU
    subtract = 0;  // no operation
    #10;

    // Test 4: Subtraction with bus_enable_n = 1, subtract = 1 (expected result = 0, ALU disabled)
    a        = 8'b00000110;  // a = 6
    b        = 8'b00000001;  // b = 1
    bus_enable_n   = 1;  // disable ALU
    subtract = 1;  // no operation
    #10;

    // Test 5: Negative result of subtraction with bus_enable_n = 0, subtract = 1
    a        = 8'b00000001;  // a = 1
    b        = 8'b00000100;  // b = 4
    bus_enable_n   = 0;  // enable ALU
    subtract = 1;  // subtraction
    #10;

    // Test 6: Large addition with enable = 0, subtract = 0
    a        = 8'b11111111;  // a = 255
    b        = 8'b00000001;  // b = 1
    bus_enable_n   = 0;  // enable ALU
    subtract = 0;  // addition
    #10;

    // Test 7: Large subtraction with enable = 0, subtract = 1
    a        = 8'b10000000;  // a = 128
    b        = 8'b00000001;  // b = 1
    bus_enable_n   = 0;  // enable ALU
    subtract = 1;  // subtraction
    #10;

    $finish;
  end
endmodule
