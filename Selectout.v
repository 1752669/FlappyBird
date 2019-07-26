`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/12 10:30:58
// Design Name: 
// Module Name: Selectout
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


module Selectout(
    input [31:0]dmemout,
    input [31:0]vgaout,
    input [31:0]segout,
    input [31:0]buttonOut,
    input [31:0]sd_out,
    input [31:0]addr,
    output reg [31:0]Select
    );
always @(*)
begin
  case(addr[31:28])
  4'b0000:Select = dmemout;
  4'b0001:Select = vgaout;
  4'b0011:Select = segout;
  4'b0100:Select = buttonOut;
  4'b1000:Select = sd_out;
  endcase
end

endmodule
