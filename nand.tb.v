`timescale 1ns/1ps

module tb_nand;

    // Test signals
    reg a, b;        // NAND gate has 2 inputs
    wire y;          // output signal

    // Instantiate the NAND gate (Unit Under Test)
    nand_gate uut (
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin
        // Create VCD file for waveform
        $dumpfile("dump.vcd");         // waveform file
        $dumpvars(0, tb_nand);         // dump all signals in tb_nand

        // Display header in console
        $display("Time(ns)   a   b   |   y");
        $display("-------------------------");
      $monitor("%0t      %b   %b   |   %b", $time, a, b, y);//0 means no minimum width.

        // Apply test cases
        a = 0; b = 0; #10;   // 0 NAND 0 = 1
        a = 0; b = 1; #10;   // 0 NAND 1 = 1
        a = 1; b = 0; #10;   // 1 NAND 0 = 1
        a = 1; b = 1; #10;   // 1 NAND 1 = 0

        $finish;      // End simulation
    end

endmodule
