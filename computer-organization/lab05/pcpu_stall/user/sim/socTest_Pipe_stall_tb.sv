import pcpu::*;

module socTest_Pipe_stall_tb ();
   reg clk;
   reg rst;

   socTest_Pipe_stall m0 (
      .clk(clk),
      .rst(rst)
   );

   initial begin
`ifdef SIM
      log_reset();
      log_msg("sim", "Start Simulation!");
`endif

      clk = 1'b0;
      rst = 1'b1;
      #5;
      rst = 1'b0;
   end

   always #5 clk = ~clk;
endmodule
