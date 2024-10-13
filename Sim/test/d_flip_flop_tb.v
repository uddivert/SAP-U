`default_nettype none
module d_flip_flop_tb;

    // Declare input signals as registers and output signals as wires
    reg clk, data;
    wire q, not_q;

    // Instantiate the DUT (Device Under Test)
    d_flip_flop uut (
        .clk(clk),      // Clock signal
        .i_data(data),  // Data input
        .o_q(q),        // Output Q
        .o_not_q(not_q) // Output Not Q
    );

    // Clock signal generation: 50% duty cycle with a period of 10 time units
    always begin
        clk = 0; #5;    // Clock low for 5 time units
        clk = 1; #5;    // Clock high for 5 time units
    end

    // Testbench logic
    initial begin
        $dumpfile("./simulation/d_flip_flop_tb.vcd"); 
        $dumpvars(0, d_flip_flop_tb);  // Correct instance name

        // case 1: No data
        data = 0; #10;

        // case 2: Data high
        data = 1; #10;

        // case 3: Data remains high
        data = 1; #10;

        // case 4: Data goes low
        data = 0; #10;

        // case 5: Data remains low
        data = 0; #10;

        $finish; // End simulation
    end
endmodule

