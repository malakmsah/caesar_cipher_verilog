`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2020 12:26:37 PM
// Design Name: 
// Module Name: VGASYS
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


module VGASYS(

    input  wire          CLK,                // Oscillator - 100MHz
    input  wire          RESET,              // Reset

    // TO BOARD LEDs
    output wire    [7:0] LED,
    
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
    output wire          TDO,                 // SWV     / JTAG TDO
    
    // Data
    input wire [7:0] char,
    input wire hreadys
    );

    // Clock
    wire          fclk;                      // Free running clock
    // Reset
    wire          reset_n = RESET;
	
    // Select signals
    wire    [3:0] mux_sel;

    wire          hsel_mem;
    wire          hsel_led;
    wire          hsel_vga = 1;
    
    // Slave read data
    wire   [31:0] hrdata_mem;
    wire   [31:0] hrdata_led;
    wire   [31:0] hrdata_vga;
    
    // Slave hready
    wire          hready_mem;
    wire          hready_led;
    wire          hready_vga;

    // CM-DS Sideband signals
    wire          lockup;
    wire          lockup_reset_req;
    wire          sys_reset_req;
    wire          txev;
    wire          sleeping;
    wire  [31:0]  irq;


    // Interrupt signals
    assign        irq = {32'b0};
    // assign        LED[7] = lockup;
    
	  // Clock divider, divide the frequency by two, hence less time constraint 
    reg clk_div;
    always @(posedge CLK)
    begin
        clk_div=~clk_div;
    end
    BUFG BUFG_CLK (
        .O(fclk),
        .I(clk_div)
    );
    
    // Reset synchronizer
    reg  [4:0]     reset_sync_reg;
    always @(posedge fclk or negedge reset_n)
    begin
        if (!reset_n)
            reset_sync_reg <= 5'b00000;
        else
        begin
            reset_sync_reg[3:0] <= {reset_sync_reg[2:0], 1'b1};
            reset_sync_reg[4] <= reset_sync_reg[2] & (~sys_reset_req);
        end
    end

    // CPU System Bus
    wire          hresetn = reset_sync_reg[4];
    wire   [31:0] haddrs = {32{1'b0}}; 
    wire    [2:0] hbursts; 
    wire          hmastlocks; 
    wire    [3:0] hprots; 
    wire    [2:0] hsizes; 
    wire    [1:0] htranss = 11; 
    wire    [31:0] hwdatas = { {25{1'b0}}, char };//7'b1001101; 
    wire          hwrites = 1; 
    wire   [31:0] hrdatas; 
    wire    [1:0] hresps = 2'b00;            // System generates no error response
    wire          exresps = 1'b0;

    // Debug signals (TDO pin is used for SWV unless JTAG mode is active)
    wire          dbg_tdo;                   // SWV / JTAG TDO
    wire          dbg_tdo_nen;               // SWV / JTAG TDO tristate enable (active low)
    wire          dbg_swdo;                  // SWD I/O 3-state output
    wire          dbg_swdo_en;               // SWD I/O 3-state enable
    wire          dbg_jtag_nsw;              // SWD in JTAG state (HIGH)
    wire          dbg_swo;                   // Serial wire viewer/output
    wire          tdo_enable     = !dbg_tdo_nen | !dbg_jtag_nsw;
    wire          tdo_tms        = dbg_jtag_nsw         ? dbg_tdo    : dbg_swo;
    assign        TMS            = dbg_swdo_en          ? dbg_swdo   : 1'bz;
    assign        TDO            = tdo_enable           ? tdo_tms    : 1'bz;

    // CoreSight requires a loopback from REQ to ACK for a minimal
    // debug power control implementation
    wire          cpu0cdbgpwrupreq;
    wire          cpu0cdbgpwrupack;
    assign        cpu0cdbgpwrupack = cpu0cdbgpwrupreq;



  // AHBLite VGA Controller  
AHBVGA uAHBVGA (
    .HCLK(fclk), 
    .HRESETn(hresetn), 
    .HADDR(haddrs), 
    .HWDATA(hwdatas), 
    .HREADY(hreadys), 
    .HWRITE(hwrites), 
    .HTRANS(htranss), 
    .HSEL(hsel_vga), 
    .HRDATA(hrdata_vga), 
    .HREADYOUT(hready_vga), 
    .hsync(Hsync), 
    .vsync(Vsync), 
    .rgb({vgaRed,vgaGreen,vgaBlue})
);
           
 
endmodule
