`timescale 1ns / 1ps
`default_nettype none

module tb_ram;

    reg [7:0] dipswitch_data;
    reg [3:0] dipswitch_addr;
    reg [7:0] bus_in;
    reg addr_button;
    reg data_button;
    reg write_enable;
    reg output_enable;
    reg control_signal;
    reg load_addr_reg;
    reg clear_addr_reg;
    reg enable_addr_reg;
    reg clk;
    wire [7:0] bus_out;

    // Instantiate the RAM module
    ram uut (
        .dipswitch_data(dipswitch_data),
        .dipswitch_addr(dipswitch_addr),
        .bus_in(bus_in),
        .addr_button(addr_button),
        .data_button(data_button),
        .write_enable(write_enable),
        .output_enable(output_enable),
        .control_signal(control_signal),
        .load_addr_reg(load_addr_reg),
        .clear_addr_reg(clear_addr_reg),
        .enable_addr_reg(enable_addr_reg),
        .clk(clk),
        .bus_out(bus_out)
    );

   initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns clock period
  end

    initial begin
        // Initialize inputs
        dipswitch_data = 8'b00001111;
        dipswitch_addr = 4'h0;
        bus_in = 8'h11110000;
        addr_button = 0;
        data_button = 0;
        write_enable = 0;
        output_enable = 0;
        control_signal = 0;
        load_addr_reg = 0;
        clear_addr_reg = 0;
        enable_addr_reg = 0;
        clk = 0;

        // Display initial state
        #10 $display("Initial state: bus_out = %h", bus_out);

        $finish;
    end

endmodule