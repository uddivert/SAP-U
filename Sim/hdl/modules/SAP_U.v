`default_nettype none
// Top Level module. Used to hook up all the modules
// Subject to lots of change.
module SAP_U (
    // System inputs
    input wire clk,   // System clock
    input wire reset, // System reset

    // Register A
    input wire       reg_a_load_n,
    input wire       reg_a_bus_enable_n,

    // Register B
    input wire       reg_b_load_n, 
    input wire       reg_b_bus_enable_n,
    input wire [7:0] reg_b_bus_in,

    // ALU
    input wire alu_enable,
    input wire alu_subtract,

    // RAM
    input wire [7:0] ram_dipswitch_data,
    input wire [3:0] ram_dipswitch_addr,
    input wire ram_addr_select,
    input wire ram_prog_mode,
    input wire ram_output_enable,
    input wire ram_control_signal,
    input wire ram_load_mar_reg,
    input wire ram_clear_mar_reg,

    // Outputs
    output wire [7:0] bus  // 8-bit bus
);
    wire [7:0] a_reg_bus_in, a_reg_bus_out;
    wire [7:0] b_reg_bus_in, b_reg_bus_out;
    wire [7:0] alu_bus_in, alu_bus_out;
    wire [7:0] ram_bus_in, ram_bus_out;
    wire [7:0] data_bus_in, data_bus_out;

Bus_Manager bus_manager(
    .a_reg_bus_in(a_reg_bus_in),
    .a_reg_bus_out(a_reg_bus_out),
    .b_reg_bus_in(b_reg_bus_in),
    .b_reg_bus_out(b_reg_bus_out),
    .alu_bus_in(alu_bus_in),
    .alu_bus_out(alu_bus_out),
    .ram_bus_in(ram_bus_in),
    .ram_bus_out(ram_bus_out),
    .data_bus_in(data_bus_in),
    .data_bus_out(data_bus_out)
);

  // stored data in registers
  wire [7:0] reg_a_data;
  wire [7:0] reg_b_data;

  register register_a (
      .clk(clk),
      .clr(reset),
      .load_n(reg_a_load_n),
      .bus_in(a_reg_bus_in),
      .bus_out(a_reg_bus_out),
      .q(reg_a_data)
  );
  register register_b (
      .clk(clk),
      .clr(reset),
      .load_n(reg_b_load_n),
      .bus_in(b_reg_bus_in),
      .bus_out(a_reg_bus_out),
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
      .output_enable(ram_output_enable),
      .control_signal(ram_control_signal),
      .load_mar_reg(ram_load_mar_reg),
      .clear_mar_reg(ram_clear_mar_reg),
      .clk(clk),
      .bus_out(bus)
  );

endmodule

module Bus_Manager(
    input wire [7:0] a_reg_bus_in,
    input wire [7:0] a_reg_bus_out,
    input wire [7:0] b_reg_bus_in,
    input wire [7:0] b_reg_bus_out,
    input wire [7:0] alu_bus_in,
    input wire [7:0] ram_bus_in,
    input wire [7:0] ram_bus_out,
    input wire [7:0] alu_bus_out,
    output wire [7:0] data_bus_in,
    output wire [7:0] data_bus_out
);
endmodule
