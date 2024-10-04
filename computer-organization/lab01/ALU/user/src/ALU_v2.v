module ALU_v2 (
   input [31:0] A,
   input [2:0] ALU_operation,
   input [31:0] B,
   output [31:0] res,
   output zero
);
   wire [31:0] I0;
   wire [31:0] I1;
   wire [31:0] I2;
   wire [31:0] I3;
   wire [31:0] I4;
   wire [31:0] I5;
   wire [31:0] I6;
   wire [31:0] I7;
   wire [31:0] o;

   wire [32:0] addc_res;

   addc32 addc32_v1 (
      .A  (A),
      .B  (ALU_operation[2] ? ~B : B),
      .C0 (ALU_operation[2]),
      .res(addc_res)
   );
   // 2: add
   assign I2 = addc_res[31:0];

   // 6: sub
   assign I6 = addc_res[31:0];

   // 7: set on less then
   assign I7 = addc_res[32] == 0;

   // 0: and
   and32 and32_v1 (
      .A  (A),
      .B  (B),
      .res(I0)
   );

   // 1: or
   or32 or32_v1 (
      .A  (A),
      .B  (B),
      .res(I1)
   );

   // 3: xor
   xor32 xor32_v1 (
      .A  (A),
      .B  (B),
      .res(I3)
   );

   // 4: nor
   nor32 nor32_v1 (
      .A  (A),
      .B  (B),
      .res(I4)
   );

   // 5: srl
   srl32 srl32_v1 (
      .A  (A),
      .B  (B[4:0]),
      .res(I5)
   );


   MUX8t1_32 MUX8t1_32_v1 (
      .ch (ALU_operation),
      .I0 (I0),
      .I1 (I1),
      .I2 (I2),
      .I3 (I3),
      .I4 (I4),
      .I5 (I5),
      .I6 (I6),
      .I7 (I7),
      .res(o)
   );

   assign res  = o;
   assign zero = (o == 0);
endmodule
