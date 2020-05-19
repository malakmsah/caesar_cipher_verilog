
module top(
    input CLK100MHZ,
    input  wire          BTNC,    // for reset
    input PS2_CLK,
    input PS2_DATA,
    input [0:0] SW,
    output [6:0]SEG,
    output [7:0]AN,
    output DP,
    output [15:0] LED,
    output UART_TXD, // *
    
   // VGA IO
    output wire    [2:0] vgaRed,
    output wire    [2:0] vgaGreen,
    output wire    [1:0] vgaBlue,
    output wire          Hsync,          // VGA Horizontal Sync
    output wire          Vsync,          // VGA Vertical Sync

     // Debug
    input  wire          TDI,                // JTAG TDI
    input  wire          TCK,                // SWD Clk / JTAG TCK
    inout  wire          TMS,                // SWD I/O / JTAG TMS
    output wire          TDO                 // SWV     / JTAG TDO
    );
    
reg CLK50MHZ = 0;    
wire [31:0] keycode;

wire [8:0] newChar;
wire cready;
wire isCharInserted;

always @(posedge(CLK100MHZ))begin
    CLK50MHZ <= ~CLK50MHZ;
end

PS2Receiver keyboard (
.clk(CLK50MHZ),
.kclk(PS2_CLK),
.kdata(PS2_DATA),
.keycodeout(keycode[31:0]),
.isCharInserted(isCharInserted)
);

assign LED [7:0] = keycode[7:0];

caeserEncoder ced(
    .char(keycode[7:0]),
    .switch(SW[0]),
    .newChar(newChar),
    .isCharInserted(isCharInserted),
    .cready(cready)
);

//assign LED [15:8] = newChar[7:0];

//seg7decimal sevenSeg (
//.x(keycode[31:0]),
//.clk(CLK100MHZ),
//.seg(SEG[6:0]),
//.an(AN[7:0]),
//.dp(DP) 
//);

  // AHBLite VGA Controller  
VGASYS vgasys1(
    .CLK(CLK100MHZ),
    .RESET(RESET),
    .LED(LED[15:8]),
    .vgaRed(vgaRed),
    .vgaGreen(vgaGreen),
    .vgaBlue(vgaBlue),
    .Hsync(Hsync),        
    .Vsync(Vsync),        
    .TDI(TDI),
    .TCK(TCK),        
    .TMS(TMS),        
    .TDO(TDO),
    .char(newChar),
    .hreadys(cready)
    );
 
endmodule