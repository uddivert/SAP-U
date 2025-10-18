`default_nettype none
module display(
  input wire [7:0] bus_in,
  input wire display_enable,
  input wire clock,
  input wire clear_n,
  input wire mystery_switch,
  output wire [7:0] data,
  output wire [7:0] character1,
  output wire [7:0] character2,
  output wire [7:0] character3,
  output wire [7:0] character4
);

// Handle Bus
reg [7:0] rom_address;
always @(posedge clock or negedge clear_n) begin
  if (!clear_n)
    rom_address <= 8'b00000000;
  else if (display_enable)
    rom_address <= bus_in;
end

// TODO Understand this behavior 
wire mystery_bit = mystery_switch; 

// Bit order: [dp a b c d e f g] (1 = OFF, 0 = ON)
wire [1:0] select_bits;
wire [10:0] full_address = {mystery_bit, select_bits, rom_address};

rom_28C16 rom_instance (
  .addr(full_address),
  .data(data)
);

wire [3:0] common_cathode_n;

dm74ls139 decoder (
  .enable_n(2'b01),
  .select(select_bits),
  .y1_n(common_cathode_n)
);

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
