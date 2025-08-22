`default_nettype none
module (
    input wire clear_n,
    input wire clk,
    input wire enable,
    input wire jump_n,
    input wire [3:0] bus_in,
    input wire bus_enable_n,
    output wire [3:0] instruction_pointer,
    output wire [3:0] bus_out
);

sn54161 counter (
    .clr_n(clear_n),
    .load_n,(jump_n),
    .ent(enable),
    .enp(enable),
    .clk(clk),
    .a(bus_in[0]),
    .b(bus_in[1]),
    .c(bus_in[2]),
    .d(bus_in[3]),
    .qa(instruction_pointer[0]),
    .qb(instruction_pointer[1]),
    .qc(instruction_pointer[2]),
    .qd(instruction_pointer[3]),
    .rco(1bX)
);

assign bus_out = bus_enable_n ? 8'b0000000Z : instruction_pointer;  // enable bus out dependendent on enable


endmodule