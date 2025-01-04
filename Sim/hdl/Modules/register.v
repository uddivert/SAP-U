// Difference from circuit board'set implementaton
// Using the sn54172's tristate buffer for output control
//
// This is because we don't need the 74LS24 octal bus transciever
// to go between the sn54173 to see the output
`default_nettype none
module register (
    input wire load,
    input wire enable,
    input wire clr,
    input wire clk,
    input wire [7:0] data,
    output wire [7:0] q
);
  sn54173_quad_flip_flop sn54173_1 (
      .m(enable),
      .n(enable),
      .g1(load),
      .g2(load),
      .clr(clr),
      .clk(clk),
      .data(data[3:0]),  // lower 4 bits of data
      .q(q[3:0])  // lower 4 bits of q
  );
  sn54173_quad_flip_flop sn54173_2 (
      .m(enable),
      .n(enable),
      .g1(load),
      .g2(load),
      .clr(clr),
      .clk(clk),
      .data(data[7:4]),  // upper 4 bits of data
      .q(q[7:4])  // upper 4 bits of q
  );
endmodule
