`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/11 20:18:40
// Design Name: 
// Module Name: Top_test
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
module SD_TOP(
   input clk_in,
   input reset,
   input bt1,
   input bt2,
   input bt3,

   output SD_clk,     //25Mhz SD SPI时钟          
   output SD_cs,      //SD SPI 片选       
   output SD_datain,  //SD SPI 数据输入       
   input  SD_dataout,  //SD SPI 数据输出
   
   output led1,
   output led2,
   output [7:0]o_seg,
   output [7:0]o_sel
   ,output reg[7:0]number1,
   output reg[7:0]number2,
   output read_o
    );
    
    parameter ADDR = 32'd16640;
    //parameter ADDR = 32'd17728;
    wire read_SD;
    reg read_req; 
    assign read_SD = read_req;
    
    reg [31:0]read_sec; 
    
    wire [47:0]rxt;
    wire [7:0]mydata_o; 
    wire myvalid_o; 
     
    wire [7:0]rx_o;
    wire init_o; 
  //  wire read_o; 
    wire [3:0] initial_state; 
    wire [3:0] read_state; 
    reg myen = 1'b0;
    
    reg [7:0] myram [3:0];
    reg [1:0] ram_addr, ram_raddr;
    wire [1:0] raddr_o;
    assign raddr_o = ram_raddr;
    
    reg [31:0] outdata;
    
    wire SD_cs_r;
    wire SD_cs_i;
    wire SD_datain_r;
    wire SD_datain_i;
   
    always@(*)begin
    outdata[7:0]<=myram[0];
    outdata[15:8]<=myram[1];
    outdata[23:16]<=myram[2];
    outdata[31:24]<=myram[3];
    end

    //SD卡读写控制部分
    reg [9:0] counter;
    always @(posedge SD_clk) begin 
    if (!init_o&&bt2==1) 
        counter <= 10'd0;
    else 
    begin 
        if (counter < 10'd1023&&bt2==1) 
        begin 
        counter <= counter + 1'b1;
        end 
    end 
    end
    
    //产生第一次SD卡读请求信号:读取4个字节
    always @(posedge SD_clk)begin 
    if(bt2==1)begin
    if (counter == 10'd1022) 
        read_req<= 1'b1;
    else if(myvalid_o && ram_addr == 3) //读完4 个type , 读请求停止
        read_req <= 1'b0;
    end
    end
    
    always @(posedge SD_clk) begin 
    if(bt2==1)begin
    if (counter == 10'd1022) 
    begin ram_addr<= 2'd0;
    end 
    else begin 
    if (myvalid_o) 
    begin 
    myram[ram_addr] <= mydata_o;
    ram_addr <= ram_addr + 1'b1;
    end end end
    end

    //SD卡的sec地址处理程序
    always @(posedge SD_clk) 
    begin 
    if(bt2==1)begin
        if (counter == 10'd1022) 
        read_sec<= ADDR;
        else if (data_come) begin 
            if (read_sec < ADDR+32) 
                read_sec <= read_sec + 1'b1; //SD 卡sec地址加1
            else read_sec <= ADDR;
        end 
    end
    end
    
    
    divide Divide(clk_in,reset,SD_clk);
    
  
   
  //  wire [47:0]turedata;
    SD_init sd_initial_inst(  
  //  .turedata(turedata),         
            .rst_n(rst_n),   
            .SD_clk(SD_clk),       
            .SD_cs(SD_cs_i),       
            .SD_datain(SD_datain_i),       
            .SD_dataout(SD_dataout),       
            .rx(rxt),       
            .init_o(init_o),         //init_o 为高，SD卡初始化完成       
            .state(initial_state) 
        );
       
        SD_read sd_read_inst(         
              .SD_clk(SD_clk),       
              .SD_cs(SD_cs_r),       
              .SD_datain(SD_datain_r),       
              .SD_dataout(SD_dataout), 
                     
              .sec(read_sec),          //SD 卡读扇区地址       
              .read_req(read_req),     //SD 卡读请求信号              
              .mydata_o(mydata_o),     //SD 卡中读取的数据        
              .myvalid_o(myvalid_o),  //myvalid_o为高，标示数据有效           
              .data_come(data_come),
              .init(init_o),       
              .mystate(read_state),              
              .read_o(read_o)        //read_o为高，SD卡数据读完成            
              ); 
           
              assign led1=init_o;
              assign led2=read_o;
              assign SD_cs=init_o?SD_cs_r:SD_cs_i;                     //SD_cs 信号选择 
              assign SD_datain=init_o?SD_datain_r:SD_datain_i;         //SD_datain 信号选择   
        
       // wire clk_7;
       // divide_7 Divide7(clk_in,reset,clk_7);
// wire [31:0]data;
// assign data=bt3?{4'b0,initial_state,8'b0,turedata[47:32]}:turedata[31:0];
       
        
//        seg7x16 Seven(clk_in,reset,outdata,o_seg,o_sel);

reg k1,k2;
always@(posedge clk_in)begin
    if(reset)begin
    k1=0;
    k2=0;
    number1=0;
    number2=0;
    end
    else if(outdata[23:16]!=8'b0&&k1==0)begin
        number1=outdata[23:16];
        k1=1;
    end
    else if(outdata[7:0]!=8'b0&&k2==0)begin
        number2=outdata[7:0];
        k2=1;
    end
end
endmodule
