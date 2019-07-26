`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/23 20:21:11
// Design Name: 
// Module Name: mux5
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


module mux5(
input[31:0]a,
input[31:0]b,
input[31:0]c,
input[31:0]d,
input[31:0]e,
input[2:0]choose,
output reg  [31:0]Mux5select
    );
    always@(*)
    begin
      case(choose)
      3'b000:Mux5select<=a;
      3'b001:Mux5select<=b;
      3'b010:Mux5select<=c;
      3'b011:Mux5select<=d;
      3'b100:Mux5select<=e;
      endcase
    end
endmodule
