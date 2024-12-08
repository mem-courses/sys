import pcpu::*;

module Pipeline_WB (
`ifdef SIM
   input  Debug_t debug_in_WB,
   output Debug_t debug_out_WB,
`endif

   input [31:0] PC4_in_WB,
   input [31:0] ALU_in_WB,
   input [31:0] DMem_data_WB,
   input [ 1:0] MemtoReg_in_WB,

   output [31:0] Data_out_WB
);
`ifdef SIM
   assign debug_out_WB = debug_in_WB;
`endif

   MUX4T1_32 MUX4T1_32_U0 (
      .s (MemtoReg_in_WB),
      .I0(ALU_in_WB),
      .I1(DMem_data_WB),
      .I2(PC4_in_WB),
      .I3(PC4_in_WB),
      .o (Data_out_WB)
   );
endmodule
