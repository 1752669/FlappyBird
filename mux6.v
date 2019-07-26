`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/23 20:21:30
// Design Name: 
// Module Name: mux6
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


module mux6(
input[31:0]a,
input[31:0]b,
input[31:0]c,
input[31:0]d,
input[31:0]e,
input[31:0]f,
input[2:0]choose,
output reg [31:0]Mux6select
    );
    always@(*)
    begin
      case(choose)
      3'b000:Mux6select<=a;
      3'b001:Mux6select<=b;
      3'b010:Mux6select<=c;
      3'b011:Mux6select<=d;
      3'b100:Mux6select<=e;
      3'b101:Mux6select<=f;
      endcase
    end
endmodule
