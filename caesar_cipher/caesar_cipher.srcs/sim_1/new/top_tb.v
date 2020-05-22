`timescale 1ns / 1ps

module top_tb();

reg clk;
reg reset;
reg PS2_CLK;
reg PS2_DATA;
reg [0:0] SW;
wire [15:0] LED;
wire UART_TXD;
wire [31:0] keycodeo;

   // VGA IO
wire [2:0] vgaRed;
wire [2:0] vgaGreen;
wire [1:0] vgaBlue;
wire Hsync;
wire Vsync;

wire isCharInserted;
wire [6:0] newChar;
wire cready;

top T(
.CLK100MHZ(clk),
.BTNC(reset),
.PS2_CLK(PS2_CLK),
.PS2_DATA(PS2_DATA),
.SW(SW),
.LED(LED),
.UART_TXD(UART_TXD),
.vgaRed(vgaRed),
.vgaGreen(vgaGreen),
.vgaBlue(vgaBlue),
.Hsync(Hsync),
.Vsync(Vsync)//,
//.keycodeo(keycodeo),
//.isCharInserted(isCharInserted),
//.newChar(newChar),
//.cready(cready)
);

	initial begin
		clk = 1;
		forever begin
		#1 clk = ~clk;
		end
	end
	
	initial begin
		// Initialize Inputs
		PS2_CLK = 1;
		PS2_DATA = 1;
		SW = 1;
        reset = 0;   
		// Wait 100 ns for global reset to finish
		#55;
		 reset = 1;  
		// 2E = 0010 1110
        #20 PS2_DATA = 0; //START 0
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;
		
		#20 PS2_DATA = 0; //1
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;
		
		#20 PS2_DATA = 1; //2
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;

		#20 PS2_DATA = 1; //3
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;
		
		#20 PS2_DATA = 1; //4
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;
		
		#20 PS2_DATA = 0; //5
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;

		#20 PS2_DATA = 1; //6
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;
		
		#20 PS2_DATA = 0; //7
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;
		
		#20 PS2_DATA = 0; //8
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;
		
		#20 PS2_DATA = 0; //PARITY 9
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;
		
		#20 PS2_DATA = 1;// STOP 10
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;
		// Add stimulus here
		
		#20 PS2_DATA = 0; //START 0
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;
		
		#20 PS2_DATA = 0; //1
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;
		
		#20 PS2_DATA = 0; //2
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;

		#20 PS2_DATA = 0; //3
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;
		
		#20 PS2_DATA = 0; //4
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;
		
		#20 PS2_DATA = 1; //5
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;

		#20 PS2_DATA = 1; //6
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;
		
		#20 PS2_DATA = 1; //7
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;
		
		#20 PS2_DATA = 1; //8
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;
		
		#20 PS2_DATA = 1; //PARITY 9
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;
		
		#20 PS2_DATA = 1;// STOP 10
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;
	//BRAKE CODE
		#20 PS2_DATA = 0; //START 0
		#5 PS2_CLK = 0;
		#25 PS2_CLK = 1;
		end
endmodule
