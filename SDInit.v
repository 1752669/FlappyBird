`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/16 22:02:56
// Design Name: 
// Module Name: SDInit
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


module SDInit(
    input reset,
    input sdClock,
    
    input sdDataBack, // sd卡的返回命令，连过来
    output sdCs, // sd卡的片选
    output sdDataSent, // 送到sd卡的命令，按位
    output initialized
);

localparam cmd0 = {8'h40,8'h00,8'h00,8'h00,8'h00,8'h95};
localparam cmd8 = {8'h48,8'h00,8'h00,8'h01,8'haa,8'h87}; 
localparam cmd55 = {8'h77,8'h00,8'h00,8'h00,8'h00,8'hff};
localparam acmd41 = {8'h69,8'h40,8'h00,8'h00,8'h00,8'hff};


localparam sd_delay = 32'd0;
localparam sd_idle = 32'd1;
localparam send_cmd0 = 32'd2;
localparam wait_sd_01 = 32'd3;
localparam send_cmd8 = 32'd4;
localparam send_cmd55 = 32'd5;
localparam send_acmd41 = 32'd6;
localparam sd_middle_delay = 32'd7;
localparam wait_sd_5Bytes = 32'd8;
localparam wait_sd_00_for_acmd41 = 32'd9;
localparam wait_sd_01_for_cmd55 = 32'd10;
localparam initialize_complete = 32'd11;

reg [47:0] commandSend; // 待发送的命令
reg [39:0] commandBack; // 返回的指令，40位是由于R3需要5个字节
reg [31:0] state;


/// 延迟模块
reg [31:0] delayCount;
reg [31:0] middleDelayCount;
wire isSendingCommand;

/// sdDataSent的控制与commandSent
assign isSendingCommand = state == send_cmd0 | state == send_cmd8 | state == send_cmd55 | state == send_acmd41;
assign sdDataSent = isSendingCommand ? commandSend[47] : 1'b1;

always @(negedge sdClock) begin
    if (isSendingCommand)
        commandSend <= {commandSend[46:0], 1'b0}; // 不断移位
    else commandSend <= commandSend;
end


/// sdDataBack的接受与commandBack
always @(negedge sdClock) begin
    commandBack <= {commandBack[38:0], sdDataBack};
end


/// 状态机状态的变化以及寄存器装载
always @(negedge sdClock) begin
    case (state)
    sd_delay: begin
        if (delayCount >= 300) begin
            state <= send_cmd0;
            commandSend <= cmd0; // 填充commandSent，准备发送cmd0
        end else begin
            delayCount <= delayCount + 1;
            state <= state;

        end
    end
    send_cmd0: begin
        // 采用移位输出的格式，因此commandSent变成0的时候代表发送结束。
        if (commandSend == 48'd0) state <= wait_sd_01;
        else state <= state;
    end
    wait_sd_01: begin
        if (commandBack[39:32] == 8'h01) state <= sd_idle;
        else state <= state;
    end
    sd_idle: begin
        state <= sd_middle_delay;
    end
    sd_middle_delay: begin
        if (middleDelayCount >= 300) begin
            commandSend <= cmd8;
            state <= send_cmd8;
        end else begin
            middleDelayCount <= middleDelayCount + 1;
            state <= state;
        end
    end
    send_cmd8: begin
        if (commandSend == 48'd0) state <= wait_sd_5Bytes;
        else state <= state;
    end
    wait_sd_5Bytes: begin
        if (commandBack == 40'h00_00_00_01_00) begin
            commandSend <= cmd55;
            state <= send_cmd55;
        end else state <= state;
    end
    send_cmd55: begin
        if (commandSend == 48'd0) state <= wait_sd_01_for_cmd55;
        else state <= state;
    end
    wait_sd_01_for_cmd55: begin
        if (commandBack[39:32] == 8'h01) begin
            commandSend <= acmd41;
            state <= send_acmd41;
        end else state <= state;
    end
    send_acmd41: begin
        if (commandSend == 48'd0) state <= wait_sd_00_for_acmd41;
        else state <= state;
    end
    wait_sd_00_for_acmd41: begin
        if (commandBack[39:32] == 8'h00) begin
            state <= initialize_complete;
        end else state <= state;
    end
    endcase
end

assign initialized = state == sd_idle;


/// 状态机下的组合逻辑，控制信号的发出
assign sdCs = state == sd_delay | state == sd_middle_delay | state == initialize_complete;


/// 复位
always @(negedge sdClock or posedge reset) begin
   if (reset) begin
        commandSend = 48'd0;
        commandBack = 40'd0;
        state = sd_delay;
        delayCount = 32'd0;
        middleDelayCount = 32'd0;
   end
end

endmodule
