`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/21 21:48:55
// Design Name: 
// Module Name: mux5
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


module mux32(
    input sel,
    input [31:0] input1,
    input [31:0] input2,
    output [31:0] out
    );
    
    assign out = sel?input1:input2;
endmodule
