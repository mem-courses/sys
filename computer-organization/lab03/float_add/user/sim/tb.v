`timescale 1ns / 1ps

module tb;

   // Inputs
   reg clk;
   reg rst;
   reg [31:0] A;
   reg [31:0] B;
   reg [1:0] c;
   reg en;

   // Outputs
   wire [31:0] result;
   wire fin;


   // Instantiate the Unit Under Test (UUT)
   float_add add (
      .clk(clk),
      .rst(rst),
      .A(A),
      .B(B),
      .c(c),
      .en(en),
      .result(result),
      .fin(fin)
   );

   always #5 clk = ~clk;

   initial begin
      // Initialize Inputs
      clk = 0;
      rst = 1;
      A   = 32'hc0000000;
      B   = 32'hc0000000;
      c   = 2'b00;
      en  = 0;
      #10;
      rst = 0;
      A   = 32'hc0a00000;  //-5.0
      B   = 32'hc0900000;  //-4.5
      c   = 2'b00;  // +
      en  = 1;  // c1180000 (-9.5)
      #80;
      en = 0;
      #20;

      A  = 32'h40a00000;  //+5.0
      B  = 32'h40900000;  //+4.5
      en = 1;  //41180000 (+9.5)
      #80;
      en = 0;
      #20;

      A  = 32'hc0400000;  //-3.0
      B  = 32'hc0000000;  //-2.0
      en = 1;
      #80;
      en = 0;
      #20;

      A  = 32'hc0400000;  //-3.0
      B  = 32'h40000000;  //2.0
      en = 1;
      #80;
      en = 0;
      #100;
      $stop();
   end
endmodule

