`timescale 1ns / 1ps
// for future; vim wire formatting macro is @R
 //set up module: use :<>norm! @M


module mips_32(
    input clk, reset,  
    output[31:0] result
    );
    
//// define all the wires here. 
//// IF
wire [9:0] branch_address;
wire branch_taken;
wire [9:0] jump_address;
wire jump;
wire [9:0] pc_plus4;
wire [31:0] instr;
wire [31:0] if_id_instr;
wire [31:0] id_ex_instr;

wire [9:0] if_id_pc_plus4;
wire IF_Flush;
wire mem_wb_reg_write;
wire [4:0] mem_wb_destination_reg;
wire [31:0] write_back_data;
wire Data_Hazard;
wire [31:0] reg1, reg2;
wire [31:0] id_ex_reg1, id_ex_reg2;
wire [31:0] imm_value;
wire [31:0] id_ex_imm_value;
wire [4:0] destination_reg;
wire [4:0] id_ex_destination_reg;
wire mem_to_reg, mem_write, mem_read, alu_src, reg_write;
wire id_ex_mem_to_reg, id_ex_mem_read, id_ex_mem_write, id_ex_reg_write, id_ex_alu_src;
wire [1:0] alu_op;
wire [1:0] id_ex_alu_op;
wire [31:0] ex_mem_alu_result;
wire [1:0] Forward_A, Forward_B;
wire [31:0] alu_in2_out, alu_result;
wire ex_mem_reg_write;
wire [31:0] ex_mem_instr;
wire [4:0] ex_mem_destination_reg;
wire [31:0] ex_mem_alu_in2_out;
wire ex_mem_mem_to_reg;
wire ex_mem_mem_read;
wire ex_mem_mem_write;
wire [31:0] mem_wb_alu_result;
wire [31:0] mem_wb_mem_read_data;
wire [31:0] mem_read_data;
wire mem_wb_mem_to_reg;



///////////////////////////// Instruction Fetch    
IF_pipe_stage if_pipeline_stage (
    .clk(clk),
    .reset(reset),
    .en(Data_Hazard),
    .branch_address(branch_address),
    .branch_taken(branch_taken),
    .jump_address(jump_address),
    .jump(jump),
    .pc_plus4(pc_plus4),
    .instr(instr)
);

        
///////////////////////////// IF/ID registers
    //special case, since have extra input to take in
    //every other in between case, use `pipe_reg` 
    // one reg for each input/output for the pipeline in-between
pipe_reg_en #(.WIDTH(10)) pc_plus4_if_reg (
    .clk(clk),
    .reset(reset),
    .en(Data_Hazard),
    .flush(IF_Flush),
    .d(pc_plus4),
    .q(if_id_pc_plus4)
);


pipe_reg_en #(.WIDTH(32)) pipe_instr_reg (
    .clk(clk),
    .reset(reset),
    .en(Data_Hazard),
    .flush(IF_Flush),
    .d(instr),
    .q(if_id_instr)
);

///////////////////////////// Instruction Decode 
ID_pipe_stage id_pipeline(
    .clk(clk), 
    .reset(reset),
    .pc_plus4(if_id_pc_plus4),
    .instr(if_id_instr),
    .mem_wb_reg_write(mem_wb_reg_write),
    .mem_wb_write_reg_addr(mem_wb_destination_reg),
    .mem_wb_write_back_data(write_back_data),
    .Data_Hazard(Data_Hazard),
    .IF_Flush(IF_Flush),
    .reg1(reg1), 
    .reg2(reg2),
    .imm_value(imm_value),
    .branch_address(branch_address),
    .jump_address(jump_address),
    .branch_taken(branch_taken),
    .destination_reg(destination_reg), 
    .mem_to_reg(mem_to_reg),
    .alu_op(alu_op),
    .mem_read(mem_read),  
    .mem_write(mem_write),
    .alu_src(alu_src),
    .reg_write(reg_write),
    .jump(jump)
);
    
 
            
///////////////////////////// ID/EX registers 

// if_id_instr
pipe_reg #(.WIDTH(32)) ID_EX_if_id_instr_reg (
    .clk(clk),
    .reset(reset),
    .d(if_id_instr),
    .q(id_ex_instr)
);

// reg1
pipe_reg #(.WIDTH(32)) ID_EX_reg1_reg (
    .clk(clk),
    .reset(reset),
    .d(reg1),
    .q(id_ex_reg1)
);

// reg2
pipe_reg #(.WIDTH(32)) ID_EX_reg2_reg (
    .clk(clk),
    .reset(reset),
    .d(reg2),
    .q(id_ex_reg2)
);

// imm_value
pipe_reg #(.WIDTH(32)) ID_EX_imm_value_reg (
    .clk(clk),
    .reset(reset),
    .d(imm_value),
    .q(id_ex_imm_value)
);

// destination_reg
pipe_reg #(.WIDTH(5)) ID_EX_destination_reg_reg (
    .clk(clk),
    .reset(reset),
    .d(destination_reg),
    .q(id_ex_destination_reg)
);

// mem_to_reg
pipe_reg #(.WIDTH(1)) ID_EX_mem_to_reg_reg (
    .clk(clk),
    .reset(reset),
    .d(mem_to_reg),
    .q(id_ex_mem_to_reg)
);

// alu_op
pipe_reg #(.WIDTH(2)) ID_EX_alu_op_reg (
    .clk(clk),
    .reset(reset),
    .d(alu_op),
    .q(id_ex_alu_op)
);

// mem_read
pipe_reg #(.WIDTH(1)) ID_EX_mem_read_reg (
    .clk(clk),
    .reset(reset),
    .d(mem_read),
    .q(id_ex_mem_read)
);

// mem_write
pipe_reg #(.WIDTH(1)) ID_EX_mem_write_reg (
    .clk(clk),
    .reset(reset),
    .d(mem_write),
    .q(id_ex_mem_write)
);

// alu_src
pipe_reg #(.WIDTH(1)) ID_EX_alu_src_reg (
    .clk(clk),
    .reset(reset),
    .d(alu_src),
    .q(id_ex_alu_src)
);

// reg_write
pipe_reg #(.WIDTH(1)) ID_EX_reg_write_reg (
    .clk(clk),
    .reset(reset),
    .d(reg_write),
    .q(id_ex_reg_write)
);
 
///////////////////////////// Hazard_detection unit
Hazard_detection hazardous(
    .id_ex_mem_read(id_ex_mem_read),
    .id_ex_destination_reg(id_ex_destination_reg),
    .if_id_rs(if_id_instr[25:21]),
    .if_id_rt(if_id_instr[20:16]),
    .branch_taken(branch_taken),     //
    .jump(jump),
    .Data_Hazard(Data_Hazard),
    .IF_Flush(IF_Flush)
);
           
///////////////////////////// Execution    
EX_pipe_stage ex_stage(
    .id_ex_instr(id_ex_instr),
    .reg1(id_ex_reg1),
    .reg2(id_ex_reg2),
    .id_ex_imm_value(id_ex_imm_value),
    .ex_mem_alu_result(ex_mem_alu_result),      // used for result forwarding
    .mem_wb_write_back_result(write_back_data),    //also result forwarding
    .id_ex_alu_src(id_ex_alu_src),
    .id_ex_alu_op(id_ex_alu_op),
    .Forward_A (Forward_A),     //also result forwarding
    .Forward_B(Forward_B),      //also result forwarding
    .alu_in2_out(alu_in2_out),  // internal???
    .alu_result(alu_result)
    );


///////////////////////////// Forwarding unit
EX_Forwarding_unit ex_forwarding (
    .ex_mem_reg_write(ex_mem_reg_write),
    .ex_mem_write_reg_addr(ex_mem_destination_reg),
    .id_ex_instr_rs(id_ex_instr[25:21]),
    .id_ex_instr_rt(id_ex_instr[20:16]),
    .mem_wb_reg_write(mem_wb_reg_write),
    .mem_wb_write_reg_addr(mem_wb_destination_reg),
    .Forward_A(Forward_A),
    .Forward_B(Forward_B)
);
     
///////////////////////////// EX/MEM registers
// id_ex_instr
pipe_reg #(.WIDTH(32)) EX_MEM_id_ex_instr_reg (
    .clk(clk),
    .reset(reset),
    .d(id_ex_instr),
    .q(ex_mem_instr)
);
// id_ex_destination_reg
pipe_reg #(.WIDTH(5)) EX_MEM_id_ex_destination_reg (
    .clk(clk),
    .reset(reset),
    .d(id_ex_destination_reg),
    .q(ex_mem_destination_reg)
);
// alu_result
pipe_reg #(.WIDTH(32)) EX_MEM_alu_result_reg (
    .clk(clk),
    .reset(reset),
    .d(alu_result),
    .q(ex_mem_alu_result)
);

// alu_in2_out
pipe_reg #(.WIDTH(32)) EX_MEM_alu_in2_out_reg (
    .clk(clk),
    .reset(reset),
    .d(alu_in2_out),
    .q(ex_mem_alu_in2_out)
);
// id_ex_mem_to_reg
pipe_reg #(.WIDTH(1)) EX_MEM_id_ex_mem_to_reg_reg (
    .clk(clk),
    .reset(reset),
    .d(id_ex_mem_to_reg),
    .q(ex_mem_mem_to_reg)
);
// id_ex_mem_read
pipe_reg #(.WIDTH(1)) EX_MEM_id_ex_mem_read_reg (
    .clk(clk),
    .reset(reset),
    .d(id_ex_mem_read),
    .q(ex_mem_mem_read)
);
// id_ex_mem_write
pipe_reg #(.WIDTH(1)) EX_MEM_id_ex_mem_write_reg (
    .clk(clk),
    .reset(reset),
    .d(id_ex_mem_write),
    .q(ex_mem_mem_write)
);
// id_ex_reg_write
pipe_reg #(.WIDTH(1)) EX_MEM_id_ex_reg_write_reg (
    .clk(clk),
    .reset(reset),
    .d(id_ex_reg_write),
    .q(ex_mem_reg_write)
);

///////////////////////////// memory    
data_memory data_mem(
    .clk(clk),
    .mem_access_addr(ex_mem_alu_result),
    .mem_write_data(ex_mem_alu_in2_out),
    .mem_write_en(ex_mem_mem_write),
    .mem_read_en(ex_mem_mem_read),
    .mem_read_data(mem_read_data)
);

///////////////////////////// MEM/WB registers  
// ex_mem_alu_result
pipe_reg #(.WIDTH(32)) MEM_WB_ex_mem_alu_result_reg (
    .clk(clk),
    .reset(reset),
    .d(ex_mem_alu_result),
    .q(mem_wb_alu_result)
);

// mem_read_data
pipe_reg #(.WIDTH(32)) MEM_WB_mem_read_data_reg (
    .clk(clk),
    .reset(reset),
    .d(mem_read_data),
    .q(mem_wb_mem_read_data)
);

// ex_mem_mem_to_reg
pipe_reg #(.WIDTH(1)) MEM_WB_ex_mem_mem_to_reg_reg (
    .clk(clk),
    .reset(reset),
    .d(ex_mem_mem_to_reg),
    .q(mem_wb_mem_to_reg)
);
    
// ex_mem_reg_write
pipe_reg #(.WIDTH(1)) MEM_WB_ex_mem_reg_write_reg (
    .clk(clk),
    .reset(reset),
    .d(ex_mem_reg_write),
    .q(mem_wb_reg_write)
);

// ex_mem_destination_reg
pipe_reg #(.WIDTH(5)) MEM_WB_ex_mem_destination_reg_reg (
    .clk(clk),
    .reset(reset),
    .d(ex_mem_destination_reg),
    .q(mem_wb_destination_reg)
);

///////////////////////////// writeback    
mux2 #(.mux_width(32)) writeback_mux (
    .a(mem_wb_alu_result),   //0
    .b(mem_wb_mem_read_data),   //1
    .sel(mem_wb_mem_to_reg),
    .y(write_back_data)
);

assign result = write_back_data;
    
endmodule
