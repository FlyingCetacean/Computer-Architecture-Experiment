`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/15 11:41:09
// Design Name: 
// Module Name: dataMemory
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


module dataMemory(
    input Clk,
    input [31:0] address,
    input [31:0] writeData,
    input memWrite,
    input memRead,
    output reg [31:0] readData
    );
    reg [31:0] memFile[63:0];
    
    integer i=0;
    
    initial begin
        for(i=0;i<32;i=i+1)
        begin
            memFile[i]=0;
        end
    end
    
    always@ (memRead, address)
    begin
        readData=memFile[address];
    end
    
     always @(negedge Clk)
     begin
        if(memWrite==1'b1)
        begin
            memFile[address]=writeData;
        end
     end
endmodule
