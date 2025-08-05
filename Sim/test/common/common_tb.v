`timescale 1ns / 1ps
module common_tb;

  // Declare input signals for SR latch
  reg sr_set, sr_reset;
  wire sr_q, sr_not_q;

  sr_latch sr (
      .set(sr_set),
      .reset(sr_reset),
      .q(sr_q),
      .q_n(sr_not_q)
  );

  // Declare input signals for D latch
  reg d_enable, d_data;
  wire d_q, d_not_q;

  d_latch dl (
      .enable(d_enable),
      .data(d_data),
      .q(d_q),
      .q_n(d_not_q)
  );

  // Declare input signals for D flip flop
  reg clk, dff_data, dff_reset;
  wire dff_q, dff_not_q;

  d_flip_flop dff (
      .clk  (clk),
      .data (dff_data),
      .reset(dff_reset),
      .q    (dff_q),
      .q_n(dff_not_q)
  );

  // Declare input signals for quad flip flop
  reg qff_m, qff_n, qff_g1, qff_g2, qff_clr;
  reg  [3:0] qff_data;
  wire [3:0] qff_q;

  sn54173_quad_flip_flop qff (
      .m(qff_m),
      .n(qff_n),
      .g1(qff_g1),
      .g2(qff_g2),
      .clr(qff_clr),
      .clk(clk),
      .data(qff_data),
      .q(qff_q)
  );

  // Declare input signals for full adder
  reg fa_a, fa_b, fa_cin;
  wire fa_s, fa_cout;

  full_adder fa (
      .a(fa_a),
      .b(fa_b),
      .cin(fa_cin),
      .s(fa_s),
      .cout(fa_cout)
  );

  // Declare input signals for carry look ahead adder
  reg cla_cin;
  reg [4:1] cla_a, cla_b;
  wire cla_cout;
  wire [4:1] cla_sum;

  dm74ls283_quad_adder cla (
      .a(cla_a),
      .b(cla_b),
      .cin(cla_cin),
      .sum(cla_sum),
      .cout(cla_cout)
  );

  // Declare input signals for F189 Ram
  reg [3:0] ram_a, ram_d;
  reg ram_cs_n, ram_we_n;
  wire [3:0] ram_o;

  f189 ram (
      .a (ram_a),
      .d (ram_d),
      .cs_n(ram_cs_n),
      .we_n(ram_we_n),
      .o (ram_o)
  );

  // Declare input signals for sn74ls157 multiplexor
  reg [3:0] mux_a, mux_b;
  reg mux_select, mux_strobe;
  wire [3:0] mux_y;

  sn74ls157 mux (
      .a(mux_a),
      .b(mux_b),
      .select(mux_select),
      .strobe(mux_strobe),
      .y(mux_y)
  );

  // Declare input signals for jk flip flop 
  reg jk_j, jk_k;
  wire jk_q, jk_q_n;

  jk_flipflop jk (
      .j(jk_j),
      .k(jk_k),
      .clk(clk),
      .q(jk_q),
      .q_n(jk_q_n)
  );

  // Declare input signals for dm7476 jff
  reg dm7476_pr_n, dm7476_clr_n, dm7476_j, dm7476_k;
  wire dm7476_q, dm7476_q_n;

  dm7476_jk_flip_flop dm7476_jkff(
      .pr_n(dm7476_pr_n),
      .clr_n(dm7476_clr_n),
      .clk(clk),
      .j(dm7476_j),
      .k(dm7476_k),
      .q(dm7476_q),
      .q_n(dm7476_q_n)
  );


  // Clock signal generation: 50% duty cycle with a period of 10 time units
  always begin
    clk = 0;
    #5;  // Clock low for 5 time units
    clk = 1;
    #5;  // Clock high for 5 time units
  end

  initial begin
    $dumpfile("./simulation/common.vcd");  // VCD file for waveform generation
    $dumpvars(0, common_tb);

    /************************************************************/
    /* SR Latch test bench                                      */
    /************************************************************/

    // case 1 (latch w/o state)
    sr_set   = 0;
    sr_reset = 0;
    #10;
    // case 2 (reset)
    sr_set   = 0;
    sr_reset = 1;
    #10;
    // case 3 (set)
    sr_set   = 1;
    sr_reset = 0;
    #10;
    // case 4 (latch with state)
    sr_set   = 0;
    sr_reset = 0;
    #10;
    // case 5 (invalid state)
    sr_set   = 1;
    sr_reset = 1;
    #10;

    /************************************************************/
    /* D latch testbench                                        */
    /************************************************************/

    // case 1 (no data)
    d_enable = 0;
    d_data   = 0;
    #10;
    // case 2 (data with no enable)
    d_enable = 0;
    d_data   = 1;
    #10;
    // case 3 (data with enable)
    d_enable = 1;
    d_data   = 1;
    #10;
    // case 4 (data off with enable off)
    d_enable = 0;
    d_data   = 0;
    #10;
    // case 5 (enable on and data off)
    d_enable = 1;
    d_data   = 0;
    #10;

    /************************************************************/
    /* D flip flop testbench                                    */
    /************************************************************/
    // case 1: No data
    dff_data  = 0;
    dff_reset = 1;
    #10;
    // case 2: Data high
    dff_data  = 1;
    dff_reset = 0;
    #10;
    // case 3: Data remains high
    dff_data = 1;
    #10;
    // case 4: Data goes low
    dff_data = 0;
    #10;
    // case 5: Data remains low
    dff_data = 0;
    #10;
    // case 7: Reset high
    dff_data = 1;
    #5;
    dff_reset = 1;
    #5;

    /************************************************************/
    /* Quad flip flop testbench                                 */
    /************************************************************/
    // Initialize all inputs
    {qff_g1, qff_g2} = 0;  // enable load
    {qff_m, qff_n} = 0;  // enable output
    qff_data = 4'b0000;
    qff_clr = 1;  // Start with clear active
    #15;  // Wait a bit to see the clr effect

    // Case 1: clr deasserted, load is high, data is set
    qff_clr  = 0;
    qff_data = 4'b1010;
    #10;

    // Case 2: Load is low, holding the previous data
    {qff_g1, qff_g1} = 1;  // disable load
    qff_data = 4'b1100;  // should not show up
    #10;

    // Case 3: Load the new data
    {qff_g1, qff_g1} = 0;  // enable load
    qff_data = 4'b1111;
    #10;

    // Case 4: Disable output
    {qff_m, qff_n} = 1;  // disable output
    #10;

    // Case 5: Activate clr, observe q goes to 0
    qff_clr = 1;
    #10;

    /************************************************************/
    /* Full adder testbench                                     */
    /************************************************************/

    // Case 1: 0 + 0
    fa_a   = 0;
    fa_b   = 0;
    fa_cin = 0;
    #15;

    // Case 2: 0 + 0 with carryin
    fa_a   = 0;
    fa_b   = 0;
    fa_cin = 1;
    #15;

    // Case 3: 0 + 1
    fa_a   = 0;
    fa_b   = 1;
    fa_cin = 0;
    #15;

    // Case 4: 0 + 1 with carryin
    fa_a   = 0;
    fa_b   = 1;
    fa_cin = 1;
    #15;

    // Case 5: 1 + 0 with carryin
    fa_a   = 1;
    fa_b   = 0;
    fa_cin = 0;
    #15;

    // Case 6: 1 + 0 with carry in
    fa_a   = 1;
    fa_b   = 0;
    fa_cin = 1;
    #15;

    // Case 7: 1 + 1
    fa_a   = 1;
    fa_b   = 1;
    fa_cin = 0;
    #15;

    // Case 8: 1 + 1 with carryin
    fa_a   = 1;
    fa_b   = 1;
    fa_cin = 1;
    #15;

    /************************************************************/
    /* Carry look ahead adder testbench                         */
    /************************************************************/
    // Test 1: Simple addition with no carry-in
    cla_a   = 4'b0000;  // a = 0
    cla_b   = 4'b0000;  // b = 0
    cla_cin = 0;  // no carry in
    #10;

    // Test 2: Simple addition with carry-in
    cla_a   = 4'b0001;  // a = 1
    cla_b   = 4'b0001;  // b = 1
    cla_cin = 1;  // carry in
    #10;

    // Test 3: Addition with no carry, result with carry-out
    cla_a   = 4'b0111;  // a = 7
    cla_b   = 4'b0001;  // b = 1
    cla_cin = 0;  // no carry in
    #10;

    // Test 4: Subtracting using carry in
    cla_a   = 4'b1000;  // a = -8 (two's complement)
    cla_b   = 4'b0000;  // b = 0
    cla_cin = 1;  // carry-in simulates subtraction
    #10;

    // Test 5: Adding two large values
    cla_a   = 4'b1110;  // a = 14
    cla_b   = 4'b0111;  // b = 7
    cla_cin = 0;  // no carry in
    #10;

    // Test 6: Adding two values resulting in overflow
    cla_a   = 4'b1111;  // a = 15
    cla_b   = 4'b0001;  // b = 1
    cla_cin = 0;  // no carry in
    #10;

    // Test 7: Adding two numbers with carry-in
    cla_a   = 4'b1010;  // a = 10
    cla_b   = 4'b0101;  // b = 5
    cla_cin = 1;  // carry in
    #10;

    // Test 8: Addition where sum exceeds 4-bit width (overflow)
    cla_a   = 4'b1100;  // a = 12
    cla_b   = 4'b1010;  // b = 10
    cla_cin = 0;  // no carry in
    #10;

    // Test 9: Adding two equal numbers (overflow)
    cla_a   = 4'b1000;  // a = 8
    cla_b   = 4'b1000;  // b = 8
    cla_cin = 0;  // no carry in
    #10;

    // Test 10: Adding max value with no carry
    cla_a   = 4'b1111;  // a = 15
    cla_b   = 4'b1111;  // b = 15
    cla_cin = 0;  // no carry in
    #10;

    // Test 11: Adding with different bits set
    cla_a   = 4'b0101;  // a = 5
    cla_b   = 4'b1010;  // b = 10
    cla_cin = 0;  // no carry in
    #10;

    // Test 12: Adding a number to 0
    cla_a   = 4'b1111;  // a = 15
    cla_b   = 4'b0000;  // b = 0
    cla_cin = 0;  // no carry in
    #10;

    // Test 13: Adding negative numbers (in two's complement)
    cla_a   = 4'b1000;  // a = -8 (two's complement)
    cla_b   = 4'b0100;  // b = 4
    cla_cin = 0;  // no carry in
    #10;

    // Test 14: Adding all ones (max 4-bit values)
    cla_a   = 4'b1111;  // a = 15
    cla_b   = 4'b1111;  // b = 15
    cla_cin = 1;  // carry in
    #10;


    /************************************************************/
    /* Ram testbench                                            */
    /************************************************************/
    ram_cs_n = 1;
    ram_we_n = 1;
    ram_a  = 0;
    ram_d  = 0;
    #10;

    // Write data to memory
    ram_cs_n = 0;
    ram_we_n = 0;
    ram_a  = 4'b0010;
    ram_d  = 4'b1100;
    #10;
    ram_we_n = 1;
    #10;

    // Read data from memory
    ram_cs_n = 0;
    ram_we_n = 1;
    ram_a  = 4'b0010;
    #10;

    /************************************************************/
    /* sn74ls157 testbench                                      */
    /************************************************************/
    mux_strobe = 0;  // set output always on
    mux_select = 0;
    mux_a = 4'b1010;
    mux_b = 4'b0101;
    mux_select = 0;
    #10;
    mux_select = 1;
    #10;

    /************************************************************/
    /* jk flipflop testbench                                      */
    /************************************************************/
    jk_j = 0;
    jk_k= 0;
    #10;

    jk_j = 1;  // Q should be on
    jk_k= 0;
    #10;

    jk_j = 0;  // Q Not output always on
    jk_k= 1;
    #10;

    jk_j = 1;  // Toggle
    jk_k= 1;
    #10;

    jk_j = 1;  // Toggle
    jk_k= 1;
    #10;

    /************************************************************/
    /* dm7476 testbench                                      */
    /************************************************************/
    dm7476_pr_n = 1; dm7476_clr_n = 1; dm7476_j = 0; dm7476_k = 0;

    // Test asynchronous preset
    #2; dm7476_pr_n = 0; // preset active
    #5; dm7476_pr_n = 1; // preset inactive

    // Test asynchronous clear
    #2; dm7476_clr_n = 0; // clear active
    #5; dm7476_clr_n = 1; // clear inactive

    // Test invalid 
    #2; dm7476_pr_n = 0; dm7476_clr_n = 0;
    #5; dm7476_pr_n = 1; dm7476_clr_n = 1;

    dm7476_j = 0; dm7476_k = 0;
    #10; 

    dm7476_j = 0; dm7476_k = 1;
    #10;

    dm7476_j = 1; dm7476_k = 0;
    #10;

    dm7476_j = 1; dm7476_k = 1;
    #20;

    dm7476_j = 0; dm7476_k = 0;
    #10;

    $finish;  // End simulation
  end
endmodule
