`default_nettype none
module register (
    input wire load_n,
    input wire clr,
    input wire clk,
    input wire bus_enable_n,
    input wire [7:0] bus_in,
    output wire [7:0] q,
    output wire [7:0] bus_out
);

  sn54173_quad_flip_flop sn54173_1 (
      .m(1'b0),
      .n(1'b0),
      .g1(load_n),
      .g2(load_n),
      .clr(clr),
      .clk(clk),
      .data(bus_in[3:0]),  // lower 4 bits of bus_in
      .q(q[3:0])  // lower 4 bits of q
  );
  sn54173_quad_flip_flop sn54173_2 (
      .m(1'b0),
      .n(1'b0),
      .g1(load_n),
      .g2(load_n),
      .clr(clr),
      .clk(clk),
      .data(bus_in[7:4]),  // upper 4 bits of data
      .q(q[7:4])  // upper 4 bits of q
  );

  // assign bus
  assign bus_out = bus_enable_n ? 8'bZ: q;

endmodule
