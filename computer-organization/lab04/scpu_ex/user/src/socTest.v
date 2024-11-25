`timescale 1ns / 1ps
`include "Defines.vh"

module socTest (
   input clk,
   input rst
);

   wire [31:0] Addr_out;
   wire        CPU_MIO;
   wire [31:0] PC_out;
   wire [31:0] inst;
   wire        mem_wen;
   wire [31:0] dmem_o_data;
   wire [31:0] dmem_i_data;

   `RegFile_Regs_Declaration

   ExtSCPU U0 (
      `RegFile_Regs_Arguments
      .Addr_out(Addr_out),
      .Data_in(dmem_o_data),
      .Data_out(dmem_i_data),
      .MIO_ready(CPU_MIO),
      .MemRW(mem_wen),
      .PC_out(PC_out),
      .clk(clk),
      .rst(rst),
      .inst_in(inst)
   );

   RAM_B U1 (
      .addra(Addr_out[11:2]),
      .clka (~clk),
      .dina (dmem_i_data),
      .douta(dmem_o_data),
      .wea  (mem_wen)
   );

   ROM_D U2 (
      .a  (PC_out[11:2]),
      .spo(inst)
   );

   // for debugging

   wire [31:0] alu_res;
   assign alu_res = Addr_out;

   localparam INIT_VALUE = 32'hDEADBEEF;

   reg [31:0] PC_last;
   initial begin
      PC_last = INIT_VALUE;
      $display("[mem] Recorder Initialized.");
   end

   integer fd;
   initial begin
      fd = $fopen("display_data.txt", "w");
      if (fd) $display("[mem] Log file opened successfully");
      else $display("[mem] Failed to open log file");
      $fwrite(fd, "");  // 清空文件内容
   end

   `define LOG_AND_DISPLAY(fd, fmt, var) \
      $display(fmt, var); \
      $fwrite(fd, fmt, var); \
      $fwrite(fd, "\n"); \
      $fflush(fd); // 记得及时刷新缓冲区，否则会得到空文件

   always @(posedge ~clk) begin
      if (PC_out != PC_last) begin
         `LOG_AND_DISPLAY(fd, "PC = %h", PC_out)
         `LOG_AND_DISPLAY(fd, "inst = %h", inst)
         `LOG_AND_DISPLAY(fd, "alu_res = %h", alu_res)
         `LOG_AND_DISPLAY(fd, "dmem_o_data = %h", dmem_o_data) // 可能滞后 
         `LOG_AND_DISPLAY(fd, "dmem_i_data = %h", dmem_i_data) // 可能滞后
         PC_last = PC_out;
      end
   end

endmodule
