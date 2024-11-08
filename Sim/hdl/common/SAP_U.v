`default_nettype none
// Top Level module. Used to hook up all the modules 
// Subject to lots of change.
module SAP_U (
    input  wire clk,        // System clock
    input  wire reset,      // System reset
    input  wire load,       // Load signal
    input  wire enable,     // Enable signal
    input  wire [7:0] data, // 8-bit data input
    output wire [7:0] q     // 8-bit output from register
);

    // Internal signal for connecting reg_inst to output q
    wire [7:0] register_q;

    // Instantiate the register module
    register reg_inst (
        .clk(clk),
        .clr(reset),
        .load(load),
        .enable(enable),
        .data(data),
        .q(register_q)
    );

    // Output assignment
    assign q = register_q;

endmodule
