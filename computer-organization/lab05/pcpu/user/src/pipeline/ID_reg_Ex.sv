import pcpu::*;

module ID_reg_Ex (
   input  Debug_t debug_in_IDEX,
   output Debug_t debug_out_IDEX,

   input wire        clk_IDEX,
   input wire        rst_IDEX,
   input wire        en_IDEX,
   input wire [31:0] PC_in_IDEX,
   input wire [ 4:0] Rd_addr_IDEX,
   input wire [31:0] Rs1_in_IDEX,
   input wire [31:0] Rs2_in_IDEX,
   input wire [31:0] Imm_in_IDEX,
   input wire        ALUSrc_B_in_IDEX,
   input wire [ 3:0] ALU_control_in_IDEX,
   input wire        Branch_in_IDEX,
   input wire        BranchN_in_IDEX,
   input wire        MemRW_in_IDEX,
   input wire        Jump_in_IDEX,
   input wire [ 1:0] MemtoReg_in_IDEX,
   input wire        RegWrite_in_IDEX,

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
   output reg        RegWrite_out_IDEX
);
   always @(posedge clk_IDEX) begin
      debug_out_IDEX <= debug_in_IDEX;
      log_data("EX", "Rs1", Rs1_in_IDEX, debug_in_IDEX);
      log_data("EX", "Rs2", Rs2_in_IDEX, debug_in_IDEX);
      log_data("EX", "Imm", Imm_in_IDEX, debug_in_IDEX);
      log_data("EX", "ALU_ctrl", ALU_control_in_IDEX, debug_in_IDEX);
   end

   always @(posedge clk_IDEX or posedge rst_IDEX) begin
      if (rst_IDEX) begin
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
endmodule

