// Difference from circuit board'set implementaton
// No tristate buffer used

`default_nettype none
module memory (
    input wire [3:0] address,
    input wire [7:0] data,
    input wire write_enable,
    input wire enable,  // reverse logic
    output wire [7:0] bus_out
);
  wire [3:0] mem_low, mem_high;
  wire [7:0] internal_data;

  f189 sram1 (
      .a (address),
      .d (data[3:0]),
      .cs(1'b0),
      .we(write_enable),
      .o (mem_low)
  );

  f189 sram2 (
      .a (address),
      .d (data[7:4]),
      .cs(1'b0),
      .we(write_enable),
      .o (mem_high)
  );
  assign internal_data = {mem_high, mem_low};
  assign bus_out = enable ? 8'b0000000Z : internal_data;  // enable bus out dependendent on enable

endmodule
