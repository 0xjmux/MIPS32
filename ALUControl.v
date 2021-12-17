`timescale 1ns / 1ps


module ALUControl(
    input [1:0] ALUOp, 
    input [5:0] Function,
    output reg[3:0] ALU_Control);  

wire [7:0] ALUControlIn;  
 assign ALUControlIn = {ALUOp,Function};  
 always @(ALUControlIn)  
 casex (ALUControlIn)  

    //DOUBLE-CHECKED AGAINST TABLE FROM ASSIGNMENT       
    8'b1x100100: ALU_Control=4'b0000; //and
    8'b11xxxxxx: ALU_Control=4'b0000; //andi 
    8'b10100101: ALU_Control=4'b0001;  //or
    8'b00xxxxxx: ALU_Control=4'b0010; //addi, lw, sw
    8'b10100000: ALU_Control=4'b0010; //add
    8'b01xxxxxx: ALU_Control=4'b0110; //beq
    8'b10100010: ALU_Control=4'b0110; //sub 
    8'b10100111: ALU_Control=4'b1100; //nor
    8'b10101010: ALU_Control=4'b0111; //slt
    8'b10000000: ALU_Control=4'b1000; //sll
    8'b10000010: ALU_Control=4'b1001; //srl
    8'b10000011: ALU_Control=4'b1010; //sra
    8'b10100110: ALU_Control=4'b0100; //xor
    8'b10011000: ALU_Control=4'b0101; // mult
    8'b10011010: ALU_Control=4'b1011; //div

  default: ALU_Control=4'b0000;  
  endcase  
 endmodule  


