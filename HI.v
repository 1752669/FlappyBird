`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/24 14:30:09
// Design Name: 
// Module Name: HI
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


module HI#(parameter startAddress = 32'h00000000)
(input clk,rst,ena,
input [31:0]data_in,
output reg [31:0] data_out
);

always@(posedge clk or posedge rst)
begin
if (rst)
data_out <= startAddress;
else if (ena)
data_out <= data_in;
else
data_out <= data_out;
end
endmodule

