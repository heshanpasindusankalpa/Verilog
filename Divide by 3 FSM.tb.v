module tb;

  reg clk; 
  reg reset;
  wire y;

  // Clock generation
  initial begin
    clk = 0; 
    forever #5 clk = ~clk;  // Toggle every 5 -> 10 units period
  end

  // Instantiate DUT (Device Under Test)
  divby3 DUT (
    .clk(clk),
    .reset(reset),
    .y(y)
  );

  // Apply reset
  initial begin
    reset = 1;
    #10 reset = 0;  // release reset after 10 time units
  end
  

  // Monitor and simulation control
  initial begin
    $dumpfile("divby3.vcd");
    $dumpvars(0, tb);

    $monitor("Time=%0t | clk=%b | reset=%b | y=%b", $time, clk, reset, y);

    #200;
    $finish;
  end

endmodule
