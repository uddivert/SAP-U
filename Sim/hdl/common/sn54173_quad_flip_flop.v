`default_nettype none
module sn54173_quad_flip_flop (
    // m and n both need to be low for output to be enabled
    input  wire m,
    input  wire n,
    input  wire g1,
    input  wire g2,
    input  wire [3:0] data,
    input  wire clr,
    input  wire clk,
    output wire [3:0] q 
);

    // internal signals
    wire [3:0] internal_q;
    wire [3:0] not_q;
    wire [3:0] flop_data;

    // Adjust logic of data input and load control
    for (i = 0; i < 4; i = i + 1) begin
        assign flop_data[i] = ( (~load & internal_q[i]) | (load & data[i]) & ~g1 & ~g2); // Data assigned if g1 and g2 both low, and load is enabled
        assign q = internal_q[i] & ~m & ~n;  // Capture internal_q on clock edge. Only output if m and n are BOTH low
    end 

    d_flip_flop d_flip_flop1 (
        .clk(clk),
        .data(flop_data[0]),
        .reset(clear),
        .q(internal_q)[0],
        .q_not(not_q[0])
    );

    d_flip_flop d_flip_flop2 (
        .clk(clk),
        .data(flop_data[1]),
        .reset(clear),
        .q(internal_q)[1],
        .q_not(not_q[1])
    );
    d_flip_flop d_flip_flop3 (
        .clk(clk),
        .data(flop_data[2]),
        .reset(clear),
        .q(internal_q)[2],
        .q_not(not_q[2])
    );
    d_flip_flop d_flip_flop4 (
        .clk(clk),
        .data(flop_data[3]),
        .reset(clear),
        .q(internal_q)[3],
        .q_not(not_q[3])
    );
endmodule
