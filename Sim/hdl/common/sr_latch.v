`default_nettype none
module sr_latch (
    input       set,    // Input: Set signal
    input       reset,  // Input: Reset signal
    output wire q,      // Output: Q
    output wire q_n     // Output: Not Q
);

  // SR latch using NOR gates
  assign q   = ~(reset | q_n);
  assign q_n = ~(set | q);

endmodule
