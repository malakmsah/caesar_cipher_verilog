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

    reg  [6:0]  char;
    wire [6:0]  newChar;
    
    reg         switch;
    
    wire        isCharCiphered;
    reg         cipherChar;
    
    caeserEncoder cet(
        .char(char),
        .switch(switch),
        .newChar(newChar),
        .isCharCiphered(isCharCiphered)
    );
    
    
  initial
  begin
    switch = 1;
    cipherChar = 1;
    char = 7'b0100000;
    #10
    
    char = 7'b1111000;
    #10
    
    char = 7'b0110001;
    #10
    
    switch = 0;
    char = 7'b0110001;
    #10
    
    char = 7'b1100010;
    #10
    
    cipherChar = 0;
    char = 7'b0110011;
    #10
    
    char = 7'b1111111;
    #10
    
    
    $finish;
    end
endmodule
