`default_nettype none
module f189 (
    input  wire [3:0] a,   // address inputs
    input  wire [3:0] d,   // input data
    input  wire       cs,  // Chip select  (active low)
    input  wire       we,  // Write enable (active low)
    output wire [3:0] o    // inverted data outputs
);

  genvar i;

  wire [15:0] write_enable;
  wire [15:0] output_enable;
  wire [3:0] q_internal [15:0];  // 16x4-bit storage

  assign o = ~q_internal[a];

  generate
    for (i = 0; i <= 15; i = i + 1) begin : g_enables
      assign write_enable[i]  = (a == i) & ~we & ~cs;
      assign output_enable[i] = (a == i) & we & ~cs;
    end
  endgenerate

  generate
    for (i = 0; i <= 15; i = i + 1) begin : g_d_storage_regist
      d_storage_register dlatch_inst (
        .data(d),
        .write(write_enable[i]),
        .enable(output_enable[i]),
        .q(q_internal[i])
      );
    end
  endgenerate
endmodule
