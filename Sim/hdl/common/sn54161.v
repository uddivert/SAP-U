`default_nettype none
module sn54161 (
    input wire clr_n,
    input wire load_n,
    input wire ent,  // enable trickle
    input wire enp,  // count enable
    input wire clk,
    input wire a,
    input wire b,
    input wire c,
    input wire d,
    output wire qa,
    output wire qb,
    output wire qc,
    output wire qd,
    output wire rco
);

  reg [3:0] q;

  always @(posedge clk or negedge clr_n) begin
    if (!clr_n) begin
      q <= 4'b0000;
    end else begin
      if (!load_n) begin
        q <= {d, c, b, a};
      end else if (enp & ent) begin
        q <= q + 4'b0001;
      end
    end
  end

  assign {qd, qc, qb, qa} = q;

  // RCO: high when the counter is at maximum (1111) AND
  // both enables are asserted. ENT is "fed forward" to enable RCO.
  assign rco = (q == 4'b1111) & enp & ent;
endmodule
