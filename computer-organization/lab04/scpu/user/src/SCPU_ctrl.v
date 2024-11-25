`timescale 1ns / 1ps

module SCPU_ctrl (
   input wire [4:0] OPcode,
   input wire [2:0] Fun3,
   input wire Fun7,
   input wire MIO_ready,
   output reg [1:0] ImmSel,
   output reg ALUSrc_B,
   output reg [1:0] MemtoReg,
   output reg Jump,
   output reg Branch,
   output reg RegWrite,
   output reg MemRW,
   output reg [2:0] ALU_Control,
   output reg CPU_MIO
);
   reg [1:0] ALU_op;

   parameter ImmSel_I = 2'b00;
   parameter ImmSel_S = 2'b01;
   parameter ImmSel_B = 2'b10;
   parameter ImmSel_J = 2'b11;
   parameter ALUSrc_B_Reg = 1'b0;
   parameter ALUSrc_B_Imm = 1'b1;
   parameter MemRW_Read = 1'b0;
   parameter MemRW_Write = 1'b1;
   parameter MemtoReg_ALU = 2'b00;
   parameter MemtoReg_Mem = 2'b01;
   parameter MemtoReg_PC4 = 2'b10;
   parameter ALU_op_Add = 2'b00;
   parameter ALU_op_Sub = 2'b01;
   parameter ALU_op_Op = 2'b10;
   parameter ALU_op_Func = 2'b11;

   always @(*) begin
      Branch <= OPcode == 5'b11000;
      Jump   <= OPcode == 5'b11011;

      case (OPcode)
         // add / sub 
         5'b01100: begin
            ImmSel   <= 2'b00; // don't care
            ALUSrc_B <= ALUSrc_B_Reg;
            ALU_op   <= ALU_op_Op;
            MemRW    <= MemRW_Read;
            RegWrite <= 1'b1;
            MemtoReg <= MemtoReg_ALU;
         end
         // addi / slti
         5'b00100: begin
            ImmSel   <= ImmSel_I;
            ALUSrc_B <= ALUSrc_B_Imm;
            ALU_op   <= ALU_op_Op; // ?
            MemRW    <= MemRW_Read;
            RegWrite <= 1'b1;
            MemtoReg <= MemtoReg_ALU;
         end
         // lw
         5'b00000: begin
            ImmSel   <= ImmSel_I;
            ALUSrc_B <= ALUSrc_B_Imm;
            ALU_op   <= ALU_op_Add;
            MemRW    <= MemRW_Read;
            RegWrite <= 1'b1;
            MemtoReg <= MemtoReg_Mem;
         end
         // sw
         5'b01000: begin
            ImmSel   <= ImmSel_S;
            ALUSrc_B <= ALUSrc_B_Imm;
            ALU_op   <= ALU_op_Add;
            MemRW    <= MemRW_Write;
            RegWrite <= 1'b0;
            MemtoReg <= 2'b00; // don't care
         end
         // beq
         5'b11000: begin
            ImmSel   <= ImmSel_B;
            ALUSrc_B <= ALUSrc_B_Reg;
            ALU_op   <= ALU_op_Sub;
            MemRW    <= MemRW_Read;
            RegWrite <= 1'b0;
            MemtoReg <= 2'b00; // don't care
         end
         // jal
         5'b11011: begin  //J
            ImmSel   <= ImmSel_J;
            ALUSrc_B <= ALUSrc_B_Imm;
            ALU_op   <= 2'b00; // don't care
            MemRW    <= MemRW_Read;
            RegWrite <= 1'b1;
            MemtoReg <= MemtoReg_PC4;
         end
         // lui
         // 5'b01101: begin
         //    ImmSel        <= ImmSel_U;
         //    ALUSrc_B      <= ALUSrc_B_Imm;
         //    MemRW         <= MemRW_Read;
         //    RegWrite      <= 1'b1;
         //    MemtoReg      <= MemtoReg_ALU;
         //    ALU_op         <= 2'b11;
         // end
         default: begin
            ImmSel   <= 2'b00;
            ALUSrc_B <= 1'b0;
            MemRW    <= 1'b0;
            RegWrite <= 1'b0;
            MemtoReg <= 2'b00;
            ALU_op   <= 2'b00;
         end
      endcase
   end

   always @(*) begin
      case (ALU_op)
         2'b00: begin
            ALU_Control <= 3'b010;  // add
         end
         2'b01: begin
            ALU_Control <= 3'b110;  // subtract
         end
         2'b10: begin
            case ({
               Fun7,  // 实际上是 func7[5]，因为只有这位有效
               Fun3  // func3[2:0]
            })
               4'b0000: ALU_Control <= 3'b010;  // add
               4'b1000: ALU_Control <= 3'b110;  // sub
               4'b0111: ALU_Control <= 3'b000;  // and
               4'b0110: ALU_Control <= 3'b001;  // or
               4'b0010: ALU_Control <= 3'b111;  // slt
               4'b0101: ALU_Control <= 3'b101;  // srl
               4'b0100: ALU_Control <= 3'b011;  // xor
               default: ALU_Control <= 3'b000;
            endcase
         end
      endcase
   end
endmodule
