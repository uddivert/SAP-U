`default_nettype none
module display(
  input wire [7:0] bus_in,
  input wire display_enable,
  input wire clock,
  input wire clear_n,
  output wire [7:0] data,
  output wire [7:0] character1,
  output wire [7:0] character2,
  output wire [7:0] character3,
  output wire [7:0] character4
);

// Handle Bus
reg [7:0] address;
always @(posedge clock or negedge clear_n) begin
  if (!clear_n)
    address <= 8'b00000000;
  else if (display_enable)
    address <= bus_in;
end

// Bit order: [dp a b c d e f g] (1 = OFF, 0 = ON)
rom_28C16 rom_instance (
  .addr(address),
  .data(data)
);

wire [3:0] common_cathode_n;

seven_segment_display seg_display0 (
  .data(data),
  .common_cathode_n(common_cathode_n[3]),
  .character(character1)
);

seven_segment_display seg_display1 (
  .data(data),
  .common_cathode_n(common_cathode_n[2]),
  .character(character2)
);

seven_segment_display seg_display2 (
  .data(data),
  .common_cathode_n(common_cathode_n[1]),
  .character(character3)
);

seven_segment_display seg_display3 (
  .data(data),
  .common_cathode_n(common_cathode_n[0]),
  .character(character4)
);

dm74ls139 decoder(
  .enable_n(),
  .select(), 
  .y1_n(common_cathode_n),
  .y2_n() // unused? 
);

endmodule
