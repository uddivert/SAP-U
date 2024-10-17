`default_nettype none
module d_flip_flop (
    input  wire clk,     // Input: clock
    input  wire data,  // Input: data for the signal
    input  wire reset,  // Input: reset signal
    output reg  q,     // Output: Q
    output wire q_not  // Output: Not Q
);

    // On the rising edge of the clock, the flip-flop captures the input data
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 0;
        end else begin
            q <= data;
        end
    end

    // Not Q is simply the inverse of Q
    assign q_not = ~q;
endmodule
