`default_nettype none
// Top Level module. Used to hook up all the modules
// Subject to lots of change.
module SAP_U (
    // System inputs
    input wire clk,   // System clock
    input wire reset, // System reset

    // Register A
    input wire       reg_a_load,    // Load signal
    input wire       reg_a_enable,  // Enable signal
    input wire [7:0] reg_a_idata,   // 8-bit data input

    // Register B
    input wire       reg_b_load,    // Load signal
    input wire       reg_b_enable,  // Enable signal
    input wire [7:0] reg_b_idata,   // 8-bit data input

    // ALU
    input wire alu_enable,
    input wire alu_subtract,

    // RAM
    input wire [7:0] ram_dipswitch_data,
    input wire [3:0] ram_dipswitch_addr,
    input wire [7:0] ram_bus_in,
    input wire ram_addr_select,
    input wire ram_prog_mode,
    input wire ram_write_enable,
    input wire ram_output_enable,
    input wire ram_control_signal,
    input wire ram_load_mar_reg,
    input wire ram_clear_mar_reg,

    // Outputs
    output wire [7:0] bus  // 8-bit bus
);

  // stored data in registers
  wire reg_a_data;
  wire reg_b_data;

  register register_a (
      .clk(clk),
      .clr(reset),
      .load(reg_a_load),
      .enable(reg_a_enable),
      .data(reg_a_idata),
      .q(reg_a_data)
  );
  register register_b (
      .clk(clk),
      .clr(reset),
      .load(reg_b_load),
      .enable(reg_b_enable),
      .data(reg_b_idata),
      .q(reg_b_data)
  );

  alu m_alu (
      .a(reg_a_data),
      .b(reg_b_data),
      .enable(alu_enable),
      .subtract(alu_subtract),
      .result(bus)
  );
  ram m_ram (
      .dipswitch_data(ram_dipswitch_data),
      .dipswitch_addr(ram_dipswitch_addr),
      .bus_in(bus),
      .addr_select(ram_addr_select),
      .prog_mode(ram_prog_mode),
      .write_enable(ram_write_enable),
      .output_enable(ram_output_enable),
      .control_signal(ram_control_signal),
      .load_mar_reg(ram_load_mar_reg),
      .clear_mar_reg(ram_clear_mar_reg),
      .clk(clk),
      .bus_out(bus)
  );

endmodule
