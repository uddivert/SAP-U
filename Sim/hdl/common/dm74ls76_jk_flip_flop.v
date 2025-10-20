`default_nettype none
module dm74ls76_jk_flip_flop (
    input  wire [1:0] pr_n,
    input  wire [1:0] clr_n,
    input  wire clk,
    input  wire [1:0] j,
    input  wire [1:0] k,
    output reg  [1:0] q,
    output wire [1:0] q_n
);
  assign q_n = ~q;

  genvar i;
  generate
    for (i = 0; i < 2; i = i + 1) begin : jk_pair
      always @(negedge clk or negedge pr_n[i] or negedge clr_n[i]) begin
        if (!pr_n[i] && !clr_n[i]) begin
          // Invalid state
          q[i] <= 1'bx;
        end else if (!pr_n[i]) begin
          // Asynchronous preset
          q[i] <= 1'b1;
        end else if (!clr_n[i]) begin
          // Asynchronous clear
          q[i] <= 1'b0;
        end else begin
          // Synchronous JK behavior
          case ({j[i], k[i]})
            2'b00: q[i] <= q[i];   // Hold
            2'b01: q[i] <= 1'b0;   // Reset
            2'b10: q[i] <= 1'b1;   // Set
            2'b11: q[i] <= ~q[i];  // Toggle
          endcase
        end
      end
    end
  endgenerate

endmodule
