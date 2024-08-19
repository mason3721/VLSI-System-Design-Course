//================================================
// Auther:      Lin Meng-Yu            
// Filename:    DefaultSlave.sv                            
// Description: DefaultSlave module of AXI Slave                  
// Version:     Submit Version 
// Date:		2023/10/31
//================================================


module DefaultSlave(

input ACLK,
input ARESETn, 

 // **************************** WRITE ADDRESS ************************** //
input [7:0] 				AWID_DS				,
input 						AWVALID_DS			,
output logic 				AWREADY_DS			,

 // **************************** WRITE DATA **************************** //
input 						WVALID_DS			,
output logic 				WREADY_DS			,

 // **************************** WRITE RESPONSE **************************** //
input 						BREADY_DS			,
output logic [7:0] 			BID_DS				,
output logic 				BVALID_DS			,

// **************************** READ ADDRESS  **************************** //
input [7:0] 				ARID_DS				,
input 						ARVALID_DS			,
output logic 				ARREADY_DS			,

// ***************************** READ DATA  **************************** //
input 						RREADY_DS			,
output logic [7:0] 			RID_DS				,
output logic 				RVALID_DS
);

// ------------------------------- State Parameter -------------------------- //
// **************** Default Slave Read *************** //                                   
parameter DS_R_ADDR = 1'b0;
parameter DS_R_DATA = 1'b1;

logic DS_R_state;
logic DS_R_next_state;
// **************** Default Slave Write *************** //  
parameter DS_W_ADDR = 2'd0;
parameter DS_W_DATA = 2'd1;
parameter DS_W_B 	 = 2'd2;

logic [1:0] DS_W_state;
logic [1:0] DS_W_next_state;
// -------------------------------------------------------------------------- //


// **************** Write Next State Combinational *************** //
	always_comb begin
		case(DS_W_state)
			DS_W_ADDR: begin
				 DS_W_next_state = (AWVALID_DS) ? DS_W_DATA : DS_W_ADDR;
			end
			DS_W_DATA: begin 
				DS_W_next_state = (WVALID_DS) ? DS_W_B : DS_W_DATA;
			end

			DS_W_B: begin 
				DS_W_next_state = (BREADY_DS) ? DS_W_ADDR : DS_W_B;
			end
			default: begin
				DS_W_next_state = 2'd0;
			end
		endcase
	end


// **************** Read Next State Combinational *************** //
	always_comb begin
		case(DS_R_state)
			DS_R_ADDR: begin
				DS_R_next_state = (ARVALID_DS) ? DS_R_DATA : DS_R_ADDR ;
			end
			DS_R_DATA: begin 
				DS_R_next_state = (RREADY_DS) ? DS_R_ADDR : DS_R_DATA;
			end
		endcase
	end

// ----------------------------- Sequential --------------------------------- //
	always_ff@(posedge ACLK or negedge ARESETn) begin
		if(~ARESETn) begin
			DS_R_state <= 1'b0;
			DS_W_state <= 2'b0;
		end
		else begin
			DS_R_state <= DS_R_next_state;
			DS_W_state <= DS_W_next_state;
		end
	end
// ------------------------------------------------------------------------- //


// ----------------------------- Output Combinational --------------------------------- //

// ****************  Write Output *************** //  
	always_comb begin
		case(DS_W_state)
			DS_W_ADDR: begin
				AWREADY_DS 	= 	1'b1;
				WREADY_DS 	= 	1'b0;
				BID_DS 		= 	8'd0;		
				BVALID_DS 	= 	1'b0;
			end

			DS_W_DATA: begin
				AWREADY_DS 	= 	1'b1;
				WREADY_DS 	= 	1'b1;	
				BID_DS 		= 	8'd0;		
				BVALID_DS 	= 	1'b0;		
			end

			DS_W_B: begin
				AWREADY_DS 	= 	1'b0;
				WREADY_DS 	=	1'b0;
				BID_DS 		= 	AWID_DS;
				BVALID_DS 	= 	1'b0;
			end

			default: begin
				AWREADY_DS 	= 	1'b0;
				WREADY_DS 	= 	1'b0;
				BID_DS 		= 	8'd0;
				BVALID_DS 	= 	1'b0;
			end
		endcase
	end

// ****************  Read Output *************** //  
	always_comb begin
		case(DS_R_state)
			DS_R_ADDR: begin
				ARREADY_DS	= 	1'b1;
				RID_DS 		= 	8'd0;		
				RVALID_DS 	= 	1'b0;
			end
			DS_R_DATA: begin
				ARREADY_DS 	= 	1'b0;
				RID_DS 		= 	ARID_DS;
				RVALID_DS 	= 	1'b1;
			end
		endcase
	end

endmodule                      
