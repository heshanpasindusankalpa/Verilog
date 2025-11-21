// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module tb_adder;

    // Test signals
    reg a, b;        // NAND gate has 2 inputs
    wire c;          // output signal

    // Instantiate the NAND gate (Unit Under Test)
    adder uut (
        .a(a),
        .b(b),
        .c(c)
    );

    initial begin
        // Create VCD file for waveform
        $dumpfile("dump.vcd");         // waveform file
      $dumpvars(0, tb_adder);         // dump all signals in tb_nand

        // Display header in console
      $display("Time(ns)   a   b   |   c");
        $display("-------------------------");
      $monitor("%0t      %b   %b   |   %b", $time, a, b, c);

        // Apply test cases
        a = 0; b = 0; #10;  
        a = 0; b = 1; #10;   
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;   

        $finish;      // End simulation
    end

endmodule
