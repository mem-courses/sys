`timescale 1ns / 1ps

module float_add (
   input             clk,
   input             rst,
   input      [31:0] A,
   input      [31:0] B,
   input      [ 1:0] c,       // 00 +, 01 -, 10 *, 11 /
   input             en,      // en = 1, begin
   output reg [31:0] result,
   output reg        fin      // fin = 1 when finish
);

   reg [8:0] diff_e;
   reg [7:0] a_e, b_e, result_e;
   reg [26:0] a_m, b_m, result_m;

   wire a_sign, b_sign;
   assign a_sign = A[31];
   assign b_sign = B[31];


   always @(posedge en or posedge rst) begin
      if (rst) begin
         diff_e   <= 0;
         a_e      <= 0;
         b_e      <= 0;
         result_e <= 0;
         a_m      <= 0;
         b_m      <= 0;
         result_m <= 0;
         fin      <= 0;

      end else begin
         fin = 0;
         if (c == 2'b00) begin  // must be true
            if (A == 0) begin
               result = B;
               fin    = 1;
            end else if (B == 0) begin
               result = A;
               fin    = 1;
            end else begin

               a_e = A[30:23];
               b_e = B[30:23];
               $display("a_e = %b, b_e = %b", a_e, b_e);

               // de-normalize A
               a_m = {A[22:0], 4'b0000};
               $display("a_m = %b, a_e = %b (pre)", a_m, a_e);
               if (a_e == 0) begin
                  a_m = a_m >> 1;
               end else if (a_e < 8'b11111111) begin
                  a_m = {1'b0, 1'b1, a_m[26:2]};
                  a_e = a_e - 1;
               end
               if (a_sign == 0) begin
                  a_m = a_m >> 1;
               end else begin
                  a_m = ~a_m + 1;
                  a_m = $signed(a_m) >>> 1;
               end
               $display("a_m = %b, a_e = %b (after)", a_m, a_e);

               // de-normalize B
               b_m = {B[22:0], 4'b0000};
               $display("b_m = %b, b_e = %b (pre)", b_m, b_e);
               if (b_e == 0) begin
                  b_m = b_m >> 1;
               end else if (b_e < 8'b11111111) begin
                  b_m = {1'b0, 1'b1, b_m[26:2]};
                  b_e = b_e - 1;
               end
               if (b_sign == 0) begin
                  b_m = b_m >> 1;
               end else begin
                  b_m = ~b_m + 1;
                  b_m = $signed(b_m) >>> 1;
               end
               $display("b_m = %b, b_e = %b (after)", b_m, b_e);

               // calculate
               diff_e = b_e - a_e;
               $display("diff_e = %b", diff_e);
               if (diff_e[8] == 0) begin
                  a_m = $signed(a_m) >> diff_e;
                  result_e = b_e;
               end else begin
                  diff_e = a_e - b_e;
                  b_m = $signed(b_m) >> diff_e;
                  result_e = a_e;
               end
               result_m = a_m + b_m;
               $display("result_m = %b (%d), result_e = %b", result_m, result_m, result_e);

               // normalize
               if ((result_m[26] ^ result_m[25]) == 1) begin
                  result_m = $signed(result_m) >>> 1;
               end else if (result_m[26:24] == 3'b000) begin
                  while (result_m[26:24] != 3'b001) begin
                     result_m = result_m << 1;
                     result_e = result_e - 1;
                  end
               end else if (result_m[26:24] == 3'b111) begin
                  while (result_m[26:24] != 3'b110) begin
                     result_m = result_m << 1;
                     result_e = result_e - 1;
                  end
               end
               result_e = result_e + 1;
               $display("result_m = %b (%d), result_e = %b", result_m, result_m, result_e);
               if (result_e >= 0 && result_e < 8'b11111110) begin
                  result_e = result_e + 1;
                  result[31] = result_m[26];
                  result[30:23] = result_e;
                  if (result[31]) begin  // signal
                     result[22:0] = ~result_m[23:1] + 1;
                  end else begin
                     result[22:0] = result_m[23:1];
                  end
               end
               $display("result_m = %b (%d), result_e = %b", result_m, result_m, result_e);

               // finish
               fin = 1;
            end

         end else begin
            // undefined
            fin = 1;
         end
      end
   end
endmodule
