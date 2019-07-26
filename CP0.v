`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/03 13:55:45
// Design Name: 
// Module Name: CP0
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



module CP0 (
		input clk, 
		input rst, 
		input mfc0,  // CPU指令Mfc0 
		input mtc0, // CPU指令Mtc0 
		input [31:0]pc, 
		input [4:0] Rd, // 指定CP0寄存器
		input [31:0] wdata, // 数据从GP寄存器到CP0寄存器
		input exception, 
		input [4:0]cause, 
		input eret, // 指令ERET (Exception Return) 
		output [31:0] rdata,      //数据从CP0寄存器到GP寄存器 
		output [31:0] status, 
		output [31:0] exc_addr,//中断程序PC的起始地址
		output reg exceptionValid,
		input mustException //
);

reg [31:0] registers[0:31];
integer i;
// 寄存器读取
assign rdata = mfc0 ? registers[Rd] : 32'bz;
assign status = registers[12];
assign exc_addr = registers[14];

localparam syscall = 4'b1000;
localparam break = 4'b1001;
localparam teq = 4'b1101;

always @(*) begin
    // status寄存器首位为1时允许中断
    if (exception && registers[12][0]) begin
        if (cause[3:0] == syscall && registers[12][1] == 1'b1)
            exceptionValid = 1'b1;
        else if (cause[3:0] == break && registers[12][2] == 1'b1)
            exceptionValid = 1'b1;
        else if (cause[3:0] == teq && registers[12][3] == 1'b1)
            exceptionValid = 1'b1;
        else
            exceptionValid = 1'b0;
    end else begin
        exceptionValid = 1'b0;
    end
end

// 寄存器修改
always @(posedge clk or posedge rst) begin
    if (rst) 
    begin
        for (i = 0; i < 32; i = i + 1)
         begin
            registers[i] <= 0;
         end
        registers[12] <= 32'h0000000f;
    end else if (mtc0) begin
        registers[Rd] <= wdata;
    end else if (mustException) begin
        registers[12] <= registers[12] << 5;
        registers[13] <= {25'b0, cause, 2'b0};
        registers[14] <= pc - 32'd4;
    end else if (eret) begin
        registers[12] <= registers[12] >> 5;
    end
end

endmodule
