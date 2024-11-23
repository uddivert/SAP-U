module alu(
    input wire [7:0] a, // input b
    input wire [7:0] b, // input a
    input wire enable,
    input wire subtract,
    output wire [7:0] result
);

/*
 * Addition (subtract = 0): Computes result=a+bresult=a+b.
 * Subtraction (subtract = 1): Computes result=a−bresult=a−b using two's complement logic.
 * Enable Control: The result is gated by the enable signal; when enable = 0, result = 0.
*/

wire internal_carryout;
wire [7:0] internal_result;
wire [7:0] internal_b;

assign internal_b = b ^ subtract;
dm74ls283_quad_adder adder1(
    .a(a[3:0]), // input a
    .b(internal_b[3:0]), // input b
    .cin(subtract), // used for two's compliment
    .sum(internal_result[3:0]), // sum
    .cout(internal_carryout) // carry out
);

dm74ls283_quad_adder adder2(
    .a(a[7:4]), // input a
    .b(internal_b[7:4]), // input b
    .cin(internal_carryout), // used for two's compliment
    .sum(internal_result[7:4]), // sum
    .cout() // carry out ignored
);

// assign result dependent on enable
assign result = enable ? internal_result: 8'b0;

endmodule
