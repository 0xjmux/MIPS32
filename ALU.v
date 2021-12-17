`timescale 1ns / 1ps


module ALU(
    input [31:0] a,  
    input [31:0] b, 
    input [3:0] alu_control,
    output zero, 
    output reg [31:0] alu_result); 
    
    wire signed [31:0] signed_a; 
    
    assign signed_a = a;
    
 always @(*)
 begin   
      case(alu_control)  
      4'b0000: alu_result = a & b; // and  
      4'b0001: alu_result = a | b; // or  
      4'b0010: alu_result = a + b; // add
      4'b0100: alu_result = a ^ b; // xor
      4'b0101: alu_result = a * b; // mult   
      4'b0110: alu_result = a - b; // sub 
      4'b0111: alu_result = (a<b) ? 32'd1 : 32'd0; // slt
      4'b1000: alu_result = a << b[10:6]; // sll 
      4'b1001: alu_result = a >> b[10:6]; // srl 
      4'b1010: alu_result = signed_a >>> b[10:6]; // sra 
      4'b1011: alu_result = a/b; // div 
      4'b1100: alu_result = ~(a | b); // nor  
 
      default: alu_result = a + b; // add  
      endcase  
 end  
 assign zero = (alu_result==32'd0) ? 1'b1: 1'b0;

endmodule
