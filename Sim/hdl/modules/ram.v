`default_nettype none
module ram (
    input wire [7:0] dipswitch_data,
    input wire [3:0] dipswitch_addr,
    input wire [7:0] bus_in,
    input wire addr_button,
    input wire prog_mode,  // selects between switches?
    input wire write_enable,
    input wire output_enable,
    input wire control_signal,
    input wire load_addr_reg,
    input wire clear_addr_reg,
    input wire clk,
    output wire [7:0] bus_out
);

  wire [3:0] mem_low, mem_high;
  wire [7:0] internal_data;

  wire [3:0] address;

  sn74ls157 mux1 (
      .a(dipswitch_data[3:0]),
      .b(bus_in[3:0]),
      .select(prog_mode),
      .strobe(1'b0),  // output always on
      .y(mem_low)
  );

  sn74ls157 mux2 (
      .a(dipswitch_data[7:4]),
      .b(bus_in[7:4]),
      .select(prog_mode),
      .strobe(1'b0),  // output always on
      .y(mem_high)
  );

  // assign run mode based on control signal
  assign run_mode = ~(clk & control_signal);

  /* Padding and unpadding so lengths of signals are proper */
  wire run_mode;
  wire [3:0] padded_run_mode = {run_mode, 3'b000};
  wire [3:0] padded_addr_button = {addr_button, 3'b000};
  wire [3:0] padded_write_mode;
  wire write_mode = padded_write_mode[3];

  sn74ls157 mux3 (
      .a(padded_run_mode),
      .b(padded_addr_button),
      .select(prog_mode),
      .strobe(1'b0),  // output always on
      .y(padded_write_mode)
  );

  mar addr_reg (
      .dipswitch_input(dipswitch_addr),
      .bus(bus_in[3:0]),
      .load(load_addr_reg),
      .button_select(addr_button),
      .clk(clk),
      .clear(clear_addr_reg),
      .mar_out(address)
  );

  assign internal_data = {~mem_high, ~mem_low};
  memory mem (
      .address(address),
      .data(internal_data),
      .write_enable(write_enable),
      .enable(output_enable),
      .bus_out(bus_out)
  );
endmodule
