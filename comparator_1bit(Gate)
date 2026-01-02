module comp1bit(
  input wire a,
  input wire b,
  output wire eq,
  output wire gt,
  output wire lt
);

  wire w1;
  wire notb;
  wire nota;

  not not1(nota, a);
  not not2(notb, b);
  and and2(lt, nota, b);
  and and1(gt, a, notb); 
  or  or1(w1, gt, lt); 
  not not3(eq, w1);

endmodule
