`timescale 1ns / 1ps

module SAP_U_tb ();
  // System inputs
  reg        clk;  // System clock
  reg        reset;  // System reset

  // Register A
  reg        reg_a_load;  // Load signal
  reg        reg_a_enable;  // Enable signal
  reg  [7:0] reg_a_idata;  // 8-bit data input

  // Register B
  reg        reg_b_load;  // Load signal
  reg        reg_b_enable;  // Enable signal
  reg  [7:0] reg_b_idata;  // 8-bit data input

  // ALU
  reg        alu_enable;
  reg        alu_subtract;

  // Ram
  reg  [7:0] ram_dipswitch_data;
  reg  [3:0] ram_dipswitch_addr;
  reg  [7:0] ram_bus_in;
  reg        ram_addr_select;
  reg        ram_prog_mode;
  reg        ram_write_enable;
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
      .reg_a_load  (reg_a_load),    // Load signal
      .reg_a_enable(reg_a_enable),  // Enable signal
      .reg_a_idata (reg_a_idata),   // 8-bit data input

      // Register B
      .reg_b_load  (reg_b_load),    // Load signal
      .reg_b_enable(reg_b_enable),  // Enable signal
      .reg_b_idata (reg_b_idata),   // 8-bit data input

      // ALU
      .alu_enable  (alu_enable),
      .alu_subtract(alu_subtract),

      // Ram
      .ram_dipswitch_data(ram_dipswitch_data),
      .ram_dipswitch_addr(ram_dipswitch_addr),
      .ram_bus_in(bus),
      .ram_addr_select(ram_addr_select),
      .ram_prog_mode(ram_prog_mode),
      .ram_write_enable(ram_write_enable),
      .ram_output_enable(ram_output_enable),
      .ram_control_signal(ram_control_signal),
      .ram_load_mar_reg(ram_load_mar_reg),
      .ram_clear_mar_reg(ram_clear_mar_reg),

      .bus(bus)  // 8-bit bus
  );

  // Clock generation: 50% duty cycle with a period of 10 time units
  always begin
    clk = 0;
    #5 clk = 1;
    #5 clk = 0;  // 10ns clock period (100 MHz)
  end

  initial begin
    $dumpfile("./simulation/testbench_master.vcd");  // VCD file for waveform generation
    $dumpvars(0, SAP_U_tb);
    // Test ALU
    #1;  // 1 ns delay
    // allow data to be loaded into register
    reg_a_load   = 0;
    reg_b_load   = 0;

    // data to be loaded into register
    reg_a_idata  = 8'b00000001;
    reg_b_idata  = 8'b00000001;

    // enable data output
    reg_a_enable = 0;
    reg_b_enable = 0;

    // enable alu to recieve from registers
    alu_enable   = 0;
    alu_subtract = 0;

    #10;
    // test subtraction
    alu_subtract = 1;

    $finish;
  end
endmodule
