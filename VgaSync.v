`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/31 09:22:05
// Design Name: 
// Module Name: VgaSync
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


module VgaSync(
    input clk25,
    output [31:0] yPos,
    output [31:0] xPos,
    output valid,
    output reg hs,
    output reg vs
);

reg [10:0] yCounter;
reg [10:0] xCounter;

assign yPos = yCounter - 35;
assign xPos = xCounter - 144;
assign valid = (yCounter >= 35) && (yCounter < 515) &&
               (xCounter >= 144) && (xCounter < 784);//???????640*480
parameter xSyncEnd = 96;//???????????
parameter xMax = 800;//???????????
parameter yMax = 525;//???????????
parameter ySyncEnd = 2;//???????????
initial begin
  yCounter = 0;
  xCounter = 0;
end
always @(posedge clk25) begin
  if(xCounter == xMax - 1)
    xCounter <= 0;
  else
    xCounter <= xCounter + 1;
end

always @(posedge clk25) begin
  if(yCounter == yMax - 1)
    yCounter <= 0;
  else if(xCounter == xMax - 1)
    yCounter <= yCounter + 1;//?????????
  else
    yCounter <= yCounter;
end

always @(negedge clk25) begin
  if(xCounter == xSyncEnd)
    hs <= 1;
  else if(xCounter == 0)
    hs <= 0;
  else
    hs <= hs;
end

always @(negedge clk25) begin
  if(yCounter == ySyncEnd)
    vs <= 1;
  else if(yCounter == 0)
    vs <= 0;
  else
    vs <= vs;
end  
endmodule

