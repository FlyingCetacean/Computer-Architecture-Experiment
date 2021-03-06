`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/24 11:39:22
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb( );
    reg [31:0] input1;
    reg [31:0] input2;
    reg [3:0] aluCtr;
    wire zero;
    wire [31:0] aluRes;
    
    ALU uo (
        .input1(input1),
        .input2(input2),
        .aluCtr(aluCtr),
        .zero(zero),
        .aluRes(aluRes) );
    
    initial begin
        aluCtr=0;
        input1=0;
        input2=0;
        
        
        #100 input1=15;input2=10;aluCtr=4'b0000;
        #100 aluCtr=4'b0001;
        #100 aluCtr=4'b0010;
        #100 aluCtr=4'b0110;
        #100 input1=10;input2=15;aluCtr=4'b0110;
        #100 input1=15;input2=10;aluCtr=4'b0111;
        #100 input1=10;input2=15;aluCtr=4'b0111;
        #100 input1=1;input2=1;aluCtr=4'b1100;
        #100 input1=16;input2=1;aluCtr=4'b1100;
        end
endmodule
