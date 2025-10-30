//verilog code for RTL 1 bit comparitor
// 1-bit Comparator in Verilog (RTL)

// The module is like a "block" you design.
module comparator_1bit (
    input wire A,       // First 1-bit input
    input wire B,       // Second 1-bit input
    output wire A_gt_B, // A > B
    output wire A_lt_B, // A < B
    output wire A_eq_B  // A == B
);

    assign A_gt_B = (A > B);
    assign A_lt_B = (A < B);
    assign A_eq_B = (A == B);

endmodule
