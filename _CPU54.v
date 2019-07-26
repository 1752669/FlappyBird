`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 11:47:56
// Design Name: 
// Module Name: _CPU54
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


module _CPU54(
    input clock,
    input  reset,
    input [31:0] out,
    input [31:0] instruction,
    input intr,
    output [2:0]dMemControl,
    output dMemWena,
    output [31:0]iROut,
    output [2:0] state,
    output [31:0] pcOut,
    output [31:0] YOut,
    output [31:0] rtOut
);

wire [1:0] mux4Select;
wire [2:0] mux6Select;
wire [1:0] mux3_1Select, mux3_2Select;
wire [2:0] mux5Select;
wire [1:0] mux3_3Select, mux3_4Select, mux3_5Select;

wire [31:0] mux4Out, rsOut, iiOut, cp0Exc;
mux4_1 mux4(YOut, rsOut, iiOut, cp0Exc, mux4Select,mux4Out);

wire [31:0] mux6Out, loOut, hiOut, cp0DataOut;
mux6 mux6(YOut, out, pcOut, loOut, hiOut, cp0DataOut, mux6Select,mux6Out);

wire [4:0] mux3_1Out;
mux3_5  mux3_1(iROut[15:11], iROut[20:16], 5'd31,mux3_1Select, mux3_1Out);

wire [31:0] ext5Out, mux3_2Out;
mux3 mux3_2(pcOut, rsOut, ext5Out, mux3_2Select,mux3_2Out);

wire [31:0] ext16Out, ext18Out, mux5Out;
mux5 mux5(32'd4, rtOut, ext16Out, ext18Out, 32'b0, mux5Select, mux5Out);

wire [63:0] dividerYOut, multiplyYOut;
wire [31:0] mux3_3Out;
mux3 mux3_3(dividerYOut[63:32], rsOut, multiplyYOut[63:32],  mux3_3Select,mux3_3Out);

wire [31:0] mux3_4Out;
mux3 mux3_4(dividerYOut[31:0], rsOut, multiplyYOut[31:0],  mux3_4Select,mux3_4Out);

wire [4:0] mux3_5Out;
mux3_5  mux3_5(5'b01001, 5'b01000, 5'b01101, mux3_5Select,mux3_5Out);

// PC -> (in, out, clk, rst, ena)
wire pcEnable;
wire [31:0] mux2_2Out;
PC_Reg #(. startAddress(32'h00400000)) pcReg(clock, reset, pcEnable, mux2_2Out, pcOut);

wire iREnable;
IR iR( clock, reset, iREnable,instruction, iROut);

// (in, out)
wire ext16Signed;
Ext5 ext5(iROut[10:6], ext5Out);
Ext16 ext16(iROut[15:0], ext16Signed, ext16Out);
Ext18 ext18(iROut[15:0], ext18Out);

// (clk, rst, wena, ov, rsAddr, rtAddr, waddr, wdata, rs, rt)
wire regFilesWEna, overflow;
wire [31:0] mux2Out;
Regfiles cpu_ref(clock, reset, regFilesWEna, overflow, iROut[25:21], iROut[20:16], mux3_1Out, mux2Out, rsOut, rtOut);

// (a, b, out, aluc, zero, carry, negative, overflow)
wire [4:0] aluControl;
wire [31:0] aluOut;
wire zero, carry, negative;
alu alu(mux3_2Out, mux5Out, aluControl,aluOut, zero, carry, negative, overflow);

// (in, out, clk, rst, ena)
wire YEnable;
Y y( clock, reset, YEnable,aluOut, YOut);

ii II(pcOut[31:28], iROut[25:0], iiOut);

wire dividerSigned;
wire [63:0] dividerOut;
divider divider(rsOut, rtOut, dividerSigned, dividerOut);

// (in, out, clk, rst, ena)
wire divYEnable;
dividerY  dividerY( clock, reset, divYEnable,dividerOut, dividerYOut);

// c = a * b -> (a, b, signed, c)
wire multiplySigned;
wire [63:0] multiplyOut;
multy multiply(rsOut, rtOut, multiplySigned, multiplyOut);

// (in, out, clk, rst, ena)
wire multYEnable;
multyY  multiplyY( clock, reset, multYEnable,multiplyOut, multiplyYOut);

// Special Registers
wire hiEna, loEna;
HI hi(clock, reset, hiEna,mux3_3Out, hiOut);
LO lo(clock, reset, loEna,mux3_4Out, loOut);
// CP0 -> (clk, rst, control, pc, waddr, wdata, exc, cause, rdata, status, exc_addr)
wire mfc0;
wire mtc0;
wire eret;
wire mustException;
wire exception, exceptionValid;
wire [31:0] status;
CP0 cp0(clock, reset, mfc0, mtc0, pcOut, iROut[15:11], rtOut, exception, mux3_5Out,  eret, cp0DataOut, status, cp0Exc, exceptionValid, mustException);

// decoding
wire [53:0] _inst;
inst decoder(iROut, _inst);

// controller
wire mux2Select, mux2_2Select;
control controller (
    .clk(clock),
    .reset(reset),
    .inst(_inst),
    .Y(YOut),
    .PC_enable(pcEnable),
    .Regfiles_wena(regFilesWEna),
    .IR_wena(iREnable),
    .Y_ena(YEnable),
    .alu_control(aluControl),
    .dmem_control(dMemControl),
    .dmem_wena(dMemWena),
    .divYena(divYEnable),
    .multYena(multYEnable),
    .dividerSigned(dividerSigned),
    .multiplySigned(multiplySigned),
    .HI_ena(hiEna),
    .LO_ena(loEna),
    .mfc0(mfc0),
    .mtc0(mtc0),
    .eret(eret),
    .exception(exception),
    .ext16Signed(ext16Signed),
    .mux2(mux2Select),
    .mux2_2(mux2_2Select),
    .mux4(mux4Select),
    .mux6(mux6Select),
    .mux5(mux5Select),
    .mux3_1(mux3_1Select),
    .mux3_2(mux3_2Select),
    .mux3_3(mux3_3Select),
    .mux3_4(mux3_4Select),
    .mux3_5(mux3_5Select),
    .exceptionValid(exceptionValid),
    .mustException(mustException),
    .state(state)
);

// 增加一个Mux2，为了能让mul指令工作
mux2  mux2(mux6Out, multiplyYOut[31:0], mux2Select,mux2Out);

mux2 mux2_2(mux4Out, 32'h00400004, mux2_2Select, mux2_2Out);
endmodule
