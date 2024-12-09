import pcpu::*;

module IF_reg_ID_stall (
   output Debug_t debug_out_IFID,

   input        clk_IFID,      //寄存器时钟
   input        rst_IFID,      //寄存器复位
   input        en_IFID,       //寄存器使能
   input [31:0] PC_in_IFID,    //PC输入
   input [31:0] inst_in_IFID,  //指令输入
   input        NOP_IFID,      //插入NOP使能

   output reg [31:0] PC_out_IFID,    //PC输出
   output reg [31:0] inst_out_IFID,  //指令输出
   output reg        valid_IFID      //寄存器有效
);
   always_ff @(posedge clk_IFID) begin
      if (NOP_IFID) begin
         debug_out_IFID.PC   <= 32'b0;
         debug_out_IFID.inst <= 32'h00000013;
      end else begin
         debug_out_IFID.PC   <= PC_in_IFID;
         debug_out_IFID.inst <= inst_in_IFID;
      end
   end

   always_ff @(posedge clk_IFID or posedge rst_IFID) begin
      if (rst_IFID) begin
         PC_out_IFID   <= 32'b0;
         inst_out_IFID <= 32'b0;
         valid_IFID    <= 1'b0;
      end else if (en_IFID) begin
         if (NOP_IFID) begin
            PC_out_IFID   <= 1'b0;
            inst_out_IFID <= 32'h00000013;
            valid_IFID    <= 1'b0; //NOP指令不更新寄存器
         end else begin
            PC_out_IFID   <= PC_in_IFID;
            inst_out_IFID <= inst_in_IFID;
            valid_IFID    <= 1'b1;
         end
      end
   end
endmodule
