`timescale 1ns / 1ps

module CSSTE_tb ();
   reg clk_100mhz;
   reg RSTN;
   reg [3:0] BTN_y;
   reg [15:0] SW;

   CSSTE csste_inst (
      .clk_100mhz(clk_100mhz),
      .RSTN(RSTN),
      .BTN_y(BTN_y),
      .SW(SW),
      .Blue(),
      .Green(),
      .Red(),
      .HSYNC(),
      .VSYNC(),
      .LED_out(),
      .AN(),
      .segment()
   );

   always #5 clk_100mhz = ~clk_100mhz;

   initial begin
      $display("Testing CSSTE...");

      clk_100mhz = 0;
      RSTN = 0;
      BTN_y = 0;
      SW = 0;

      SW[7:5] = 3'b111;  // 7段数码管显示PC_out
      // SW[8] = 1'b0 ;  // 全速运行

      #100000;
      RSTN = 1;

      #100;
      $display("Testing CSSTE Done.");
      $finish;
   end

endmodule
