`timescale 1ns / 1ps

module Processor(input logic clk, reset);
    logic [31:0] plus4, next_index, wdata, rdata, index, A, B, B_i, A_r, B_r, instruction, alu_out;
    logic [3:0] alu_op;
    logic [2:0] mask, br_type;
    logic [1:0] wb_sel;
    logic reg_wr, rd_en, wr_en, sel_A, sel_B, br_taken;
    
    PC pc (.clk(clk), .reset(reset), .B(next_index), .A(index));
    Add4 add4 (.A(index), .B(plus4));
    Mux2 select_PC (.A(plus4), .B(alu_out), .sel(br_taken), .C(next_index));
    
    InstructionMemory im (.addr(index), .instruction(instruction));

    RegisterFile rf (.clk(clk), .reset(reset), .reg_wr(reg_wr), .raddr1(instruction[19:15]), .raddr2(instruction[24:20]), .waddr(instruction[11:7]), .wdata(wdata), .rdata1(A_r), .rdata2(B_r));
    ImmediateGenerator ig (.clk(clk), .instruction(instruction), .imm_out(B_i));

    Mux2 select_A (.A(index), .B(A_r), .sel(sel_A), .C(A));
    Mux2 select_B (.A(B_r), .B(B_i), .sel(sel_B), .C(B));
    BranchCondition bc (.rs1(A_r), .rs2(B_r), .br_type(br_type), .opcode(instruction[6:0]), .br_taken(br_taken));

    Controller controller (.instruction(instruction), .alu_op(alu_op), .mask(mask), .br_type(br_type), .reg_wr(reg_wr), .sel_A(sel_A), .sel_B(sel_B), .rd_en(rd_en), .wr_en(wr_en), .wb_sel(wb_sel));
    ALU alu (.A(A), .B(B), .alu_op(alu_op), .C(alu_out));
    
    DataMemory memory (.addr(alu_out), .wdata(B_r), .mask(mask), .wr_en(wr_en), .rd_en(rd_en), .clk(clk), .rdata(rdata));
    WriteBack writeback (.A(alu_out), .B(rdata), .C(index), .wb_sel(wb_sel), .wdata(wdata));
endmodule
