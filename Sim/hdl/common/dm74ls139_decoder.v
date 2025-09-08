`default_nettype none
module dm74ls139 (
  input  wire [1:0] enable_n,
  input  wire [1:0] select, 
  output wire [3:0] y1_n,
  output wire [3:0] y2_n
);
// Decoder 1
assign y1_n = (enable_n[0] == 1'b0) ?
    ~(4'b0001 << select) : 4'b1111;

// Decoder 2
assign y2_n = (enable_n[1] == 1'b0) ? 
    ~(4'b0001 << select) : 4'b1111;

endmodule
