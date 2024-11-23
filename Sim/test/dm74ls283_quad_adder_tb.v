`timescale 1ns / 1ps

module dm74ls283_quad_adder_tb();
reg [4:1] a; // input b
reg [4:1] b; // input a
reg cin; // carry in
wire [4:1] s1; // sum
wire cout; // carry out

dm74ls283_quad_adder uut(
    .a(a),
    .b(b),
    .cin(cin),
    .s1(s1),
    .cout(cout)
);

  // Testbench stimulus
  initial begin
    $dumpfile("./simulation/testbench_master.vcd");  // VCD file for waveform generation
    $dumpvars(0, dm74ls283_quad_adder_tb);

    // setup conditions
    a = 4'b0000;
    b = 4'b0000;
    cin = 0;
    #10

    a = 4'b1000;
    b = 4'b0000;
    cin = 0;
    #10
    
    a = 4'b1000;
    b = 4'b0000;
    cin = 1;
    #10

    a = 4'b1111;
    b = 4'b1111;
    cin = 1;
    #10
    $finish;
  end
endmodule