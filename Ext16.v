`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/23 20:24:25
// Design Name: 
// Module Name: Ext16
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


module Ext16#(parameter WIDTH = 16)
(
input [WIDTH - 1:0] a, 
input sext, //1表示有符号 
output [31:0] b 
); 
assign b = sext ? {{(32 - WIDTH){a[WIDTH - 1]}},a} : {{(32 - WIDTH){1'b0}},a};
endmodule
