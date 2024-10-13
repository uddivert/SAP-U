`default_nettype none
module d_flip_flop
(
    input  clk,         // Input: clock
    input  i_data,      // Input: data for the signal
    output reg o_q,     // Output: Q
    output wire o_not_q // Output: Not Q
);

    // On the rising edge of the clock, the flip-flop captures the input data
    always @(posedge clk) begin
        o_q <= i_data;
    end

    // Not Q is simply the inverse of Q
    assign o_not_q = ~o_q;
endmodule
