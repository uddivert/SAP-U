`default_nettype none

module seven_segment_display (
  input  wire [7:0] data,
  input  wire       common_cathode_n,
  output reg  [7:0] character
);

always @(*) begin
  case (data)
    8'h81: character = 8'h0;
    8'hcf: character = 8'h1;
    8'h92: character = 8'h2;
    8'h86: character = 8'h3;
    8'hcc: character = 8'h4;
    8'ha4: character = 8'h5;
    8'ha0: character = 8'h6;
    8'h8f: character = 8'h7;
    8'h80: character = 8'h8;
    8'h84: character = 8'h9;
    8'h88: character = 8'ha;
    8'he0: character = 8'hb;
    8'hb1: character = 8'hc;
    8'hc2: character = 8'hd;
    8'hb0: character = 8'he;
    8'hb8: character = 8'hf;
    default: character = 8'h0;
  endcase

  // Gating for common cathode
  if (~common_cathode_n)
    character = 8'h00;
end

endmodule

