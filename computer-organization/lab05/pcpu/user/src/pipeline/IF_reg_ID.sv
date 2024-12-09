import pcpu::*;

module IF_reg_ID (
   output Debug_t debug_out_IFID,

   input        clk_IFID,
   input        rst_IFID,
   input        en_IFID,
   input [31:0] PC_in_IFID,
   input [31:0] inst_in_IFID,

   output reg [31:0] PC_out_IFID,
   output reg [31:0] inst_out_IFID
);
   always_ff @(posedge clk_IFID) begin
      debug_out_IFID.PC   <= PC_in_IFID;
      debug_out_IFID.inst <= inst_in_IFID;
   end

   always_ff @(posedge clk_IFID or posedge rst_IFID) begin
      if (rst_IFID) begin
         PC_out_IFID   <= 32'b0;
         inst_out_IFID <= 32'b0;
      end else if (en_IFID) begin
         PC_out_IFID   <= PC_in_IFID;
         inst_out_IFID <= inst_in_IFID;
      end
   end
endmodule
