
module top(
    input  wire          CLK100MHZ,
    input  wire          BTNC,    // for reset
    input  wire          PS2_CLK,
    input  wire          PS2_DATA,
    input  wire   [0:0]  SW,
    output wire   [15:0] LED,
    output wire          UART_TXD, // *
    
   // VGA IO
    output wire    [2:0] vgaRed,
    output wire    [2:0] vgaGreen,
    output wire    [1:0] vgaBlue,
    output wire          Hsync,          // VGA Horizontal Sync
    output wire          Vsync//,          // VGA Vertical Sync
    );
    
   
wire [31:0] keycode;

wire [6:0]  char;
wire [6:0]  newChar;
wire [6:0]  ascii7b;

wire        isCharInserted  = 0;
wire        isCharMapped    = 0;
wire        isCharCiphered  = 0;
wire        isCharDisplayed = 0;

reg         CLK50MHZ = 0; 
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

mapto7bitacsii mta(
    .keycode(keycode[7:0]),
    .ascii(ascii7b),
    .isCharMapped(isCharMapped)
);

caeserEncoder ced(
    .char(ascii7b),
    .switch(SW[0]),
    .isCharMapped(isCharMapped),
    .newChar(newChar),
    .isCharCiphered(isCharCiphered)
);

// AHBLite VGA Controller  
VGASYS vgasys1(
    .CLK(CLK100MHZ),
    .RESET(~BTNC),    
    .char(newChar),
    .hreadys(isCharCiphered),
    .LED(LED[15:8]),
    .vgaRed(vgaRed),
    .vgaGreen(vgaGreen),
    .vgaBlue(vgaBlue),
    .Hsync(Hsync),        
    .Vsync(Vsync),
    .isCharDisplayed(isCharDisplayed)
    );
 
endmodule