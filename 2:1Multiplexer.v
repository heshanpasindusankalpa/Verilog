module mux_2to1(
input wire a,
input wire b,
input wire en,
input wire se,
output reg y  
);
  
  
assign y= en?(se?a:b):1'bz;
endmodule
