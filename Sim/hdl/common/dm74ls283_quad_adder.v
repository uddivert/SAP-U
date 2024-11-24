 `default_nettype none
module dm74ls283_quad_adder(
    input wire [4:1] a, // input b
    input wire [4:1] b, // input a
    input wire cin, // carry in
    output wire [4:1] sum, // sum
    output wire cout // carry out
);

wire [4:1] gen; // generate signal
wire [4:1] prop; // propagate signal
wire [4:0] carry; // carry signals

// intial carry in
assign carry[0] = cin;

// create generate and propagation signals
assign gen = a & b;
assign prop = a | b; 

// carry calculation
assign carry[1] = gen[1] | (prop[1] & carry[0]);
assign carry[2] = gen[2] | (prop[2] & carry[1]);
assign carry[3] = gen[3] | (prop[3] & carry[2]);
assign carry[4] = gen[4] | (prop[4] & carry[3]);

// Use `generate` to instantiate the `full_adder` modules
genvar i;
generate
    for (i = 1; i <= 4; i = i + 1) begin : adder_chain
        full_adder full_adder_inst (
            .a(a[i]),
            .b(b[i]),
            .cin(carry[i-1]),
            .s(sum[i]),
            .cout() // carry-out is handled separately by `c` array
        );
    end
endgenerate

// Final carry out
assign cout = carry[4];

endmodule