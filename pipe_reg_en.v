`timescale 1ns / 1ps

module pipe_reg_en #(parameter WIDTH = 8)(
    input clk, reset,
    input en, flush,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
    );
    
    always @(posedge clk or posedge reset)  
    begin   
        if(reset)   
            q <= 0; 
        else if (flush) 
            q <= 0;
        else if (en)
            q <= d;  
    end  
endmodule