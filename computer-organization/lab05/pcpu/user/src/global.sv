package pcpu;

   typedef struct packed {
      logic [31:0] x0;
      logic [31:0] ra;
      logic [31:0] sp;
      logic [31:0] gp;
      logic [31:0] tp;
      logic [31:0] t0;
      logic [31:0] t1;
      logic [31:0] t2;
      logic [31:0] s0;
      logic [31:0] s1;
      logic [31:0] a0;
      logic [31:0] a1;
      logic [31:0] a2;
      logic [31:0] a3;
      logic [31:0] a4;
      logic [31:0] a5;
      logic [31:0] a6;
      logic [31:0] a7;
      logic [31:0] s2;
      logic [31:0] s3;
      logic [31:0] s4;
      logic [31:0] s5;
      logic [31:0] s6;
      logic [31:0] s7;
      logic [31:0] s8;
      logic [31:0] s9;
      logic [31:0] s10;
      logic [31:0] s11;
      logic [31:0] t3;
      logic [31:0] t4;
      logic [31:0] t5;
      logic [31:0] t6;
   } RV32_Regs_t;

   typedef struct packed {
      // ID/EX
      logic [31:0] IdEx_inst;
      logic [4:0]  IdEx_rd;
      logic [4:0]  IdEx_rs1;
      logic [4:0]  IdEx_rs2;
      logic [31:0] IdEx_rs1_val;
      logic [31:0] IdEx_rs2_val;
      logic        IdEx_reg_wen;
      logic        IdEx_is_imm;
      logic [31:0] IdEx_imm;
      logic [31:0] Ex_forward_rs1;
      logic [31:0] Ex_forward_rs2;
      logic        IdEx_mem_wen;
      logic        IdEx_mem_ren;
      logic        IdEx_is_branch;
      logic        IdEx_is_jal;
      logic        IdEx_is_jalr;
      logic        IdEx_is_auipc;
      logic        IdEx_is_lui;
      logic [3:0]  IdEx_alu_ctrl;
      logic [2:0]  IdEx_cmp_ctrl;
      logic [31:0] ExMa_pc;
      logic [31:0] ExMa_inst;
      logic [4:0]  ExMa_rd;
      logic        ExMa_reg_wen;
      logic        ExMa_mem_ren;
      logic        ExMa_is_jal;
      logic        ExMa_is_jalr;
      logic [31:0] MaWb_pc;
      logic [31:0] MaWb_inst;
      logic [4:0]  MaWb_rd;
      logic        MaWb_reg_wen;
   } VGA_Signals_t;

   // ===================== debugger =====================

   localparam string log_filename = "sim_log.txt";

   typedef struct packed {
      // note: 在 struct 中使用 packed 关键字确保结构体中的数据是紧密排列的
      logic [31:0] PC;
      logic [31:0] inst;
   } Debug_t;
   localparam Debug_t empty_dbg = '{PC: 0, inst: 0};

   function void log_reset();
`ifdef SIM
      integer file;
      file = $fopen(log_filename, "w");  // this will make the file empty
      if (file) begin
         $fclose(file);
      end else begin
         $display("Error: Unable to open file %s", log_filename);
      end
`endif
   endfunction

   function void log_plain(string text);
`ifdef SIM
      integer log_file;  // note: 函数内定义的局部变量需要放在函数开头吗？不放就没法过编译

      $display(text);
      log_file = $fopen(log_filename, "a");  // append mode is required
      if (log_file) begin
         $fwrite(log_file, text);
         $fwrite(log_file, "\n");
         $fclose(log_file);
      end else begin
         $display("Error: Unable to open file %s", log_filename);
      end
`endif
   endfunction

   function void log_msg(string stage, string msg, Debug_t dbg = empty_dbg);
`ifdef SIM
      string plain;
      if (dbg != empty_dbg) begin
         plain = $sformatf("[%3s] %8h %8h %s", stage, dbg.PC, dbg.inst, msg);
      end else begin
         plain = $sformatf("[%3s] %17s %s", stage, "", msg);
      end
      log_plain(plain);
`endif
   endfunction

   function void log_data(string stage, string name, int val, Debug_t dbg = empty_dbg);
`ifdef SIM
      string msg;

      // Check if val contains X or Z
      if ($isunknown(val)) begin
         $error("Value '%s' contains X or Z", name);
         $finish;
      end

      msg = $sformatf("%8s: %8h", name, val);
      log_msg(stage, msg, dbg);
`endif
   endfunction
endpackage
