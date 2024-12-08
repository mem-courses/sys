import pcpu::*;

module Regs (
   input wire        clk,
   input wire        rst,
   input wire [ 4:0] Rs1_addr,
   input wire [ 4:0] Rs2_addr,
   input wire [ 4:0] Wt_addr,
   input wire [31:0] Wt_data,
   input wire        RegWrite,

   output reg [31:0] Rs1_data,
   output reg [31:0] Rs2_data,

   output RV32_Regs_t regs_for_vga
);
   reg [31:0] register[1:31];  // r1-r31
   integer i;

   always @(posedge clk or posedge rst) begin
      if (rst) begin
         for (i = 1; i < 32; i = i + 1) begin
            register[i] <= 0;  // reset
         end

      end else begin
         if ((Wt_addr != 0) && (RegWrite == 1)) register[Wt_addr] <= Wt_data;  // write
      end
   end

   always @(negedge clk or posedge rst) begin
      if (rst) begin
         Rs1_data <= 0;
         Rs2_data <= 0;

      end else begin
         if (RegWrite && Wt_addr == Rs1_addr) begin
            Rs1_data <= Wt_data;
         end else begin
            Rs1_data <= (Rs1_addr == 0) ? 0 : register[Rs1_addr];
         end

         if (RegWrite && Wt_addr == Rs2_addr) begin
            Rs2_data <= Wt_data;
         end else begin
            Rs2_data <= (Rs2_addr == 0) ? 0 : register[Rs2_addr];
         end
      end
   end

   // map to vga signals
   assign regs_for_vga.x0  = 32'b0;
   assign regs_for_vga.ra  = register[1];
   assign regs_for_vga.sp  = register[2];
   assign regs_for_vga.gp  = register[3];
   assign regs_for_vga.tp  = register[4];
   assign regs_for_vga.t0  = register[5];
   assign regs_for_vga.t1  = register[6];
   assign regs_for_vga.t2  = register[7];
   assign regs_for_vga.s0  = register[8];
   assign regs_for_vga.s1  = register[9];
   assign regs_for_vga.a0  = register[10];
   assign regs_for_vga.a1  = register[11];
   assign regs_for_vga.a2  = register[12];
   assign regs_for_vga.a3  = register[13];
   assign regs_for_vga.a4  = register[14];
   assign regs_for_vga.a5  = register[15];
   assign regs_for_vga.a6  = register[16];
   assign regs_for_vga.a7  = register[17];
   assign regs_for_vga.s2  = register[18];
   assign regs_for_vga.s3  = register[19];
   assign regs_for_vga.s4  = register[20];
   assign regs_for_vga.s5  = register[21];
   assign regs_for_vga.s6  = register[22];
   assign regs_for_vga.s7  = register[23];
   assign regs_for_vga.s8  = register[24];
   assign regs_for_vga.s9  = register[25];
   assign regs_for_vga.s10 = register[26];
   assign regs_for_vga.s11 = register[27];
   assign regs_for_vga.t3  = register[28];
   assign regs_for_vga.t4  = register[29];
   assign regs_for_vga.t5  = register[30];
   assign regs_for_vga.t6  = register[31];

endmodule
