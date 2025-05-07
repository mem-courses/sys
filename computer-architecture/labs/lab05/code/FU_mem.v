`timescale 1ns / 1ps

module FU_mem (
   input         clk,
   EN,
   mem_w,
   input  [ 2:0] bhw,
   input  [31:0] rs1_data,
   rs2_data,
   imm,
   output [31:0] mem_data,
   output        finish
);

   reg [1:0] state;
   assign finish = state[0] == 1'b1;
   initial begin
      state = 0;
   end

   reg mem_w_reg;
   reg [2:0] bhw_reg;
   reg [31:0] rs1_data_reg, rs2_data_reg, imm_reg;

   //to fill sth.in
   always @(posedge clk) begin
      if (state == 2'd0) begin
         if (EN) begin
            state <= 2'd2;
            mem_w_reg <= mem_w;
            bhw_reg <= bhw;
            rs1_data_reg <= rs1_data;
            rs2_data_reg <= rs2_data;
            imm_reg <= imm;
         end
      end else if (state == 2'd2) state <= 2'd1;
      else state <= 2'd0;
   end

   wire [31:0] addr = rs1_data_reg + imm_reg;

   RAM_B ram (
      .clka       (clk),
      .addra      (addr),
      .dina       (rs2_data_reg),
      .wea        (mem_w_reg),
      .douta      (mem_data),
      .mem_u_b_h_w(bhw_reg)
   );

endmodule
