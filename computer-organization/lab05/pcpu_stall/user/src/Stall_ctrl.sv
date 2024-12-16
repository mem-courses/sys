module Stall_ctrl (
   input logic       rst_stall,           //复位
   input logic       RegWrite_out_IDEX,   //执行阶段寄存器写控制
   input logic [4:0] Rd_addr_out_IDEX,    //执行阶段寄存器写地址
   input logic       RegWrite_out_EXMem,  //访存阶段寄存器写控制
   input logic [4:0] Rd_addr_out_EXMem,   //访存阶段寄存器写地址
   input logic [4:0] Rs1_addr_ID,         //译码阶段寄存器读地址1
   input logic [4:0] Rs2_addr_ID,         //译码阶段寄存器读地址2
   input logic       Rs1_used,            //Rs1被使用
   input logic       Rs2_used,            //Rs2被使用
   input logic       Branch_ID,           //译码阶段beq
   input logic       BranchN_ID,          //译码阶段bne
   input logic       Jump_ID,             //译码阶段jal
   input logic       Branch_out_IDEX,     //执行阶段beq
   input logic       BranchN_out_IDEX,    //执行阶段bne
   input logic       Jump_out_IDEX,       //执行阶段jal
   input logic       Branch_out_EXMem,    //访存阶段beq
   input logic       BranchN_out_EXMem,   //访存阶段bne
   input logic       Jump_out_EXMem,      //访存阶段jal

   output logic en_IF,     //流水线寄存器的使能及NOP信号
   output logic en_IFID,
   output logic NOP_IFID,
   output logic NOP_IDEX
);

   // 注意wire的值不光可能是0/1，还可以是X/Z
   // 这里为了避免输出是不定态，必须判断相应信号为1才进行
   // 下面判断时也应该使用===和!==
   localparam true = 1'b1;

   wire Data_stall;
   wire Control_stall;

   // 寄存器索引为0的情况会在Rs1_used/Rs2_used的条件中处理，所以不需要进行额外判断
   assign Data_stall = ((RegWrite_out_IDEX === true && Rs1_used === true && Rd_addr_out_IDEX == Rs1_addr_ID)  //
      || (RegWrite_out_IDEX === true && Rs2_used === true && Rd_addr_out_IDEX == Rs2_addr_ID)  //
      || (RegWrite_out_EXMem === true && Rs1_used === true && Rd_addr_out_EXMem == Rs1_addr_ID)  //
      || (RegWrite_out_EXMem === true && Rs2_used === true && Rd_addr_out_EXMem == Rs2_addr_ID));

   assign Control_stall = (Branch_ID === true || BranchN_ID === true || Jump_ID === true)  // 
      || (Branch_out_IDEX === true || BranchN_out_IDEX === true || Jump_out_IDEX === true)  //
      || (Branch_out_EXMem === true || BranchN_out_EXMem === true || Jump_out_EXMem === true);

   assign en_IF = Data_stall !== true && Control_stall !== true;
   assign en_IFID = Data_stall !== true;
   assign NOP_IFID = Control_stall === true;
   assign NOP_IDEX = Data_stall === true;

endmodule
