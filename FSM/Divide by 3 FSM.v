  
// endmodule
module divby3(
  input wire clk,
  input wire reset,
  output reg y
);

  // State encoding
  reg [1:0] state, next_state;
  parameter s0 = 2'b00;
  parameter s1 = 2'b01;
  parameter s2 = 2'b10;

  // Sequential block: state transition
  always @(posedge clk or posedge reset) begin
    if (reset)
      state <= s0;
    else
      state <= next_state;
  end

  // Combinational block: next-state logic
  always @(*) begin
    case (state)
      s0: next_state = s1;
      s1: next_state = s2;
      s2: next_state = s0;
      default: next_state = s0;
    endcase
  end

  // Output logic (Moore type — depends only on state)
  always @(*) begin
    case (state)
      s0: y = 1'b1;
      default: y = 1'b0;
    endcase
  end

endmodule
