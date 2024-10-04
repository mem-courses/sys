`timescale 1ns / 1ps

module div32 (
   input clk,
   input rst,
   input start,
   input [31:0] dividend,
   input [31:0] divisor,
   output finish,
   output [31:0] quotient,
   output [31:0] remainder
);

   reg [63:0] tmp;
   reg [ 5:0] cnt;

   always @(posedge start) begin
      tmp <= {31'b0, dividend, 1'b0};
      cnt <= 6'b100000;
   end

   wire [31:0] diff;
   sub32_nocarry sub32_nocarry_v (
      .a(tmp[63:32]),
      .b(divisor),
      .s(diff)
   );

   always @(posedge clk or posedge rst) begin
      if (rst == 1) begin
         tmp <= 64'b0;
         cnt <= 6'b0;
      end else if (cnt > 0) begin
         if (tmp[63:32] >= divisor) begin
            tmp <= {diff[30:0], tmp[31:0], 1'b1};
         end else begin
            tmp <= {tmp[62:0], 1'b0};
         end
         cnt <= cnt - 1;
      end
   end

   assign finish    = (cnt == 0);
   assign quotient  = tmp[31:0];
   assign remainder = {1'b0, tmp[63:33]};
endmodule
