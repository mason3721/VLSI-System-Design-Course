//================================================
// Auther:      Lin Meng-Yu            
// Filename:    B_channel.sv                            
// Description: Write Response module of AXI bridge                  
// Version:     Submit Version 
// Date:		2023/10/31
//================================================

module B_channel(
        
    input ACLK,
    input ARESETn,	
            
 // **************************** WRITE RESPONSE S0 ************************** //
    input [7:0]             BID_S0              ,
    input [1:0]             BRESP_S0            ,
    input                   BVALID_S0           ,
    output logic            BREADY_S0           ,
        
 // **************************** WRITE RESPONSE S1 ************************** //
    input [7:0]             BID_S1              ,
    input [1:0]             BRESP_S1            ,
    input                   BVALID_S1           ,
    output logic            BREADY_S1           ,
        
// **************************** WRITE RESPONSE DS ************************** //
    input [7:0]             BID_DS              ,
    input                   BVALID_DS           ,
    output logic            BREADY_DS           ,
        
// **************************** WRITE RESPONSE M1 ************************** //
    input                   BREADY_M1           ,
    output logic [7:0]      BID_M1              ,
    output logic [1:0]      BRESP_M1            ,
    output logic            BVALID_M1
);


// -------------------------- Parameters ------------------------------ //
    parameter S0VALID   = 3'b001;
    parameter S1VALID   = 3'b010;
    parameter DSVALID   = 3'b100;

    parameter S0GRANT   = 2'b00;
    parameter S1GRANT   = 2'b01;
    parameter DSGRANT   = 2'b10;

    parameter M0READY   = 2'b00;
    parameter M1READY   = 2'b01;
    parameter DSREADY   = 2'b10;
            
    logic [1:0] grant;

// ------------------------- Sequential -------------------------------- //
// ************** B Arbiter ******************* //           
    always_ff @(posedge ACLK or negedge ARESETn) begin
		if(!ARESETn)begin
			grant <= 2'd0;
		end
		else begin
			case({BVALID_DS, BVALID_S1, BVALID_S0})
				S0VALID : begin
                     grant  <=  2'd0;
                end

				S1VALID : begin 
                    grant   <=  2'd1;
                end

				DSVALID : begin 
                    grant   <=  2'd2;
                end

				default : begin
                    grant   <=  grant;
                end
			endcase
		end
    end   
// ----------------------------------------------------------------------- //	

// ------------------------- Combinational -------------------------------- //
// **************** B Channel Mux *************** //  
    always_comb begin
         case(grant)
            S0GRANT : begin
                BID_M1		=	{BID_S0[7:6], 2'b00, BID_S0[3:0]};
                BRESP_M1	=	BRESP_S0;
                BVALID_M1	=	BVALID_S0;
                    
            end
            S1GRANT : begin
                BID_M1		=	{BID_S1[7:6], 2'b01,  BID_S1[3:0]};
                BRESP_M1	=	BRESP_S1;
                BVALID_M1	= 	BVALID_S1;
                    
            end

            DSGRANT : begin
                BID_M1	    =	{BID_DS[7:6], 2'b10, BID_DS[3:0]};
                BRESP_M1	=	2'b11;
                BVALID_M1	=	BVALID_DS;
            end

            default : begin
                BID_M1		=	{BID_S0[7:6], 2'b00, BID_S0[3:0]};
                BRESP_M1	=	BRESP_S0;
                BVALID_M1	=	BVALID_S0;
            end
        endcase	
    end   

// **************** B Ready Decoder *************** //  
    always_comb begin
        case (BID_M1[5:4] )
            M0READY : begin
                BREADY_S0	= BREADY_M1;
                BREADY_S1	= 1'b0;
                BREADY_DS	= 1'b0;
            end

            M1READY : begin
                BREADY_S0	= 1'b0;
                BREADY_S1	= BREADY_M1;
                BREADY_DS	= 1'b0;
            end

            DSREADY : begin
                BREADY_S0	= 1'b0;
                BREADY_S1	= 1'b0;
                BREADY_DS	= BREADY_M1;
            end

            default : begin
                BREADY_S0	= 1'b0;
                BREADY_S1	= 1'b0;
                BREADY_DS	= 1'b0;
            end
            endcase
         end
        
        
endmodule
