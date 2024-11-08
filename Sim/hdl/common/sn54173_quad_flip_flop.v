`default_nettype none
module sn54173_quad_flip_flop (
    input wire m,
    input wire n,
    input wire g1,
    input wire g2,
    input wire clr,
    input wire clk,
    input wire [3:0] data,
    output wire [3:0] q
);

  // internal signals
  wire [3:0] internal_q;
  wire [3:0] not_q;
  wire [3:0] flop_data;

  genvar i;
  generate
    for (i = 0; i <= 3; i = i + 1) begin : g_d_flip_flops // label for generate function

      // If  g1 and g2 BOTH low, data is loaded into d flipflop.
      // else value stays with current value of Q
      // M & N must both be low for output to be set
      assign flop_data[i] = ((~(~g1 & ~g2) & internal_q[i]) | ((~g1 & ~g2) & data[i]));
      assign q[i] = internal_q[i] & ~m & ~n;

      d_flip_flop dff (
          .clk(clk),
          .data(flop_data[i]),
          .reset(clr),
          .q(internal_q[i]),
          .q_not(not_q[i])
      );
    end
  endgenerate
endmodule
