`timescale 1ns / 1ps

module tb ();

   reg clk;
   reg rst;

   soc_test_wrapper u (
      .clk(clk),
      .rst(rst)
   );

   always #5 clk = ~clk;

   initial begin
      clk = 0;
      rst = 1;
      #1;
      rst = 0;
   end

endmodule
