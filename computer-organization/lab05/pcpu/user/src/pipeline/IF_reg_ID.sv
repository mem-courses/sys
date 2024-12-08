import pcpu::*;

module IF_reg_ID (
`ifdef SIM
   output Debug_t debug_out_IFID,
`endif

   input wire        clk_IFID,
   input wire        rst_IFID,
   input wire        en_IFID,
   input wire [31:0] PC_in_IFID,
   input wire [31:0] inst_in_IFID,

   output reg [31:0] PC_out_IFID,
   output reg [31:0] inst_out_IFID
);
`ifdef SIM
   always @(posedge clk_IFID) begin
      debug_out_IFID.PC   <= PC_in_IFID;
      debug_out_IFID.inst <= inst_in_IFID;
   end
`endif

   always @(posedge clk_IFID or posedge rst_IFID) begin
      if (rst_IFID) begin
         PC_out_IFID   <= 32'b0;
         inst_out_IFID <= 32'b0;
      end else if (en_IFID) begin
         PC_out_IFID   <= PC_in_IFID;
         inst_out_IFID <= inst_in_IFID;
      end
   end
endmodule
