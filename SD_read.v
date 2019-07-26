`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/11 16:04:41
// Design Name: 
// Module Name: SD_read
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


module SD_read(
     input SD_clk,       
     output reg SD_cs,       
     output reg SD_datain,       
     input  SD_dataout,               
     input [31:0] sec,              
     input read_req,              
     output reg [7:0]mydata_o,                            
     output reg myvalid_o,             
     output reg data_come,                     
     input init,                   
     output reg [3:0] mystate,       
     output reg read_o   
     );
     reg [7:0] rx;
     reg en;
     reg rx_valid;
     reg [5:0] count;
     reg [21:0] cnt;
     reg myen;
     
     reg read_finish;
     reg read_start;
     
     reg [7:0] mydata;
     
     reg [1:0] read_step;
     reg [9:0] read_cnt;
     
     reg [47:0] CMD17; 
     
     reg [2:0] cnta, cntb;
     
     parameter idle = 4'd0;
     parameter read = 4'd1;
     parameter read_wait = 4'd2;
     parameter read_data = 4'd3;
     parameter read_done = 4'd4; 
     
     always @(posedge SD_clk)
     begin  
        rx[0]<=SD_dataout;  
        rx[7:1]<=rx[6:0]; 
     end
     
     
     always @(posedge SD_clk) 
     begin 
         if (!SD_dataout && !en) 
         begin 
             rx_valid <= 1'b0;
             count <= 1;
             en <= 1'b1;
         end    
         else if(en) 
         begin    
             if(count<7) 
             begin    
                count<=count+1'b1;    
                rx_valid<=1'b0;   
            end   
            else 
            begin    
                count<=0;   
                en<=1'b0;   
                rx_valid<=1'b1;  
            end  
        end  
        else 
        begin 
             en<=1'b0;
             count<=0;
             rx_valid<=1'b0;
         end
        end 
     
     
     always @(negedge SD_clk) 
     if (!init) 
     begin 
         mystate <= idle;
         CMD17 <= {8'h51, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff};
         read_start <= 1'b0;
         read_o <= 1'b0;
         SD_cs <= 1'b1;
         SD_datain <= 1'b1;
     end
     else 
     begin 
        case (mystate)
        idle : 
        begin 
            read_start <= 1'b0;
            SD_cs <= 1'b1;
            SD_datain <= 1'b1;
            cnt <= 22'd0;
            if (read_req) 
            begin 
                mystate <= read;
                read_o <= 1'b0;
                CMD17 <= {8'h51, sec [31:24], sec [23:16], sec [15:8], sec [7:0], 8'hff}; 
            end 
            else 
                mystate <= idle;
        end
        
        read : 
        begin 
            read_start <= 1'b0;
            if (CMD17 != 48'd0)
            begin 
                SD_cs <= 1'b0;
                SD_datain <= CMD17[47];
                CMD17 <= {CMD17 [46:0], 1'b0}; 
                myen <= 1'b0;
                cnt <= 22'd0;
            end 
            else 
            begin 
                if (rx_valid) 
                begin 
                    cnt <= 0;
                    mystate <= read_wait;
                end 
            end 
        end
          
        read_wait : 
        begin 
            if (read_finish) 
            begin 
                mystate <= read_done;
                read_start <= 1'b0;
            end 
            else 
                read_start <= 1'b1;
        end 
               
        read_done : 
        begin 
            read_start <= 1'b0;
            if (cnt < 22'd15)
            begin 
                SD_cs <= 1'b1;
                SD_datain <= 1'b1;
                cnt <= cnt + 1'b1;
            end 
            else 
            begin 
                cnt <= 0;
                mystate <= idle;
                read_o <= 1'b1;
            end 
        end 
        
        default : mystate <= 0;
        endcase 
        end
    
       
    
     always @(posedge SD_clk) 
     begin
        if(!init)
        begin 
            myvalid_o <= 1'b0;
            mydata_o <= 0;
            mydata <= 0;
            read_step <= 2'b00;
            read_finish <= 1'b0;
            data_come <= 1'b0;
        end
        else 
        begin 
            case (read_step)
            2'b00 : 
            begin 
                cntb <= 0;
                read_cnt <= 0;
                read_finish <= 1'b0;
                if ((read_start == 1'b1) & (!SD_dataout))
                begin 
                    read_step <= 2'b01;
                    data_come <= 1'b1;
                end 
                else 
                    read_step <= 2'b00;
            end 
            
            2'b01 :
            begin 
                if (read_cnt < 512) 
                begin 
                    if (cntb < 7) 
                    begin 
                        myvalid_o <= 1'b0;
                        mydata <= {mydata [6:0], SD_dataout}; 
                        cntb <= cntb + 1'b1;
                        data_come <= 1'b0;
                    end 
                    else 
                    begin 
                        myvalid_o <= 1'b1;       
                        mydata_o <= {mydata [6:0], SD_dataout}; 
                        cntb <= 0; 
                        read_cnt <= read_cnt + 1'b1;
                        data_come <= 1'b0;
                    end 
                end 
                else 
                begin 
                    read_finish <= 1'b1;
                    read_step <= 2'b00;
                    myvalid_o <= 1'b0;
                    data_come <= 1'b0;
                end 
            end 
            
            default : read_step <= 2'b00;
        endcase
        end
        end 
           

endmodule 
