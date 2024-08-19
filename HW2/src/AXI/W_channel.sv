//================================================
// Auther:      Lin Meng-Yu            
// Filename:    W_channel.sv                            
// Description: Data Write module of AXI bridge                  
// Version:     Submit Version 
// Date:		2023/10/31
//================================================

module W_channel(

    input ACLK,
    input ARESETn,
        
// **************************** Write ADDRESS M1 ************************** //
    input [31:0]            AWADDR_M1           ,
    input                   AWVALID_M1          ,
    input                   AWREADY_M1          ,
    input [31:0]            WDATA_M1            ,
    input [3:0]             WSTRB_M1            ,
    input                   WLAST_M1            ,
    input                   WVALID_M1           ,
    output logic            WREADY_M1           ,
        
// **************************** Write ADDRESS S0 ************************** //
    input                   WREADY_S0           ,
    output logic [31:0]     WDATA_S0            ,
    output logic [3:0]      WSTRB_S0            ,
    output logic            WLAST_S0            ,
    output logic            WVALID_S0           ,

// **************************** Write ADDRESS S1 ************************** //
    input                   WREADY_S1           ,
    output logic [31:0]     WDATA_S1            ,
    output logic [3:0]      WSTRB_S1            ,
    output logic            WLAST_S1            ,
    output logic            WVALID_S1           ,

 // **************************** Write ADDRESS DS ************************** //
    input                   WREADY_DS           ,
    output logic            WVALID_DS
        
);

    logic [31:0] AWADDR_M1_temp;

    
    assign WDATA_S0 = WDATA_M1;
    assign WSTRB_S0 = WSTRB_M1;
    assign WLAST_S0 = WLAST_M1;
        
    assign WDATA_S1 = WDATA_M1;
    assign WSTRB_S1 = WSTRB_M1;
    assign WLAST_S1 = WLAST_M1;

 // ------------------------- Parameters -------------------------------- //  
    parameter S0ADDR		  =		16'h0000;
    parameter S1ADDR		  =		16'h0001;

    parameter M0VALID		  =		3'b100;
    parameter M1VALID		  =		3'b010;
    parameter DSVALID		  =		3'b001;


 // ---------------------------------------------------------------------- //  
        
 // ------------------------- Combinational -------------------------------- //             
 // *************** AWREADY Mux ***************** //         
    always_comb begin
	    case({WVALID_S0, WVALID_S1, WVALID_DS})
		    M0VALID: begin
				WREADY_M1 = WREADY_S0;
			end
			M1VALID: begin
				WREADY_M1 = WREADY_S1;
			end
			DSVALID: begin
				WREADY_M1 = WREADY_DS;
			end
				
			default: begin
				WREADY_M1 = 1'b0;
			end
		endcase
	
	end

// *************** W Valid Decoder ***************** //    
// Use WVALID_M1 & AWVALID_M1 
     always_comb begin
         if(&( WVALID_M1 ~^ 1'b1) && &(AWVALID_M1 ~^ 1'b1)) begin
                case(AWADDR_M1[31:16]) 
                S0ADDR: begin 
                    WVALID_S0	=	WVALID_M1;
                    WVALID_S1	=	1'b0;
                    WVALID_DS	=	1'b0;
                 end
                S1ADDR: begin	
                    WVALID_S0	=	1'b0;
                    WVALID_S1	=	WVALID_M1;
                    WVALID_DS	=	1'b0;
                 end
                default: begin 
                    WVALID_S0	=	1'b0;
                    WVALID_S1	=	1'b0;
                    WVALID_DS	=	WVALID_M1;
                                            
                end
            endcase
        end
        else begin
            case(AWADDR_M1_temp[31:16])
                S0ADDR: begin
                    WVALID_S0	=	WVALID_M1;
                    WVALID_S1	=	1'b0;
                    WVALID_DS	=	1'b0;
                end
                
                S1ADDR: begin
                    WVALID_S0	=	1'b0;
                    WVALID_S1	=	WVALID_M1;
                    WVALID_DS	=	1'b0;
                end
                
                default: begin
                    WVALID_S0	=	1'b0;
                    WVALID_S1	=	1'b0;
                    WVALID_DS	=	WVALID_M1;
                    end
            endcase
		end
    end	

 // ------------------------- Sequential -------------------------------- //       
        
// ************ Address Write Temp ****************** //
    always_ff @ (posedge ACLK or negedge ARESETn) begin
        if(~ARESETn) begin
            AWADDR_M1_temp <= 32'd0;
        end
        else if (&(AWVALID_M1 ~^ 1'b1) && &(AWREADY_M1 ~^ 1'b1)) begin
            AWADDR_M1_temp <= AWADDR_M1;
        end
        else begin
            AWADDR_M1_temp <= AWADDR_M1_temp;
        end
    end

// ------------------------------------------------------------------------- //
	
	
endmodule
        
        