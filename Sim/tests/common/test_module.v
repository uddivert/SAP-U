module test_module (
    input  wire clk,    // Input: clock

    // D Flip Flop
    input  wire data_dff,   // Input: data for the signal
    input  wire reset_dff,  // Input: reset signal
    output reg  q_dff,      // Output: Q
    output wire q_not_dff,   // Output: Not Q

    // sn54173_quad_flip_flop
    input wire m_qff,
    input wire n_qff,
    input wire g1_qff,
    input wire g2_qff,
    input wire clr_qff,
    input wire [3:0] data_qff,
    output wire [3:0] q_qff,

    //D Latch
    input wire enable_dl,  // Input: Enables latch to be on
    input wire data_dl,    // Input: data for the signal
    output wire q_dl,       // Output: Q
    output wire q_not_dl,    // Output: Not Q

    // Carry look ahead adder
    input wire [4:1] a_cla, // input b
    input wire [4:1] b_cla, // input a
    input wire cin_cla, // carry in
    output wire [4:1] sum_cla, // sum
    output wire cout_cla, // carry out

    // Full adder
    input wire a_fa, // input a
    input wire b_fa, // input b
    input wire cin_fa, // carry in
    output wire s_fa, // sum
    output wire cout_fa, // carry out

    // SR Latch
    input wire set_sr,    // Input: Set signal
    input wire reset_sr,  // Input: Reset signal
    output wire q_sr,      // Output: Q
    output wire q_not_sr   // Output: Not Q
);
    d_flip_flop dff (
        .clk(clk),
        .data(data_dff),
        .reset(reset_dff),
        .q(q_dff),
        .q_not(q_not_dff)
    );

    d_latch latch (
        .enable(enable_dl),  // Input: Enables latch to be on
        .data(data_dl),    // Input: data for the signal
        .q(q_dl),       // Output: Q
        .q_not(q_not_dl)   // Output: Not Q
    );

    sn54173_quad_flip_flop qff(
        .m(m_qff),
        .n(n_qff),
        .g1(g1_qff),
        .g2(g2_qff),
        .clr(clr_qff),
        .clk(clk),
        .data(data_qff),
        .q(q_qff)
    );

    d_latch dl(
        .enable(enable_dl),  // Input: Enables latch to be on
        .data(data_dl),    // Input: data for the signal
        .q(q_dl),       // Output: Q
        .q_not(q_not_dl)    // Output: Not Q
    );

    full_adder fa(
        .a(a_fa), // input a
        .b(b_fa), // input b
        .cin(cin_fa), // carry in
        .s(s_fa), // sum
        .cout(cout_fa) // carry out
    );

    dm74ls283_quad_adder cla(
        .a(a_cla), // input b
        .b(b_cla), // input a
        .cin(cin_cla), // carry in
        .sum(sum_cla), // sum
        .cout(cout_cla) // carry out
    );

    sr_latch sl(
        .set(set_sr),
        .reset(reset_sr),
        .q(q_sr),
        .q_not(q_not_sr)
    );
endmodule
