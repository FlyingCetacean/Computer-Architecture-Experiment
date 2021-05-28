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
    input reset,
    input [31:0] address,
    input [31:0] writeData,
    input memWrite,
    input memRead,
    output reg [31:0] readData
    );
    reg [7:0] memFile[0:31];
    
  //  integer i=0;
    
    initial begin
   
      $readmemh("C:/Archlabs/lab06/data.txt",memFile);
      readData=0;
    end
   // 
    always@ (memRead, address,reset)
    begin
        if (reset)
            readData=0;
        else if(memRead)
            readData={memFile[address+3], memFile[address+2], memFile[address+1], memFile[address]};
            else
                readData=0;
    end
    
     always @(negedge Clk)
     begin
       if(memWrite==1'b1)
        begin
            memFile[address]=writeData[7:0];
            memFile[address+1]=writeData[15:8];
            memFile[address+2]=writeData[23:16];
            memFile[address+3]=writeData[31:24];
        end
     end
endmodule
