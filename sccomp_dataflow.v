`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/06/03 15:45:20
// Design Name: 
// Module Name: sccomp_dataflow
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


module sccomp_dataflow
(
    input clk_in,
    input reset,
    input jump,
    input pause,
    input start,
    output [11:0]rgb, 
    output hs,
    output vs,
    output [7:0]o_seg,
    output [7:0]o_sel,
    input read_req,
    output sd_clk,
    input sdDataBack,
    output read_complete,
    output initialized,
    output sd_Data_IR,
    output sdCs
 );
wire    [2:0]state;
wire    [31:0]pcOut;
wire    dMemWena;
wire    [2:0]dMemControl;
wire [31:0] instruction, dMemOut;
wire [31:0] YOut, rtOut, iROut;
wire clk25;
wire [31:0]idata;
wire [31:0]segout;
wire [31:0]sout;
wire ena;
wire clk2s;
_CPU54 sccpu(.clock(clk25), .reset(reset), .out(sout), .instruction(instruction), .dMemControl(dMemControl), .dMemWena(dMemWena), .iROut(iROut), .state(state), .pcOut(pcOut), .YOut(YOut), .rtOut(rtOut));
segena segena7(.clk(clk_in),.reset(reset),.cs(1),.addr(YOut),.wdata(rtOut),.we(dMemWena),.idata(idata),.ena(ena),.segout(segout),.o_seg(o_seg),.o_sel(o_sel));
clk_diliver uut0(.clk(clk_in),.clk25(clk25),.clk2s(clk2s));
dmem dMem(clk25,dMemWena,YOut,YOut,rtOut,dMemControl,dMemOut);
imem iMem(pcOut[12:2], instruction);
//vga 
   wire ena2;
   wire [31:0]Vgaout;
 VGAena  vga( 
    .clk(clk_in),
    .clk25(clk25),
    .addr(YOut),
    .wdata(rtOut),
    .we(dMemWena),
    .hs(hs),
    .vs(vs),
    .ena(ena2),
    .Vgaout(Vgaout),
    .rgb(rgb)
    );
    //选择器
   wire [31:0]buttonOut;
   wire [31:0] sd_out;
 Selectout select2(
    .dmemout(dMemOut),
    .vgaout(Vgaout),
    .segout(segout),
    .buttonOut(buttonOut),
    .sd_out(sd_out),
    .addr(YOut),
    .Select(sout)
    );
    //按钮
    wire ena1;
    button button1(
    .clk(clk_in),
    .pause(pause),
    .jump(jump),
    .start(start),
    .we(dMemWena),
    .ena(ena1),
    .addr(YOut),
    .buttonOut(buttonOut)
    );
sdControl sd(
   .addr(Yout),
   .read_req(read_req),
   .reset(reset),
   .clock(clk_in),
   .sd_clk(sd_clk),
   .sdDataBack(sdDataBack),
   .sd_Data_IR(sd_Data_IR),
   .sdCs(sdCs),
   .initialized(initialized),
   .read_complete(read_complete),
   .sd_out(sd_out)
);
endmodule
