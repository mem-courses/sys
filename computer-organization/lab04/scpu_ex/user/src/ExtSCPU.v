`timescale 1ns / 1ps
`include "Defines.vh"

module ExtSCPU (
   input wire clk,
   input wire rst,
   input wire MIO_ready,
   input wire [31:0] inst_in,
   input wire [31:0] Data_in,

   `RegFile_Regs_output
   output wire CPU_MIO,
   output wire MemRW,
   output wire [31:0] PC_out,
   output wire [31:0] Data_out,
   output wire [31:0] Addr_out
);

   wire       ALUSrc_B;
   wire [3:0] ALU_operation;
   wire       Branch;
   wire       BranchN;
   wire [1:0] Jump;
   wire [2:0] ImmSel;
   wire [1:0] MemtoReg;
   wire       RegWrite;

   DataPath_more DataPath_inst (
      .clk          (clk),
      .rst          (rst),
      .ALUSrc_B     (ALUSrc_B),
      .ALU_operation(ALU_operation),
      .Branch       (Branch),
      .BranchN      (BranchN),
      .Data_in      (Data_in),
      .ImmSel       (ImmSel),
      .Jump         (Jump),
      .MemtoReg     (MemtoReg),
      .RegWrite     (RegWrite),
      .inst_field   (inst_in),

      // output
      `RegFile_Regs_Arguments
      .ALU_out (Addr_out),
      .Data_out(Data_out),
      .PC_out  (PC_out)
   );

   SCPU_ctrl_more SCPU_ctrl_inst (
      // input
      .OPcode   (inst_in[6:0]),
      .Fun3     (inst_in[14:12]),
      .Fun7     (inst_in[30]),
      .MIO_ready(MIO_ready),

      // output
      .ImmSel     (ImmSel),
      .ALUSrc_B   (ALUSrc_B),
      .MemtoReg   (MemtoReg),
      .Jump       (Jump),
      .Branch     (Branch),
      .BranchN    (BranchN),
      .RegWrite   (RegWrite),
      .MemRW      (MemRW),
      .ALU_Control(ALU_operation),
      .CPU_MIO    (CPU_MIO)
   );
endmodule
