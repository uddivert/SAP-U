`default_nettype none
module sn54173_quad_flip_flop (
    input  wire load,
    input  wire data,
    input  wire reset,
    input  wire clk,
    output wire q
);

  wire internal_q, not_q, flop_data;

// Adjust logic of data input and load control
assign flop_data = (~load  & internal_q) | (load & data);
assign q = internal_q; // Capture internal_q on clock edge

d_flip_flop d_flip_flop1 (
  .clk(clk),
  .data(flop_data),
  .reset(reset),
  .q(internal_q),
  .q_not(not_q)
);

endmodule
