`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/17 11:36:30
// Design Name: 
// Module Name: ALUCtr
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


module ALUCtr(
    input [1:0] ALUOp,
    input [5:0] Funct,
    output reg [3:0] ALUCtrOut
    );
    
    always @(ALUOp, Funct)
    begin
        casex({ALUOp,Funct})
            8'b00000000:ALUCtrOut=4'b0010;
            8'b01000000:ALUCtrOut=4'b0110;
            8'b10000000:ALUCtrOut=4'b0010;
            8'b10000010:ALUCtrOut=4'b0110;
            8'b10000100:ALUCtrOut=4'b0000;
            8'b10000101:ALUCtrOut=4'b0001;
            8'b10001010:ALUCtrOut=4'b0111;
        endcase
    end
endmodule


