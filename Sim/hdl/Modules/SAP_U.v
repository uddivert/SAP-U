`default_nettype none
// Top Level module. Used to hook up all the modules 
// Subject to lots of change.
module SAP_U (
    // System inputs
    input  wire clk,        // System clock
    input  wire reset,      // System reset

    // Register A
    input  wire reg_a_load,       // Load signal
    input  wire reg_a_enable,     // Enable signal
    input  wire [7:0] reg_a_idata, // 8-bit data input

    // Register B
    input  wire reg_b_load,       // Load signal
    input  wire reg_b_enable,     // Enable signal
    input  wire [7:0] reg_b_idata, // 8-bit data input

    // ALU
    input wire alu_enable, 
    input wire alu_subtract,

    // Outputs
    output wire [7:0] bus     // 8-bit bus
);

    // stored data in registers
    wire reg_a_data;
    wire reg_b_data;

    register register_a(
        .clk(clk),
        .clr(reset),
        .load(reg_a_load),
        .enable(reg_a_enable),
        .data(reg_a_idata),
        .q(reg_a_data)
    );
    register register_b(
        .clk(clk),
        .clr(reset),
        .load(reg_b_load),
        .enable(reg_b_enable),
        .data(reg_b_idata),
        .q(reg_b_data)
    );

    alu m_alu(
        .a(reg_a_data),
        .b(reg_b_data),
        .enable(alu_enable),
        .subtract(alu_subtract),
        .result(bus)
    );

endmodule
