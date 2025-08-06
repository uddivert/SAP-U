`default_nettype none
// Behavioural Design
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
        2'b00: q <= q;        // No change
        2'b01: q <= 0;        // Reset
        2'b10: q <= 1;        // Set
        2'b11: q <= ~q;       // Toggle
    endcase
end

endmodule

