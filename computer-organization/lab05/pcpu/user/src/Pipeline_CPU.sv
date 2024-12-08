import pcpu::*;

module Pipeline_CPU (
   input  wire        clk,
   input  wire        rst,
   input  wire [31:0] Data_in,
   input  wire [31:0] inst_IF,
   output wire [31:0] PC_out_IF,
   output wire [31:0] PC_out_ID,
   output wire [31:0] inst_ID,
   output wire [31:0] PC_out_EX,
   output wire        MemRW_Mem,
   output wire [31:0] Addr_out,
   output wire [31:0] Data_out,
   output wire [31:0] Data_out_WB,

   output wire RV32_Regs_t   regs,
   output wire vga_signals_t vga_signals
);

   // =========== debugging signals ===========
`ifdef SIM
   Debug_t debug_out_IFID;
   Debug_t debug_out_ID;
   Debug_t debug_out_IDEX;
   Debug_t debug_out_EX;
   Debug_t debug_out_EXMem;
   Debug_t debug_out_Mem;
   Debug_t debug_out_MemWB;
   Debug_t debug_out_WB;
`endif
   // =========== debugging signals ===========


   Pipeline_IF Instruction_Fetch (
      .clk_IF   (clk),
      .rst_IF   (rst),
      .en_IF    (1'b1),
      .PC_in_IF (PC_out_EXMem),
      .PCSrc    (PCSrc_out_Mem),
      .PC_out_IF(PC_out_IF)
   );


   wire [31:0] PC_out_IFID;
   wire [31:0] inst_out_IFID;
   IF_reg_ID IF_reg_ID (
`ifdef SIM
      .debug_out_IFID(debug_out_IFID),
`endif

      .clk_IFID    (clk),
      .rst_IFID    (rst),
      .en_IFID     (1'b1),
      .PC_in_IFID  (PC_out_IF),
      .inst_in_IFID(inst_IF),

      .PC_out_IFID  (PC_out_IFID),
      .inst_out_IFID(inst_out_IFID)
   );


   wire [ 4:0] Rd_addr_out_ID;
   wire [31:0] Rs1_out_ID;
   wire [31:0] Rs2_out_ID;
   wire [31:0] Imm_out_ID;
   wire        ALUSrc_B_ID;
   wire        Branch_ID;
   wire        BranchN_ID;
   wire        MemRW_ID;
   wire        Jump_ID;
   wire        RegWrite_out_ID;
   wire [ 3:0] ALU_control_ID;
   wire [ 1:0] MemtoReg_ID;
   Pipeline_ID Instruction_Decoder (
`ifdef SIM
      .debug_in_ID (debug_out_IFID),
      .debug_out_ID(debug_out_ID),
`endif

      .clk_ID         (clk),
      .rst_ID         (rst),
      .RegWrite_in_ID (RegWrite_out_MemWB),
      .Rd_addr_ID     (Rd_addr_out_MemWB),
      .Wt_data_ID     (Data_out_WB),
      .Inst_in_ID     (inst_out_IFID),
      .Rd_addr_out_ID (Rd_addr_out_ID),
      .Rs1_out_ID     (Rs1_out_ID),
      .Rs2_out_ID     (Rs2_out_ID),
      .Imm_out_ID     (Imm_out_ID),
      .ALUSrc_B_ID    (ALUSrc_B_ID),
      .ALU_control_ID (ALU_control_ID),
      .Branch_ID      (Branch_ID),
      .BranchN_ID     (BranchN_ID),
      .MemRW_ID       (MemRW_ID),
      .Jump_ID        (Jump_ID),
      .MemtoReg_ID    (MemtoReg_ID),
      .RegWrite_out_ID(RegWrite_out_ID),
      .regs           (regs)
   );

   wire [31:0] PC_out_IDEX;
   wire [31:0] Rs1_out_IDEX;
   wire [31:0] Rs2_out_IDEX;
   wire [31:0] Imm_out_IDEX;
   wire [ 4:0] Rd_addr_out_IDEX;
   wire [ 3:0] ALU_control_out_IDEX;
   wire [ 1:0] MemtoReg_out_IDEX;
   wire        ALUSrc_B_out_IDEX;
   wire        Branch_out_IDEX;
   wire        BranchN_out_IDEX;
   wire        MemRW_out_IDEX;
   wire        Jump_out_IDEX;
   wire        RegWrite_out_IDEX;
   ID_reg_Ex ID_reg_Ex (
`ifdef SIM
      .debug_in_IDEX (debug_out_ID),
      .debug_out_IDEX(debug_out_IDEX),
`endif

      .clk_IDEX           (clk),
      .rst_IDEX           (rst),
      .en_IDEX            (1'b1),
      .PC_in_IDEX         (PC_out_IFID),
      .Rd_addr_IDEX       (Rd_addr_out_ID),
      .Rs1_in_IDEX        (Rs1_out_ID),
      .Rs2_in_IDEX        (Rs2_out_ID),
      .Imm_in_IDEX        (Imm_out_ID),
      .ALUSrc_B_in_IDEX   (ALUSrc_B_ID),
      .ALU_control_in_IDEX(ALU_control_ID),
      .Branch_in_IDEX     (Branch_ID),
      .BranchN_in_IDEX    (BranchN_ID),
      .MemRW_in_IDEX      (MemRW_ID),
      .Jump_in_IDEX       (Jump_ID),
      .MemtoReg_in_IDEX   (MemtoReg_ID),
      .RegWrite_in_IDEX   (RegWrite_out_ID),

      .PC_out_IDEX         (PC_out_IDEX),
      .Rd_addr_out_IDEX    (Rd_addr_out_IDEX),
      .Rs1_out_IDEX        (Rs1_out_IDEX),
      .Rs2_out_IDEX        (Rs2_out_IDEX),
      .Imm_out_IDEX        (Imm_out_IDEX),
      .ALUSrc_B_out_IDEX   (ALUSrc_B_out_IDEX),
      .ALU_control_out_IDEX(ALU_control_out_IDEX),
      .Branch_out_IDEX     (Branch_out_IDEX),
      .BranchN_out_IDEX    (BranchN_out_IDEX),
      .MemRW_out_IDEX      (MemRW_out_IDEX),
      .Jump_out_IDEX       (Jump_out_IDEX),
      .MemtoReg_out_IDEX   (MemtoReg_out_IDEX),
      .RegWrite_out_IDEX   (RegWrite_out_IDEX)
   );


   wire [31:0] PC4_out_EX;
   wire [31:0] ALU_out_EX;
   wire [31:0] Rs2_out_EX;
   wire        zero_out_EX;
   Pipeline_EX Execute (
`ifdef SIM
      .debug_in_EX (debug_out_IDEX),
      .debug_out_EX(debug_out_EX),
`endif

      .PC_in_EX         (PC_out_IDEX),
      .Rs1_in_EX        (Rs1_out_IDEX),
      .Rs2_in_EX        (Rs2_out_IDEX),
      .Imm_in_EX        (Imm_out_IDEX),
      .ALUSrc_B_in_EX   (ALUSrc_B_out_IDEX),
      .ALU_control_in_EX(ALU_control_out_IDEX),

      .PC_out_EX  (PC_out_EX),
      .PC4_out_EX (PC4_out_EX),
      .zero_out_EX(zero_out_EX),
      .ALU_out_EX (ALU_out_EX),
      .Rs2_out_EX (Rs2_out_EX)
   );


   wire [31:0] PC_out_EXMem;
   wire [31:0] PC4_out_EXMem;
   wire [31:0] ALU_out_EXMem;
   wire [31:0] Rs2_out_EXMem;
   wire [ 4:0] Rd_addr_out_EXMem;
   wire [ 1:0] MemtoReg_out_EXMem;
   wire        zero_out_EXMem;
   wire        Branch_out_EXMem;
   wire        BranchN_out_EXMem;
   wire        MemRW_out_EXMem;
   wire        Jump_out_EXMem;
   wire        RegWrite_out_EXMem;
   Ex_reg_Mem Ex_reg_Mem (
`ifdef SIM
      .debug_in_EXMem (debug_out_EX),
      .debug_out_EXMem(debug_out_EXMem),
`endif

      .clk_EXMem        (clk),
      .rst_EXMem        (rst),
      .en_EXMem         (1'b1),
      .PC_in_EXMem      (PC_out_EX),
      .PC4_in_EXMem     (PC4_out_EX),
      .Rd_addr_EXMem    (Rd_addr_out_IDEX),
      .zero_in_EXMem    (zero_out_EX),
      .ALU_in_EXMem     (ALU_out_EX),
      .Rs2_in_EXMem     (Rs2_out_EX),
      .Branch_in_EXMem  (Branch_out_IDEX),
      .BranchN_in_EXMem (BranchN_out_IDEX),
      .MemRW_in_EXMem   (MemRW_out_IDEX),
      .Jump_in_EXMem    (Jump_out_IDEX),
      .MemtoReg_in_EXMem(MemtoReg_out_IDEX),
      .RegWrite_in_EXMem(RegWrite_out_IDEX),

      .PC_out_EXMem      (PC_out_EXMem),
      .PC4_out_EXMem     (PC4_out_EXMem),
      .Rd_addr_out_EXMem (Rd_addr_out_EXMem),
      .zero_out_EXMem    (zero_out_EXMem),
      .ALU_out_EXMem     (ALU_out_EXMem),
      .Rs2_out_EXMem     (Rs2_out_EXMem),
      .Branch_out_EXMem  (Branch_out_EXMem),
      .BranchN_out_EXMem (BranchN_out_EXMem),
      .MemRW_out_EXMem   (MemRW_out_EXMem),
      .Jump_out_EXMem    (Jump_out_EXMem),
      .MemtoReg_out_EXMem(MemtoReg_out_EXMem),
      .RegWrite_out_EXMem(RegWrite_out_EXMem)
   );


   wire PCSrc_out_Mem;
   Pipeline_Mem Memory_Access (
`ifdef SIM
      .debug_in_Mem (debug_out_EX),
      .debug_out_Mem(debug_out_Mem),
`endif

      .zero_in_Mem   (zero_out_EXMem),
      .Branch_in_Mem (Branch_out_EXMem),
      .BranchN_in_Mem(BranchN_out_EXMem),
      .Jump_in_Mem   (Jump_out_EXMem),
      .PCSrc_out_Mem (PCSrc_out_Mem)
   );


   wire [31:0] PC4_out_MemWB;
   wire [31:0] ALU_out_MemWB;
   wire [31:0] DMem_data_out_MemWB;
   wire [ 4:0] Rd_addr_out_MemWB;
   wire [ 1:0] MemtoReg_out_MemWB;
   wire        RegWrite_out_MemWB;
   Mem_reg_WB Mem_reg_WB (
`ifdef SIM
      .debug_in_MemWB (debug_out_Mem),
      .debug_out_MemWB(debug_out_MemWB),
`endif

      .clk_MemWB        (clk),
      .rst_MemWB        (rst),
      .en_MemWB         (1'b1),
      .PC4_in_MemWB     (PC4_out_EXMem),
      .Rd_addr_MemWB    (Rd_addr_out_EXMem),
      .ALU_in_MemWB     (ALU_out_EXMem),
      .DMem_data_MemWB  (Data_in),
      .MemtoReg_in_MemWB(MemtoReg_out_EXMem),
      .RegWrite_in_MemWB(RegWrite_out_EXMem),

      .PC4_out_MemWB      (PC4_out_MemWB),
      .Rd_addr_out_MemWB  (Rd_addr_out_MemWB),
      .ALU_out_MemWB      (ALU_out_MemWB),
      .DMem_data_out_MemWB(DMem_data_out_MemWB),
      .MemtoReg_out_MemWB (MemtoReg_out_MemWB),
      .RegWrite_out_MemWB (RegWrite_out_MemWB)
   );


   Pipeline_WB Write_Back (
`ifdef SIM
      .debug_in_WB (debug_out_MemWB),
      .debug_out_WB(debug_out_WB),
`endif

      .PC4_in_WB     (PC4_out_MemWB),
      .ALU_in_WB     (ALU_out_MemWB),
      .DMem_data_WB  (DMem_data_out_MemWB),
      .MemtoReg_in_WB(MemtoReg_out_MemWB),
      .Data_out_WB   (Data_out_WB)
   );

   assign PC_out_ID = PC_out_IFID;
   assign inst_ID   = inst_out_IFID;
   assign Addr_out  = ALU_out_EXMem;
   assign Data_out  = Rs2_out_EXMem;
   assign MemRW_Mem = MemRW_out_EXMem;
endmodule
