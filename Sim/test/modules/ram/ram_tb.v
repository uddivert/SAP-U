`timescale 1ns / 1ps
`default_nettype none

module ram_tb;

    reg [7:0] dipswitch_data;
    reg [3:0] dipswitch_addr;
    reg [7:0] bus_in;
    reg addr_button;
    reg prog_mode;
    reg write_enable;
    reg output_enable;
    reg control_signal;
    reg load_addr_reg;
    reg clear_addr_reg;
    reg clk;
    wire [7:0] bus_out;

    // Instantiate the RAM module
    ram uut (
        .dipswitch_data(dipswitch_data),
        .dipswitch_addr(dipswitch_addr),
        .bus_in(bus_in),
        .addr_button(addr_button),
        .prog_mode(prog_mode),
        .write_enable(write_enable),
        .output_enable(output_enable),
        .control_signal(control_signal),
        .load_addr_reg(load_addr_reg),
        .clear_addr_reg(clear_addr_reg),
        .clk(clk),
        .bus_out(bus_out)
    );

  // Clock signal generation: 50% duty cycle with a period of 10 time units
  always begin
    clk = 0;
    #5;  // Clock low for 5 time units
    clk = 1;
    #5;  // Clock high for 5 time units
  end

    initial begin
    $dumpfile("./simulation/ram_tb.vcd");  // VCD file for waveform generation
    $dumpvars(0, ram_tb);
        // Initialize inputs
        dipswitch_data = 8'b00001111;
        dipswitch_addr = 4'h0;
        bus_in = 8'b11110000;
        addr_button = 0;
        prog_mode = 0; // set to dipswitch_data
        write_enable = 1;
        control_signal = 0;
        load_addr_reg = 0;
        clear_addr_reg = 1;

        #6
        write_enable = 0;
        output_enable = 0;
        clear_addr_reg = 0;

        // Display initial state
        #20 $display("Initial state: bus_out = %h", bus_out);

        #1  prog_mode = 1;
        #10 dipswitch_addr = 4'h1;

        $finish;
    end

endmodule