`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/31 09:22:05
// Design Name: 
// Module Name: VgaColor
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


module VgaColor(
    input valid,
    input [31:0] xPos,
    input [31:0] yPos,
    input [31:0] xPipe0, //���������
    input [31:0] xPipe1,
    input [31:0] yPipe0, //���ӵ��ұ���
    input [31:0] yPipe1,
    input [31:0] yBird, //�������µ�
    output reg [11:0] rgb
);

parameter xBirdWid = 30;
parameter yBirdHeight = 40;
//����أ�(xBird, yBird)Ϊ���½�
parameter xBird = 80;
parameter xPipeWid = 30;
parameter yPipeGap = 140; //���¹ܵ��ļ��


//��͹��ӵ�ʾ��ͼ
//     ||
// [ ] ||

//����߼� 
always @(*) begin
  if(valid) begin
     //�񣨷��飩����ɫ
    if(xPos >= xBird && xPos < xBird + xBirdWid 
    && yPos + yBirdHeight >= yBird && yPos < yBird)
      rgb <= 12'h000;
    else if(xPos + xPipeWid >= xPipe0 && xPos < xPipe0
    && (yPos >= 0 && yPos + yPipeGap < yPipe0 || yPos >= yPipe0 && yPos < 480))
      rgb <= 12'h3cf;//�����ǵ���ɫ
    else if(xPos + xPipeWid >= xPipe1 && xPos < xPipe1
    && (yPos >= 0 && yPos + yPipeGap < yPipe1 || yPos >= yPipe1 && yPos < 480))
      rgb <= 12'h3cf;
    else
      rgb <= 12'hfff; //������ɫ
  end
  else
      rgb <= 12'h000;
end
endmodule
