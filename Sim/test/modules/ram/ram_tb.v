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
        dipswitch_data = 8'b11001111;
        dipswitch_addr = 4'h0;
        bus_in = 8'b11110111;
        addr_button = 1; // don't load address from bus
        prog_mode = 0; // set to dipswitch_data
        write_enable = 1; // don't write to memory
        control_signal = 0;
        load_addr_reg = 0; // load address
        clear_addr_reg = 1; // clear mar
        output_enable = 0;

        #6
        write_enable = 0;
        clear_addr_reg = 0;

        // Display initial state
        #10 $display("Initial state: bus_out = %h", bus_out);
        write_enable= 1;

        // change address and save data here
        prog_mode = 1;
        dipswitch_addr = 4'h1;
        write_enable= 0;
        #10 $display("Second state: bus_out = %h", bus_out);
        write_enable= 1;

        // try change address without load address set off
        #10 load_addr_reg= 1;
        dipswitch_addr = 4'h0;

        // check memory to make sure if memory in address 0 is still same
        load_addr_reg = 0;
        #10

        // clear address reg
        dipswitch_addr = 4'h5;
        #10
        clear_addr_reg = 1; // clear qff in mar
        #10


        $finish;
    end

endmodule