package pcpu;

   typedef struct packed {
      // 使用 packed 关键字确保结构体中的数据是紧密排列的
      logic [31:0] x0;
      logic [31:0] ra;
      logic [31:0] sp;
      logic [31:0] gp;
      logic [31:0] tp;
      logic [31:0] t0;
      logic [31:0] t1;
      logic [31:0] t2;
      logic [31:0] s0;
      logic [31:0] s1;
      logic [31:0] a0;
      logic [31:0] a1;
      logic [31:0] a2;
      logic [31:0] a3;
      logic [31:0] a4;
      logic [31:0] a5;
      logic [31:0] a6;
      logic [31:0] a7;
      logic [31:0] s2;
      logic [31:0] s3;
      logic [31:0] s4;
      logic [31:0] s5;
      logic [31:0] s6;
      logic [31:0] s7;
      logic [31:0] s8;
      logic [31:0] s9;
      logic [31:0] s10;
      logic [31:0] s11;
      logic [31:0] t3;
      logic [31:0] t4;
      logic [31:0] t5;
      logic [31:0] t6;
   } rv32_regs_t;

   typedef struct packed {
      // ID/EX
      logic [4:0]  IdEx_rd;
      logic [4:0]  IdEx_rs1;
      logic [4:0]  IdEx_rs2;
      logic [31:0] IdEx_rs1_val;
      logic [31:0] IdEx_rs2_val;
      logic        IdEx_reg_wen;
      logic        IdEx_is_imm;
      logic [31:0] IdEx_imm;
   } vga_singals_t;

endpackage
