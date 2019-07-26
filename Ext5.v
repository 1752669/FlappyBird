`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/23 20:24:05
// Design Name: 
// Module Name: Ext5
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


module Ext5 #(parameter WIDTH = 5)
(
input [WIDTH - 1:0] a,
output [31:0] b
);
assign b = {{(32 - WIDTH){1'b0}},a};
endmodule
