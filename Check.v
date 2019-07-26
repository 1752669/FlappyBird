`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/31 09:22:05
// Design Name: 
// Module Name: Check
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


module Check(
    input clk,
    input clk1_s,
    input reset,enable,pause,
    input [10:0] yBird,
    input [10:0] xPipe0,
    input [10:0] xPipe1,
    input [10:0] yPipe0,
    input [10:0] yPipe1,
    output reg dead,reg[31:0]current_score,
    output reg [15:0]light
    
);

parameter xBirdWid = 30;
parameter yBirdHeight = 40;
//左边沿，(xBird, yBird)为左下角
parameter xBird = 80;
parameter xPipeWid = 30;
parameter yPipeGap = 140;//上下管道的间距

always @(posedge clk) begin
  //两根柱子
  if(xBird + xBirdWid + xPipeWid > xPipe0 && xBird < xPipe0
  && (yBird > yPipe0 || yBird + yPipeGap < yPipe0 + yBirdHeight))
    dead <= 1;
  else if(xBird + xBirdWid + xPipeWid > xPipe1 && xBird < xPipe1
  && (yBird > yPipe1 || yBird + yPipeGap < yPipe1 + yBirdHeight))
    dead <= 1;

  //屏幕上下底?
  else if(yBird >= 480 || $signed(yBird) < yBirdHeight)//0是屏幕的最上方（上下边界）
    dead <= 1;
  else
    dead <= 0;
end
reg xChanged = 1;

//分数
always @(posedge clk or posedge reset)
 begin
 if(reset)
   current_score=0;
else
if(enable)
begin
if(!pause)
begin
if((xBird == xPipe0 || xBird == xPipe1) && xChanged)
 begin
   xChanged <= 0;
   current_score<= current_score + 1;
 end
 else 
 if((xBird == xPipe0 + 1 || xBird == xPipe1 + 1) && !xChanged)
   xChanged <= 1;
   end
   else
      if(pause)
    current_score<= current_score;
   end
   end
initial
begin
light=0;
end
always@(posedge clk1_s or posedge reset)
begin
if(reset)
light=0;
else
begin
if(enable)
begin
if(!pause)
begin
if(!dead)
begin
light=light+1;
end
else
light=light;
end
end
end
end
endmodule
