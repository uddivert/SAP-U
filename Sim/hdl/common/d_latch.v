`default_nettype none
module d_latch (
    input  wire enable,  // Input: Enables latch to be on
    input  wire data,    // Input: data for the signal
    output wire q,       // Output: Q
    output wire q_n      // Output: Not Q
);

  // D latch using NOR gates and AND gates
  assign q = ~((enable & ~data) | q_n);
  assign q_n = ~((enable & data) | q);

endmodule
