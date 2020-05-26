`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2020 02:57:25 PM
// Design Name: 
// Module Name: caeserDecoder
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


module caeserDecoder(
    input wire  [7:0] char,
    output reg [7:0] newChar
    );
    
    always @(*)
    begin
        case (char)
        8'b00000001: newChar = 8'b11111101; 
        8'b00000010: newChar = 8'b11111110;
        8'b00000011: newChar = 8'b11111111; 
        default: newChar = char - 8'b00000011; 
        endcase
    end
    
endmodule
