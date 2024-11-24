`timescale 1ns / 1ps

module dm74ls283_quad_adder_tb();
reg [4:1] a; // input a
reg [4:1] b; // input b
reg cin; // carry in
wire [4:1] sum; // sum
wire cout; // carry out

dm74ls283_quad_adder uut(
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

  // Testbench stimulus
  initial begin
    $dumpfile("./simulation/testbench_master.vcd");  // VCD file for waveform generation
    $dumpvars(0, dm74ls283_quad_adder_tb);

    // Test 1: Simple addition with no carry-in
    a = 4'b0000;  // a = 0
    b = 4'b0000;  // b = 0
    cin = 0;      // no carry in
    #10;

    // Test 2: Simple addition with carry-in
    a = 4'b0001;  // a = 1
    b = 4'b0001;  // b = 1
    cin = 1;      // carry in
    #10;

    // Test 3: Addition with no carry, result with carry-out
    a = 4'b0111;  // a = 7
    b = 4'b0001;  // b = 1
    cin = 0;      // no carry in
    #10;

    // Test 4: Subtracting using carry in
    a = 4'b1000;  // a = -8 (two's complement)
    b = 4'b0000;  // b = 0
    cin = 1;      // carry-in simulates subtraction
    #10;

    // Test 5: Adding two large values
    a = 4'b1110;  // a = 14
    b = 4'b0111;  // b = 7
    cin = 0;      // no carry in
    #10;

    // Test 6: Adding two values resulting in overflow
    a = 4'b1111;  // a = 15
    b = 4'b0001;  // b = 1
    cin = 0;      // no carry in
    #10;

    // Test 7: Adding two numbers with carry-in
    a = 4'b1010;  // a = 10
    b = 4'b0101;  // b = 5
    cin = 1;      // carry in
    #10;

    // Test 8: Addition where sum exceeds 4-bit width (overflow)
    a = 4'b1100;  // a = 12
    b = 4'b1010;  // b = 10
    cin = 0;      // no carry in
    #10;

    // Test 9: Adding two equal numbers (overflow)
    a = 4'b1000;  // a = 8
    b = 4'b1000;  // b = 8
    cin = 0;      // no carry in
    #10;

    // Test 10: Adding max value with no carry
    a = 4'b1111;  // a = 15
    b = 4'b1111;  // b = 15
    cin = 0;      // no carry in
    #10;

    // Test 11: Adding with different bits set
    a = 4'b0101;  // a = 5
    b = 4'b1010;  // b = 10
    cin = 0;      // no carry in
    #10;

    // Test 12: Adding a number to 0
    a = 4'b1111;  // a = 15
    b = 4'b0000;  // b = 0
    cin = 0;      // no carry in
    #10;

    // Test 13: Adding negative numbers (in two's complement)
    a = 4'b1000;  // a = -8 (two's complement)
    b = 4'b0100;  // b = 4
    cin = 0;      // no carry in
    #10;

    // Test 14: Adding all ones (max 4-bit values)
    a = 4'b1111;  // a = 15
    b = 4'b1111;  // b = 15
    cin = 1;      // carry in
    #10;

    $finish;
  end
endmodule
