`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2020 03:11:10 AM
// Design Name: 
// Module Name: top2_tb
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


module PS2Receiver_tb();

reg clk;
reg kclk;
reg kdata;
wire [31:0] keycodeout;
wire isCharInserted;

	// Instantiate the Unit Under Test (UUT)
	PS2Receiver uut (
		.clk(clk), 
		.kclk(kclk), 
		.kdata(kdata), 
		.keycodeout(keycodeout),
		.isCharInserted(isCharInserted)
	);

	initial begin
		clk = 1;
		forever begin
		#1 clk = ~clk;
		end
	end
	
	initial begin
		// Initialize Inputs
		kclk = 1;
		kdata = 1;

		// Wait 100 ns for global reset to finish
		#55;
		
        #20 kdata = 0; //START 0
		#5 kclk = 0;
		#25kclk = 1;
		
		#20 kdata = 1; //1
		#5 kclk = 0;
		#25kclk = 1;
		
		#20 kdata = 0; //2
		#5 kclk = 0;
		#25kclk = 1;

		#20 kdata = 1; //3
		#5 kclk = 0;
		#25kclk = 1;
		
		#20 kdata = 0; //4
		#5 kclk = 0;
		#25kclk = 1;
		
		#20 kdata = 1; //5
		#5 kclk = 0;
		#25kclk = 1;

		#20 kdata = 1; //6
		#5 kclk = 0;
		#25kclk = 1;
		
		#20 kdata = 1; //7
		#5 kclk = 0;
		#25kclk = 1;
		
		#20 kdata = 0; //8
		#5 kclk = 0;
		#25kclk = 1;
		
		#20 kdata = 0; //PARITY 9
		#5 kclk = 0;
		#25kclk = 1;
		
		#20 kdata = 1;// STOP 10
		#5 kclk = 0;
		#25kclk = 1;
		// Add stimulus here
		
		#20 kdata = 0; //START 0
		#5 kclk = 0;
		#25kclk = 1;
		
		#20 kdata = 0; //1
		#5 kclk = 0;
		#25kclk = 1;
		
		#20 kdata = 0; //2
		#5 kclk = 0;
		#25kclk = 1;

		#20 kdata = 0; //3
		#5 kclk = 0;
		#25kclk = 1;
		
		#20 kdata = 0; //4
		#5 kclk = 0;
		#25kclk = 1;
		
		#20 kdata = 1; //5
		#5 kclk = 0;
		#25kclk = 1;

		#20 kdata = 1; //6
		#5 kclk = 0;
		#25kclk = 1;
		
		#20 kdata = 1; //7
		#5 kclk = 0;
		#25kclk = 1;
		
		#20 kdata = 1; //8
		#5 kclk = 0;
		#25kclk = 1;
		
		#20 kdata = 1; //PARITY 9
		#5 kclk = 0;
		#25kclk = 1;
		
		#20 kdata = 1;// STOP 10
		#5 kclk = 0;
		#25kclk = 1;
	//BRAKE CODE
		#20 kdata = 0; //START 0
		#5 kclk = 0;
		#25kclk = 1;
		
		//#50
	//$finish;
	end	
endmodule