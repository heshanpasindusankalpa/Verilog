module nand_gate (
    input wire a,     // input A
    input wire b,     // input B
    output wire y     // output
);

    assign y = ~(a & b);   // NAND operation

endmodule
