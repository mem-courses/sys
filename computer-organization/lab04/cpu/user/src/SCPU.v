`timescale 1ns / 1ps
`include "Defines.vh"

module SCPU (
   input wire clk,
   input wire rst,
   input wire MIO_ready,
   input wire [31:0] inst_in,
   input wire [31:0] Data_in,

   output wire CPU_MIO,
   output wire MemRW,
   output wire [31:0] PC_out,
   output wire [31:0] Data_out,
   output wire [31:0] Addr_out,
   `RegFile_Regs_output
);

   wire ALUSrc_B;
   wire [2:0] ALU_Control;
   wire Branch;
   wire Jump;
   wire [1:0] ImmSel;
   wire [1:0] MemtoReg;
   wire RegWrite;

   DataPath DataPath_inst (
      // input
      .ALUSrc_B(ALUSrc_B),
      .ALU_Control(ALU_Control),
      .Branch(Branch),
      .Data_in(Data_in),
      .ImmSel(ImmSel),
      .Jump(Jump),
      .MemtoReg(MemtoReg),
      .RegWrite(RegWrite),
      .clk(clk),
      .inst_field(inst_in),
      .rst(rst),

      // output
      .ALU_out (Addr_out),
      .Data_out(Data_out),
      .PC_out  (PC_out),

      `RegFile_Regs_Arguments
   );

   SCPU_ctrl SCPU_ctrl_inst (
      // input
      .OPcode(inst_in[6:2]),
      .Fun3(inst_in[14:12]),
      .Fun7(inst_in[30]),
      .MIO_ready(MIO_ready),

      // output
      .ImmSel(ImmSel),
      .ALUSrc_B(ALUSrc_B),
      .MemtoReg(MemtoReg),
      .Jump(Jump),
      .Branch(Branch),
      .RegWrite(RegWrite),
      .MemRW(MemRW),
      .ALU_Control(ALU_Control),
      .CPU_MIO(CPU_MIO)
   );

endmodule