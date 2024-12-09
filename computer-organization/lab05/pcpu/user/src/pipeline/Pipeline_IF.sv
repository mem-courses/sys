import pcpu::*;

module Pipeline_IF (
   input         clk_IF,
   input         rst_IF,
   input         en_IF,
   input  [31:0] PC_in_IF,
   input         PCSrc,
   output [31:0] PC_out_IF
);
   wire [31:0] Q, o;

   MUX2T1_32 MUX2T1_32 (
      .I0(Q + 4),
      .I1(PC_in_IF),
      .s (PCSrc),
      .o (o)
   );

   REG32 PC (
      .clk(clk_IF),
      .rst(rst_IF),
      .CE (en_IF),
      .D  (o),
      .Q  (Q)
   );

   assign PC_out_IF = Q;
endmodule
