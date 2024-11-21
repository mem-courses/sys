`timescale 1ns / 1ps
`include "Defines.vh"

module socTest (
   input clk,
   input rst
);

   wire [31:0] Addr_out;
   wire [31:0] Data_out;
   wire        CPU_MIO;
   wire        MemRW;
   wire [31:0] PC_out;
   wire [31:0] douta;
   wire [31:0] spo;

   `RegFile_Regs_Declaration

   SCPU U0 (
      `RegFile_Regs_Arguments
      .Addr_out(Addr_out),
      .Data_in(douta),
      .Data_out(Data_out),
      .MIO_ready(CPU_MIO),
      .MemRW(MemRW),
      .PC_out(PC_out),
      .clk(clk),
      .rst(rst),
      .inst_in(spo)
   );

   RAM_B U1 (
      .addra(Addr_out[11:2]),
      .clka (~clk),
      .dina (Data_out),
      .douta(douta),
      .wea  (MemRW)
   );

   ROM_D U2 (
      .a  (PC_out[11:2]),
      .spo(spo)
   );
endmodule
