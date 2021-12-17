`timescale 1ns / 1ps


module ID_pipe_stage(
    input  clk, reset,
    input  [9:0] pc_plus4,
    input  [31:0] instr,
    input  mem_wb_reg_write,
    input  [4:0] mem_wb_write_reg_addr,
    input  [31:0] mem_wb_write_back_data,
    input  Data_Hazard,
    input  IF_Flush,
    output [31:0] reg1, reg2,
    output [31:0] imm_value,
    output [9:0] branch_address,
    output [9:0] jump_address,
    output branch_taken,
    output [4:0] destination_reg, 
    output mem_to_reg,
    output [1:0] alu_op,
    output mem_read,  
    output mem_write,
    output alu_src,
    output reg_write,
    output jump
    );
    

// WIRE DEFINITIONS
wire hazard_test;
wire [31:0] imm_shifted;
wire [31:0] sign_extended_shifted;
wire eq_test;
wire reg_dst;
wire branch;
wire [1:0] w_alu_op;
wire w_mem_to_reg, w_mem_read, w_mem_write, w_alu_src, w_reg_write;


// control unit
control ctrl_unit (
    .reset(reset),
    .opcode(instr[31:26]),
    .reg_dst(reg_dst), 
    .mem_to_reg(w_mem_to_reg), 
    .alu_op(w_alu_op),  
    .mem_read(w_mem_read), 
    .mem_write(w_mem_write), 
    .alu_src(w_alu_src), 
    .reg_write(w_reg_write), 
    .branch(branch),
    .jump(jump) 
    ); 

//not data hazard OR control hazard into control mux
assign hazard_test = (!Data_Hazard) || IF_Flush;

//hazard test controlled mux
//////////////////////////////////////////

//memtoreg
mux2 #(.mux_width(1)) hazard_mux_1 (
    .a(w_mem_to_reg),   //0
    .b(1'b0),   //1
    .sel(hazard_test),
    .y(mem_to_reg)
);

// mem read
mux2 #(.mux_width(1)) hazard_mux_2 (
    .a(w_mem_read),   //0
    .b(1'b0),   //1
    .sel(hazard_test),
    .y(mem_read)
);

// mem write
mux2 #(.mux_width(1)) hazard_mux_3 (
    .a(w_mem_write),   //0
    .b(1'b0),   //1
    .sel(hazard_test),
    .y(mem_write)
);

// alu_src
mux2 #(.mux_width(1)) hazard_mux_4 (
    .a(w_alu_src),   //0
    .b(1'b0),   //1
    .sel(hazard_test),
    .y(alu_src)
);

// reg_write
mux2 #(.mux_width(1)) hazard_mux_5 (
    .a(w_reg_write),   //0
    .b(1'b0),   //1
    .sel(hazard_test),
    .y(reg_write)
);

// alu_op
mux2 #(.mux_width(2)) hazard_mux_6 (
    .a(w_alu_op),   //0
    .b(2'b00),   //1
    .sel(hazard_test),
    .y(alu_op)
);


//instr [15:0] sign extended/
sign_extend sign_ex_inst (
    .sign_ex_in(instr[15:0]),
    .sign_ex_out(imm_value)
);
     

// eq test reg output
register_file registers(
    .clk(clk),
    .reset(reset),
    .reg_write_en(mem_wb_reg_write),  
    .reg_write_dest(mem_wb_write_reg_addr),  
    .reg_write_data(mem_wb_write_back_data),
    .reg_read_addr_1(instr[25:21]), 
    .reg_read_addr_2(instr[20:16]),  
    .reg_read_data_1(reg1),  
    .reg_read_data_2(reg2)
);

//sign extended shift left 2
assign imm_shifted = imm_value << 2;        //shift immediate value left

//pc plus 4 + signextended shifted
assign branch_address = imm_shifted[9:0] + pc_plus4;

//if_id_instr instr[25:0 shift left 2 = jump addr
assign jump_address = {instr[25:0],2'b00};        //shift immediate value left

// eq test
assign eq_test = (((reg1 ^ reg2) == 32'd0) ?  1'b1 : 1'b0);

// control branch line AND eq test
assign branch_taken = (branch & eq_test);

// destination reg mux
mux2 #(.mux_width(5)) reg_dst_mux(
    .a(instr[20:16]),   //0
    .b(instr[15:11]),   //1
    .sel(reg_dst),
    .y(destination_reg)
);


endmodule
