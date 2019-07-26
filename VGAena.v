`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/11 17:05:33
// Design Name: 
// Module Name: VGAena
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


module VGAena(
    input clk,
    input clk25,
    input [31:0] addr,
    input [31:0] wdata,
    input we,
    output hs,
    output vs,
    output ena,
    output reg [31:0] Vgaout,
    output  [11:0] rgb 
);
assign ena = (we == 1'b1 & addr[31:28] == 4'b0001 );

reg [31:0] xPipe0; //管子左边沿
reg [31:0] xPipe1;
reg [31:0] yPipe0; //管子的右边沿
reg [31:0] yPipe1;
reg [31:0] yBird; //正方形下底

wire [31:0] yPos;
wire [31:0] xPos;
wire valid;
always @(posedge clk) begin
    if(ena & addr[15:0] ==16'h0000)
        xPipe0 <= wdata;
    else if(ena & addr[15:0] ==16'h0004)
        xPipe1 <= wdata;
    else if(ena & addr[15:0] ==16'h0008)
        yPipe0 <= wdata;
    else if(ena & addr[15:0] ==16'h000c)
        yPipe1 <= wdata;
    else if(ena & addr[15:0] ==16'h0010)
        yBird <= wdata; 
   end

always @(*) begin
    case(addr[15:0])
    16'h0000: Vgaout = xPipe0;
    16'h0004: Vgaout = xPipe1;
    16'h0008: Vgaout = yPipe0;
    16'h000c: Vgaout = yPipe1;
    16'h0010: Vgaout = yBird;
    default : Vgaout = 32'hzzzzzzzz;
    endcase
end
VgaSync uut2(
  .clk25(clk25),
  .yPos(yPos),
  .xPos(xPos),
  .valid(valid),
  .hs(hs),
  .vs(vs)
  );
VgaColor uut3(
 .valid(valid),
 .xPos(xPos),
 .yPos(yPos),
 .xPipe0(xPipe0), 
 .xPipe1(xPipe1),
 .yPipe0(yPipe0),
 .yPipe1(yPipe1),
 .yBird(yBird), 
 .rgb(rgb)
);
endmodule
