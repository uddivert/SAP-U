`default_nettype none
module sn54173_quad_flip_flop (
    input  wire m,
    input  wire n,
    input  wire g1,
    input  wire g2,
    input  wire clr,
    input  wire clk,
    input  wire [3:0] data,
    output wire [3:0] q 
);

    // internal signals
    wire [3:0] internal_q;
    wire [3:0] not_q;
    wire [3:0] flop_data;

    // If  g1 and g2 BOTH low and load is enabled, data is loaded into d flipflop.
    // else value stays with current value of Q
    // M & N must both be low for output to be set
    for (i = 0; i < 4; i = i + 1) begin
        assign flop_data[i] = ( (~load & internal_q[i]) | (load & data[i]) & ~g1 & ~g2); 
        assign q = internal_q[i] & ~m & ~n;
    end 

    genvar i;
    generate
      for (i=1; i<=4; i=i+1) begin : generated_d_flip_flops
        d_flip_flop (
            .clk(clk),
            .data(flop_data[i]),
            .reset(clear),
            .q(internal_q)[i],
            .q_not(not_q[i])
        );
       end 
    endgenerate
endmodule