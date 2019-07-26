`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/25 11:24:01
// Design Name: 
// Module Name: divider
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


module divider (
    input [31:0]a,
    input [31:0]b,
    input isSigned,
    output[63:0]z

);

// $signed(a) / $signed(b)

reg [31:0]_hi,_lo;
always @(*)
begin
if(isSigned)
begin
    _hi =  $signed(a)% $signed(b);
    _lo = $signed(a) / $signed(b);
   
end
else begin
   _hi = a%b;
   _lo = a/b;
end
end
assign  z = {_hi,_lo};
endmodule
