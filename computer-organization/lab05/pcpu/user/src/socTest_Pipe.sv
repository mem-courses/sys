import pcpu::*;

module socTest_Pipe (
   input clk,
   input rst
);

   wire [31:0] spo_ROM;
   wire [31:0] spo_RAM;

   wire        MemRW_Ex;
   wire        MemRW_Mem;
   wire [31:0] PC_out_ID;
   wire [31:0] PC_out_IF;
   wire [31:0] inst_ID;
   wire [31:0] PC_out_Ex;
   wire [31:0] Addr_out;
   wire [31:0] Data_out;
   wire [31:0] Data_out_WB;

   always @(0);
   RV32_Regs_t regs;

   Pipeline_CPU U1 (
      .clk        (clk),
      .rst        (rst),
      .inst_IF    (spo_ROM),
      .Data_in    (spo_RAM),
      .PC_out_IF  (PC_out_IF),
      .PC_out_ID  (PC_out_ID),
      .inst_ID    (inst_ID),
      .PC_out_EX  (PC_out_Ex),
      .MemRW_EX   (MemRW_Ex),
      .MemRW_Mem  (MemRW_Mem),
      .Addr_out   (Addr_out),
      .Data_out   (Data_out),
      .Data_out_WB(Data_out_WB),

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
      .wea  (MemRW_Ex),
      .addra(Addr_out[11:2]),
      .dina (Data_out),
      .douta(spo_RAM)
   );
   always @(posedge clk) begin
      if (MemRW_Ex) begin
         $display("[mem] write with => Addr_out: %h, Data_out: %h", Addr_out, Data_out);
      end
   end

endmodule

