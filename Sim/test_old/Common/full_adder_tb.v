`timescale 1ns / 1ps

module full_adder_tb();

    // Declare inputs as reg and outputs as wire
    reg a;
    reg b;
    reg cin;
    wire s;
    wire cout;

    // Instantiate the full adder module
    full_adder uut (
        .a(a),
        .b(b),
        .cin(cin),
        .s(s),
        .cout(cout)
    );

    // Initial block for applying test vectors
    initial begin
        // Create a waveform dump file for simulation
        $dumpvars(0, full_adder_tb);

        // Test all combinations of inputs

        a = 0; b = 0; cin = 0; #15;
        a = 0; b = 0; cin = 1; #15;
        a = 0; b = 1; cin = 0; #15;
        a = 0; b = 1; cin = 1; #15;
        a = 1; b = 0; cin = 0; #15;
        a = 1; b = 0; cin = 1; #15;
        a = 1; b = 1; cin = 0; #15;
        a = 1; b = 1; cin = 1; #15;

        // Finish the simulation
        $finish;
    end

endmodule

