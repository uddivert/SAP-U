`timescale 1ns/1ps

module sn54173_quad_flip_flop_tb;

    // Inputs
    reg load;
    reg data;
    reg reset;
    reg clk;

    // Outputs
    wire q;

    // Instantiate the Unit Under Test (UUT)
    sn54173_quad_flip_flop uut (
        .load(load),
        .data(data),
        .reset(reset),
        .clk(clk),
        .q(q)
    );

    // Clock generation: 50% duty cycle with a period of 10 time units
    always begin
        clk = 0;
        #5 clk = 1;
        #5 clk = 0; // 10ns clock period (100 MHz)
    end

    // Testbench stimulus
    initial begin
        $dumpfile("./simulation/testbench_master.vcd"); // VCD file for waveform generation
        $dumpvars(0, sn54173_quad_flip_flop_tb);

        // Initialize all inputs
        load = 0;
        data = 0;
        reset = 1; // Start with reset active
        #15;       // Wait a bit to see the reset effect

        // Case 1: Reset deasserted, load is high, data is 1
        reset = 0;
        load = 1;
        data = 1;
        #10;  // Wait for a clock edge

        // Case 2: Load is low, holding the previous data
        load = 0;
        #10;  // Wait for a clock edge

        // Case 3: Change data to 0, load is high (load the new data)
        load = 1;
        data = 0;
        #10;  // Wait for a clock edge

        // Case 4: Hold the previous state (load is low)
        load = 0;
        #10;  // Wait for a clock edge

    // Case 5: Activate reset, observe q goes to 0
    reset = 1;
    #10;  // Wait for a clock edge

        // Case 6: Deassert reset, load a new value (data = 1)
        reset = 0;
        load = 1;
        data = 1;
        #10;  // Wait for a clock edge

        // End simulation
        $finish;
    end
endmodule

