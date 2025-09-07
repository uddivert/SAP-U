`default_nettype none
module display(
  input wire [3:0] address,
  output wire [7:0] data
);

// Declare ROM with 16 entries, 8-bit wide
reg [7:0] rom [0:15];

initial begin
  $readmemh("./simulation/output_rom.hex", rom);
end

// Combinational ROM read
assign data = rom[address];

endmodule
