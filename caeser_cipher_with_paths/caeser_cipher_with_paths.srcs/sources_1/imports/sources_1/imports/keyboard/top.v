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
    
    // for test bench
//    output wire   [31:0] keycode,
//    output wire          isCharInserted,
//    output wire        isCharMapped,
//    output wire        isCharCiphered,
//    output wire         isCharDisplayed,
//    output wire      [6:0]    newChar,
//    output wire        insertChar,
//    output wire        mapChar,
//    output wire        cipherChar,
//    output wire        displayChar,
//    output wire        done,
//    output wire [1:0] present_state
);
    
   
wire [31:0] keycode;

wire [6:0]  char;
wire [6:0]  newChar;
wire [6:0]  ascii7b;


// status signals
wire        isCharInserted;//  = 0;
wire        isCharMapped    ;
wire        isCharCiphered  ;
wire        isCharDisplayed ;


// control signals
wire        insertChar;//  = 0;
wire        mapChar;//    = 0;
wire        cipherChar;//  = 0;
wire        displayChar;// = 0;
wire        done;

wire [1:0] present_state;
//initial begin

//       isCharInserted  <= 0;
//        isCharMapped    <= 0;
//        isCharCiphered  <= 0;
//        isCharDisplayed <= 0;
//end

reg         CLK50MHZ = 0; 
always @(posedge(CLK100MHZ))begin
    CLK50MHZ <= ~CLK50MHZ;
end




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

//assign LED [15:8] = {isCharInserted, isCharMapped, isCharCiphered, isCharDisplayed, insertChar, mapChar, cipherChar, displayChar}; // for test

mapto7bitacsii mta( 
    .mapChar(mapChar),
    .keycode(keycode[7:0]),
    .ascii(ascii7b),
    .isCharMapped(isCharMapped)
);

caeserEncoder ced(
    .char(ascii7b),
    .switch(SW[0]),
    .cipherChar(cipherChar),
    .newChar(newChar),
    .isCharCiphered(isCharCiphered)
);


// AHBLite VGA Controller  
AHBLITE_SYS vgasys1(
    .CLK(CLK100MHZ),
    .RESET(~BTNC),    
    .char(newChar),
    .displayChar(displayChar),//hreadys
    .vgaRed(vgaRed),
    .vgaGreen(vgaGreen),
    .vgaBlue(vgaBlue),
    .Hsync(Hsync),        
    .Vsync(Vsync),//,
    .isCharDisplayed(isCharDisplayed)
    );
    
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

assign LED [14:8] = newChar;
assign LED [15]   = isCharDisplayed;
 
endmodule