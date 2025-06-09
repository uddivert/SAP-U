`default_nettype none
`define PUSH_BUTTON write_enable

// if program mode 0, read from dipswitch. To read PUSH_BUTTON 1
// if program_mode 1, read from bus. To read control_signal 1
module ram (
    input wire [7:0] dipswitch_data,
    input wire [3:0] dipswitch_addr,
    input wire [7:0] bus_in,
    input wire prog_mode,
    input wire addr_select,
    input wire write_enable_n,
    input wire bus_enable_n,
    input wire control_signal,
    input wire load_mar_reg_n,
    input wire clear_mar_reg,
    input wire clk,
    output wire [7:0] bus_out
);

// Memory Address Register (MAR)
  wire [3:0] qff_out;
  wire [3:0] reversed_address;
  wire [3:0] dipswitch_addr_reversed;
  assign dipswitch_addr_reversed = {
    dipswitch_addr[0], dipswitch_addr[1], dipswitch_addr[2], dipswitch_addr[3]
  };

  sn74ls157 mux (
      .a(dipswitch_addr_reversed),
      .b(qff_out),
      .select(addr_select),
      .strobe(1'b0),  // output always on
      .y(reversed_address)
  );

  wire [3:0] address;
  assign address = {
    reversed_address[0], reversed_address[1], reversed_address[2], reversed_address[3]
  };

  sn54173_quad_flip_flop qff (
      .m(1'b0),
      .n(1'b0),
      .g1(load_mar_reg_n),
      .g2(load_mar_reg_n),
      .clr(clear_mar_reg),
      .clk(clk),
      .data({bus_in[0], bus_in[1], bus_in[2], bus_in[3]}),
      .q(qff_out)
  );

// Static Ram
   wire [7:0] internal_data;
   assign internal_data = {mem_high, mem_low};
   memory mem (
      .address(address),
      .data(internal_data),
      .write_enable_n(padded_memory_write_mode[1]),
      .bus_enable_n(bus_enable_n),
      .bus_out(bus_out)
  );

  wire [3:0] padded_write_enable;
  assign padded_write_enable = {1'b0, 1'b0, write_enable_n, 1'b0};

  reg run_mode;
  always @ (posedge clk) begin
        run_mode <= ~control_signal;
    end

  wire [3:0] padded_run_mode;
  assign padded_run_mode = {1'b0, 1'b0, run_mode, 1'b0};  
  wire [3:0] padded_memory_write_mode; // only care about [1]
  sn74ls157 u32 (
      .a(padded_write_enable),
      .b(padded_run_mode),
      .select(prog_mode),
      .strobe(1'b0),  // output always on
      .y(padded_memory_write_mode)
  );

  wire [3:0] mem_low;
  sn74ls157 mux1 (
      .a(dipswitch_data[3:0]),
      .b(bus_in[3:0]),
      .select(prog_mode),
      .strobe(1'b0),  // output always on
      .y(mem_low)
  );

  wire [3:0] mem_high;
  sn74ls157 mux2 (
      .a(dipswitch_data[7:4]),
      .b(bus_in[7:4]),
      .select(prog_mode),
      .strobe(1'b0),  // output always on
      .y(mem_high)
  );

endmodule
