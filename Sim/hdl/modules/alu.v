`default_nettype none
module alu (
    input wire [7:0] a,  // input b
    input wire [7:0] b,  // input a
    input wire bus_enable_n,
    input wire subtract,
    input wire flag_fi_n,  // controls if flag is holding value or updating
    input wire flag_clear_n,  // clears flags
    input wire clk,
    output wire [7:0] bus_out,
    output wire [1:0] flag_out
);

  /*
   * Addition (subtract = 0): Computes result=a+bresult=a+b.
   * Subtraction (subtract = 1): Computes result=a−bresult=a−b using two's complement logic.
   * Enable Control: The result is gated by the enable signal; when enable = 0, result = 0.
  */

  wire internal_carryout;
  wire external_carryout;
  wire [7:0] internal_result;
  wire [7:0] internal_b;

  // hardware will use nor gates as conditional not gate as an inverter
  assign internal_b = subtract ? ~b : b;
  dm74ls283_quad_adder adder1 (
      .a(a[3:0]),  // input a
      .b(internal_b[3:0]),  // input b
      .cin(subtract),  // used for two's compliment
      .sum(internal_result[3:0]),  // sum
      .cout(internal_carryout)  // carry out
  );

  dm74ls283_quad_adder adder2 (
      .a(a[7:4]),  // input a
      .b(internal_b[7:4]),  // input b
      .cin(internal_carryout),  // used for two's compliment
      .sum(internal_result[7:4]),  // sum
      .cout(external_carryout)  // carry out ignored
  );

  wire [3:0] intermediate_zero_data;
  wire [3:0] flag_data;

  // populate flag data
  assign flag_data[0] = external_carryout;

  // compute zero flag
  assign flag_data[1] = ~|internal_result;  // Simplifies zero flag logic
  assign flag_data[2] = 1'b0; // unused
  assign flag_data[3] = 1'b0; // unused
  assign bus_out = bus_enable_n ? 8'bZ : internal_result;  // assign result dependent on enable

  // handle flags
  wire [3:0] flag_out_full;
  assign flag_out = flag_out_full[1:0]; // only output lower two bits
  sn54173_quad_flip_flop flags_reg (
      .m(1'b0),
      .n(1'b0),
      .g1(flag_fi_n),
      .g2(flag_fi_n),
      .clr(flag_clear_n),
      .clk(clk),
      .data(flag_data),
      .q(flag_out_full)
  );
endmodule
