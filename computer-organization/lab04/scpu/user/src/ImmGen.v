module ImmGen (
   input  wire [ 1:0] ImmSel,
   input  wire [31:0] inst_field,
   output reg  [31:0] Imm_out
);
   always @(*) begin
      case (ImmSel)
         // I-type: addi, lw
         2'b00: Imm_out = {{20{inst_field[31]}}, inst_field[31:20]};
         // S-type: sw
         2'b01: Imm_out = {{20{inst_field[31]}}, {inst_field[31:25]}, inst_field[11:7]};
         // SB-type: beq
         2'b10: Imm_out = {{20{inst_field[31]}}, inst_field[7], inst_field[30:25], inst_field[11:8], 1'b0};
         // UJ-type: jal
         2'b11: Imm_out = {{11{inst_field[31]}}, inst_field[31], inst_field[19:12], inst_field[20], inst_field[30:21], 1'b0};
      endcase
   end
endmodule
