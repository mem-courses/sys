`timescale 1ns / 1ps

module mul32 (
   input clk,
   input rst,
   input [31:0] multiplicand,
   input [31:0] multiplier,
   input start,
   output reg [63:0] product,
   output reg finish
);

   reg [5:0] count;
   reg carry;
   reg calculating;

   always @(posedge clk or posedge rst) begin
      if (rst) begin
         // reset all
         product <= 64'b0;
         count <= 6'b0;
         finish <= 1'b0;
         calculating <= 1'b0;
      end else begin
         // calculate
         if (start && !calculating) begin
            product <= {32'b0, multiplier};
            count <= 6'b0;
            finish <= 1'b0;
            calculating <= 1'b1;
         end else if (calculating) begin
            if (count < 32) begin
               if (product[0]) begin
                  {carry, product[63:32]} <= {1'b0, product[63:32]} + {1'b0, multiplicand};
               end else begin
                  carry <= 1'b0;
               end
               product <= {carry, product[63:1]};
               count   <= count + 1;
            end else begin
               finish <= 1'b1;
               calculating <= 1'b0;
            end
         end
      end
   end

endmodule
