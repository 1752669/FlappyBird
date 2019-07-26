`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 11:24:21
// Design Name: 
// Module Name: multy
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


module multy(
    input [31:0]a,
    input [31:0]b,
    input isSigned,
    output[63:0]z
);

assign z = isSigned ? $signed(a)*$signed(b):a*b;

endmodule
