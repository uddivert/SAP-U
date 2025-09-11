`default_nettype none
module display(
  input wire [7:0] address,
  output wire [7:0] data,
  output wire [7:0] characters[0:2]
);

// 2K x 8 ROM (28C16 style)
reg [7:0] rom [0:2047];  // 2048 entries, each 8-bit wide

initial begin
  $readmemh("./simulation/output_rom.hex", rom);
end

// Bit order: [dp a b c d e f g] (1 = OFF, 0 = ON)
assign data = rom[address];

wire [3:0] common_cathode_n,

  // Use `generate` to instantiate the 7 segment displays
  genvar i;
  generate
    for (i = 0; i <= 2; i = i + 1) begin : g_seg_display  // label for generate function

      seven_segment_display seg_display (
        .data(data),
        .common_cathode_n(common_cathode_n),
        .character(characters(i))
      );

    end
  endgenerate


dm74ls139 decoder(
  .enable_n,
  .select, 
  .y1_n({common_cathode_n[0],common_cathode_n[1], common_cathode_n[2], common_cathode_n[3] }),
  .y2_n // unused? 
);

endmodule
