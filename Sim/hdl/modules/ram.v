`default_nettype none
module ram (
    input wire [7:0] dipswitch_data,
    input wire [3:0] dipswitch_addr,
    input wire [7:0] bus_in,
    input wire addr_select,
    input wire prog_mode,  // selects between switches?
    input wire write_enable,
    input wire output_enable,
    input wire control_signal,
    input wire load_mar_reg,
    input wire clear_mar_reg,
    input wire clk,
    output wire [7:0] bus_out
);

///////////////////////////////////////
/// MAR //////////////////////////////
/////////////////////////////////////
  wire [3:0] qff_out;
  sn74ls157 mux (
      .a(qff_out),
      .b(dipswitch_addr),
      .select(addr_select),
      .strobe(1'b0),  // output always on
      .y(address)
  );
  sn54173_quad_flip_flop qff (
      .m(1'b0),
      .n(1'b0),
      .g1(load_mar_reg),
      .g2(load_mar_reg),
      .clr(clear_mar_reg),
      .clk(clk),
      .data(bus_in[3:0]),
      .q(qff_out)
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
  wire [3:0] padded_addr_select = {addr_select, 3'b000};
  wire [3:0] padded_write_mode;
  wire write_mode = padded_write_mode[3];

  sn74ls157 mux3 (
      .a(padded_run_mode),
      .b(padded_addr_select),
      .select(prog_mode),
      .strobe(1'b0),  // output always on
      .y(padded_write_mode)
  );


  assign internal_data = {mem_high, mem_low};
  memory mem (
      .address(address),
      .data(internal_data),
      .write_enable(write_enable),
      .enable(output_enable),
      .bus_out(bus_out)
  );
endmodule
