`default_nettype none
module memory (
    input wire [3:0] address,
    input wire [7:0] data,
    input wire write_enable_n,
    input wire bus_enable_n,  // reverse logic
    output wire [7:0] bus_out
);
  wire [3:0] mem_low, mem_high;
  wire [7:0] internal_data;

  f189 sram1 (
      .a (address),
      .d (data[3:0]),
      .cs_n(1'b0),
      .we_n(write_enable_n),
      .o (mem_low)
  );

  f189 sram2 (
      .a (address),
      .d (data[7:4]),
      .cs_n(1'b0),
      .we_n(write_enable_n),
      .o (mem_high)
  );
  assign internal_data = {~mem_high, ~mem_low};
  assign bus_out = bus_enable_n ? 8'b0000000Z : internal_data;  // enable bus out dependendent on enable

endmodule
