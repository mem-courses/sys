`timescale 1ns / 1ps

module srl32 (
   A,
   B,
   res
);
   input [31:0] A;
   input [4:0] B;
   output reg [31:0] res;
   wire [31:0] tt;
   assign tt = 32'b0;
   always @* begin
      case (B)
         5'b00000: res = A[31:0];
         5'b00001: res = {tt[31:31], A[31:1]};
         5'b00010: res = {tt[31:30], A[31:2]};
         5'b00011: res = {tt[31:29], A[31:3]};
         5'b00100: res = {tt[31:28], A[31:4]};
         5'b00101: res = {tt[31:27], A[31:5]};
         5'b00110: res = {tt[31:26], A[31:6]};
         5'b00111: res = {tt[31:25], A[31:7]};
         5'b01000: res = {tt[31:24], A[31:8]};
         5'b01001: res = {tt[31:23], A[31:9]};
         5'b01010: res = {tt[31:22], A[31:10]};
         5'b01011: res = {tt[31:21], A[31:11]};
         5'b01100: res = {tt[31:20], A[31:12]};
         5'b01101: res = {tt[31:19], A[31:13]};
         5'b01110: res = {tt[31:18], A[31:14]};
         5'b01111: res = {tt[31:17], A[31:15]};
         5'b10000: res = {tt[31:16], A[31:16]};
         5'b10001: res = {tt[31:15], A[31:17]};
         5'b10010: res = {tt[31:14], A[31:18]};
         5'b10011: res = {tt[31:13], A[31:19]};
         5'b10100: res = {tt[31:12], A[31:20]};
         5'b10101: res = {tt[31:11], A[31:21]};
         5'b10110: res = {tt[31:10], A[31:22]};
         5'b10111: res = {tt[31:9], A[31:23]};
         5'b11000: res = {tt[31:8], A[31:24]};
         5'b11001: res = {tt[31:7], A[31:25]};
         5'b11010: res = {tt[31:6], A[31:26]};
         5'b11011: res = {tt[31:5], A[31:27]};
         5'b11100: res = {tt[31:4], A[31:28]};
         5'b11101: res = {tt[31:3], A[31:29]};
         5'b11110: res = {tt[31:2], A[31:30]};
         5'b11111: res = {tt[31:1], A[31:31]};
      endcase
   end
endmodule
