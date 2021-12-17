`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2021 11:22:04 AM
// Design Name: 
// Module Name: tb_mips_32
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


module tb_mips_32;
      reg clk;  
      reg reset;  
      // Outputs  

      wire [31:0] result;
      // Instantiate the Unit Under Test (UUT)  
      mips_32 uut (  
           .clk(clk),   
           .reset(reset),     
           .result(result)    
      );  
      
      real points = 0;
      

      initial begin  
           clk = 0;  
           forever #10 clk = ~clk;  
      end  
      initial begin  
           // Initialize Inputs  
 
           reset = 1;  
           // Wait 100 ns for global reset to finish  
           #100;  
           reset = 0;  
           // store some data in data memory
           uut.data_mem.ram[0]= 32'b00000000000000000000000000000001;// 00000001
           uut.data_mem.ram[1]= 32'b00001111110101110110111000010000;// 0fd76e10 
           uut.data_mem.ram[2]= 32'b01011010000000000100001010011011;// 5a00429b 
           uut.data_mem.ram[3]= 32'b00010100001100110011111111111100;// 14333ffc 
           uut.data_mem.ram[4]= 32'b00110010000111111110110111001011;// 321fedcb 
           uut.data_mem.ram[5]= 32'b10000000000000000000000000000000;// 80000000 
           uut.data_mem.ram[6]= 32'b10010000000100101111110101100101;// 9012fd65
           uut.data_mem.ram[7]= 32'b10101011110000000000001000110111;// abc00237
           uut.data_mem.ram[8]= 32'b10110101010010111100000000110001;// b54bc031
           uut.data_mem.ram[9]= 32'b11000001100001111010011000000110;// c187a606 
          
          #1500; 

          
          if(uut.data_mem.ram[11]==32'h0fd76e00) $display("NO DEPENDENCY ANDI 	success!\n"); else $display("NO DEPENDENCY ANDI 	failed! with value %d\n", uut.data_mem.ram[11]);
          if(uut.data_mem.ram[12]==32'hf02891ee) $display("NO DEPENDENCY NOR  	success!\n"); else $display("NO DEPENDENCY NOR  	failed! with value %d\n", uut.data_mem.ram[12]);
          if(uut.data_mem.ram[13]==32'h00000001) $display("NO DEPENDENCY SLT  	success!\n"); else $display("NO DEPENDENCY SLT  	failed! with value %d\n", uut.data_mem.ram[13]);
          if(uut.data_mem.ram[14]==32'h7ebb7080) $display("NO DEPENDENCY SLL  	success!\n"); else $display("NO DEPENDENCY SLL  	failed!\n");
          if(uut.data_mem.ram[15]==32'h00000000) $display("NO DEPENDENCY SRL  	success!\n"); else $display("NO DEPENDENCY SRL  	failed!\n");
          if(uut.data_mem.ram[16]==32'hfe000000) $display("NO DEPENDENCY SRA  	success!\n"); else $display("NO DEPENDENCY SRA  	failed!\n");
          if(uut.data_mem.ram[17]==32'h00000000) $display("NO DEPENDENCY XOR  	success!\n"); else $display("NO DEPENDENCY XOR  	failed!\n");
          if(uut.data_mem.ram[18]==32'h0fd76e10) $display("NO DEPENDENCY MULT 	success!\n"); else $display("NO DEPENDENCY MULT 	failed!\n");
          if(uut.data_mem.ram[19]==32'h0fd76e10) $display("NO DEPENDENCY DIV  	success!\n"); else $display("NO DEPENDENCY DIV  	failed!\n");
          
          if(uut.data_mem.ram[20]==32'h00000d61) $display("ANDI No Forwarding       success!\n"); else $display("ANDI No Forwarding     failed!\n");
          if(uut.data_mem.ram[21]==32'hf028908e) $display("Forward EX/MEM to EX B   success!\n"); else $display("Forward EX/MEM to EX B failed!\n");
          if(uut.data_mem.ram[22]==32'h00000001) $display("Forward MEM/WB to EX A	success!\n"); else $display("Forward MEM/WB to EX A	failed!\n");
          if(uut.data_mem.ram[23]==32'h5faca000) $display("SLL  No Forwarding		success!\n"); else $display("SLL  No Forwarding		failed!\n");
          if(uut.data_mem.ram[24]==32'h00bf5940) $display("Forward EX/MEM to EX A	success!\n"); else $display("Forward EX/MEM to EX A	failed!\n");
          if(uut.data_mem.ram[25]==32'h17eb2800) $display("Forward MEM/WB to EX A	success!\n"); else $display("Forward MEM/WB to EX A	failed!\n");
          if(uut.data_mem.ram[26]==32'h9fc59375) $display("XOR  No Forwarding		success!\n"); else $display("XOR  No Forwarding		failed!\n");
          if(uut.data_mem.ram[27]==32'he4e43c50) $display("MULT No Forwarding		success!\n"); else $display("MULT No Forwarding		failed!\n");
          if(uut.data_mem.ram[28]==32'h00000000) $display("Forward MEM/WB to EX B	success!\n"); else $display("Forward MEM/WB to EX B	failed!\n");
          
          // Data Hazard is the result of dependency between LW instruction's destination register and one of the next instruction's source register
          // we need to insert a NOP. This means that pc shouldnt change for one clk cycle. check your waveform to make sure your pc doesnt change 
          if(uut.data_mem.ram[29]==32'hd15f1416) $display("DATA HAZARD RS DEPENDENCY    success!\n"); else $display("DATA HAZARD RS DEPENDENCY  failed!\n");
          if(uut.data_mem.ram[30]==32'hb54bc032) $display("DATA HAZARD RT DEPENDENCY	success!\n"); else $display("DATA HAZARD RT DEPENDENCY	failed! with value %h and time %d\n", uut.data_mem.ram[30], $time);
          
          // Control Hazard
          if(uut.data_mem.ram[31]==32'hc187a606) $display("CONTROL HAZARD BRANCH	success!\n"); else $display("CONTROL HAZARD BRANCH	failed!\n");
          if(uut.data_mem.ram[32]==32'hb54bc031) $display("CONTROL HAZARD JUMP	success!\n"); else $display("CONTROL HAZARD JUMP	failed!\n");
         
     end 



       //ends tb after too long has elapsed to prevent it continuously running after it's finished
     initial begin
        #10000;
        $display("caught by runaway prevention");
        $finish;
      end  



endmodule
