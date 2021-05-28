`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/17 09:50:27
// Design Name: 
// Module Name: Ctr_tb
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


module Ctr_tb();
    reg [5:0] OpCode; 
    wire regDst;
    wire aluSrc;
    wire memToReg;
    wire regWrite;
    wire memRead;
    wire memWrite;
    wire branch;
    wire [1:0] aluOp;
    wire jump;
    
    Ctr u0 (
        .OpCode(OpCode),
        .regDst(regDst),
        .aluSrc(aluSrc),
        .memToReg(memToReg),
        .regWrite(regWrite),
        .memRead(memRead),
        .memWrite(memWrite),
        .branch( branch),
        . aluOp( aluOp),
        .jump(jump)
        );
        
    initial begin
        OpCode=0;
        #100;
        
        #100 OpCode=6'b000000;
        #100 OpCode=6'b100011;
        #100 OpCode=6'b101011;
        #100 OpCode=6'b000100;
        #100 OpCode=6'b000010;
        #100 OpCode=6'b010101;
        end
endmodule
