`timescale 1ns / 1ps


module IF_pipe_stage(
    input clk, reset,
    input en,
    input [9:0] branch_address,
    input [9:0] jump_address,
    input branch_taken,
    input jump,
    output [9:0] pc_plus4,
    output [31:0] instr
    );
    
       


wire [9:0] branch_mux_out;
reg [9:0] pc_reg;
wire [9:0] mux_pc_reg;

//output goes to if_mux_2
mux2 #(.mux_width(10)) if_mux_1 (
    .a(pc_plus4),   //0
    .b(branch_address),   //1
    .sel(branch_taken),
    .y(branch_mux_out)
);


mux2 #(.mux_width(10)) if_mux_2 (
    .a(branch_mux_out),   //0
    .b(jump_address),   //1
    .sel(jump),
    .y(mux_pc_reg)
);


// between PC and Instr Mem is reg for staging

// PC, when enable is high the correct output is passed along 
always @(posedge clk or posedge reset)
begin
    if(reset)
        pc_reg <= 10'b0000000000;
    else if (en==1)
        pc_reg <= mux_pc_reg;
end

assign pc_plus4 = pc_reg + 10'b0000000100;

instruction_mem instu_mem (
    .read_addr(pc_reg),
    .data(instr)
);

endmodule
