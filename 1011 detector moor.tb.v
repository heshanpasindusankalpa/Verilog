`timescale 1ns / 1ps

module moore_seq_detector_1011_tb;

    reg clk;
    reg reset;
    reg x;
    wire y;

// Unit Under Test (UUT)
    moore_seq_detector_1011 uut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y)
    );

    // Clock generation: toggles every 5ns -> 10ns period = 100 MHz
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Dumpfile setup for waveform viewing
        $dumpfile("waveform.vcd");   // Name of the waveform file
        $dumpvars(0, moore_seq_detector_1011_tb); // Dump all signals in this module

        // Initialize signals
        clk = 0;
        reset = 1;
        x = 0;
        #10 reset = 0;

        // Apply input sequence: 1011
        x = 1; #10;
        x = 0; #10;
        x = 1; #10;
        x = 1; #10;

        // Wait some time to observe output
        #20 $finish;
    end

endmodule
