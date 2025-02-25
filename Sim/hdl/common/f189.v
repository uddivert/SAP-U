`default_nettype none
module f189 (
    input  wire [3:0] a,   // address inputs
    input  wire [3:0] d,   // input data
    input  wire       cs,  // Chip select  (active low)
    input  wire       we,  // Write enable (active low)
    output wire [3:0] o    // inverted data outputs
);

  reg [3:0] mem[0:15];  // 16x4-bit memory

  always @(negedge we) begin
    if (!cs && !we) begin
      mem[a] <= d;  // Write operation
    end
  end

  assign o = ~mem[a];  // Read operation with inverted output

endmodule
