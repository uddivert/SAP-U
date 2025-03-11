`default_nettype none
module ram(
    input wire [7:0] dipswitch_data,
    input wire button;
    input wire write_enable;
    input wire output_enable;
    input wire clk;
);

  wire [3:0] mem_low, mem_high;
  wire [7:0] bus_data;
  sn74ls159 mux1 (
      .a(dipswitch_data[3:0]),
      .b(bus_data[3:0]),
      .select(button_select),
      .strobe(0),  // output always on
      .y(mem_low)
  );

  sn74ls159 mux2 (
      .a(dipswitch_data[7:4]),
      .b(bus_data[7:4]),
      .select(button_select),
      .strobe(0),  // output always on
      .y(mem_high)
  );

mar addr_reg(
    input wire [3:0] dipswitch_input,   // sets address
    input wire [3:0] bus,
    input wire load,
    input wire button_select,
    input wire clear,
    input wire enable,
    input wire clk,
    output wire [3:0] mar_out
);

assign internal_data = {~mem_high, ~mem_low};
memory mem(

    .data(internal_data),
    /*
    input wire [3:0] address,
    input wire [7:0] data,
    input wire write_enable,
    input wire enable,  // reverse logic
    output wire [7:0] bus_out
    */
);
endmodule