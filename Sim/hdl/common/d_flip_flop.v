`default_nettype none
module d_flip_flop (
    input       clk,     // Input: clock
    input       data,  // Input: data for the signal
    output reg  q,     // Output: Q
    output wire q_not  // Output: Not Q
);

  // On the rising edge of the clock, the flip-flop captures the input data
  always @(posedge clk) begin
    q <= data;
  end

  // Not Q is simply the inverse of Q
  assign q_not = ~q;
endmodule
