`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/23 20:22:11
// Design Name: 
// Module Name: PC_Reg
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


module PC_Reg #(parameter startAddress = 32'h00400000)
(
input clk,rst,ena,
input [31:0]data_in,
output reg [31:0] data_out
);

always@(posedge clk or posedge rst )
begin
if (rst)
data_out <= startAddress;
else if (ena)
data_out <= data_in;
else
data_out <= data_out;
end

endmodule
