`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/22 02:54:05
// Design Name: 
// Module Name: Top_tb
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


module Top_tb();

    reg clk;
    reg reset;
    
    always #4 clk=!clk;   
    Top u0(
        .clk(clk),
        .reset(reset)
    );
    initial begin
        clk=1;
        reset=1;
        #10
        reset=0;
        #2000;       
    end
endmodule
