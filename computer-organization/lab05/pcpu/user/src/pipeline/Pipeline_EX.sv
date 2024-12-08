module Pipeline_EX (
   input  Debug_t debug_in_EX,
   output Debug_t debug_out_EX,

   input [31:0] PC_in_EX,
   input [31:0] Rs1_in_EX,
   input [31:0] Rs2_in_EX,
   input [31:0] Imm_in_EX,
   input        ALUSrc_B_in_EX,
   input [ 3:0] ALU_control_in_EX,

   output [31:0] PC_out_EX,
   output [31:0] PC4_out_EX,
   output [31:0] ALU_out_EX,
   output [31:0] Rs2_out_EX,
   output        zero_out_EX
);
   assign debug_out_EX = debug_in_EX;

   wire [31:0] Data_out;
   MUX2T1_32 MUX2T1_32_inst (
      .I0(Rs2_in_EX),
      .I1(Imm_in_EX),
      .s (ALUSrc_B_in_EX),
      .o (Data_out)
   );

   ALU ALU_inst (
      .A            (Rs1_in_EX),
      .B            (Data_out),
      .ALU_operation(ALU_control_in_EX),
      .res          (ALU_out_EX),
      .zero         (zero_out_EX)
   );

   assign PC_out_EX  = PC_in_EX + Imm_in_EX;
   assign PC4_out_EX = PC_in_EX + 4;
   assign Rs2_out_EX = Rs2_in_EX;
endmodule
