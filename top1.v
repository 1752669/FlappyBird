`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/18 00:03:36
// Design Name: 
// Module Name: top1
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


module top1(
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
reg [31:0] counter = 32'd0;
always @(posedge clock) begin
    counter <= counter + 1'b1;
end
assign sd_clk = counter[7];

wire [3:0] state;
wire [47:0] commandBack;
wire [47:0] commandSend;
wire sdCs1;
wire sd_Data_IR1;
initsd init (
    .reset(reset),
    .sd_clk(sd_clk),
    .sdDataBack(sdDataBack), // sd卡的返回命令，连过来
    .sdCs(sdCs1), // sd卡的片选
    .sd_Data_IR(sd_Data_IR1), // 送到sd卡的命令，按位
    .initialized(initialized),
    .commandBack(commandBack)
);

wire valid;
wire sd_Data_IR2;
wire [7:0]dataOut;
wire sdCs2;
wire data_signal;
reg  [31:0]sec = 16640 ;
readsd read(
    .sd_clk(sd_clk),              
    .sd_Data_IR(sd_Data_IR2),                           
    .init(initialized),              //初始化完成信号 
    .sec(sec), 
    .read_req(read_req),
    .DateOut(dataOut),     //SD 卡读出的数据  
    .valid(valid),                                  
    .sdCs(sdCs2),  
    .data_signal(data_signal),
    .sdDateBack(sdDataBack),                          
    .state(state),       
    .read_complete(read_complete)
);
reg [7:0]data[0:10];
reg [31:0] addrCount;
assign sd_out = data[addr[15:2]];

always @(posedge sd_clk) begin
if(addrCount <= 10) begin
    if(valid)begin
        data[addrCount] <= dataOut;
        addrCount <= addrCount + 1;
    end
end
end

assign sd_Data_IR = initialized ? sd_Data_IR2 :sd_Data_IR1;
assign sdCs = initialized ? sdCs2 : sdCs1;


endmodule
 