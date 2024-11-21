module ALU (
   input [31:0] A,
   input [2:0] ALU_operation,
   input [31:0] B,
   output [31:0] res,
   output zero
);
   reg [31:0] tmp;
   always @(*) begin
      case (ALU_operation)
         3'b000:  tmp = A & B;
         3'b001:  tmp = A | B;
         3'b010:  tmp = A + B;
         3'b110:  tmp = A - B;
         3'b111:  tmp = ($signed(A) < $signed(B));
         3'b100:  tmp = (A | B) ^ (32'b11111111111111111111111111111111);
         3'b101:  tmp = A >> (B & 5'b11111);
         default: tmp = A ^ B;
      endcase
   end

   assign zero = (tmp == 0);
   assign res  = tmp;
endmodule
