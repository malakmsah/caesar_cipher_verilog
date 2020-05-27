// Example 65c: Square root control
// Copyright 2009, 2012 LBE Books, LLC
module FSM (  
input wire clk ,
input wire clr ,

// status 
input wire isCharInserted ,
input wire isCharMapped ,
input wire isCharCiphered ,
input wire isCharDisplayed ,


// control signals
output reg        insertChar,
output reg        mapChar,
output reg        cipherChar,
output reg        displayChar,

output reg [1:0] present_state,
output reg done
);
//reg [1:0] present_state;
reg [1:0]  next_state;
parameter S0 = 2'b00, S1 =2'b01, S2 = 2'b10,S3 = 2'b11; // states

//initial begin
//        done = 0;
//        insertChar  = 0;
//        mapChar     = 0;
//        cipherChar  = 0;
//        displayChar = 0;
//end        										 
// State registers
always @(posedge clk or posedge clr)
  begin
  	if (clr == 1)
    	present_state <= S0;
  	else 
		present_state <= next_state;
  end 

// C1 module
always @(*)
  begin
     case(present_state)
		2'b00: if(isCharInserted == 0)
			    next_state = S0;
			else 	 
			    next_state = S1;
			    
		2'b01: if(isCharMapped == 0)
			    next_state = S1;
			else 	 
			    next_state = S2;
			    
		2'b10:  if(isCharCiphered == 0)
			    next_state = S2;
			else 	 
			    next_state = S3;
		2'b11:  if(isCharDisplayed == 0)
			    next_state = S3;
			else 	 
			    next_state = S0;
		
	default next_state = S0;
   endcase		  
  end 
 
// C2 module
always @(*)
    begin
//    	insertChar  <= 0;
//        mapChar     <= 0;
//        cipherChar  <= 0;
//        displayChar <= 0;
//        done <= 0;
        
        case(present_state)
		
		S0:
		begin 
		insertChar  <= 1;
//        mapChar     <= 0;
//        cipherChar  <= 0;
        displayChar <= 0;
        end
			    
		S1: 
		begin 
//		insertChar  <= 0;
        mapChar     <= 1;
//        cipherChar  <= 0;
        displayChar <= 0;
        end
		
			    
		S2:  
		begin 
//		insertChar  <= 0;
//        mapChar     <= 0;
        cipherChar  <= 1;
        displayChar <= 0;
        end
        
		S3: 
		begin 
//		insertChar  <= 0;
//      mapChar     <= 0;
//      cipherChar  <= 0;
        displayChar <= 1;
        done        <= 1;
        end 
		
	default done <= 0;
	endcase
  end
  
endmodule

