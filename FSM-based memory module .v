
// Add code here

module  memory(

input wire  clk, reset,
input wire  read, write,
input wire  [3:0] addr,
input wire  [7:0] din,
output reg [7:0] dout,
output reg ready
);

reg [7:0] mem[0:15];
reg [1:0] state;
localparam IDLE=2'b00,  WRITE=2'b01,READ=2'b10, DONE=2'b11;


always @(posedge clk or posedge reset )begin
 if(reset)begin
  state<=IDLE;
  ready<=0;
  dout<=0;
end
 else begin
  case(state)
   IDLE:begin
    ready<=0;
    if(write)state<=WRITE;
    else if(read)state<=READ;
    else
     state<=IDLE;
   end
   WRITE:begin
    mem[addr]<=din;
    state<=DONE;
   end
   
   READ:begin
   dout<=mem[addr];
   state<=DONE;
   end
   
   DONE:begin
   ready<=1;
   if(!write && !read) state<=IDLE;
   end
   default:
   state<=IDLE;
   endcase
  end
end
endmodule
