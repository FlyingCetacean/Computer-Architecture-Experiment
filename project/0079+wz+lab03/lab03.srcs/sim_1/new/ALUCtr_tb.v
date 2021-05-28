`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/17 11:45:40
// Design Name: 
// Module Name: ALUCtr_tb
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


module ALUCtr_tb();
     reg [1:0] ALUOp;
     reg [5:0] Funct;
     wire [3:0] ALUCtrOut;
     
     ALUCtr u0(
        .ALUOp(ALUOp),
        .Funct(Funct),
        .ALUCtrOut(ALUCtrOut)
        );
    
     initial begin
        ALUOp=0;
        Funct=0;
        #100;
        
       #100 ALUOp=2'b00;Funct=6'b000000;
       #100 ALUOp=2'b01;Funct=6'b000000;
       #100 ALUOp=2'b10;Funct=6'b000000;
       #100 ALUOp=2'b10;Funct=6'b000010;
       #100 ALUOp=2'b10;Funct=6'b000100;
       #100 ALUOp=2'b10;Funct=6'b000101;
       #100 ALUOp=2'b10;Funct=6'b001010;
       
        end
endmodule
