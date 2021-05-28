`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/20 12:00:40
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
    reg Clk;
    reg reset;
    always #20 Clk=!Clk;
    Top uo(
        .Clk(Clk),
        .reset(reset) );    
    initial begin
    Clk=1;
    reset=1;
    #10
    reset=0;
    #2000;
    end
endmodule
