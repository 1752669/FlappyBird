`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/23 23:23:36
// Design Name: 
// Module Name: dmem
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


module dmem(
input clk,
input wena,
input [31:0] raddr,
input [31:0] waddr,
input [31:0] wdata,
input [2:0]choose,
output reg  [31:0] data_out
    );
reg [7:0]memory[255:0];

parameter LB=0;
parameter LBU=1;
parameter LH=2;
parameter LHU=3;
parameter LW=4;
parameter SB=5;
parameter SW=6;
parameter SH=7;
wire enaout;
Dmem_ena  ena1 (.addr(waddr),.we(wena),.ena(enaout));
    always@(posedge clk)
        begin
          if(enaout)
       case(choose)
           SB:{memory[waddr]}<=wdata[7:0];
           SW:{memory[waddr],memory[waddr+1],memory[waddr+2],memory[waddr+3]}<=wdata;
           SH:{memory[waddr],memory[waddr+1]}<=wdata[15:0];
endcase
end
      always @(*)
      begin
       case(choose)
           LB: data_out={{24{memory[raddr][7]}},memory[raddr]};
           LBU: data_out={24'b0,memory[raddr]};
           LH: data_out={{16{memory[raddr][7]}},memory[raddr],memory[raddr+1]};
           LHU: data_out={16'b0,memory[raddr],memory[raddr+1]};
           LW: data_out={memory[raddr],memory[raddr+1],memory[raddr+2],memory[raddr+3]};
endcase
end
endmodule
