// Code your design here
module piso_reg 
(
input wire clk,   
input wire reset,
input wire load,
input wire [7:0]din,
output reg dout
         
);
  reg [7:0] shift_reg;  // internal shift register
  always @(posedge clk or posedge reset)begin
    if(reset) begin
      dout <=1'b0;
      shift_reg=8'h00;
    end
    else if(load)begin
      shift_reg<=din;
      dout <=shift_reg[7];  //these two happen in parallel
    end
    else begin
      shift_reg<={{shift_reg[6:0]},{1'b0}};
      dout <=shift_reg[7];
   
  end  
endmodule
