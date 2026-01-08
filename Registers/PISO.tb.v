
`timescale 1ns/1ps
module tb_piso_reg;

  reg clk;
  reg reset;
  reg load;
  reg [7:0] din;
  wire dout;

  piso_reg uut (
    .clk(clk),
    .reset(reset),
    .load(load),
    .din(din),
    .dout(dout)
  );

  
  always #5 clk = ~clk; // 10ns clock period (100MHz)

  initial begin
    
    clk = 0;
    reset = 1;
    load = 0;
    din = 8'b10110011;

    #10 reset = 0;

    // Load data
    #10 load = 1;
    #10 load = 0;

    // Let shifting happen for 10 clock cycles
    #100;

    // Apply another load with new data
    din = 8'b11001100;
    load = 1;
    #10 load = 0;

    // Observe shifting again
    #100;

    // Finish simulation
    $finish;
  end

  // For waveform view
  initial begin
    $dumpfile("piso_reg.vcd");
    $dumpvars(0, tb_piso_reg);
  end

endmodule
