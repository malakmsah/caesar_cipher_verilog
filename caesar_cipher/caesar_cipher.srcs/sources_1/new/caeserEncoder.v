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
    input wire [6:0] char,
    input wire switch,
    input wire isCharInserted,
    output reg [6:0] newChar,
    output reg cready
    );
    
    
    always @(*)
    begin
        if( isCharInserted == 1)
            begin
            if(switch == 0)
                begin
                    case (char) // encode
                        7'b0000000: newChar = 7'b0000000; // NULL
                        7'b0100000: newChar =  7'b0100000; // Space
                        
                        
                        7'b1111000: newChar = 7'b1100001;//X to A
                        7'b1111001: newChar = 7'b1100010;//Y to B
                        7'b1111010: newChar = 7'b1100011;//Z to C
                        
                        7'b0110111: newChar = 7'b0110000;//7 to 1
                        7'b0111000: newChar = 7'b0110001;//8 to 2
                        7'b0111001: newChar = 7'b0110010;//9 to 3
                        
                        default: newChar = char + 7'b0000011; 
                    endcase
                end
            else
                begin
                    case (char)
                        7'b0000000: newChar = 7'b0000000;
                        7'b0100000: newChar =  7'b0100000;
                        
                        7'b1100001: newChar = 7'b1111000;//A to X
                        7'b1100010: newChar = 7'b1111001;//B to Y
                        7'b1100011: newChar = 7'b1111010;//C to Z
                        
                        7'b0110000: newChar = 7'b0110111;//1 to 7
                        7'b0110001: newChar = 7'b0111000;//2 to 8
                        7'b0110010: newChar = 7'b0111001;//3 to 9
                        
                        default: newChar = char - 7'b0000011; 
                    endcase
                end
            cready = 1;
        end
        else
            cready = 0;
    end
    
endmodule
