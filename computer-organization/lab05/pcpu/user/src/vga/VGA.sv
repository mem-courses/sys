import pcpu::*;

module VGA (
   input wire clk_25m,
   input wire clk_100m,
   input wire rst,

   input wire RV32_Regs_t   regs,
   input wire VGA_Signals_t vga_signals,

   input wire [31:0] PC_IF,
   input wire [31:0] inst_IF,
   input wire [31:0] PC_ID,
   input wire [31:0] inst_ID,
   input wire [31:0] PC_Ex,
   input wire        MemRW_Mem,
   input wire [31:0] Data_out,
   input wire [31:0] Addr_out,

   output wire       hs,
   output wire       vs,
   output wire [3:0] vga_r,
   output wire [3:0] vga_g,
   output wire [3:0] vga_b
);

   wire [9:0] vga_x;
   wire [8:0] vga_y;
   wire video_on;
   VgaController vga_controller (
      .clk     (clk_25m),
      .rst     (rst),
      .vga_x   (vga_x),
      .vga_y   (vga_y),
      .hs      (hs),
      .vs      (vs),
      .video_on(video_on)
   );
   wire display_wen;
   wire [11:0] display_w_addr;
   wire [7:0] display_w_data;
   VgaDisplay vga_display (
      .clk     (clk_100m),
      .video_on(video_on),
      .vga_x   (vga_x),
      .vga_y   (vga_y),
      .vga_r   (vga_r),
      .vga_g   (vga_g),
      .vga_b   (vga_b),
      .wen     (display_wen),
      .w_addr  (display_w_addr),
      .w_data  (display_w_data)
   );
   VgaDebugger vga_debugger (
      .clk           (clk_100m),
      .display_wen   (display_wen),
      .display_w_addr(display_w_addr),
      .display_w_data(display_w_data),
      .pc            (PC_IF),
      .inst          (inst_IF),

      // 各阶段调试输出
      .IfId_pc        (vga_signals.IfId_pc),
      .IfId_inst      (vga_signals.IfId_inst),
      .IdEx_pc        (vga_signals.IdEx_pc),
      .IdEx_inst      (vga_signals.IdEx_inst),
      .IdEx_rd        (vga_signals.IdEx_rd),
      .IdEx_rs1       (vga_signals.IdEx_rs1),
      .IdEx_rs2       (vga_signals.IdEx_rs2),
      .IdEx_rs1_val   (vga_signals.IdEx_rs1_val),
      .IdEx_rs2_val   (vga_signals.IdEx_rs2_val),
      .IdEx_reg_wen   (vga_signals.IdEx_reg_wen),
      .IdEx_is_imm    (vga_signals.IdEx_is_imm),
      .IdEx_imm       (vga_signals.IdEx_imm),
      .Ex_forward_rs1 (vga_signals.Ex_forward_rs1),
      .Ex_forward_rs2 (vga_signals.Ex_forward_rs2),
      .IdEx_mem_wen   (vga_signals.IdEx_mem_wen),
      .IdEx_mem_ren   (vga_signals.IdEx_mem_ren),
      .IdEx_is_branch (vga_signals.IdEx_is_branch),
      .IdEx_is_jal    (vga_signals.IdEx_is_jal),
      .IdEx_is_jalr   (vga_signals.IdEx_is_jalr),
      .IdEx_is_auipc  (vga_signals.IdEx_is_auipc),
      .IdEx_is_lui    (vga_signals.IdEx_is_lui),
      .IdEx_alu_ctrl  (vga_signals.IdEx_alu_ctrl),
      .IdEx_cmp_ctrl  (vga_signals.IdEx_cmp_ctrl),
      .ExMa_pc        (vga_signals.ExMa_pc),
      .ExMa_inst      (vga_signals.ExMa_inst),
      .ExMa_rd        (vga_signals.ExMa_rd),
      .ExMa_reg_wen   (vga_signals.ExMa_reg_wen),
      .ExMa_mem_i_data(Data_out),
      .ExMa_alu_res   (Addr_out),
      .ExMa_mem_wen   (MemRW_Mem),
      .ExMa_mem_ren   (vga_signals.ExMa_mem_ren),
      .ExMa_is_jal    (vga_signals.ExMa_is_jal),
      .ExMa_is_jalr   (vga_signals.ExMa_is_jalr),
      .MaWb_pc        (vga_signals.MaWb_pc),
      .MaWb_inst      (vga_signals.MaWb_inst),
      .MaWb_rd        (vga_signals.MaWb_rd),
      .MaWb_reg_wen   (vga_signals.MaWb_reg_wen),
      .MaWb_reg_i_data(vga_signals.MaWb_reg_i_data),

      // 寄存器相关接口
      .x0 (regs.x0),
      .ra (regs.ra),
      .sp (regs.sp),
      .gp (regs.gp),
      .tp (regs.tp),
      .t0 (regs.t0),
      .t1 (regs.t1),
      .t2 (regs.t2),
      .s0 (regs.s0),
      .s1 (regs.s1),
      .a0 (regs.a0),
      .a1 (regs.a1),
      .a2 (regs.a2),
      .a3 (regs.a3),
      .a4 (regs.a4),
      .a5 (regs.a5),
      .a6 (regs.a6),
      .a7 (regs.a7),
      .s2 (regs.s2),
      .s3 (regs.s3),
      .s4 (regs.s4),
      .s5 (regs.s5),
      .s6 (regs.s6),
      .s7 (regs.s7),
      .s8 (regs.s8),
      .s9 (regs.s9),
      .s10(regs.s10),
      .s11(regs.s11),
      .t3 (regs.t3),
      .t4 (regs.t4),
      .t5 (regs.t5),
      .t6 (regs.t6)
   );
endmodule
