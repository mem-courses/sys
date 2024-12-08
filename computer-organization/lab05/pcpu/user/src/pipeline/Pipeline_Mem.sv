module Pipeline_Mem (
`ifdef SIM
   input  Debug_t debug_in_Mem,
   output Debug_t debug_out_Mem,
`endif

   input  zero_in_Mem,
   input  Branch_in_Mem,
   input  BranchN_in_Mem,
   input  Jump_in_Mem,
   output PCSrc_out_Mem
);
`ifdef SIM
   assign debug_out_Mem = debug_in_Mem;
`endif

   assign PCSrc_out_Mem = Jump_in_Mem | (Branch_in_Mem & zero_in_Mem) | (BranchN_in_Mem & (~zero_in_Mem));
endmodule
