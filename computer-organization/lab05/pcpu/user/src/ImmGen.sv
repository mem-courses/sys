module ImmGen (
   input  wire [ 2:0] ImmSel,
   input  wire [31:0] inst_field,
   output reg  [31:0] Imm_out
);
   always @(*) begin
      case (ImmSel)
         // I-type: addi, lw
         3'b000: Imm_out = {{20{inst_field[31]}}, inst_field[31:20]};
         // S-type: sw
         3'b001: Imm_out = {{20{inst_field[31]}}, {inst_field[31:25]}, inst_field[11:7]};
         // SB-type: beq
         3'b010: Imm_out = {{20{inst_field[31]}}, inst_field[7], inst_field[30:25], inst_field[11:8], 1'b0};
         // UJ-type: jal
         3'b011: Imm_out = {{11{inst_field[31]}}, inst_field[31], inst_field[19:12], inst_field[20], inst_field[30:21], 1'b0};
         // U-type: lui
         3'b100: Imm_out = {inst_field[31:12], 12'h0};
      endcase
   end
endmodule
