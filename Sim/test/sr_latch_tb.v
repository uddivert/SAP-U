`default_nettype none
module sr_latch_tb;

    // Declare input signals as registers and output signals as wires
    reg set, reset;
    wire q, not_q;

    // Instantiate the DUT (Device Under Test)
    sr_latch uut (
        .i_set(set),
        .i_reset(reset),
        .o_q(q),
        .o_not_q(not_q)
    );


    initial begin

        $dumpfile("./simulation/sr_latch_tb.vcd"); 
        $dumpvars(0, sr_latch_tb); 

        // case 1 (latch w/o state)
        set = 0; reset = 0; #10;

        // case 2 (reset)
        set = 0; reset = 1; #10;

        // case 3 (set)
        set = 1; reset = 0; #10;

        // case 4 (latch with state)
        set = 0; reset = 0; #10;

        // case 5 (invalid state)
        set = 1; reset = 1; #10;

        $finish; // End simulation
    end
endmodule
