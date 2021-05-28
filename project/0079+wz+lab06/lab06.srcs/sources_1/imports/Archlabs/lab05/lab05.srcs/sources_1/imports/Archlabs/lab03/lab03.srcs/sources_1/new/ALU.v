`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/04/24 11:19:04
// Design Name: 
// Module Name: ALU
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


module ALU(input1, input2, aluCtr, zero, aluRes,reset );
    input reset;
    input [31:0] input1;
    input [31:0] input2;
    input [3:0] aluCtr;
    output reg zero;
    output reg [31:0] aluRes;
    
    always @ (input1 or input2 or aluCtr or reset)
    begin
    
    if(reset)
    begin
        zero=0;
        aluRes=0;
    end
    else
    case(aluCtr)
    4'b0000://and
    begin
    aluRes=input1 & input2;
    end
    4'b0001://or
    begin
    aluRes=input1 | input2;
    end
    4'b0010://add
    begin
    aluRes=input1+input2;
    end
    4'b0110://sub
    begin
    aluRes=input1-input2;
    end
    4'b0111://slt
    begin
        if (input1<input2)
            aluRes=1;
        else
            aluRes=0;
    end
    4'b1100://nor
    begin
    aluRes=~(input1|input2);
    end
    default:
    begin
    aluRes=0;
    end
 endcase
  if (aluRes==0)
        zero=1;
    else
        zero=0;
    end
   
endmodule
