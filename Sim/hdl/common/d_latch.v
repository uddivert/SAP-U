`default_nettype none
module d_latch (
    input wire enable,  // Input: Enables latch to be on
    input wire data,    // Input: data for the signal
    output wire q,       // Output: Q
    output wire q_not    // Output: Not Q
);

  // D latch using NOR gates and AND gates
  assign q = ~((enable & ~data) | q_not);
  assign q_not = ~((enable & data) | q);

endmodule
