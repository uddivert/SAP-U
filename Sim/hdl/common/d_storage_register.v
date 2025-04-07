module d_storage_register (
   input wire [7:0] data,
   input wire write,
   input wire enable,
   output wire [7:0] q
);

   wire [7:0] q_internal;
  // Use `generate` to instantiate the `d_latches` modules
  genvar i;
  generate
    for (i = 0; i <= 7; i = i + 1) begin : dlatch_generate
      d_latch dlatch_inst(
        .enable(write),
        .data(data[i]),
        .data(q_internal[i])
      );
    end
  endgenerate

  assign q = enable ? internal_q : 8'bz; 
endmodule