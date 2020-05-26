`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Thomas Kappenman
// 
// Create Date: 03/03/2015 09:33:36 PM
// Design Name: 
// Module Name: PS2Receiver
// Project Name: Nexys4DDR Keyboard Demo
// Target Devices: Nexys4DDR
// Tool Versions: 
// Description: PS2 Receiver module used to shift in keycodes from a keyboard plugged into the PS2 port
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PS2Receiver(
    input clk,
    input kclk,
    input kdata,
    input wire insertChar,
    output reg [31:0] keycodeout,
    output reg isCharInserted
    );
    
      
    initial begin
        isCharInserted = 0;
    end
    
    wire kclkf;
    wire kdataf;
    reg [7:0]  datacur;
    reg [7:0]  dataprev;
    reg [3:0]  cnt;
    reg [31:0] keycode;
    reg flag;
    
    initial begin
        keycode[31:0] <= 0;
        cnt <= 4'b0000;
        flag <= 1'b0;
        dataprev <= 8'b00000000;
    end
    
debouncer debounce(
    .clk(clk),
    .I0(kclk),
    .I1(kdata),
    .O0(kclkf),
    .O1(kdataf)
);
    
always@(negedge(kclkf))begin
   
        case(cnt)
        0:;//Start bit
        1:datacur[0] <= kdataf;
        2:datacur[1] <= kdataf;
        3:datacur[2] <= kdataf;
        4:datacur[3] <= kdataf;
        5:datacur[4] <= kdataf;
        6:datacur[5] <= kdataf;
        7:datacur[6] <= kdataf;
        8:datacur[7] <= kdataf;
        9:  flag     <= 1'b1;
        10: flag     <=1'b0;
        
        endcase
        if(cnt<10) cnt<=cnt+1;
        else if(cnt==10) cnt<=0;
       
end

always @(posedge flag)begin
    if ( dataprev!= datacur)begin
        keycode[31:24] <= keycode[23:16];
        keycode[23:16] <= keycode[15:8];
        keycode[15:8]  <= dataprev;
        keycode[7:0]   <= datacur;
        dataprev       <= datacur;
    end
end

always @(posedge clk)
begin    
if(insertChar == 1)
begin
  keycodeout = keycode;
  isCharInserted = (keycode[7:0] != 8'b00000000);
  end    
end

endmodule