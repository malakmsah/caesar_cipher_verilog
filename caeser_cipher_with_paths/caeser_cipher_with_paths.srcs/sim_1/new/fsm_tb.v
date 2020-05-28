`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2020 01:01:02 AM
// Design Name: 
// Module Name: fsm_tb
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


module fsm_tb();

reg         isCharInserted;
reg         isCharMapped;
reg         isCharCiphered;
reg         isCharDisplayed;


// control signals
wire        insertChar;
wire        mapChar;
wire        cipherChar;
wire        displayChar;
wire        done;

wire [1:0] present_state;

reg reset;
reg clk;

FSM fsm_tb(  
.clk(clk),
.clr(reset),
.isCharInserted(isCharInserted),
.isCharMapped(isCharMapped),
.isCharCiphered(isCharCiphered),
.isCharDisplayed(isCharDisplayed),
.insertChar(insertChar),
.mapChar(mapChar),
.cipherChar(cipherChar),
.displayChar(displayChar),
.done(done),
.present_state(present_state)
);

	initial begin
		clk = 1;
		forever begin
		#1 clk = ~clk;
		end
	end
	
	initial
    begin
    reset = 0;
    
    isCharInserted = 0;
    isCharMapped = 0;
    isCharCiphered = 0;
    isCharDisplayed = 0;
    #10
    
    isCharInserted = 1;
    isCharMapped = 0;
    isCharCiphered = 0;
    isCharDisplayed = 0;    
    #10
 
    isCharInserted = 1;
    isCharMapped = 1;
    isCharCiphered = 0;
    isCharDisplayed = 0;
    #10  
 
    isCharInserted = 1;
    isCharMapped = 1;
    isCharCiphered = 1;
    isCharDisplayed = 0;
    #10   
 
    isCharInserted = 1;
    isCharMapped = 1;
    isCharCiphered = 1;
    isCharDisplayed = 1;
    #10    
    
    $finish;
    end
endmodule
