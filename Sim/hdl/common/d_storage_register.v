module d_storage_register (
    input wire [3:0] data,
    input wire write,
    input wire enable,
    output wire [3:0] q
);

  wire [3:0] q_internal;
  // Use `generate` to instantiate the `d_latches` modules
  genvar i;
  generate
    for (i = 0; i <= 3; i = i + 1) begin : g_dlatch
      d_latch dlatch_inst (
          .enable(write),
          .data(data[i]),
          .q(q_internal[i])
      );
    end
  endgenerate

  assign q = enable ? q_internal : 4'b000z;
endmodule
