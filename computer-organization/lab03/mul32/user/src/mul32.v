`timescale 1ns / 1ps

module mul32 (
   input clk,
   input rst,
   input [31:0] multiplicand,
   input [31:0] multiplier,
   input start,
   output [63:0] product,
   output finish
);

   reg [63:0] tmp;
   reg [ 5:0] cnt;

   always @(posedge start) begin
      cnt = 6'b100000;
      tmp = {33'b0, multiplier};
   end

   wire [31:0] sum;
   wire carry;
   add32 add32_v (
      .a(tmp[63:32]),
      .b(multiplicand),
      .c(carry),
      .s(sum)
   );

   always @(posedge clk or posedge rst) begin
      if (rst == 1) begin
         tmp <= 64'b0;
         cnt <= 6'b0;
      end else if (cnt > 0) begin
         if (tmp[0] == 1) begin
            tmp <= {carry, sum, tmp[31:1]};
         end else begin
            tmp <= tmp >> 1;
         end
         cnt <= cnt - 1;
      end
   end

   assign finish  = (cnt == 0);
   assign product = tmp;
endmodule
