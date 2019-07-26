`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/23 23:24:24
// Design Name: 
// Module Name: control
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


module control(
    input clk, 
    input reset, 
    input [53:0] inst, 
    input [31:0] Y,
    output reg PC_enable, 
    output reg Regfiles_wena, 
    output reg IR_wena, 
    output reg Y_ena, 
    output reg [4:0] alu_control, 
    output reg [2:0] dmem_control, 
    output reg dmem_wena, 
    output  divYena, 
    output multYena, 
    output  dividerSigned,
    output  multiplySigned, 
    output reg HI_ena, 
    output reg LO_ena, 
    output reg mfc0,
    output reg mtc0,
    output reg eret,
    output reg exception,
    output ext16Signed,
    output mux2,
    output mux2_2,
    output [1:0]mux4, 
    output [2:0]mux6,
    output [2:0]mux5,
    output [1:0]mux3_1,
    output [1:0]mux3_2,
    output [1:0]mux3_3,
    output [1:0]mux3_4,
    output [1:0]mux3_5,
    input exceptionValid,
    output mustException ,
    output reg [2:0]state
);
// ___________________________________________________________________
//state:
   localparam  fetch=0;
   localparam  decoding=1;
   localparam  execution=2;
   localparam  writeback=3;
   localparam  judgement=4;
   localparam pause = 5;

//  ___________________________________________________________________
wire inst_add = inst[0];
wire inst_addu = inst[1];
wire inst_sub = inst[2];
wire inst_subu = inst[3];
wire inst_and = inst[4];
wire inst_or = inst[5];
wire inst_xor = inst[6];
wire inst_nor = inst[7];
wire inst_slt = inst[8];
wire inst_sltu = inst[9];
wire inst_sll = inst[10];
wire inst_srl = inst[11];
wire inst_sra = inst[12];
wire inst_sllv = inst[13];
wire inst_srlv = inst[14];
wire inst_srav = inst[15];
wire inst_jr = inst[16];
wire inst_addi = inst[17];
wire inst_addiu = inst[18];
wire inst_andi = inst[19];
wire inst_ori = inst[20];
wire inst_xori = inst[21];
wire inst_lw = inst[22];
wire inst_sw = inst[23];
wire inst_beq = inst[24];
wire inst_bne = inst[25];
wire inst_slti = inst[26];
wire inst_sltiu = inst[27];
wire inst_lui = inst[28];
wire inst_j = inst[29];
wire inst_jal = inst[30];
wire inst_clz = inst[31];
wire inst_divu = inst[32];
wire inst_eret = inst[33];
wire inst_jalr = inst[34];
wire inst_lb = inst[35];
wire inst_lbu = inst[36];
wire inst_lhu = inst[37];
wire inst_sb = inst[38];
wire inst_sh = inst[39];
wire inst_lh = inst[40];
wire inst_mfc0 = inst[41];
wire inst_mfhi = inst[42];
wire inst_mflo = inst[43];
wire inst_mtc0 = inst[44];
wire inst_mthi = inst[45];
wire inst_mtlo = inst[46];
wire inst_mul = inst[47];
wire inst_multu = inst[48];
wire inst_syscall = inst[49];
wire inst_teq = inst[50];
wire inst_bgez = inst[51];
wire inst_break = inst[52];
wire inst_div = inst[53];
  
localparam _addu =5'b00000;
localparam _subu =5'b00001;
localparam _add =5'b00010;
localparam _sub =5'b00011;
localparam _and =5'b00100;
localparam _or =5'b00101;
localparam _xor =5'b00110;
localparam _nor =5'b00111;
localparam _lui1 =5'b01000;
localparam _lui2 =5'b01001;
localparam _sltu =5'b01010;
localparam _slt =5'b01011;
localparam _sra =5'b01100;
localparam _srl =5'b01101;
localparam _sll =5'b01110;
localparam _slr =5'b01111;
localparam _clz =5'b10000;



always @(negedge clk or posedge reset)
begin
if(reset)
    state <= pause;
else if (state == pause)
    state<=fetch;
else if(state==fetch)
    state<=decoding;
else if(state==decoding)
    if(inst_beq||inst_bne||inst_bgez||inst_teq)
        state<=judgement;
    else
        state <= execution;
else if(state == judgement)
    if (((inst_beq|inst_teq)&Y==0)|(inst_bne&Y!=0)|(inst_bgez & $signed(Y)>=0))
        state <= execution;
    else
        state<=fetch;
else if(state==execution)
    if ((inst_break | inst_teq | inst_syscall) & ~exceptionValid)
        state <= fetch;
    else
        state<=writeback;
else if (state==writeback)
    state<=fetch;
end

// mustException
assign mustException = state == writeback & (inst_teq | inst_break | inst_syscall);

// PC_enable
always @(*)
    begin
if(state==decoding|(state==execution&inst_jr)|(state==execution&inst_j)
| (state==execution&inst_jal)|(state==writeback&(inst_bgez|inst_bne|inst_beq))
 |(state==writeback&inst_jalr)|(state==execution&inst_eret) | state == writeback & (inst_break | inst_teq | inst_syscall))
      PC_enable=1;
else  PC_enable=0;
    end

//Regfiles_wena
always @(*)
     begin
if((state==writeback&
(inst_add|inst_addu|inst_sub|inst_subu|inst_and|inst_or|inst_xor|
inst_nor|inst_slt|inst_sltu|inst_sll|inst_srl|inst_sra|inst_sllv|inst_srlv|inst_srav|inst_addi|
inst_andi|inst_ori|inst_xori|inst_addiu|inst_lw|inst_slti|inst_sltiu|inst_lui|inst_lb|
inst_lbu|inst_lh|inst_lhu|inst_clz|inst_mul))|(state==execution&(inst_jal|inst_jalr|inst_mflo|inst_mfhi|inst_mfc0)))
   Regfiles_wena=1;
else 
  Regfiles_wena=0;
end


//  IR_wena
always @(*)
begin
if(state==fetch)
    IR_wena=1;
else
    IR_wena=0;
end

//Y_ena
always @(*)
   begin
if(
    (
        state==fetch|
        (
            state==execution&
            (
inst_add|inst_addu|inst_sub|inst_subu|inst_and|inst_or|inst_xor|inst_nor|inst_slt|inst_sltu|inst_sll|inst_srl||inst_sra|inst_sllv|inst_srlv|inst_srav|
inst_addi|inst_addiu|inst_andi|inst_ori|inst_xori|inst_lw|inst_sw|inst_beq|inst_bne|inst_sltiu|inst_lui|inst_bgez|inst_lb|
inst_lbu|inst_lh|inst_lhu|inst_sb|inst_sh|inst_clz|inst_slti|inst_teq
            )
        )
|
   (
    state==judgement
   )
    )
)
   Y_ena=1;
else
   Y_ena=0;
end

//alu_control
always @(*)
   begin
if(state==fetch|(state==execution&(inst_add|inst_addi|inst_lw|inst_sw|
inst_beq|inst_bne|inst_bgez|inst_lb|inst_lbu|inst_lh|inst_lhu|inst_sb|inst_sh)))
     alu_control=_add;
else if(state==execution&(inst_addu|inst_addiu))
    alu_control=_addu;
else if((state==execution&(inst_sub))|(state==judgement))
    alu_control=_sub;
else if(state==execution&inst_subu)
    alu_control=_subu;
else if(state==execution&(inst_and|inst_andi))
    alu_control=_and;
else if(state==execution&(inst_or|inst_ori))
    alu_control=_or;
else if(state==execution&(inst_xor|inst_xori))
    alu_control=_xor;
else if(state==execution&inst_nor)
    alu_control=_nor;
else if(state==execution&(inst_slt|inst_slti))
    alu_control=_slt;
else if(state==execution&(inst_sltu|inst_sltiu))
    alu_control=_sltu;
else if(state==execution&(inst_sll|inst_sllv))
    alu_control=_sll;
else if(state==execution&(inst_srl|inst_srlv))
    alu_control=_srl;
else if(state==execution&(inst_sra|inst_srav))
    alu_control=_sra;
else if(state==execution&inst_lui)
    alu_control=_lui1;
else if(state==execution&inst_clz)
    alu_control=_clz;
end

localparam  LB=0;
localparam  LBU=1;
localparam  LH=2;
localparam  LHU=3;
localparam  LW=4;
localparam  SB=5;
localparam  SW=6;
localparam  SH=7;

//dmem_control
always @(*)
begin
if(state==writeback)
begin
if(inst_sb)
    dmem_control=SB;
else if(inst_sh)
    dmem_control=SH;
else if(inst_sw)
    dmem_control=SW;
else if(inst_lw)
    dmem_control=LW;
else if(inst_lb)
    dmem_control=LB;
else if(inst_lbu)
    dmem_control=LBU;
else if(inst_lh)
    dmem_control=LH;
else if(inst_lhu)
    dmem_control=LHU;
end
end
// dmem_wena
always @(*)
  begin
if(state==writeback&(inst_sw|inst_sb|inst_sh))
  dmem_wena=1;
else 
  dmem_wena=0;
end
  




// divYena
assign divYena =( state ==execution & (inst_div | inst_divu));

// multYena
assign multYena = (state == execution & (inst_multu | inst_mul));

// dividerSigned
assign dividerSigned = inst_div;

// multiplySigned
assign multiplySigned = inst_mul;






//HI_ena
always @(*)
begin
if(state==writeback)
begin
    if(inst_div|inst_divu|inst_mul|inst_multu)
        HI_ena=1;
    else
        HI_ena = 0;
end
else if(state==execution&inst_mthi)
        HI_ena=1;
else HI_ena=0;
end

//LO_ena
always @(*)
begin
if(state==writeback)
begin
    if(inst_div|inst_divu|inst_mul|inst_multu)
        LO_ena=1;
    else
        LO_ena = 0;
end
else if(state==execution&inst_mtlo)
    LO_ena=1;
else 
    LO_ena=0;
end

// mfc0
always @(*)
begin
if(state==execution)
begin
if(inst_mfc0)
    mfc0 = 1;
else 
    mfc0 = 0;
end else
    mfc0 = 0;
end

// mtc0
always @(*)
begin
if(state==execution)
begin
if(inst_mtc0)  
    mtc0 = 1;
else 
    mtc0 = 0;
end else
    mtc0 = 0;
end

// eret
always @(*)
begin
if(state==writeback)
begin
if(inst_eret)  
   eret = 1;
else 
   eret = 0;
end else
    eret = 0;
end


//exception
always @(*)
begin
if(state==execution)
begin
if(inst_break|inst_syscall|inst_teq)
    exception = 1;
else 
    exception = 0;
end
end


//mux4
assign mux4[0] = state == execution & (inst_jr | inst_eret) |state==writeback & inst_jalr;
assign mux4[1] = state == execution & (inst_j | inst_eret|inst_jal);

// mux6Select
assign mux6[0] = (
    (state == execution | state == writeback) & (inst_lw | inst_lb | inst_lbu | inst_lh | inst_lhu) |
    (state == execution & (inst_mfc0 | inst_mflo))
);
assign mux6[1] = (state == execution & (inst_jal | inst_mflo | inst_jalr));
assign mux6[2] = state == execution & (inst_mfhi | inst_mfc0);

// mux3_1
assign mux3_1[0] = (
    (state == execution | state == writeback) & (inst_addi | inst_addiu | inst_andi | inst_ori | inst_xori | 
        inst_lw | inst_slti | inst_sltiu | inst_lui | inst_lb | inst_lbu |
        inst_lh | inst_lhu) |
    (state == execution & (inst_mfc0)) |
    state == judgement
);
assign mux3_1[1] = state == execution & (inst_jal);


// mux3_2
assign mux3_2[0] = (
    (state == execution | state == writeback) & (inst_add | inst_addu | inst_sub | inst_subu | inst_and | inst_or |
        inst_xor | inst_nor | inst_slt | inst_sltu | inst_sllv | inst_srlv | inst_srav |
        inst_addi | inst_addiu | inst_andi | inst_ori | inst_xori |
        inst_lw | inst_sw | inst_slti | inst_sltiu | 
        inst_lb | inst_lbu | inst_lh | inst_lhu | inst_sb | inst_sh | inst_clz)
         | state == judgement
);
assign mux3_2[1] = (state == execution | state == writeback) & (inst_sll | inst_srl | inst_sra);

// mux5
assign mux5[0] = (
    (state == execution | state == writeback) & (inst_add | inst_addu | inst_sub | inst_subu | inst_and | inst_or |
        inst_xor | inst_nor | inst_slt | inst_sltu | inst_sllv | inst_srlv | inst_srav | inst_sll | inst_srl | inst_sra
    ) |
    state == judgement & ~inst_bgez |
    ((state == execution | state == writeback) & inst_beq |
    (state == execution | state == writeback) & inst_bne |
    (state == execution | state == writeback) & inst_bgez)
);
assign mux5[1] = (
    ((state == execution | state == writeback) & inst_beq |
    (state == execution | state == writeback) & inst_bne |
    (state == execution | state == writeback) & inst_bgez) |
    (state == execution | state == writeback) & (
        inst_addi | inst_addiu | inst_andi | inst_ori | inst_xori |
        inst_lw | inst_sw | inst_slti | inst_sltiu | inst_lui |
        inst_lb | inst_lbu | inst_lh | inst_lhu | inst_sb | inst_sh
    )
);
assign mux5[2] = inst_bgez & state == judgement;

// mux3_3
assign mux3_3[0] = state == execution & inst_mthi;
assign mux3_3[1] = (state == execution | state == writeback) & (inst_mul | inst_multu);

// mux3_4
assign mux3_4[0] = state == execution & inst_mtlo;
assign mux3_4[1] = (state == execution | state == writeback) & (inst_mul | inst_multu);

// mux3_5
assign mux3_5[0] = inst_syscall;
assign mux3_5[1] = inst_teq;


// mux2
assign mux2 = inst_mul;

// mux2_2
assign mux2_2 = state == writeback & (inst_teq | inst_syscall | inst_break);

// ext16Signed
assign ext16Signed = ~(inst_andi | inst_ori | inst_xori);

endmodule
