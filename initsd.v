`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/18 13:36:18
// Design Name: 
// Module Name: initsd
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


module initsd(
    input reset,//重置信号
    input sd_clk,//时钟
    input sdDataBack,//sd卡的返回命令，连过来
    output sdCs,// sd卡的片选
    output sd_Data_IR,//送到sd卡的命令， 按位
    output initialized,
    output [47:0] commandBack
    );
    wire [3:0] state;
    SD_init uut(
    .rst_n(reset), 
    .SD_clk(sd_clk), 
    .SD_cs(sdCs), 
    .SD_datain(sd_Data_IR), 
   .SD_dataout(sdDataBack),
   .rx(commandBack),  
    .init_o(initialized), 
    .state(state));
endmodule
