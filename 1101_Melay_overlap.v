// Code your design here
module 1101_Melay_overlap(  
 
input wire clk,
input wire reset,
input wire in,
output reg out  
);

//states
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;
  
reg [1:0] current_state,next_state;

//Sequential logic for state transition
always @(posedge clk or posedge reset)begin
  if(reset)begin
  curent_state<=S0;
  end else begin
  current_state<=next_state;
  end  
end

always @(current_state or in)begin
  case(current_state)
  S0: next_state=in?S1:S0;
  S1: next_state=in?S2:S0;
  S2: next_state=in?S2:S3;
  S3: next_state=in?S1:S0;
  default:next_state=S0;
  endcase
      
end  
 // Combinational logic for Mealy output 
always @(current_state or in)
  if((current_state==S3)&& (in==1'b1))begin
  end else begin
  out = 1'b0;
  end
end
  
endmodule

