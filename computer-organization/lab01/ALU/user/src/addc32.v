`timescale 1ns / 1ps

module addc32 (
   A,
   B,
   C0,
   res
);
   input [31:0] A, B;
   input C0;
   output [32:0] res;
   assign res = A + B + C0;
endmodule

