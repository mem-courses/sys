`timescale 1ns / 1ps
`include "Defines.vh"

module DataPath_more (
   input        clk,            // 寄存器时钟
   input        rst,            // 寄存器复位
   input [31:0] inst_field,     // 指令数据域[31:7]
   input        ALUSrc_B,       // ALU端口B输入选择
   input [ 1:0] MemtoReg,       // Regs写入数据源控制
   input [ 1:0] Jump,           // J指令
   input        Branch,         // beq指令需要
   input        BranchN,        // bneq指令需要
   input        RegWrite,       // 寄存器写信号
   input [31:0] Data_in,        // 存储器输入
   input [ 3:0] ALU_operation,  // ALU操作控制
   input [ 2:0] ImmSel,         // ImmGen操作控制

   `RegFile_Regs_output

   output wire [ 4:0] vga_rs1,
   output wire [31:0] vga_rs1_val,
   output wire [ 4:0] vga_rs2,
   output wire [31:0] vga_rs2_val,
   output wire [31:0] vga_imm,
   output wire [31:0] vga_a_val,
   output wire [31:0] vga_b_val,

   output [31:0] ALU_out,   // ALU运算输出
   output [31:0] Data_out,  // CPU数据输出
   output [31:0] PC_out     // PC指针输出
);

   wire [31:0] Rs1_data;
   wire [31:0] ALU_B;
   wire [31:0] Imm_out;
   wire [31:0] Wt_data;
   wire        ALU_zero;

   wire [ 4:0] Rs1_addr = inst_field[19:15];
   wire [ 4:0] Rs2_addr = inst_field[24:20];
   wire [ 4:0] Wt_addr = inst_field[11:7];

   // 寄存器堆
   Regs Regs_v1_0 (
      .clk(clk),
      .rst(rst),

      `RegFile_Regs_Arguments
      .Rs1_addr(Rs1_addr),
      .Rs2_addr(Rs2_addr),
      .Wt_addr (Wt_addr),
      .Wt_data (Wt_data),
      .RegWrite(RegWrite),
      .Rs1_data(Rs1_data),
      .Rs2_data(Data_out)
   );

   // 立即数生成模块
   ImmGen_more ImmGen_U (
      .ImmSel    (ImmSel),
      .inst_field(inst_field),
      .Imm_out   (Imm_out)
   );

   // MUX (ALUSrc)
   MUX2T1_32 MUX2T1_32_0 (
      .I0(Data_out),
      .I1(Imm_out),
      .s (ALUSrc_B),
      .o (ALU_B)
   );

   // ALU_more
   ALU_more ALU (
      .A            (Rs1_data),
      .B            (ALU_B),
      .ALU_operation(ALU_operation),
      .res          (ALU_out),
      .zero         (ALU_zero)
   );


   wire [31:0] PC_plus_4, PC_plus_imm;
   wire [31:0] PC_next_b, PC_next_j;

   assign PC_plus_4   = PC_out + 4;
   assign PC_plus_imm = PC_out + Imm_out;

   // MUX (branch)
   MUX2T1_32 MUX2T1_32_1 (
      .I0(PC_plus_4),
      .I1(PC_plus_imm),
      .s ((ALU_zero & Branch) | ((~ALU_zero) & BranchN)),
      .o (PC_next_b)
   );

   // MUX (jump)
   MUX4T1_32 MUX2T1_3 (
      .I0(PC_next_b),
      .I1(PC_plus_imm),
      .I2(ALU_out),
      .I3(PC_plus_imm),
      .s (Jump),
      .o (PC_next_j)
   );

   MUX4T1_32 MUX4T1_0 (
      .s (MemtoReg),
      .I0(ALU_out),
      .I1(Data_in),
      .I2(PC_plus_4),
      .I3(Imm_out),
      .o (Wt_data)
   );

   REG32 PC (
      .clk(clk),
      .rst(rst),
      .CE (1'b1  /* vcc */),
      .D  (PC_next_j),
      .Q  (PC_out)
   );

   // for VGA debugger
   assign vga_rs1     = Rs1_addr;
   assign vga_rs1_val = Rs1_data;
   assign vga_rs2     = Rs2_addr;
   assign vga_rs2_val = Data_out;
   assign vga_imm     = Imm_out;
   assign vga_a_val   = Rs1_data;
   assign vga_b_val   = ALU_B;

endmodule
