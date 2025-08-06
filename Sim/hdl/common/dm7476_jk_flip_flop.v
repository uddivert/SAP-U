`default_nettype none
module dm7476_jk_flip_flop(
    input  wire pr_n,
    input  wire clr_n,
    input  wire clk,
    input  wire j,
    input  wire k,
    output reg  q,
    output wire q_n
);
    assign q_n = ~q;

    always @(negedge clk or negedge pr_n or posedge clr_n) begin
        if (!pr_n && clr_n) begin
            // Asynchronous preset
            q <= 1'b1;
        end else if (pr_n && !clr_n) begin
            // Asynchronous clear
            q <= 1'b0;
        end else if (!pr_n && !clr_n) begin
            // Invalid state
            q <= 1'bx; 
        end else begin
            // Synchronous behavior on falling edge of clk
            case ({j, k})
                2'b00: q <= q;        // Hold
                2'b01: q <= 1'b0;     // Reset
                2'b10: q <= 1'b1;     // Set
                2'b11: q <= ~q;       // Toggle
            endcase
        end
    end

endmodule
