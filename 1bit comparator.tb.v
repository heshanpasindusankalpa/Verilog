`timescale 1ns / 1ps

module tb_comparator_1bit;

    // Testbench signals
    reg A;//rdeclared as reg because they'll be driven by the testbench
    reg B;
    wire A_gt_B;
    wire A_lt_B;
    wire A_eq_B;

    // Instantiate the comparator module
  comparator_1bit uut (//unit under test
        .A(A),
        .B(B),
        .A_gt_B(A_gt_B),
        .A_lt_B(A_lt_B),
        .A_eq_B(A_eq_B)
  );  

    // Enable waveform dumping
    initial begin
        $dumpfile("dump.vcd");               // VCD file name
        $dumpvars(0, tb_comparator_1bit);    // Dump all signals in this module
    end

    // Stimulus and display
    initial begin
        $display("A B | A_gt_B A_lt_B A_eq_B");
        $display("---------------------------");

        // Test case 1: A = 0, B = 0
        A = 0; B = 0; #10;
       // $display("%b %b |    %b      %b      %b", A, B, A_gt_B, A_lt_B, A_eq_B);

        // Test case 2: A = 0, B = 1
       A = 0; B = 1; #10;
       // $display("%b %b |    %b      %b      %b", A, B, A_gt_B, A_lt_B, A_eq_B);

        // Test case 3: A = 1, B = 0
        A = 1; B = 0; #10;
       // $display("%b %b |    %b      %b      %b", A, B, A_gt_B, A_lt_B, A_eq_B);

        // Test case 4: A = 1, B = 1
        A = 1; B = 1; #10;
       // $display("%b %b |    %b      %b      %b", A, B, A_gt_B, A_lt_B, A_eq_B);

        $finish;
    end

endmodule
