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
    input wire alu_enable_n,
    input wire alu_subtract,

    // RAM
    input wire [7:0] ram_dipswitch_data,
    input wire [3:0] ram_dipswitch_addr,
    input wire ram_addr_select,
    input wire ram_prog_mode,
    input wire ram_bus_enable_n,
    input wire ram_write_enable_n,
    input wire ram_control_signal,
    input wire ram_load_mar_reg_n,
    input wire ram_clear_mar_reg,

    // Bus
    input wire [7:0] data_bus_in
);
    wire [7:0] data_bus_out;
    wire [7:0] reg_a_bus_out;
    wire [7:0] reg_b_bus_out;
    wire [7:0] alu_bus_out;
    wire [7:0] ram_bus_out;

Bus_Manager bus_manager(
    .data_bus_in(data_bus_in),
    .data_bus_out(data_bus_out),

    .reg_a_bus_out(reg_a_bus_out),
    .reg_a_bus_enable_n(reg_a_bus_enable_n),

    .reg_b_bus_out(reg_b_bus_out),
    .reg_b_bus_enable_n(reg_b_bus_enable_n),

    .alu_bus_out(alu_bus_out),
    .alu_bus_enable_n(alu_enable_n),

    .ram_bus_out(ram_bus_out),
    .ram_bus_enable_n(ram_bus_enable_n)
);

  // stored data in registers
  wire [7:0] reg_a_data;
  wire [7:0] reg_b_data;

  register register_a (
      .clk(clk),
      .clr(reset),
      .bus_enable_n(reg_a_bus_enable_n),
      .load_n(reg_a_load_n),
      .bus_in(data_bus_in),
      .bus_out(reg_a_bus_out),
      .q(reg_a_data)
  );
  register register_b (
      .clk(clk),
      .clr(reset),
      .bus_enable_n(reg_b_bus_enable_n),
      .load_n(reg_b_load_n),
      .bus_in(data_bus_in),
      .bus_out(reg_a_bus_out),
      .q(reg_b_data)
  );

  alu m_alu (
      .a(reg_a_data),
      .b(reg_b_data),
      .bus_enable_n(alu_enable_n),
      .subtract(alu_subtract),
      .bus_out(alu_bus_out)
  );

  // TODO fix names for wires in ram. Should be suffixed with _n
  // include write enable
  ram m_ram (
      .dipswitch_data(ram_dipswitch_data),
      .dipswitch_addr(ram_dipswitch_addr),
      .bus_in(data_bus_in),
      .addr_select(ram_addr_select),
      .prog_mode(ram_prog_mode),
      .bus_enable_n(ram_bus_enable_n),
      .write_enable_n(ram_write_enable_n),
      .control_signal(ram_control_signal),
      .load_mar_reg_n(ram_load_mar_reg_n),
      .clear_mar_reg(ram_clear_mar_reg),
      .clk(clk),
      .bus_out(ram_bus_out)
  );

endmodule

module Bus_Manager(
    input wire [7:0] data_bus_in,

    // Register A
    input wire [7:0] reg_a_bus_out,
    input wire reg_a_bus_enable_n,

    // Register B
    input wire [7:0] reg_b_bus_out,
    input wire reg_b_bus_enable_n,

    // ALU
    input wire [7:0] alu_bus_out,
    input wire alu_bus_enable_n,

    // Ram
    input wire [7:0] ram_bus_out,
    input wire ram_bus_enable_n,

    output wire [7:0] data_bus_out
);

assign data_bus_out = ~reg_a_bus_enable_n ? reg_a_bus_out :
                          ~reg_b_bus_enable_n ? reg_b_bus_out :
                          ~ram_bus_enable_n   ? ram_bus_out   :
                          ~alu_bus_enable_n   ? alu_bus_out   :
                          8'b0000000Z;

endmodule
