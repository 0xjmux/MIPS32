`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2021 11:27:00 AM
// Design Name: 
// Module Name: instruction_mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module instruction_mem(
    input [9:0] read_addr,
    output [31:0] data
    );
    
    reg [31:0]rom[255:0];  
    
    initial  
    begin  

        // load to registers 1 to 10
                                                        // instruction           alu result in hex       register content       mem content
														
        rom[0]  = 32'b10001100000000010000000000000000; // r1  = mem[0]                 0                   r1 = 00000001            -
        rom[1]  = 32'b10001100000000100000000000000100; // r2  = mem[4]                 1                   r2 = 0fd76e10            -
        rom[2]  = 32'b10001100000000110000000000000100; // r3  = mem[4]                 2                   r3 = 0fd76e10            -
        rom[3]  = 32'b10001100000001000000000000001100; // r4  = mem[12]                3                   r4 = 14333ffc            -
        rom[4]  = 32'b10001100000001010000000000010000; // r5  = mem[16]                4                   r5 = 321fedcb            -
        rom[5]  = 32'b10001100000001100000000000010100; // r6  = mem[20]                5                   r6 = 80000000            -
        rom[6]  = 32'b10001100000001110000000000011000; // r7  = mem[24]                6                   r7 = 9012fd65            -
        rom[7]  = 32'b10001100000010000000000000011100; // r8  = mem[28]                7                   r8 = abc00237            -
        rom[8]  = 32'b10001100000010010000000000100000; // r9  = mem[32]                8                   r9 = b54bc031            -
        rom[9]  = 32'b10001100000010100000000000100100; // r10 = mem[36]                9                   r10= c187a606            -
                                                                                                           
        // no dependency test, no jump                                                                     
        rom[10] = 32'b00110000011010111111111101100011; // andi r11,r3,#ff63          0fd76e00              r11= 0fd76e00            -
        rom[11] = 32'b00000000001000100110000000100111; // nor  r12,r1,r2             f02891ee              r12= f02891ee            - 
        rom[12] = 32'b00000000001000100110100000101010; // slt  r13,r1,r2                 1                 r13= 1                   -
        rom[13] = 32'b11000000010000000111000011000000; // sll  r14,r2,#3             7ebb7080              r14= 7ebb7080            -
        rom[14] = 32'b11000000001000000111100101000010; // srl  r15,r1,#5                 0                 r15= 0                   -
        rom[15] = 32'b11000000110000001000000110000011; // sra  r16,r6,#6             fe000000              r16= fe000000            -
        rom[16] = 32'b00000000010000111000100000100110; // xor  r17,r2,r3             00000000              r17= 00000000            -
        rom[17] = 32'b00000000001000101001000000011000; // mult r17,r1,r2             0fd76e10              r18= 0fd76e10            -
        rom[18] = 32'b00000000010000011001100000011010; // div  r19,r2,r1             0fd76e10              r19= 0fd76e10            -
        // store the result in memory                                                                      
        rom[19] = 32'b10101100000010110000000000101100; // sw mem[r0+11] <= r11         2c                        -                  mem[11]= 0fd76e00
        rom[20] = 32'b10101100000011000000000000110000; // sw mem[r0+12] <= r12         30                        -                  mem[12]= f02891ee
        rom[21] = 32'b10101100000011010000000000110100; // sw mem[r0+13] <= r13         34                        -                  mem[13]=    1   
        rom[22] = 32'b10101100000011100000000000111000; // sw mem[r0+14] <= r14         38                        -                  mem[14]= 7ebb7080
        rom[23] = 32'b10101100000011110000000000111100; // sw mem[r0+15] <= r15         3c                        -                  mem[15]=    0   
        rom[24] = 32'b10101100000100000000000001000000; // sw mem[r0+16] <= r16         40                        -                  mem[16]= fe000000
        rom[25] = 32'b10101100000100010000000001000100; // sw mem[r0+17] <= r17         44                        -                  mem[17]= 00000000
        rom[26] = 32'b10101100000100100000000001001000; // sw mem[r0+18] <= r18         48                        -                  mem[18]= 0fd76e10
        rom[27] = 32'b10101100000100110000000001001100; // sw mem[r0+19] <= r19         4c                        -                  mem[19]= 0fd76e10
                                                                                                           
        // forwarding test                                                                                 
        rom[28] = 32'b00110000111010110000111101100011; // andi r11,r7,#f63           00000d61              r11= 00000d61            -
        rom[29] = 32'b00000000010010110110000000100111; // nor  r12,r2,r11            f028908e              r12= f028908e            -
        rom[30] = 32'b00000001011000100110100000101010; // slt  r13,r11,r2               1                  r13=    1                -
        rom[31] = 32'b11000000111000000111001101000000; // sll  r14,r2,#13            5faca000              r14= 5faca000            -
        rom[32] = 32'b11000001110000000111100111000010; // srl  r15,r14,#7            00bf5940?              r15= 00bf5940            -
        rom[33] = 32'b11000001110000001000000010000011; // sra  r16,r14,#2            17eb2800?              r16= 17eb2800?            -    
        rom[34] = 32'b00000000010001111000100000100110; // xor  r17,r2,r7             9fc59375              r17= 9fc59375            -
        rom[35] = 32'b00000000010001111001000000011000; // mult r18,r2,r7             e4e43c50              r18= e4e43c50            -
        rom[36] = 32'b00000000111100011001100000011010; // div  r19,r7,r17               0                  r19=    0                -
        // store the result in memory                                                                      
        rom[37] = 32'b10101100000010110000000001010000; // sw mem[r0+20] <= r11          50                                          mem[20]= 00000d61 
        rom[38] = 32'b10101100000011000000000001010100; // sw mem[r0+21] <= r12          54         forwardb=2 from ex/mem to ex     mem[21]= f028908e 
        rom[39] = 32'b10101100000011010000000001011000; // sw mem[r0+22] <= r13          58         forarda=1 from mem/wb to ex      mem[22]=    1        
        rom[40] = 32'b10101100000011100000000001011100; // sw mem[r0+23] <= r14          5c         no forwarding                    mem[23]= 5faca000 
        rom[41] = 32'b10101100000011110000000001100000; // sw mem[r0+24] <= r15          60         forarda=2 from ex/mem to ex      mem[24]= 00bf5940 
        rom[42] = 32'b10101100000100000000000001100100; // sw mem[r0+25] <= r16          64         forarda=1 from mem/wb to ex      mem[25]= 17eb2800 
        rom[43] = 32'b10101100000100010000000001101000; // sw mem[r0+26] <= r17          68         no forwarding                    mem[26]= 9fc59375 
        rom[44] = 32'b10101100000100100000000001101100; // sw mem[r0+27] <= r18          6c         no forwarding                    mem[27]= e4e43c50
        rom[45] = 32'b10101100000100110000000001110000; // sw mem[r0+28] <= r19          70         forwardb=1 from mem/wb to ex     mem[28]=    0 
                                                                                                           
        // Data Hazard test                                                                                
        // Data Hazard is the result of dependency between LW instruction's destination register and one of the next instruction's source register
        // we need to insert a NOP. This means that pc shouldnt change for one clk cycle. check your waveform to make sure your pc doesnt change 
        rom[46] = 32'b10001100000010110000000000100100; // r11 = mem[36]                 9                  r11= c187a606            -
        rom[47] = 32'b00000001011000100110000000100000; // add r12,r11,r2             d15f1416              r12= d15f1416            -
        rom[48] = 32'b10001100000011010000000000100000; // r13 = mem[32]                 9                  r13= b54bc031            -
        $display("%d\n", $time);
        rom[49] = 32'b00000000001011010111000000100000; // add r14,r1,r13             b54bc032              r14= b54bc032            -
        // store the result in memory                                                                      
        rom[50] = 32'b10101100000011000000000001110100; // sw mem[r0+29] <= r12          74                       -                  mem[29]= d15f1416
        rom[51] = 32'b10101100000011100000000001111000; // sw mem[r0+30] <= r14          78                       -                  mem[30]= b54bc032
                                                                                                           
        // Control Hazard test Branch                                                                      
        rom[52] = 32'b00010000010000110000000000000011; // beq r2,r3,#3                   0         branch to instruction rom[56]
        rom[53] = 32'b00000000001000100101000000100000; // add r10,r1,r2              0fd76e11              r10= 0fd76e11            -
        rom[54] = 32'b00000000001001000101000000100000; // add r10,r1,r4              14333ffd              r10= 14333ffd            -
        rom[55] = 32'b00000000001001010101000000100000; // add r10,r1,r5              321fedcc              r10= 321fedcc            -
        // store the result in memory                                                                      
        rom[56] = 32'b10101100000010100000000001111100; // sw mem[r0+31] <= r10          7c                       -                  mem[31]= c187a606
                                                                                                           
        // Control Hazard test Jump                                                                        
        rom[57] = 32'b00001000000000000000000001000000; // j #40                                    jump to instruction rom[64]
        rom[58] = 32'b00000000001000100100100000100000; // add r9,r1,r2               0fd76e11              r9= 0fd76e11             -
        rom[59] = 32'b00000000001001000100100000100000; // add r9,r1,r4               14333ffd              r9= 14333ffd             -
        rom[60] = 32'b00000000001001010100100000100000; // add r9,r1,r5               321fedcc              r9= 321fedcc             -
        rom[61] = 32'b00000000001001100100100000100000; // add r9,r1,r6               80000001              r9= 80000001             -
        rom[62] = 32'b00000000001001110100100000100000; // add r9,r1,r7               9012fd66              r9= 9012fd66             -
        rom[63] = 32'b00000000001010000100100000100000; // add r9,r1,r8               abc00238              r9= abc00238             -
        // store the result in memory                                                                      
        rom[64] = 32'b10101100000010010000000010000000; // sw mem[r0+32] <= r9           80                       -                  mem[32]= b54bc031
                                                                                                           
      end                                                                                                  
                                                                                                           
      assign data = rom[read_addr[9:2]];                                                                   
                                                                                                           
endmodule

