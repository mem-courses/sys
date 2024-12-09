module Stall_ctrl (
   input       rst_stall,           //复位
   input       RegWrite_out_IDEX,   //执行阶段寄存器写控制
   input [4:0] Rd_addr_out_IDEX,    //执行阶段寄存器写地址
   input       RegWrite_out_EXMem,  //访存阶段寄存器写控制
   input [4:0] Rd_addr_out_EXMem,   //访存阶段寄存器写地址
   input [4:0] Rs1_addr_ID,         //译码阶段寄存器读地址1
   input [4:0] Rs2_addr_ID,         //译码阶段寄存器读地址2
   input       Rs1_used,            //Rs1被使用
   input       Rs2_used,            //Rs2被使用
   input       Branch_ID,           //译码阶段beq
   input       BranchN_ID,          //译码阶段bne
   input       Jump_ID,             //译码阶段jal
   input       Branch_out_IDEX,     //执行阶段beq
   input       BranchN_out_IDEX,    //执行阶段bne
   input       Jump_out_IDEX,       //执行阶段jal
   input       Branch_out_EXMem,    //访存阶段beq
   input       BranchN_out_EXMem,   //访存阶段bne
   input       Jump_out_EXMem,      //访存阶段jal

   output en_IF,     //流水线寄存器的使能及NOP信号
   output en_IFID,
   output NOP_IFID,
   output NOP_IDEx
);

   wire Data_stall;
   wire Control_stall;

   assign Data_stall = ((RegWrite_out_IDEX==1 && Rs1_used==1) && (Rs1_addr_ID!=5'b0) && (Rd_addr_out_IDEX == Rs1_addr_ID))
                        || ( (RegWrite_out_IDEX==1 && Rs2_used==1) && (Rs2_addr_ID!=5'b0) && (Rd_addr_out_IDEX == Rs2_addr_ID))
                        || ((RegWrite_out_EXMem==1 && Rs1_used==1) && (Rs1_addr_ID!=5'b0) && (Rd_addr_out_EXMem == Rs1_addr_ID))
                        || ( (RegWrite_out_EXMem==1 && Rs2_used==1) && (Rs2_addr_ID!=5'b0) && (Rd_addr_out_EXMem == Rs2_addr_ID));



   assign Control_stall = (Branch_ID || BranchN_ID || Jump_ID) || (Branch_out_IDEX || BranchN_out_IDEX || Jump_out_IDEX) || (Branch_out_EXMem || BranchN_out_EXMem || Jump_out_EXMem);

   //    assign Control_stall =  (Branch_out_IDEX || BranchN_out_IDEX || Jump_out_IDEX)
   //                            || (Branch_out_EXMem || BranchN_out_EXMem || Jump_out_EXMem);
   //    assign Control_stall = 0;


   //    assign en_IF = (!Data_stall)  && (!Control_stall);
   //    assign en_IFID = (!Data_stall)  && (!Control_stall);
   //    assign NOP_IDEX = (Data_stall) || (Control_stall);
   //    assign NOP_IFID = (Control_stall);

   always @(*) begin
      if ((Jump_out_EXMem || Branch_out_EXMem || BranchN_out_EXMem) && PCSrc) en_IF = (!Data_stall);
      else en_IF = (!Data_stall) && (!Control_stall);
      en_IFID  = (!Data_stall);
      NOP_IDEX = (Data_stall);
      NOP_IFID = (Control_stall);
   end

endmodule
