`timescale 1ns / 1ps

module REG32 (
   input clk,
   input rst,
   input CE,
   input [31:0] D,
   output reg [31:0] Q
);
   always @(posedge clk or posedge rst) begin
      if (rst == 1) Q <= 0;
      else if (CE) Q <= D;
   end
endmodule
