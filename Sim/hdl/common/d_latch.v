`default_nettype none
module d_latch
(
    input  i_enable,    // Input: Enables latch to be on
    input  i_data,      // Input: data for the signal
    output wire o_q,    // Output: Q
    output wire o_not_q // Output: Not Q
);

// D latch using NOR gates and AND gates
assign o_q = ~((i_enable & ~i_data) | o_not_q);
assign o_not_q = ~((i_enable & i_data) |  o_q);

endmodule
