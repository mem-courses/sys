`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/09/27 10:47:23
// Design Name: 
// Module Name: MUX8t1_32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MUX8t1_32 (
   I0,
   I1,
   I2,
   I3,
   I4,
   I5,
   I6,
   I7,
   ch,
   res
);
   input [31:0] I0, I1, I2, I3, I4, I5, I6, I7;
   input [2:0] ch;
   output [31:0] res;
   assign res = (ch[2] == 0 ? (ch[1] == 0 ? (ch[0] == 0 ? I0 : I1) : (ch[0] == 0 ? I2 : I3)) : (ch[1] == 0 ? (ch[0] == 0 ? I4 : I5) : (ch[0] == 0 ? I6 : I7)));
endmodule
