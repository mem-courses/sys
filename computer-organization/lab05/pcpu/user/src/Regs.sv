`timescale 1ns / 1ps

import pcpu::*;

module Regs (
   input        clk,
   input        rst,
   input [ 4:0] Rs1_addr,
   input [ 4:0] Rs2_addr,
   input [ 4:0] Wt_addr,
   input [31:0] Wt_data,
   input        RegWrite,

   output [31:0] Rs1_data,
   output [31:0] Rs2_data,

   output rv32_regs_t regs_for_vga
);
   reg [31:0] register[1:31];  // r1-r31
   integer i;

   assign Rs1_data = (Rs1_addr == 0) ? 0 : register[Rs1_addr];  // read
   assign Rs2_data = (Rs2_addr == 0) ? 0 : register[Rs2_addr];  // read

   always @(posedge clk or posedge rst) begin
      if (rst == 1) begin
         for (i = 1; i < 32; i = i + 1) register[i] <= 0;  // reset
      end else begin
         if ((Wt_addr != 0) && (RegWrite == 1)) register[Wt_addr] <= Wt_data;  // write
      end
   end

   // map to vga signals
   assign regs.x0  = 32'b0;
   assign regs.ra  = register[1];
   assign regs.sp  = register[2];
   assign regs.gp  = register[3];
   assign regs.tp  = register[4];
   assign regs.t0  = register[5];
   assign regs.t1  = register[6];
   assign regs.t2  = register[7];
   assign regs.s0  = register[8];
   assign regs.s1  = register[9];
   assign regs.a0  = register[10];
   assign regs.a1  = register[11];
   assign regs.a2  = register[12];
   assign regs.a3  = register[13];
   assign regs.a4  = register[14];
   assign regs.a5  = register[15];
   assign regs.a6  = register[16];
   assign regs.a7  = register[17];
   assign regs.s2  = register[18];
   assign regs.s3  = register[19];
   assign regs.s4  = register[20];
   assign regs.s5  = register[21];
   assign regs.s6  = register[22];
   assign regs.s7  = register[23];
   assign regs.s8  = register[24];
   assign regs.s9  = register[25];
   assign regs.s10 = register[26];
   assign regs.s11 = register[27];
   assign regs.t3  = register[28];
   assign regs.t4  = register[29];
   assign regs.t5  = register[30];
   assign regs.t6  = register[31];

endmodule
