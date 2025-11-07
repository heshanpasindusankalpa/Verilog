`timescale 1ns/1ps

module tb_memory_fsm;

  reg clk, reset;
  reg read, write;
  reg [3:0] addr;
  reg [7:0] din;
  wire [7:0] dout;
  wire ready;

  // Instantiate the memory module
  memory uut (
    .clk(clk),
    .reset(reset),
    .read(read),
    .write(write),
    .addr(addr),
    .din(din),
    .dout(dout),
    .ready(ready)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    clk = 0;
    reset = 1; read = 0; write = 0; addr = 0; din = 0;
    #10 reset = 0;

    // Write multiple values
    write_word(4'd0, 8'hA5);
    write_word(4'd1, 8'h5A);
    write_word(4'd2, 8'hFF);
    write_word(4'd3, 8'h12);
    write_word(4'd4, 8'h00);

    // Read back values
    read_word(4'd0);
    read_word(4'd1);
    read_word(4'd2);
    read_word(4'd3);
    read_word(4'd4);

    $finish;
  end

  // Write helper task
  task write_word(input [3:0] a, input [7:0] d);
  begin
    @(negedge clk);
    write = 1; read = 0; addr = a; din = d;
    @(negedge clk);
    write = 0;
    wait(ready);
  end
  endtask

  // Read helper task
  task read_word(input [3:0] a);
  begin
    @(negedge clk);
    read = 1; write = 0; addr = a;
    @(negedge clk);
    read = 0;
    wait(ready);
    $display("Read Addr %d = %h", a, dout);
  end
  endtask

endmodule
