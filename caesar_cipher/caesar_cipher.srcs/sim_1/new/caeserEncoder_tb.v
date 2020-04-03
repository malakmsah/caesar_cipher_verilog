`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2020 12:59:39 PM
// Design Name: 
// Module Name: caeserEncoder_tb
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


module caeserEncoder_tb();
    reg [7:0] char;
    wire [7:0] newChar;

    caeserEncoder cet(
        .char(char),
        .newChar(newChar)
    );
    
    
  initial
  begin
    char = 8'b00000001;
    #10
    
    char = 8'b01000001;
    #10
    
    char = 8'b11111101;
    #10
    
    char = 8'b11111110;
    #10
    
    char = 8'b11111111;
    #10
    
    
    $finish;
    end
endmodule
