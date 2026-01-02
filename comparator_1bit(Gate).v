module comp1b (
input wire a,
input wire b,
output wire c
);

wire na , nb , na_or_nb ;
wire a_or_b ;

not NG1 (na , a);
not NG2 (nb , b);
and AND1 ( na_or_nb , na , nb);
and AND2 ( a_or_b , a, b);

or OR1 (c, na_or_nb , a_or_b );

endmodule
