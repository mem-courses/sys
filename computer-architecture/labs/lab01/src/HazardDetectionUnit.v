`timescale 1ps / 1ps

module HazardDetectionUnit (
   input        clk,
   input        Branch_ID,
   rs1use_ID,
   rs2use_ID,
   input  [1:0] hazard_optype_ID,
   input  [4:0] rd_EXE,
   rd_MEM,
   rs1_ID,
   rs2_ID,
   rs2_EXE,
   output       PC_EN_IF,
   reg_FD_EN,
   reg_FD_stall,
   reg_FD_flush,
   reg_DE_EN,
   reg_DE_flush,
   reg_EM_EN,
   reg_EM_flush,
   reg_MW_EN,
   output       forward_ctrl_ls,
   output [1:0] forward_ctrl_A,
   forward_ctrl_B
);
   //according to the diagram, design the Hazard Detection Unit
   reg [1:0] hazard_optype_EXE, hazard_optype_MEM;
   always @(posedge clk) begin
      hazard_optype_EXE <= hazard_optype_ID;
      hazard_optype_MEM <= hazard_optype_EXE;
   end
   assign reg_FD_EN = 1;
   assign reg_DE_EN = 1;
   assign reg_EM_EN = 1;
   assign reg_MW_EN = 1;
   assign PC_EN_IF = ~reg_FD_stall;
   assign reg_FD_stall = hazard_optype_EXE == 2'b10 & (rd_EXE == rs1_ID & rs1use_ID & rs1_ID != 0 | rd_EXE == rs2_ID & rs2use_ID & rs2_ID != 0 & hazard_optype_ID != 2'b11);
   assign reg_DE_flush = reg_FD_stall;
   assign reg_FD_flush = Branch_ID;
   assign forward_ctrl_A = {2{rs1use_ID & rs1_ID != 0}} & {rd_EXE == rs1_ID & hazard_optype_EXE == 2'b01 ? 2'b01 :
                                                            rd_MEM == rs1_ID & hazard_optype_MEM == 2'b01 ? 2'b10 :
                                                            rd_MEM == rs1_ID & hazard_optype_MEM == 2'b10 ? 2'b11 :
                                                            2'b00};
   assign forward_ctrl_B = {2{rs2use_ID & rs2_ID != 0}} & {rd_EXE == rs2_ID & hazard_optype_EXE == 2'b01 ? 2'b01 :
                                                            rd_MEM == rs2_ID & hazard_optype_MEM == 2'b01 ? 2'b10 :
                                                            rd_MEM == rs2_ID & hazard_optype_MEM == 2'b10 ? 2'b11 :
                                                            2'b00};
   assign forward_ctrl_ls = rs2_EXE != 0 & rs2_EXE == rd_MEM & hazard_optype_EXE == 2'b11 & hazard_optype_MEM == 2'b10;

endmodule
