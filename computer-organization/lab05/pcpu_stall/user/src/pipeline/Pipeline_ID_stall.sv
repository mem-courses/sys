import pcpu::*;

module Pipeline_ID_stall (
   input  Debug_t debug_in_ID,
   output Debug_t debug_out_ID,

   input         clk_ID,
   input         rst_ID,
   input         RegWrite_in_ID,
   input  [ 4:0] Rd_addr_ID,
   input  [31:0] Wt_data_ID,
   input  [31:0] Inst_in_ID,
   output [ 4:0] Rd_addr_out_ID,
   output [31:0] Rs1_out_ID,
   output [31:0] Rs2_out_ID,
   output [ 4:0] Rs1_addr_ID,     //寄存器地址1
   output [ 4:0] Rs2_addr_ID,     //寄存器地址2
   output        Rs1_used,        //Rs1被使用
   output        Rs2_used,        //Rs2被使用
   output [31:0] Imm_out_ID,
   output        ALUSrc_B_ID,
   output [ 3:0] ALU_control_ID,
   output        Branch_ID,
   output        BranchN_ID,
   output        MemRW_ID,
   output        Jump_ID,
   output [ 1:0] MemtoReg_ID,
   output        RegWrite_out_ID,

   output RV32_Regs_t regs
);
   assign debug_out_ID = debug_in_ID;

   assign Rs1_addr_ID = Inst_in_ID[19:15];
   assign Rs2_addr_ID = Inst_in_ID[24:20];
   assign Rs1_used = (Rs1_addr_ID != 5'b0);
   assign Rs2_used = (Rs2_addr_ID != 5'b0) && (ALUSrc_B_ID == 0);

   Regs Regs_inst (
      .clk         (clk_ID),
      .rst         (rst_ID),
      .Rs1_addr    (Rs1_addr_ID),
      .Rs2_addr    (Rs2_addr_ID),
      .Wt_addr     (Rd_addr_ID),
      .Wt_data     (Wt_data_ID),
      .RegWrite    (RegWrite_in_ID),
      .Rs1_data    (Rs1_out_ID),
      .Rs2_data    (Rs2_out_ID),
      .regs_for_vga(regs)             // just for vga
   );

   wire [2:0] ImmSel;

   ImmGen ImmGen_inst (
      .ImmSel    (ImmSel),
      .inst_field(Inst_in_ID),
      .Imm_out   (Imm_out_ID)
   );

   SCPU_ctrl SCPU_ctrl_inst (
      .OPcode(Inst_in_ID[6:0]),
      .Fun3  (Inst_in_ID[14:12]),
      .Fun7  (Inst_in_ID[30]),

      .ImmSel     (ImmSel),
      .ALUSrc_B   (ALUSrc_B_ID),
      .MemtoReg   (MemtoReg_ID),
      .Jump       (Jump_ID),
      .Branch     (Branch_ID),
      .BranchN    (BranchN_ID),
      .RegWrite   (RegWrite_out_ID),
      .MemRW      (MemRW_ID),
      .ALU_Control(ALU_control_ID)
   );

   assign Rd_addr_out_ID = Inst_in_ID[11:7];  // 这里的rd要传递一圈传递回来再生效

endmodule
