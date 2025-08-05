`default_nettype none

// Modeled Behaviorly
module jk_flipflop (
    input wire j,
    input wire k,
    input wire clk,
    output reg q,
    output wire q_n
);

assign q_n = ~q;

always @(posedge clk) begin
    case ({j, k})
        2'b00: q <= q;
        2'b01: q <= 0;
        2'b10: q <= 1;
        2'b11: q <= ~q;
    endcase
end

endmodule

