`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/10 09:55:22
// Design Name: 
// Module Name: SD_init
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


module SD_init(


    input rst_n, 
    input SD_clk, 
    output reg SD_cs, 
    output reg SD_datain, 
    input SD_dataout,
    output reg [47:0] rx,  
    output reg init_o, 
    output reg [3:0] state
    );  
    
    
reg [47:0] CMD;

reg [47:0] CMD0={8'h40,8'h00,8'h00,8'h00,8'h00,8'h95};   
reg [47:0] CMD8={8'h48,8'h00,8'h00,8'h01,8'haa,8'h87};  
reg [47:0] CMD55={8'h77,8'h00,8'h00,8'h00,8'h00,8'hff};   
reg [47:0] ACMD41={8'h69,8'h40,8'h00,8'h00,8'h00,8'hff}; 

reg [9:0] counter=10'd0; 
reg reset=1'b1; 
 
parameter idle=4'b0000;             
parameter send_cmd0=4'b0001;      
parameter wait_01=4'b0010;           
parameter waitb=4'b0011;             
parameter send_cmd8=4'b0100;      
parameter waita=4'b0101;           
parameter send_cmd55=4'b0110;       
parameter send_acmd41=4'b0111;       
parameter init_done=4'b1000;        
parameter init_fail=4'b1001;        
 
reg [9:0] cnt; 
reg [5:0]aa; 
reg rx_valid; 
reg en; 


always @(posedge SD_clk) 
begin 
    rx [47:1] = rx [46:0];
    rx[0] = SD_dataout;    
end


always @(posedge SD_clk) 
begin 
    if (!SD_dataout && !en) 
    begin 
        rx_valid<= 1'b0;
        aa <= 1;
        en <= 1'b1; 
    end 
    else if (en) 
    begin 
        if (aa < 47) 
        begin 
            aa <= aa + 1'b1;
            rx_valid <= 1'b0;
        end 
        else 
        begin
            aa <= 0;
            en <= 1'b0;
            rx_valid <= 1'b1; 
        end 
    end 
    else 
    begin 
        en <= 1'b0;
        aa <= 0;
        rx_valid <= 1'b0;
    end
end


always @(negedge SD_clk or posedge rst_n) 
begin 
    if (rst_n) 
    begin 
        counter <= 0;
        reset <= 1'b1;
    end 
    else 
    begin 
        if (counter < 10'd1023) 
        begin 
            counter <= counter + 1'b1;
            reset <= 1'b1;
        end 
        else 
        begin 
            reset <= 1'b0;
        end 
    end 
end


always @(negedge SD_clk) 
begin 
    if (reset == 1'b1) 
    begin 
        if (counter < 512) 
        begin 
            SD_cs <= 1'b0; 
            SD_datain <= 1'b1;
            init_o <= 1'b0;
            state <= idle;
        end 
        else 
        begin 
            SD_cs <= 1'b1; 
            SD_datain <= 1'b1;
            init_o <= 1'b0;
            state <= idle;
        end 
    end 
    else 
    begin 
        case (state)

        idle : 
        begin 
            init_o <= 1'b0;
            CMD <= CMD0; 
            SD_cs <= 1'b1;
            SD_datain <= 1'b1;
            state <= send_cmd0;
            cnt <= 0;
        end 
        
        send_cmd0 : 
        begin 
            if (CMD != 48'd0) 
            begin 
                SD_cs = 1'b0;
                SD_datain = CMD[47]; 
                CMD = {CMD [46:0], 1'b0};
            end 
            else 
            begin 
                SD_cs <= 1'b0;
                SD_datain <= 1'b1;
                state <= wait_01;
            end 
        end 
        
        wait_01 : 
        begin 
            if (rx_valid && rx [47:40] == 8'h1) 
            begin 
                SD_cs <= 1'b1;
                SD_datain <= 1'b1;
                state <= waitb;
            end 
            else if (rx_valid && rx [47:40] != 8'h1) 
            begin 
                SD_cs <= 1'b1;
                SD_datain <= 1'b1;
                state <= idle;
            end 
            else 
            begin 
                SD_cs <= 1'b0;
                SD_datain <= 1'b1;
                state <= wait_01;
            end 
        end 
        
        waitb : 
        begin 
            if (cnt < 10'd1023) 
            begin 
                SD_cs <= 1'b1;
                SD_datain <= 1'b1;
                state <= waitb;
                cnt <= cnt + 1'b1;
            end 
            else 
            begin 
                SD_cs <= 1'b1;
                SD_datain <= 1'b1;
                CMD8={8'h48,8'h00,8'h00,8'h01,8'haa,8'h87};
                CMD = CMD8; 
                cnt <= 0;
                state <= send_cmd8;
            end 
        end 
        
        send_cmd8 : 
        begin 
            if (CMD != 48'd0) 
            begin 
                SD_cs <= 1'b0;
                SD_datain = CMD[47];
                CMD = {CMD [46:0], 1'b0};
            end 
            else 
            begin 
                SD_cs <= 1'b0;
                SD_datain <= 1'b1;
                state <= waita;
            end 
        end 
         
        waita : 
        begin 
            SD_cs <= 1'b0;
            SD_datain <= 1'b1;
            if (rx_valid && rx [47:40] == 8'b0001)
            begin 
                state <= send_cmd55;
                CMD55 <= {8'h77, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff};  
                ACMD41 <= {8'h69, 8'h40, 8'h00, 8'h00, 8'h00, 8'hff}; 
            end 
            else if (rx_valid && rx [47:40] != 8'b0001) 
            begin 
                state <= init_fail;
            end 
        end 
        
        send_cmd55 : 
        begin 
            if (CMD55 != 48'd0) 
            begin  
                SD_cs <= 1'b0;                
                SD_datain = CMD55[47];
                CMD55 = {CMD55 [46:0], 1'b0};
                end else begin 
                SD_cs <= 1'b0;
                SD_datain <= 1'b1;
                if (rx_valid && rx [47:40] == 8'h01) 
                    state <= send_acmd41;
                else
                begin 
                    if (cnt < 10'd127) 
                        cnt <= cnt + 1'b1;
                    else 
                    begin 
                        cnt <= 10'd0;
                        state <= init_fail;
                    end 
                end 
            end 
        end 

        send_acmd41 : 
        begin 
            if (ACMD41 != 48'd0) 
            begin 
                SD_cs <= 1'b0;
                SD_datain = ACMD41[47];
                ACMD41 = {ACMD41 [46:0], 1'b0};
            end else begin 
                SD_cs <= 1'b0;
                SD_datain <= 1'b1;
                ACMD41 <= 48'd0;
                if (rx_valid && rx [47:40] == 8'h00) 
                    state <= init_done;
                else
                begin 
                    if (cnt < 10'd127) 
                        cnt <= cnt + 1'b1;
                    else 
                    begin 
                        cnt <= 10'd0;
                        state <= init_fail;
                    end 
                end 
            end 
        end 
        
        init_done : 
        begin 
            init_o <= 1'b1;
            SD_cs <= 1'b1;
            SD_datain <= 1'b1;
            cnt <= 0;
        end 
            
        init_fail : 
        begin 
            init_o <= 1'b0;
            SD_cs <= 1'b1;
            SD_datain <= 1'b1;
            cnt <= 0;
            state <= waitb;
        end 
        
        default : 
        begin 
            state <= idle;
            SD_cs <= 1'b1;
            SD_datain <= 1'b1;
            init_o <= 1'b0;
        end   
    endcase 
    end 
end 
endmodule
