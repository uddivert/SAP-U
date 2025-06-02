`timescale 1ns / 1ps

module SAP_U_tb ();
  // System inputs
  reg        clk;  // System clock
  reg        reset;  // System reset

  // Register A
  reg        reg_a_load_n;  // Load signal
  reg        reg_a_bus_enable_n;  // Enable signal
  reg  [7:0] reg_a_bus_in;  // 8-bit data input

  // Register B
  reg        reg_b_load_n;  // Load signal
  reg        reg_b_bus_enable_n;  // Enable signal
  reg  [7:0] reg_b_bus_in;  // 8-bit data input

  // ALU
  reg        alu_enable;
  reg        alu_subtract;

  // Ram
  reg  [7:0] ram_dipswitch_data;
  reg  [3:0] ram_dipswitch_addr;
  reg        ram_addr_select;
  reg        ram_prog_mode;
  reg        ram_output_enable;
  reg        ram_control_signal;
  reg        ram_load_mar_reg;
  reg        ram_clear_mar_reg;

  // Outputs
  wire [7:0] bus;  // 8-bit bus


  SAP_U uut (
      // System inputs
      .clk  (clk),   // System clock
      .reset(reset), // System reset

      // Register A
      .reg_a_load_n  (reg_a_load_n),    // Load signal
      .reg_a_bus_enable_n(reg_a_bus_enable_n),  // Enable signal

      // Register B
      .reg_b_load_n  (reg_b_load_n),    // Load signal
      .reg_b_bus_enable_n(reg_b_bus_enable_n),  // Enable signal

      // ALU
      .alu_enable  (alu_enable),    // Lets ALU output to bus
      .alu_subtract(alu_subtract),
/*
      // Ram
      .ram_dipswitch_data(ram_dipswitch_data),
      .ram_dipswitch_addr(ram_dipswitch_addr),
      .ram_bus_in(bus),
      .ram_addr_select(ram_addr_select),
      .ram_prog_mode(ram_prog_mode),
      .ram_output_enable(ram_output_enable),
      .ram_control_signal(ram_control_signal),
      .ram_load_mar_reg(ram_load_mar_reg),
      .ram_clear_mar_reg(ram_clear_mar_reg),
      */

      .bus(bus)  // 8-bit bus
  );

  // Clock generation: 50% duty cycle with a period of 10 time units
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns clock period
  end

  initial begin
    $dumpfile("./simulation/testbench_master.vcd");  // VCD file for waveform generation
    $dumpvars(0, SAP_U_tb);
    // Test ALU

    // allow data to be loaded into register
    reg_a_load_n   = 0;
    reg_b_load_n   = 0;
    alu_enable   = 0; // Enable ALU output to bus
    reset = 0;

    // data to be loaded into register
    // TODO

    #10
    // stop registers from writing to bus
    alu_subtract = 0; // Addition Mode
    #10;

    // test subtraction
    alu_subtract = 1;
    #10

/*
    // Test Ram
    ram_dipswitch_data = 8'h0;
    ram_dipswitch_addr = 4'h0;
    ram_bus_in = 8'h0;
    ram_addr_select = 1;    // don't load address from bus
    ram_prog_mode = 0;      // set to dipswitch_data
    ram_control_signal = 0; // Don't read data from bus
    ram_load_mar_reg = 0;   // load address
    ram_clear_mar_reg = 1;  // clear mar
    ram_output_enable = 0;  // enable output

    #5 
    // Set dipswich data to F and write to address 0
    ram_dipswitch_data = 8'b1;
    #10
    */

    $finish;
  end
endmodule
