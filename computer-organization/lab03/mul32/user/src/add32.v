module add32 (
   input [31:0] a,
   input [31:0] b,
   output c,
   output [31:0] s
);

   assign {c, s} = {1'b0, a} + {1'b0, b};
endmodule
