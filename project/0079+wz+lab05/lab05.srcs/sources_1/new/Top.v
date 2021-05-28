`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/18 16:30:08
// Design Name: 
// Module Name: Top
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


module Top(
    input Clk,
    input reset
    //output reg [31:0] PC
    );
    wire [31:0] INST;
    reg [31:0] PC;
    wire [4:0] WRITE_REG;
    wire [31:0] WRITE_DATA;
    
    wire [3:0] ALU_CTR;
    wire ZERO;
    wire [31:0] ALU_RES;
    wire [1:0] ALU_OP;
    wire REG_DST;
    wire JUMP;
    wire BRANCH;
    wire MEM_READ;
    wire MEM_WRITE;
    wire MEM_TO_REG;
    wire ALU_SRC;
    wire REG_WRITE;
    wire [31:0] READ_DATA;
    wire [31:0] READ_DATA1;
    wire [31:0] READ_DATA2;
    wire [31:0] DATA;
    wire [31:0]IMM_SEXT;
    wire [31:0]ALU_SRC_B;
    initial begin
        PC=0;
    end
    
    Ctr mainCtr(
        .OpCode(INST[31:26]),
        .regDst(REG_DST),
        .aluSrc(ALU_SRC),
        .memToReg(MEM_TO_REG),
        .regWrite(REG_WRITE),
        .memRead(MEM_READ),
        .memWrite(MEM_WRITE),
        .branch(BRANCH),
        .aluOp(ALU_OP),
        .jump(JUMP)
    );//
    
    mux5 WriteRegMux(
        .sel(REG_DST),
        .input1(INST[15:11]),
        .input2(INST[20:16]),
        .out(WRITE_REG)
    );//
    
    ALU alu(
        .input1(READ_DATA1),
        .input2(ALU_SRC_B),
        .aluCtr(ALU_CTR),
        .zero(ZERO),
        .aluRes(ALU_RES),
        .reset(reset)
    );//
    
    mux32 AluSrcMux(
        .sel(ALU_SRC),
        .input1(IMM_SEXT),
        .input2(READ_DATA2),
        .out(ALU_SRC_B)
    );//
    
    ALUCtr mainALUCtr(
        .ALUOp(ALU_OP),
        .Funct(INST[5:0]),
        .reset(reset),
        .ALUCtrOut(ALU_CTR)
    );//
    
    dataMemory maindataMemory(
        .Clk(Clk),
        .reset(reset),
        .address(ALU_RES),
        .writeData(READ_DATA2),
        .memWrite(MEM_WRITE),
        .memRead(MEM_READ),
        .readData(READ_DATA)
    );//
    
    mux32 RegWriteMux(
        .sel(MEM_TO_REG),
        .input1(READ_DATA),
        .input2(ALU_RES),
        .out(WRITE_DATA)
    );//
    
    Registers Registers(
        .reset(reset),
        .readReg1(INST[25:21]),
        .readReg2(INST[20:16]),
        .writeReg(WRITE_REG),
        .writeData(WRITE_DATA),
        .regWrite(REG_WRITE),
        .Clk(Clk),
        .readData1(READ_DATA1),
        .readData2(READ_DATA2)
    );//
    
    signext mainsignext(
        .inst(INST[15:0]),
        .data(IMM_SEXT),
        .reset(reset)//
    );
    
    inst_memory inst_memory(
        .reset(reset),
        .readAddress(PC),
        .inst(INST)
    );//

   wire [31:0] PC_4;
   wire [31:0] Branch_addr;
   wire [31:0] sel_Branch_addr;
   wire [31:0] Jump_addr;
   wire [31:0] next;
   wire [31:0] Sext_shift;
  
  assign PC_4=PC+4;
  assign Jump_addr={PC_4[31:28],INST[25:0]<<2};
  assign Sext_shift=IMM_SEXT<<2;
  assign Branch_addr= PC_4+Sext_shift;
  
  mux32 BranchMux(
    .sel(BRANCH & ZERO),
    .input1(Branch_addr),
    .input2(PC_4),
    .out(sel_Branch_addr)
  );
    
    mux32 JumpMux(
    .sel(JUMP),
    .input1(Jump_addr),
    .input2(sel_Branch_addr),
    .out(next)
    );
    
    always@(negedge Clk)
    begin
       if(reset)
         PC=0;
       else
        PC=next;
    end

    
endmodule
