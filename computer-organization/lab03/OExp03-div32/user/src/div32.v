`timescale 1ns / 1ps

module div32 (
   input clk,
   input rst,

   input    start,
   input    [31:0] dividend,
   input    [31:0] divisor,

   output    finish,
   output    [31:0] quotient,
   output    [31:0] remainder
);


endmodule

