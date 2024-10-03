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

endmodule
