`timescale 1ns/1ps
`default_nettype none

module display_tb;

  // Testbench signals
  reg [3:0] address;
  wire [7:0] data;

  // Instantiate the module under test (MUT)
  display uut (
    .address(address),
    .data(data)
  );

  integer i;

  initial begin
    // Optional: dump waveform for simulation viewing
    $dumpfile("./simulation/display.vcd");  // VCD file for waveform generation
    $dumpvars(0, display_tb);

    // Sweep through all addresses
    for (i = 0; i < 16; i = i + 1) begin
      address = i;
      #10; // wait 10ns for combinational output to settle
      $display("Address = %0d, Data = 0x%0h", address, data);
    end

    $finish; // End simulation
  end

endmodule

