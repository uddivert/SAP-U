// memory address register

module mar (
    input wire [3:0] dipswitch_input,   // sets address
    input wire [3:0] bus,
    input wire load,
    input wire button_select,
    input wire clear,
    input wire enable,
    input wire clk,
    output wire [3:0] mar_out
);
  wire [3:0] qff_out;
  sn74ls157 mux (
      .a(qff_out),
      .b(dipswitch_input),
      .select(button_select),
      .strobe(1'b0),  // output always on
      .y(mar_out)
  );
  sn54173_quad_flip_flop qff (
      .m(enable),
      .n(enable),
      .g1(load),
      .g2(load),
      .clr(clear),
      .clk(clk),
      .data(bus),
      .q(qff_out)
  );

endmodule
