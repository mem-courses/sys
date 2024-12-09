import pcpu::*;

module ID_reg_EX_stall (
   input  Debug_t debug_in_IDEX,
   output Debug_t debug_out_IDEX,

   input        clk_IDEX,
   input        rst_IDEX,
   input        en_IDEX,
   input        NOP_IDEX,             //插入NOP使能
   input        valid_in_IDEX,        //有效
   input [31:0] PC_in_IDEX,
   input [ 4:0] Rd_addr_IDEX,
   input [31:0] Rs1_in_IDEX,
   input [31:0] Rs2_in_IDEX,
   input [31:0] Imm_in_IDEX,
   input        ALUSrc_B_in_IDEX,
   input [ 3:0] ALU_control_in_IDEX,
   input        Branch_in_IDEX,
   input        BranchN_in_IDEX,
   input        MemRW_in_IDEX,
   input        Jump_in_IDEX,
   input [ 1:0] MemtoReg_in_IDEX,
   input        RegWrite_in_IDEX,

   output reg [31:0] PC_out_IDEX,
   output reg [ 4:0] Rd_addr_out_IDEX,
   output reg [31:0] Rs1_out_IDEX,
   output reg [31:0] Rs2_out_IDEX,
   output reg [31:0] Imm_out_IDEX,
   output reg        ALUSrc_B_out_IDEX,
   output reg [ 3:0] ALU_control_out_IDEX,
   output reg        Branch_out_IDEX,
   output reg        BranchN_out_IDEX,
   output reg        MemRW_out_IDEX,
   output reg        Jump_out_IDEX,
   output reg [ 1:0] MemtoReg_out_IDEX,
   output reg        valid_out_IDEX,        //有效
   output reg        RegWrite_out_IDEX
);
   always_ff @(posedge clk_IDEX) begin
      if (NOP_IDEX) begin
         debug_out_IDEX.PC   <= 32'b0;
         debug_out_IDEX.inst <= 32'h00000013;
      end else begin
         debug_out_IDEX <= debug_in_IDEX;
      end
      log_data("EX", "Rs1", Rs1_in_IDEX, debug_in_IDEX);
      log_data("EX", "Rs2", Rs2_in_IDEX, debug_in_IDEX);
      log_data("EX", "Imm", Imm_in_IDEX, debug_in_IDEX);
      log_data("EX", "ALU_ctrl", ALU_control_in_IDEX, debug_in_IDEX);
   end

   always_ff @(posedge clk_IDEX or posedge rst_IDEX) begin
      if (rst_IDEX) begin
         valid_out_IDEX <= 1'b0;
         PC_out_IDEX <= 32'b0;
         Rd_addr_out_IDEX <= 5'b0;
         Rs1_out_IDEX <= 32'b0;
         Rs2_out_IDEX <= 32'b0;
         Imm_out_IDEX <= 32'b0;
         ALUSrc_B_out_IDEX <= 1'b0;
         ALU_control_out_IDEX <= 4'b0;
         Branch_out_IDEX <= 1'b0;
         BranchN_out_IDEX <= 1'b0;
         MemRW_out_IDEX <= 1'b0;
         Jump_out_IDEX <= 1'b0;
         MemtoReg_out_IDEX <= 2'b0;
         RegWrite_out_IDEX <= 1'b0;
      end else if (en_IDEX) begin
         if (NOP_IDEX) begin
            valid_out_IDEX <= 1'b0;
            PC_out_IDEX <= 32'b0;
            Rd_addr_out_IDEX <= 5'b0;
            Rs1_out_IDEX <= 32'b0;
            Rs2_out_IDEX <= 32'b0;
            Imm_out_IDEX <= 32'b0;
            ALUSrc_B_out_IDEX <= 1'b0;
            ALU_control_out_IDEX <= 4'b0;
            Branch_out_IDEX <= 1'b0;
            BranchN_out_IDEX <= 1'b0;
            MemRW_out_IDEX <= 1'b0;
            Jump_out_IDEX <= 1'b0;
            MemtoReg_out_IDEX <= 2'b0;
            RegWrite_out_IDEX <= 1'b0;
         end else begin
            valid_out_IDEX <= valid_in_IDEX;
            PC_out_IDEX <= PC_in_IDEX;
            Rd_addr_out_IDEX <= Rd_addr_IDEX;
            Rs1_out_IDEX <= Rs1_in_IDEX;
            Rs2_out_IDEX <= Rs2_in_IDEX;
            Imm_out_IDEX <= Imm_in_IDEX;
            ALUSrc_B_out_IDEX <= ALUSrc_B_in_IDEX;
            ALU_control_out_IDEX <= ALU_control_in_IDEX;
            Branch_out_IDEX <= Branch_in_IDEX;
            BranchN_out_IDEX <= BranchN_in_IDEX;
            MemRW_out_IDEX <= MemRW_in_IDEX;
            Jump_out_IDEX <= Jump_in_IDEX;
            MemtoReg_out_IDEX <= MemtoReg_in_IDEX;
            RegWrite_out_IDEX <= RegWrite_in_IDEX;
         end
      end
   end
endmodule

