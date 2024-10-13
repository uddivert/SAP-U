`default_nettype none
module sr_latch (
    input       set,    // Input: Set signal
    input       reset,  // Input: Reset signal
    output wire q,      // Output: Q
    output wire q_not   // Output: Not Q
);

  // SR latch using NOR gates
  assign q = ~(reset | q_not);
  assign q_not = ~(set | q);

endmodule
