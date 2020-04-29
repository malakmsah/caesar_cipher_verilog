
module top(
    input CLK100MHZ,
    input PS2_CLK,
    input PS2_DATA,
    input [0:0] SW,
    output [6:0]SEG,
    output [7:0]AN,
    output DP,
    output [15:0] LED,
    output UART_TXD // *
    );
    
reg CLK50MHZ = 0;    
wire [31:0] keycode;

wire [8:0] newChar;

always @(posedge(CLK100MHZ))begin
    CLK50MHZ <= ~CLK50MHZ;
end

PS2Receiver keyboard (
.clk(CLK50MHZ),
.kclk(PS2_CLK),
.kdata(PS2_DATA),
.keycodeout(keycode[31:0])
);

assign LED [7:0] = keycode[7:0];

ceaserEncoder ced(
    .char(keycode[7:0]),
    .switch(SW[0]),
    .newChar(newChar) 
);

assign LED [15:8] = newChar[15:8];

seg7decimal sevenSeg (
.x(keycode[31:0]),
.clk(CLK100MHZ),
.seg(SEG[6:0]),
.an(AN[7:0]),
.dp(DP) 
);
 
endmodule