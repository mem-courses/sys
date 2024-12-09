module Mem_reg_WB_stall (
   input  Debug_t debug_in_MemWB,
   output Debug_t debug_out_MemWB,

   input        clk_MemWB,
   input        rst_MemWB,
   input        en_MemWB,
   input [31:0] PC4_in_MemWB,
   input [ 4:0] Rd_addr_MemWB,
   input [31:0] ALU_in_MemWB,
   input [31:0] DMem_data_in_MemWB,
   input [ 1:0] MemtoReg_in_MemWB,
   input        RegWrite_in_MemWB,
   input        valid_in_MemWB,      //有效

   output reg        valid_out_MemWB,      //有效
   output reg [31:0] PC4_out_MemWB,
   output reg [ 4:0] Rd_addr_out_MemWB,
   output reg [31:0] ALU_out_MemWB,
   output reg [31:0] DMem_data_out_MemWB,
   output reg [ 1:0] MemtoReg_out_MemWB,
   output reg        RegWrite_out_MemWB
);
   always_ff @(posedge clk_MemWB) begin
      debug_out_MemWB <= debug_in_MemWB;
      if (RegWrite_in_MemWB) begin
         log_data("WB", "ALU_res", ALU_in_MemWB, debug_in_MemWB);
         log_data("WB", "Mem_Data", DMem_data_in_MemWB, debug_in_MemWB);
      end
   end

   always_ff @(posedge clk_MemWB or posedge rst_MemWB)
      if (rst_MemWB) begin
         valid_out_MemWB <= 1'b0;
         PC4_out_MemWB <= 32'b0;
         Rd_addr_out_MemWB <= 5'b0;
         ALU_out_MemWB <= 32'b0;
         DMem_data_out_MemWB <= 32'b0;
         MemtoReg_out_MemWB <= 2'b0;
         RegWrite_out_MemWB <= 1'b0;
      end else if (en_MemWB) begin
         valid_out_MemWB <= valid_in_MemWB;
         PC4_out_MemWB <= PC4_in_MemWB;
         Rd_addr_out_MemWB <= Rd_addr_MemWB;
         ALU_out_MemWB <= ALU_in_MemWB;
         DMem_data_out_MemWB <= DMem_data_in_MemWB;
         MemtoReg_out_MemWB <= MemtoReg_in_MemWB;
         RegWrite_out_MemWB <= RegWrite_in_MemWB;
      end
endmodule
