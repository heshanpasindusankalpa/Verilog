`timescale 1ns/1ps

module tb_inverter;

    reg  a;
    wire b;
  
    inverter uut (
        .a(a),
        .b(b)
    );

    initial begin 
        $dumpfile("inverter.vcd");
        $dumpvars(0, tb_inverter);

        a = 0; #10;
        a = 1; #10;
        a = 0; #10;
        a = 1; #10;

        $finish;
    end

endmodule
