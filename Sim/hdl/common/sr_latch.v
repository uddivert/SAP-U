`default_nettype none
module sr_latch
(
    input  i_set,       // Input: Set signal
    input  i_reset,     // Input: Reset signal
    output wire o_q,    // Output: Q
    output wire o_not_q // Output: Not Q
);

// SR latch using NOR gates
assign o_q = ~(i_reset| o_not_q);
assign o_not_q = ~(i_set | o_q);

endmodule

