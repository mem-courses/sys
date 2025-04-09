`timescale 1ns / 1ps

module ExceptionUnit (
   input         clk,
   rst,
   input         csr_rw_in,
   input  [ 1:0] csr_wsc_mode_in,
   input         csr_w_imm_mux,
   input  [11:0] csr_rw_addr_in,
   input  [31:0] csr_w_data_reg,
   input  [ 4:0] csr_w_data_imm,
   output [31:0] csr_r_data_out,

   input interrupt,
   input illegal_inst,
   input l_access_fault,
   input s_access_fault,
   input ecall_m,

   input mret,

   input  [31:0] epc_cur,
   input  [31:0] epc_next,
   output [31:0] PC_redirect,
   output        redirect_mux,

   output reg_FD_flush,
   reg_DE_flush,
   reg_EM_flush,
   reg_MW_flush,
   output RegWrite_cancel
);

   reg [11:0] csr_raddr, csr_waddr;
   reg [31:0] csr_wdata;
   reg csr_w;
   reg [1:0] csr_wsc;

   wire [31:0] mstatus;

   CSRRegs csr (
      .clk         (clk),
      .rst         (rst),
      .csr_w       (csr_w),
      .raddr       (csr_raddr),
      .waddr       (csr_waddr),
      .wdata       (csr_wdata),
      .rdata       (csr_r_data_out),
      .mstatus     (mstatus),
      .csr_wsc_mode(csr_wsc)
   );

   //According to the diagram, design the Exception Unit

   parameter MSTATUS = 12'h300;
   parameter MTVEC = 12'h305;
   parameter MEPC = 12'h341;
   parameter MCAUSE = 12'h342;
   parameter MTVAL = 12'h343;

   reg [1:0] state, nstate;
   always @(posedge clk) begin
      state <= nstate;
   end

   wire Exception = illegal_inst | l_access_fault | s_access_fault | ecall_m;
   wire Interrupt = interrupt & mstatus[3];
   assign reg_MW_flush = Exception | Interrupt | (state == 2'b01);
   assign reg_EM_flush = reg_MW_flush | mret;
   assign reg_DE_flush = reg_EM_flush;
   assign reg_FD_flush = reg_DE_flush;
   assign RegWrite_cancel = Exception;
   assign PC_redirect = csr_r_data_out;
   assign redirect_mux = mret | (state == 2'b01);

   reg [31:0] epc, cause;
   always @(posedge clk) begin
      if ((state == 2'b00) & (Interrupt | Exception)) begin
         epc   <= Interrupt ? epc_next : epc_cur;
         cause <= Interrupt ? 32'h80000000 : illegal_inst ? 32'h2 : l_access_fault ? 32'h5 : s_access_fault ? 32'h7 : 32'hb;
      end
   end

   always @(*) begin
      case (state)
         2'b00: begin
            if (Exception | Interrupt) begin
               csr_waddr <= MSTATUS;
               csr_wdata <= {mstatus[31:8], mstatus[3], mstatus[6:4], 1'b0, mstatus[2:0]};
               csr_w <= 1;
               csr_wsc <= 2'b01;
               nstate <= 2'b01;
            end else if (mret) begin
               csr_raddr <= MEPC;
               csr_waddr <= MSTATUS;
               csr_wdata <= {mstatus[31:8], 1'b1, mstatus[6:4], mstatus[7], mstatus[2:0]};
               csr_w <= 1;
               csr_wsc <= 2'b01;
               nstate <= 2'b00;
            end else if (csr_rw_in) begin
               csr_raddr <= csr_rw_addr_in;
               csr_waddr <= csr_rw_addr_in;
               csr_wdata <= csr_w_imm_mux ? {27'b0, csr_w_data_imm} : csr_w_data_reg;
               csr_w <= 1;
               csr_wsc <= csr_wsc_mode_in;
               nstate <= 2'b00;
            end else begin
               csr_w  <= 0;
               nstate <= 2'b00;
            end
         end
         2'b01: begin
            csr_raddr <= MTVEC;
            csr_waddr <= MEPC;
            csr_wdata <= epc;
            csr_w <= 1;
            csr_wsc <= 2'b01;
            nstate <= 2'b10;
         end
         2'b10: begin
            csr_waddr <= MCAUSE;
            csr_wdata <= cause;
            csr_w <= 1;
            csr_wsc <= 2'b01;
            nstate <= 2'b11;
         end
         2'b11: begin
            csr_waddr <= MTVAL;
            csr_wdata <= 32'h114514;
            csr_w <= 1;
            csr_wsc <= 2'b01;
            nstate <= 2'b00;
         end
      endcase
   end

   initial begin
      state = 0;
      csr_raddr = 0;
      csr_w = 0;
   end

endmodule
