`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/18 14:49:13
// Design Name: 
// Module Name: signext
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


module signext(
    input [15:0] inst,
    input reset,
    output reg [31:0] data
    );
    always@(inst)
    begin
        if(inst[15] == 0)
        assign data = {16'b0000000000000000,inst};
        
        else if(inst[15] ==1)
        assign data = {16'b1111111111111111,inst};
    end
endmodule
