import pcpu::*;

module socTest_Pipe_stall (
   input clk,
   input rst
);

   wire [31:0] spo_ROM;
   wire [31:0] spo_RAM;

   wire        MemRW_Mem;
   wire [31:0] PC_out_ID;
   wire [31:0] PC_out_IF;
   wire [31:0] inst_ID;
   wire [31:0] PC_out_EX;
   wire [31:0] Addr_out;
   wire [31:0] Data_out;
   wire [31:0] Data_out_WB;

   always @(0);  // this line is to make the formatter happy
   RV32_Regs_t   regs;
   VGA_Signals_t vga_signals;

   Pipeline_CPU_stall U1 (
      .clk      (clk),
      .rst      (rst),
      .Data_in  (spo_RAM),
      .inst_IF  (spo_ROM),
      .PC_out_IF(PC_out_IF),
      .MemRW_Mem(MemRW_Mem),
      .Addr_out (Addr_out),
      .Data_out (Data_out),

      .regs       (regs),
      .vga_signals(vga_signals)
   );

   // instruction memory
   ROM_D U2 (
      .a  (PC_out_ID[11:2]),
      .spo(spo_ROM)
   );

   // data memory
   RAM_B U3 (
      .clka (~clk),
      .wea  (MemRW_Mem),
      .addra(Addr_out[11:2]),
      .dina (Data_out),
      .douta(spo_RAM)
   );

endmodule
