`timescale 1ns / 1ps `default_nettype none

module memory_tb;
  reg [3:0] address;
  reg [7:0] data;
  reg write_enable_n;
  reg bus_enable_n;
  wire [7:0] bus_out;

  // Instantiate the Memory module
  memory uut (
      .address(address),
      .data(data),
      .write_enable_n(write_enable_n),
      .bus_enable_n(bus_enable_n),
      .bus_out(bus_out)
  );

  initial begin
    $dumpfile("./simulation/memory_tb.vcd");
    $dumpvars(0, memory_tb);

    // Initialize signals
    address = 4'b0000;
    data = 8'b00000000;
    write_enable_n = 1;  // Initially not writing
    bus_enable_n = 1;  // Initially disable output (high-Z)

    #10;

    // Test 1: Write to address 0x2
    address = 4'b0010;
    data = 8'b10101010;
    write_enable_n = 0;  // Enable write
    #10;
    write_enable_n = 1;  // Disable write

    // Test 2: Write to address 0x5
    address = 4'b0101;
    data = 8'b11001100;
    write_enable_n = 0;
    #10;
    write_enable_n = 1;

    // Test 3: Read from address 0x2
    address = 4'b0010;
    bus_enable_n = 0;  // Enable output
    #10;
    $display("Read from 0x2: %b (Expected: 10101010)", bus_out);

    // Test 4: Read from address 0x5
    address = 4'b0101;
    #10;
    $display("Read from 0x5: %b (Expected: 11001100)", bus_out);

    // Test 5: Tri-state output when enable = 1
    bus_enable_n = 1;
    #10;
    $display("Bus should be zeros: %b", bus_out);

    // End simulation
    $finish;
  end
endmodule
