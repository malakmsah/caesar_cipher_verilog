`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/20/2020 08:59:41 AM
// Design Name: 
// Module Name: mapto7bitacsii
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

// Convert keyboard encoding to 7 bit ascii encoding
module mapto7bitacsii(
    input  wire [7:0] keycode,
    output reg  [6:0] ascii
);
    

always @(*) 
begin
  
    case (keycode)    
        'h45: ascii= 7'b0110000;//0)
        'h16: ascii= 7'b0110001;//1!    
        'h1E: ascii= 7'b0110010; //2@
        'h26: ascii= 7'b0110011;//3#
        'h25: ascii= 7'b0110100;//4$
        'h2E: ascii= 7'b0110101;//5%
        'h36: ascii= 7'b0110110;//6^
        'h3D: ascii= 7'b0110111;//7&
        'h3E: ascii= 7'b0111000;//8*
        'h46: ascii= 7'b0111001;//9(
        
        'h1C: ascii= 7'b1100001;//A
        'h32: ascii= 7'b1100010;//B
        'h21: ascii= 7'b1100011;//C
        'h23: ascii= 7'b1100100;//D
        'h24: ascii= 7'b1100101;//E
        'h2B: ascii= 7'b1100110;//F
        'h34: ascii= 7'b1100111;//G
        'h33: ascii= 7'b1101000;//H
        'h43: ascii= 7'b1101001;//I
        'h3B: ascii= 7'b1101010;//J
        'h42: ascii= 7'b1101011;//K
        'h4B: ascii= 7'b1101100;//L
        'h3A: ascii= 7'b1101101;//M
        'h31: ascii= 7'b1101110;//N
        'h44: ascii= 7'b1101111;//O
        'h4D: ascii= 7'b1110000;//P
        'h15: ascii= 7'b1110001;//Q
        'h2D: ascii= 7'b1110010;//R
        'h1B: ascii= 7'b1110011;//S
        'h2C: ascii= 7'b1110100;//T
        'h3C: ascii= 7'b1110101;//U
        'h2A: ascii= 7'b1110110;//V
        'h1D: ascii= 7'b1110111;//W
        'h22: ascii= 7'b1111000;//X
        'h35: ascii= 7'b1111001;//Y
        'h1Z: ascii= 7'b1111010;//Z
        
        'h29: ascii= 7'b0100000; //Space
        
        default: ascii=7'b0000000;  
    endcase
  
  end  
endmodule