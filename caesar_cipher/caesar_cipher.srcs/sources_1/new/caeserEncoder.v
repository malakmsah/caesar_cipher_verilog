`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2020 12:46:03 PM
// Design Name: 
// Module Name: caeserEncoder
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
// ASCII Code: ascii-code.com
//////////////////////////////////////////////////////////////////////////////////


module caeserEncoder(
    input wire [7:0] char,
    input wire switch,
    output reg [7:0] newChar
    );
    
    always @(*)
    begin
        if(switch == 0)
            begin
                case (char)
                    8'b11111101: newChar = 8'b00000001; 
                    8'b11111110: newChar = 8'b00000010;
                    8'b11111111: newChar = 8'b00000011; 
                    default: newChar = char + 8'b00000011; 
                endcase
            end
        else
            begin
                case (char)
                    8'b00000001: newChar = 8'b11111101; 
                    8'b00000010: newChar = 8'b11111110;
                    8'b00000011: newChar = 8'b11111111; 
                    default: newChar = char - 8'b00000011; 
                endcase
            end
    end
    
endmodule
