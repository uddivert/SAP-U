`timescale 1ns / 1ps `default_nettype none

module memory_tb;
  reg [3:0] address;
  reg [7:0] data;
  reg write_enable;
  reg enable;
  wire [7:0] bus_out;

  // Instantiate the Memory module
  memory uut (
      .address(address),
      .data(data),
      .write_enable(write_enable),
      .enable(enable),
      .bus_out(bus_out)
  );

  initial begin
    $dumpfile("./simulation/memory_tb.vcd");
    $dumpvars(0, memory_tb);

    // Initialize signals
    address = 4'b0000;
    data = 8'b00000000;
    write_enable = 1;  // Initially not writing
    enable = 1;  // Initially disable output (high-Z)

    #10;

    // Test 1: Write to address 0x2
    address = 4'b0010;
    data = 8'b10101010;
    write_enable = 0;  // Enable write
    #10;
    write_enable = 1;  // Disable write

    // Test 2: Write to address 0x5
    address = 4'b0101;
    data = 8'b11001100;
    write_enable = 0;
    #10;
    write_enable = 1;

    // Test 3: Read from address 0x2
    address = 4'b0010;
    enable = 0;  // Enable output
    #10;
    $display("Read from 0x2: %b (Expected: 01010101)", bus_out);

    // Test 4: Read from address 0x5
    address = 4'b0101;
    #10;
    $display("Read from 0x5: %b (Expected: b11001100)", bus_out);

    // Test 5: Tri-state output when enable = 1
    enable = 1;
    #10;
    $display("Bus should be high-Z: %b", bus_out);

    // End simulation
    $finish;
  end
endmodule
