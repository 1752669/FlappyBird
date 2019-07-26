`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/18 19:58:52
// Design Name: 
// Module Name: sdControl
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


module sdControl(
    input [31:0]addr,
    input read_req,
    input reset,
    input clock,
    output sd_clk,
    input sdDataBack,
    output sd_Data_IR,
    output sdCs,
    output initialized,
    output read_complete,
    output [31:0]sd_out
    );
top1 uut(
    .addr(addr),
    .read_req(read_req),
    .reset(reset),
    .clock(clock),
    .sd_clk(sd_clk),
    .sdDataBack(sdDataBack),
    .sd_Data_IR(sd_Data_IR),
    .sdCs(sdCs),
    .initialized(initialized),
    .read_complete(read_complete),
    .sd_out(sd_out)
);
endmodule
