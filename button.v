`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/12 21:21:10
// Design Name: 
// Module Name: button
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


module button(
    input clk,
    input pause,
    input jump,
    input start,
    input we,
    output ena,
    input [31:0]addr,
    output [31:0]buttonOut
    );
   reg  pause_ena ;
   reg  jump_ena ;
   reg  start_ena;
    
   reg  pause_end ;
   reg  jump_end ;
   reg  start_end;

   reg  [32:0]clk_nt;
initial 
begin
  pause_ena = 0;
  jump_ena = 0;
  start_ena = 0;
  clk_nt = 0;
  end
    assign buttonOut = {29'b0,start_ena,pause_ena,jump_ena};
  always @(posedge clk)
  begin
 if(clk_nt == 2)
 begin
  clk_nt <= 0;
  pause_end <= pause;
  jump_end <= jump;
  start_end <= start; 
 if(pause_end == 0 & pause == 1)
    pause_ena <= 1;
else if(jump_end == 0 & jump == 1)
    jump_ena <= 1;
else if(start_end == 0 & start == 1)
    start_ena <= 1;
 else if(pause_end == 1 & pause == 0)
   pause_ena <= 0;
else if(jump_end == 1 & jump == 0)
   jump_ena <= 0;
else if(start_end == 1 & start == 0)
   start_ena <= 0;
end
else 
begin 
clk_nt <= clk_nt+1;
end 
end 
endmodule
