`default_nettype none
module d_flip_flop (
    input  wire clk,     // Input: clock
    input  wire data,  // Input: data for the signal
    input  wire reset,  // Input: reset signal
    output reg  q,     // Output: Q
    output wire q_not  // Output: Not Q
);

  // On the rising edge of the clock, the flip-flop captures the input data
  always @(posedge clk) begin
    q <= data;
  end

  // When reset signal is high, set output q to 0
  always @(reset) begin
    q <= 0;
  end

  // Not Q is simply the inverse of Q
  assign q_not = ~q;
endmodule
