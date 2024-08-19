//================================================
// Auther:      Lin Meng-Yu            
// Filename:    AW_channel.sv                            
// Description: Address Write channel module of AXI bridge                  
// Version:     Submit Version 
// Date:		2023/10/31
//================================================

module AW_channel(
         
// *********************** ADDRESS WRITE M1 ************************** //
    input                   AWVALID_M1          ,
    input [3:0]             AWID_M1             ,
    input [31:0]            AWADDR_M1           ,
    input [3:0]             AWLEN_M1            ,
    input [2:0]             AWSIZE_M1           ,
    input [1:0]             AWBURST_M1          ,
    output logic            AWREADY_M1          ,
                                    
// *********************** ADDRESS WRITE S0 ************************** //
    input                   AWREADY_S0          ,
    output logic            AWVALID_S0          ,
    output logic [7:0]      AWID_S0             ,            
    output logic [31:0]     AWADDR_S0           ,
    output logic [3:0]      AWLEN_S0            ,
    output logic [2:0]      AWSIZE_S0           ,
    output logic [1:0]      AWBURST_S0          ,
        
// *********************** ADDRESS WRITE S1 ************************** //
    input                   AWREADY_S1          ,
    output logic            AWVALID_S1          ,
    output logic [7:0]      AWID_S1             ,            
    output logic [31:0]     AWADDR_S1           ,
    output logic [3:0]      AWLEN_S1            ,
    output logic [2:0]      AWSIZE_S1           ,
    output logic [1:0]      AWBURST_S1          ,
        
 // *********************** ADDRESS WRITE DS ************************** //
    input                   AWREADY_DS          ,
    output logic            AWVALID_DS          ,
    output logic [7:0]      AWID_DS                              
);
        
    assign AWID_S0      =   {4'b0100, AWID_M1}  ;
    assign AWADDR_S0    =   AWADDR_M1           ;
    assign AWLEN_S0		=	AWLEN_M1            ;
    assign AWSIZE_S0	=	AWSIZE_M1           ;
    assign AWBURST_S0	=	AWBURST_M1          ;       
        
    assign AWID_S1      =   {4'b0100, AWID_M1}  ;
    assign AWADDR_S1    =   AWADDR_M1           ;
    assign AWLEN_S1		=	AWLEN_M1            ;
    assign AWSIZE_S1	=	AWSIZE_M1           ;
    assign AWBURST_S1	=	AWBURST_M1          ;        
             
    assign AWID_DS		=	{4'b0100, AWID_M1}  ;       



// ---------------------------------- Parameters -------------------------------------- //

 parameter S0VALID		  =		3'b100;
 parameter S1VALID		  =		3'b010;
 parameter DSVALID		  =		3'b001;

 parameter S0ADDR   	  = 	16'h0000;
 parameter S1ADDR   	  = 	16'h0001;

// ------------------------------------------------------------------------------------ //    



// --------------------------- Combinational Select ---------------------------- //               
// *************** AW Valid Decoder ***************** //       
    always_comb begin
        case(AWADDR_M1[31:16]) 

		    S0ADDR: begin     // Slave S0
			    AWVALID_S0	=	AWVALID_M1;
			    AWVALID_S1	=	1'b0;
			    AWVALID_DS	=	1'b0;
		    end

		    S1ADDR: begin	    // Slave S1
			    AWVALID_S0	=	1'b0;
			    AWVALID_S1	=	AWVALID_M1;
			    AWVALID_DS	=	1'b0;
		    end
			
		    default: begin          // Slave DS
			    AWVALID_S0	=	1'b0;
			    AWVALID_S1	=	1'b0;
			    AWVALID_DS	=	AWVALID_M1;									
		    end
		endcase
      end	
      
      
// *************** AW Ready Mux ***************** // 
        always_comb begin
		case({AWVALID_S0, AWVALID_S1, AWVALID_DS})
			S0VALID:begin
				AWREADY_M1 = AWREADY_S0;
			end
			S1VALID:begin
				AWREADY_M1 = AWREADY_S1;
			end
			DSVALID:begin
				AWREADY_M1 = AWREADY_DS;
			end
				
			default: begin
				AWREADY_M1 = 1'b0;
			end
		endcase
	
	end
	
	
endmodule
               