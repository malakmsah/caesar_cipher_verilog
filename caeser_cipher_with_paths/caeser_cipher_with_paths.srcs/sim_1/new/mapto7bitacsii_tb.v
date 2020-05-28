`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2020 11:58:56 AM
// Design Name: 
// Module Name: mapto7bitacsii_tb
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


module mapto7bitacsii_tb();
    reg           mapChar;
    reg     [7:0] keycode;
    wire    [6:0] ascii;
    wire          isCharMapped;
     
    mapto7bitacsii mapper_tb(
        .mapChar(mapChar),
        .keycode(keycode),
        .ascii(ascii),
        .isCharMapped(isCharMapped)
    );    
    
   
  initial
  begin
    mapChar = 1;
    keycode = 'h45;
    #10
    
    keycode = 'h2B;
    #10
    
    keycode = 'h1D;
    #10
    
    keycode = 'h11;
    #10
    
    keycode = 'h29;
    #10
    
    mapChar = 0;
    keycode = 'h3D;
    #10
    
    keycode = 'h3A;
    #10
    
    
    $finish;
    end
        
endmodule
