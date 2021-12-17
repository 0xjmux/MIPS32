`timescale 1ns / 1ps

module EX_pipe_stage(
    input [31:0] id_ex_instr,
    input [31:0] reg1, reg2,
    input [31:0] id_ex_imm_value,
    input [31:0] ex_mem_alu_result,
    input [31:0] mem_wb_write_back_result,
    input id_ex_alu_src,
    input [1:0] id_ex_alu_op,
    input [1:0] Forward_A, Forward_B,
    output [31:0] alu_in2_out,
    output [31:0] alu_result
    );
    
    wire [31:0] mux_1_out;
    wire [31:0] mux_3_out;
    wire [31:0] mux_2_out;
    wire [3:0] alu_control;

// reg1 mux, forward_A
mux4 #(.mux_width(32)) ex_reg1_mux (
    .a(reg1),   //00
    .b(mem_wb_write_back_result),   //01
    .c(ex_mem_alu_result),    //10
    .d(),    //11
    .sel(Forward_A),
    .y(mux_1_out)
);

// reg2 mux, forward_B
mux4 #(.mux_width(32)) ex_reg2_mux (
    .a(reg2),   //00
    .b(mem_wb_write_back_result),   //01
    .c(ex_mem_alu_result),    //10
    .d(),    //11
    .sel(Forward_B),
    .y(mux_2_out)
);

assign alu_in2_out = mux_2_out;


// imm_value reg2 mux
mux2 #(.mux_width(32)) ex_immvalue_mux (
    .a(mux_2_out),   //00
    .b(id_ex_imm_value),   //01
    .sel(id_ex_alu_src),
    .y(mux_3_out)
);

// alu control module
ALUControl ex_alu_control(
    .ALUOp(id_ex_alu_op),
    .Function(id_ex_instr[5:0]),
    .ALU_Control(alu_control)
);  


// ALU 
ALU ex_alu(
    .a(mux_1_out),
    .b(mux_3_out),
    .alu_control(alu_control),
    .zero(),
    .alu_result(alu_result)
    ); 

endmodule
