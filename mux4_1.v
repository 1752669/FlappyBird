`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/23 20:20:10
// Design Name: 
// Module Name: mux4_1
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


module mux4_1(
    input[31:0]Yout,
    input [31:0]RSout,
    input [31:0]IIout,
    input [31:0]ext_addrout,
    input [1:0]choose,
    output reg [31:0]Mux4_1select
);
always @(*)
begin
  case (choose)
  2'b00:Mux4_1select<=Yout;
  2'b01:Mux4_1select<=RSout;
  2'b10:Mux4_1select<=IIout;
  2'b11:Mux4_1select<=ext_addrout;
  endcase
end
endmodule
