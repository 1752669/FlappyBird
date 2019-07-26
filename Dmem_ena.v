`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/11 16:47:04
// Design Name: 
// Module Name: Dmem_ena
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


module Dmem_ena(
    input [31:0]addr,
    input we,
    output ena
    );
assign ena = (we == 1'b1 & addr[31:28] == 4'b0);
endmodule
