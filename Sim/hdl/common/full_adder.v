 `default_nettype none
module full_adder(
    input wire a, // input a
    input wire b, // input b
    input wire cin, // carry in
    output wire s, // sum
    output wire cout // carry out
);

// The expression for sum as a Sum of Products is:
// (~a & ~b & cin) | (~a & b & ~cin) | (a & ~b & ~cin) | (a & b & cin);
//
// This can be optimized into sum = cin XOR (a XOR b)
assign s = cin ^ (a ^ b); 


// The expression for carry out as a Sum of Products is:
// (~a & b & cin) | (a & ~b & cin) | (a & b & ~cin) | (a & b & cin);
//
// This can be optimized into cout = ab OR cin AND (a XOR b)

assign cout = a & b | cin & (a ^ b);

endmodule
