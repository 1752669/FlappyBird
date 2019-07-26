`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/12 10:42:32
// Design Name: 
// Module Name: segena
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


module segena(
    input clk,
	input reset,
	input cs,
    input [31:0] addr,
    input [31:0] wdata,
    input we,
    output reg [31:0]idata,
    output ena,
    output reg [31:0]segout,
    output [7:0] o_seg,
	output [7:0] o_sel
    );
    assign ena = (we == 1 & addr[31:28] == 4'b0011 );
   always @(posedge clk)
   begin
     if(ena == 1)
     begin
     idata  <= wdata;
     segout <= wdata;
     end
     else
      begin
     idata <= idata;
     segout <= idata;
      end
     end
  seg  seg7(
     .clk(clk),
	 .reset(reset),
	 .cs(cs),
	 .i_data(idata),
	 .o_seg(o_seg),
	 .o_sel(o_sel)
    );

endmodule
