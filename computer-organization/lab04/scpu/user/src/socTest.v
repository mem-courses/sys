`timescale 1ns / 1ps
`include "Defines.vh"

module socTest (
   input clk,
   input rst
);

   wire [31:0] Addr_out;
   wire        CPU_MIO;
   wire        MemRW;
   wire [31:0] PC_out;
   wire [31:0] dmem_o_data;
   wire [31:0] dmem_i_data;
   wire [31:0] spo;

   `RegFile_Regs_Declaration

   SCPU U0 (
      `RegFile_Regs_Arguments
      .Addr_out(Addr_out),
      .Data_in(dmem_o_data),
      .Data_out(dmem_i_data),
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
      .dina (dmem_i_data),
      .douta(dmem_o_data),
      .wea  (MemRW)
   );

   ROM_D U2 (
      .a  (PC_out[11:2]),
      .spo(spo)
   );

   // for debugging

   wire [31:0] alu_res;
   wire [31:0] inst;
   assign alu_res = Addr_out;
   assign inst = spo;

   reg [31:0] last_PC_out;
   reg [31:0] last_inst;
   reg [31:0] last_alu_res;
   reg [31:0] last_dmem_i_data;
   reg [31:0] last_dmem_o_data;
   initial begin
      last_PC_out = 32'hFFFFFFFF;
      last_inst = 32'hFFFFFFFF;
      last_alu_res = 32'hFFFFFFFF;
      last_dmem_i_data = 32'hFFFFFFFF;
      last_dmem_o_data = 32'hFFFFFFFF;
      $display("[mem] Recorder Initialized.");
   end

   integer fd;
   initial begin
      fd = $fopen("display_data.txt", "w");
      if (fd) $display("[mem] Log file opened successfully");
      else $display("[mem] Failed to open log file");
      $fwrite(fd, ""); // 清空文件内容
   end

   `define LOG_AND_DISPLAY(fd, fmt, var, last_var) \
      if (var != last_var) begin \
         $fwrite(fd, fmt, var); \
         $fflush(fd); \
         $display(fmt, var); \
         last_var = var; \
      end // 记得及时刷新缓冲区，否则会得到空文件

   always @* begin
      `LOG_AND_DISPLAY(fd, "PC = %h", PC_out, last_PC_out)
      `LOG_AND_DISPLAY(fd, "inst = %h", inst, last_inst)
      `LOG_AND_DISPLAY(fd, "alu_res = %h", alu_res, last_alu_res)
      `LOG_AND_DISPLAY(fd, "dmem_i_data = %h", dmem_i_data, last_dmem_i_data)
      `LOG_AND_DISPLAY(fd, "dmem_o_data = %h", dmem_o_data, last_dmem_o_data)
   end
   
endmodule