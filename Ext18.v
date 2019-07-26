`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/23 20:24:42
// Design Name: 
// Module Name: Ext18
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


module Ext18(
input [15:0] a,
output [31:0] b
);
assign b = {{(32 - 16){a[15]}},a,2'b00};
endmodule
