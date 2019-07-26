`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 14:58:25
// Design Name: 
// Module Name: mux3_5
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


module mux3_5(
input[4:0]a,
input[4:0]b,
input[4:0]c,
input[1:0]choose,
output reg [4:0]Mux3select
 );
 always@(*)
 begin
 case(choose)
 2'b00:Mux3select<=a;
 2'b01:Mux3select<=b;
 2'b10:Mux3select<=c;
 endcase
 end
endmodule
