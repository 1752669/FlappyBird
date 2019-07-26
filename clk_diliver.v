`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/06/09 08:21:13
// Design Name: 
// Module Name: clk_diliver
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


module clk_diliver(
    input clk,
   output clk25,
   output clk2s
);
 
reg [31:0] q = 0;

always @(posedge clk)
  q <= q + 1;
 assign clk25 = q[1];
 assign clk2s = q[2];

endmodule

 