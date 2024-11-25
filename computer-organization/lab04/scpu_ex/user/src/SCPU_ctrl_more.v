`timescale 1ns / 1ps

module SCPU_ctrl_more (
   input      [6:0] OPcode,       // inst[6:0]
   input      [2:0] Fun3,         // inst[14:12]
   input            Fun7,         // inst[30] / Func7[5]
   input            MIO_ready,    // CPU Wait
   output reg [2:0] ImmSel,
   output reg       ALUSrc_B,
   output reg [1:0] MemtoReg,
   output reg [1:0] Jump,
   output reg       Branch,
   output reg       BranchN,
   output reg       RegWrite,
   output reg       MemRW,
   output reg [3:0] ALU_Control,
   output reg       CPU_MIO
);
   reg [1:0] ALU_op;

   parameter ImmSel_I = 3'b000;
   parameter ImmSel_S = 3'b001;
   parameter ImmSel_B = 3'b010;
   parameter ImmSel_J = 3'b011;
   parameter ImmSel_U = 3'b100;

   parameter ALUSrc_B_Reg = 1'b0;
   parameter ALUSrc_B_Imm = 1'b1;

   parameter MemRW_Read = 1'b0;
   parameter MemRW_Write = 1'b1;

   parameter MemtoReg_ALU = 2'b00;
   parameter MemtoReg_Mem = 2'b01;
   parameter MemtoReg_PC4 = 2'b10;
   parameter MemtoReg_Imm = 2'b11;

   parameter ALU_op_Add = 2'b00;
   parameter ALU_op_Sub = 2'b01;
   parameter ALU_op_Func = 2'b10;

   always @(*) begin
      // branch control
      if (OPcode == 7'b1100011) begin
         Branch  <= Fun3 == 3'b000;
         BranchN <= Fun3 == 3'b001;
      end else begin
         Branch  <= 1'b0;
         BranchN <= 1'b0;
      end

      // jump control
      Jump[1] <= OPcode == 7'b1100111;
      Jump[0] <= OPcode == 7'b1101111;

      case (OPcode)
         // R-type ALU
         7'b0110011: begin
            ImmSel   <= 3'b00; // don't care
            ALUSrc_B <= ALUSrc_B_Reg;
            ALU_op   <= ALU_op_Func;
            MemRW    <= MemRW_Read;
            RegWrite <= 1'b1;
            MemtoReg <= MemtoReg_ALU;
         end
         // I-type ALU
         7'b0010011: begin
            ImmSel   <= ImmSel_I;
            ALUSrc_B <= ALUSrc_B_Imm;
            ALU_op   <= ALU_op_Func;
            MemRW    <= MemRW_Read;
            RegWrite <= 1'b1;
            MemtoReg <= MemtoReg_ALU;
         end
         // lw
         7'b0000011: begin
            ImmSel   <= ImmSel_I;
            ALUSrc_B <= ALUSrc_B_Imm;
            ALU_op   <= ALU_op_Add;
            MemRW    <= MemRW_Read;
            RegWrite <= 1'b1;
            MemtoReg <= MemtoReg_Mem;
         end
         // sw
         7'b0100011: begin
            ImmSel   <= ImmSel_S;
            ALUSrc_B <= ALUSrc_B_Imm;
            ALU_op   <= ALU_op_Add;
            MemRW    <= MemRW_Write;
            RegWrite <= 1'b0;
            MemtoReg <= 2'b00; // don't care
         end
         // beq / bne
         7'b1100011: begin
            ImmSel   <= ImmSel_B;
            ALUSrc_B <= ALUSrc_B_Reg;
            ALU_op   <= ALU_op_Sub;
            MemRW    <= MemRW_Read;
            RegWrite <= 1'b0;
            MemtoReg <= 0; // don't care
         end
         // jal
         7'b1101111: begin  //J
            ImmSel   <= ImmSel_J;
            ALUSrc_B <= ALUSrc_B_Imm;
            ALU_op   <= 2'b00; // don't care
            MemRW    <= 1'b0;  // don't care
            RegWrite <= 1'b1;
            MemtoReg <= MemtoReg_PC4;
         end
         // jalr
         7'b1100111: begin
            ImmSel <= ImmSel_J;
            ALUSrc_B <= ALUSrc_B_Imm;
            ALU_op   <= ALU_op_Add;
            MemRW    <= 1'b0; // don't care
            RegWrite <= 1'b1;
            MemtoReg <= MemtoReg_PC4;
         end
         // lui
         7'b0110111: begin
            ImmSel   <= ImmSel_U;
            ALUSrc_B <= 1'b0;  // don't care
            ALU_op   <= 2'b00; // don't care
            MemRW    <= 1'b0;  // don't care
            RegWrite <= 1'b1;
            MemtoReg <= MemtoReg_Imm;
         end
         default: begin
            ImmSel   <= 3'b000;
            ALUSrc_B <= 1'b0;
            MemRW    <= 1'b0;
            RegWrite <= 1'b0;
            MemtoReg <= 2'b00;
            ALU_op   <= 2'b00;
         end
      endcase
   end

   // 二级译码
   always @(*) begin
      case (ALU_op)
         2'b00:   ALU_Control = 4'b0000;
         2'b01:   ALU_Control = 4'b1000;
         default: ALU_Control = {Fun7, Fun3};
      endcase
   end
endmodule
