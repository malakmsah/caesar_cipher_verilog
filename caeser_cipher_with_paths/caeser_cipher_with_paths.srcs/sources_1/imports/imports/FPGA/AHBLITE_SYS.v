//////////////////////////////////////////////////////////////////////////////////
//END USER LICENCE AGREEMENT                                                    //
//                                                                              //
//Copyright (c) 2012, ARM All rights reserved.                                  //
//                                                                              //
//THIS END USER LICENCE AGREEMENT ("LICENCE") IS A LEGAL AGREEMENT BETWEEN      //
//YOU AND ARM LIMITED ("ARM") FOR THE USE OF THE SOFTWARE EXAMPLE ACCOMPANYING  //
//THIS LICENCE. ARM IS ONLY WILLING TO LICENSE THE SOFTWARE EXAMPLE TO YOU ON   //
//CONDITION THAT YOU ACCEPT ALL OF THE TERMS IN THIS LICENCE. BY INSTALLING OR  //
//OTHERWISE USING OR COPYING THE SOFTWARE EXAMPLE YOU INDICATE THAT YOU AGREE   //
//TO BE BOUND BY ALL OF THE TERMS OF THIS LICENCE. IF YOU DO NOT AGREE TO THE   //
//TERMS OF THIS LICENCE, ARM IS UNWILLING TO LICENSE THE SOFTWARE EXAMPLE TO    //
//YOU AND YOU MAY NOT INSTALL, USE OR COPY THE SOFTWARE EXAMPLE.                //
//                                                                              //
//ARM hereby grants to you, subject to the terms and conditions of this Licence,//
//a non-exclusive, worldwide, non-transferable, copyright licence only to       //
//redistribute and use in source and binary forms, with or without modification,//
//for academic purposes provided the following conditions are met:              //
//a) Redistributions of source code must retain the above copyright notice, this//
//list of conditions and the following disclaimer.                              //
//b) Redistributions in binary form must reproduce the above copyright notice,  //
//this list of conditions and the following disclaimer in the documentation     //
//and/or other materials provided with the distribution.                        //
//                                                                              //
//THIS SOFTWARE EXAMPLE IS PROVIDED BY THE COPYRIGHT HOLDER "AS IS" AND ARM     //
//EXPRESSLY DISCLAIMS ANY AND ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING     //
//WITHOUT LIMITATION WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR //
//PURPOSE, WITH RESPECT TO THIS SOFTWARE EXAMPLE. IN NO EVENT SHALL ARM BE LIABLE/
//FOR ANY DIRECT, INDIRECT, INCIDENTAL, PUNITIVE, OR CONSEQUENTIAL DAMAGES OF ANY/
//KIND WHATSOEVER WITH RESPECT TO THE SOFTWARE EXAMPLE. ARM SHALL NOT BE LIABLE //
//FOR ANY CLAIMS, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, //
//TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE    //
//EXAMPLE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE EXAMPLE. FOR THE AVOIDANCE/
// OF DOUBT, NO PATENT LICENSES ARE BEING LICENSED UNDER THIS LICENSE AGREEMENT.//
//////////////////////////////////////////////////////////////////////////////////

module AHBLITE_SYS(
    input  wire          CLK,                // Oscillator - 100MHz
    input  wire          RESET,              // Reset
    input  wire          displayChar, 
    input  wire    [6:0] char,
    
   // VGA IO
    output wire    [2:0] vgaRed,
    output wire    [2:0] vgaGreen,
    output wire    [1:0] vgaBlue,
    output wire          Hsync,          // VGA Horizontal Sync
    // VGA Vertical Sync
    output wire          Vsync,       

    output wire          isCharDisplayed
    
    // Debug
//    input  wire          TDI,                // JTAG TDI
//    input  wire          TCK,                // SWD Clk / JTAG TCK
//    inout  wire          TMS,                // SWD I/O / JTAG TMS
//    output wire          TDO                 // SWV     / JTAG TDO
    );
 wire          TDI;             // JTAG TDI
  wire          TCK;                // SWD Clk / JTAG TCK
  wire          TMS;                // SWD I/O / JTAG TMS
 wire          TDO;                 // SWV     / JTAG TDO
 
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

    reg controll = 0; // <= displayChar;
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
    reg    [31:0] hwdatas ;
    
    wire          hwrites = 1; 
    wire   [31:0] hrdatas; 
    reg          hreadys =1; 
    wire    [1:0] hresps = 2'b00;            // System generates no error response
    wire          exresps = 1'b0;

    always @(*)
    begin
        hwdatas [31:7] <= 25'b0000000000000000000000000;
        hwdatas [6:0]  <= char;//7'b1001101;
//        if(displayChar == 1)  
//            hreadys        <= 1;
//        else
//            hreadys        <= 0;    
    end 

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
    .rgb({vgaRed,vgaGreen,vgaBlue}),
    .displayChar(displayChar),
    .isCharDisplayed(isCharDisplayed)
);

  always @ (posedge displayChar)
  begin 
         controll = 1;
  end  

   always @ (posedge isCharDisplayed)
  begin 
    //if (isCharDisplayed == 1) 
    //begin
        #20
         controll = 0;
    //end         
  end   
endmodule
