`timescale 1ns / 1ps


module sign_extend(
    input [15:0] sign_ex_in,
    output reg [31:0] sign_ex_out
    );
    
    always @(*) begin
        sign_ex_out = { {16{sign_ex_in[15]}}, sign_ex_in[15:0] };
    end
endmodule
