`timescale 1ns / 1ps `default_nettype none

module mar_tb;
  reg [3:0] dipswitch_input, bus;
  reg load, button_select, clear, enable, clk;
  wire [3:0] mar_out;

  mar uut (
      .dipswitch_input(dipswitch_input),
      .bus(bus),
      .load(load),
      .button_select(button_select),
      .clear(clear),
      .enable(enable),
      .clk(clk),
      .mar_out(mar_out)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns clock period
  end

  initial begin
    $dumpfile("./simulation/mar_tb.vcd");
    $dumpvars(0, mar_tb);
    {clear, enable, load} = 0;  // set clear off, enable on, load on
    button_select = 0;
    dipswitch_input = 4'b1010;
    bus = 4'b0101;
    #10;
    button_select = 1;
    #10;
    clear = 1;
    #10;
    $finish;
  end

endmodule
