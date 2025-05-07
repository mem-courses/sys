`timescale 1ns / 1ps

module FU_mul (
   input         clk,
   EN,
   input  [31:0] A,
   B,
   output [31:0] res,
   output        finish
);

   reg [6:0] state;
   assign finish = state[0] == 1'b1;
   initial begin
      state = 0;
   end

   reg [31:0] A_reg, B_reg;
   wire [63:0] mulres;

   //to fill sth.in
   always @(posedge clk) begin
      if (EN & state == 0) begin
         state <= 7'b1000000;
         A_reg <= A;
         B_reg <= B;
      end else state <= state >> 1;
   end

   multiplier mul (
      .CLK(clk),
      .A  (A_reg),
      .B  (B_reg),
      .P  (mulres)
   );

   assign res = mulres[31:0];

endmodule
