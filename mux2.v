`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 14:17:32
// Design Name: 
// Module Name: mux2
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


module mux2(
input[31:0]a,
input[31:0]b,
input choose,
output reg [31:0]Mux2select
    );
    always @(*)
    begin
    if(choose==1)
      Mux2select=b;
    else
      Mux2select=a;

    end
endmodule
