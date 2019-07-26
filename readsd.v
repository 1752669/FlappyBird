`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/18 15:54:34
// Design Name: 
// Module Name: readsd
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


module readsd(
     input sd_clk,              
     output sd_Data_IR,             
     input init,                  //初始化完成信号 
     input [31:0] sec,            //SD 卡的sec地址       
     input read_req,              //SD 卡数据读请求信号 
     output [7:0]DateOut,     //SD 卡读出的数据                             
     output valid,          //数据有效信号       
     output sdCs,  
     output  data_signal,     //SD 卡数据读出指示信号
     input  sdDateBack,                               
     output [3:0] state,       
     output read_complete 
    );    
SD_read uut(
    .SD_clk(sd_clk),       
    .SD_cs(sdCs),       
    .SD_datain(sd_Data_IR),       
    .SD_dataout(sdDateBack),             
    .sec(sec),            //SD 卡的sec地址       
    .read_req(read_req),              //SD 卡数据读请求信号 
    .mydata_o(DateOut),    //SD 卡读出的数据                             
    .myvalid_o(valid),        //数据有效信号       
    .data_come(data_signal),        //SD 卡数据读出指示信号          
    .init(init),                   //初始化完成信号  
    .mystate(state),       
    .read_o(read_complete)  
);
endmodule
