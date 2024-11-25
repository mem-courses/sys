module ALU_more (
   input  [31:0] A,
   input  [31:0] B,
   input  [ 3:0] ALU_operation,
   output [31:0] res,
   output        zero
);
   reg [31:0] tmp;

   // 这里的 ALU_operation 直接和 {Fun7[5], Fun3[2:0]} 对应
   always @(*) begin
      case (ALU_operation)
         4'b0000: tmp = A + B;  // add / addi / ...
         4'b1000: tmp = A - B;  // sub / ...
         4'b0001: tmp = A << (B[4:0]);  // sll
         4'b0010: tmp = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0;  // slt / slti
         4'b0011: tmp = (A < B) ? 32'b1 : 32'b0;  // sltu // sltiu
         4'b0100: tmp = A ^ B;  // xor / xori
         4'b0101: tmp = A >> (B[4:0]);  // srl / srli
         4'b1101: tmp = A >>> (B[4:0]);  // sra / srai
         4'b0110: tmp = A | B;  // or / ori
         4'b0111: tmp = A & B;  // and / andi
      endcase
   end

   assign zero = (tmp == 0);
   assign res  = tmp;
endmodule
