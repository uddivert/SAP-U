module sn74ls159 (
    input wire [3:0] a,
    input wire [3:0] b,
    input wire select,
    input wire strobe,
    output wire [3:0] y
);
 genvar i;
  generate
    for (i = 0; i <= 3; i = i + 1) begin : mux
    assign y[i] = (a[i] & ~select & ~strobe) | (b[i] & select & ~strobe);
    end
    endgenerate
endmodule