`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/20 11:37:46
// Design Name: 
// Module Name: inst_memory
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


module inst_memory(
    input reset,
    input [31:0] readAddress,
    output reg [31:0] inst
    );
    reg [7:0]instMemFile[0:63];
    initial begin
    
   $readmemb("C:/Archlabs/lab06/inst1.txt",instMemFile);
    
    
     end 
    always@(readAddress or reset)
    begin
        if(reset)
            inst=0;
        else
            inst ={ instMemFile[readAddress+3],instMemFile[readAddress+2],
            instMemFile[readAddress+1], instMemFile[readAddress] };
    end
    
endmodule
