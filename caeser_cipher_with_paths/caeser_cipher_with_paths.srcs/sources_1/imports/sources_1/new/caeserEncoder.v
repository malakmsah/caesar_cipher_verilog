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
    input wire cipherChar,
    output reg [6:0] newChar,
    output reg isCharCiphered
);

reg [6:0] cipherlength = 7'b0000011;


always @(*)
    begin
        if(cipherChar == 1)
            begin
            
                case (char)
                    7'b0000000: newChar <= 7'b0000000; // NULL
                    7'b0100000: newChar <= 7'b0100000; // Space
                    
                    // encode
                    7'b1111000: begin if(switch == 0) newChar <= 7'b1100001; else  newChar <= 7'b1110101; end //X to A else x to u
                               
                    7'b1111001: begin if(switch == 0) newChar <= 7'b1100010; else  newChar <= 7'b1110110; end //Y to B else y to v
                    7'b1111010: begin if(switch == 0) newChar <= 7'b1100011; else  newChar <= 7'b1110111; end //Z to C else z to w
                    
                    7'b0110111: begin if(switch == 0) newChar <= 7'b0110001; else  newChar <= 7'b0110100; end //7 to 1 else 7 to 4
                    7'b0111000: begin if(switch == 0) newChar <= 7'b0110010; else  newChar <= 7'b0110101; end //8 to 2 else 8 to 5 
                    7'b0111001: begin if(switch == 0) newChar <= 7'b0110011; else  newChar <= 7'b0110110; end //9 to 3 else 9 to 6
                    
                    // decode
                    7'b1100001: begin if(switch == 1) newChar <= 7'b1111000; else  newChar <= 7'b1100100; end //A to X else A to D
                    7'b1100010: begin if(switch == 1) newChar <= 7'b1111001; else  newChar <= 7'b1100101; end //B to Y else B to E
                    7'b1100011: begin if(switch == 1) newChar <= 7'b1111010; else  newChar <= 7'b1100110; end //C to Z else C to F
                    
                    7'b0110001: begin if(switch == 1) newChar <= 7'b0110111; else  newChar <= 7'b0110100; end //1 to 7   else 1 to 4
                    7'b0110010: begin if(switch == 1) newChar <= 7'b0111000; else  newChar <= 7'b0110101; end //2 to 8   else 2 to 5
                    7'b0110011: begin if(switch == 1) newChar <= 7'b0111001; else  newChar <= 7'b0110110; end //3 to 9   else 3 to 6
                
                    default:
                        begin
                            if(switch == 0) 
                                newChar <= char + cipherlength;
                            else 
                                newChar <= char - cipherlength;
                        end
                endcase    
                isCharCiphered = 1;

            end
        else
            begin
                isCharCiphered  <= 0;
                newChar         <= 7'b0000000;
            end

    end

endmodule