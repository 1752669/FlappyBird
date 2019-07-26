`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/31 11:12:36
// Design Name: 
// Module Name: ClockDivider
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


module ClockDivider(
    input clk,
    output clk25
    // output clk01_ms,
    // output clk5_ms,
    // output clk10_ms,
    // output clk100_ms,
    // output clk1_s,
    // output clk2_s
);

reg [31:0] q = 0;
always @(posedge clk)
 q <= q + 1;
assign clk25 = q[1]; //25Mhz     //�൱���������ķ�Ƶ
// assign clk01_ms=q[13];//1000hz
// assign clk5_ms = q[18];//200hz
// assign clk10_ms=q[19];//100hz
// assign clk100_ms=q[23];//10hz
// assign clk1_s = q[25];//1hz
// assign clk2_s = q[26];//0.5hz
endmodule
