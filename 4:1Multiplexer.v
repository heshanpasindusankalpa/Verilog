module mul_4to1(
  input wire [3:0]d,
  input wire [1:0]se,
  input wire en,
  output reg y
  
);
  
  always@(*)begin
    if(en)begin
      case(se)
        2'b00:y=d[0];
        2'b01:y=d[1];
        2'b10:y=d[2];
        2'b11:y=d[3];
        default:y=1'bz;
      endcase
    end
    else 
      y=1'bz;
  end
