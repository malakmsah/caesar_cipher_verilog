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
    output wire          Vsync,          // VGA Vertical Sync
    output wire   [31:0] keycode,
    output wire          isCharInserted,
    output wire        isCharMapped,
    output wire        isCharCiphered,
    output wire         isCharDisplayed,
    output wire          newChar,
    output wire        insertChar,
    output wire        mapChar,
    output wire        cipherChar,
    output wire        displayChar,
    output wire        done,
    output wire present_state
);
    
   
//wire [31:0] keycode;

wire [6:0]  char;
wire [6:0]  newChar;
wire [6:0]  ascii7b;

// status signals
//wire        isCharInserted  = 0;
//wire        isCharMapped    = 0;
//wire        isCharCiphered  = 0;
//wire        isCharDisplayed = 0;


// control signals
//wire        insertChar;//  = 0;
//wire        mapChar;//    = 0;
//wire        cipherChar;//  = 0;
//wire        displayChar;// = 0;
//wire        done;

reg         CLK50MHZ = 0; 
always @(posedge(CLK100MHZ))begin
    CLK50MHZ <= ~CLK50MHZ;
end

FSM fsm_t(  
.clk(CLK100MHZ),
.clr(BTNC),
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

PS2Receiver keyboard (
    // clocks
    .clk(CLK50MHZ),
    .kclk(PS2_CLK),
    
    // control 
    .insertChar(insertChar),
    
    // data in
    .kdata(PS2_DATA),
    
    // data out
    .keycodeout(keycode[31:0]),
    
    // status
    .isCharInserted(isCharInserted)
);

assign LED [7:0] = keycode[7:0];

assign LED [15:8] = {isCharInserted, isCharMapped, isCharCiphered, isCharDisplayed, insertChar, mapChar, cipherChar, displayChar}; // for test

mapto7bitacsii mta( 
    .clk(CLK100MHZ),
    .clr(BTNC),
    .mapChar(mapChar),
    .keycode(keycode[7:0]),
    .ascii(ascii7b),
    .isCharMapped(isCharMapped)
);

caeserEncoder ced(
    .char(ascii7b),
    .switch(SW[0]),
    .chiperChar(cipherChar),
    .newChar(newChar),
    .isCharCiphered(isCharCiphered)
);

// AHBLite VGA Controller  
VGASYS vgasys1(
    .CLK(CLK100MHZ),
    .RESET(~BTNC),    
    .char(newChar),
    .hreadys(displayChar),
    .LED(LED[15:8]),
    .vgaRed(vgaRed),
    .vgaGreen(vgaGreen),
    .vgaBlue(vgaBlue),
    .Hsync(Hsync),        
    .Vsync(Vsync),
    .isCharDisplayed(isCharDisplayed)
    );

 
endmodule