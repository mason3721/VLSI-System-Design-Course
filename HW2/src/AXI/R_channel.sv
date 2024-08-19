//================================================
// Auther:      Lin Meng-Yu            
// Filename:    R_channel.sv                            
// Description: Read channel module of AXI bridge                  
// Version:     Submit Version 
// Date:		2023/10/31
//================================================

module R_channel(

	input ACLK, 
	input ARESETn,
// **************************** READ DATA S0 ************************** //
	input [7:0] 			RID_S0				,	
	input [31:0] 			RDATA_S0			,
	input [1:0] 			RRESP_S0			,
	input 					RLAST_S0			,
	input 					RVALID_S0			,
	output logic 			RREADY_S0			,	
// **************************** READ DATA S1 ************************** //
	input [7:0] 			RID_S1				,
	input [31:0] 			RDATA_S1			,
	input [1:0] 			RRESP_S1			,
	input 					RLAST_S1			,
	input 					RVALID_S1			,
	output logic 			RREADY_S1			,

// **************************** READ DATA DS ************************** //	
	input [7:0] 			RID_DS				,
	input 					RVALID_DS			,
	output logic 			RREADY_DS			,

// **************************** READ DATA M0 ************************** //		
	output logic [3:0] 		RID_M0				,
	output logic [31:0] 	RDATA_M0			,
	output logic [1:0] 		RRESP_M0			,
	output logic 			RLAST_M0			,
	output logic 			RVALID_M0			,
	input 					RREADY_M0			,

// **************************** READ DATA M1 ************************** //	
	output logic [3:0] 		RID_M1				,
	output logic [31:0] 	RDATA_M1			,
	output logic [1:0] 		RRESP_M1			,
	output logic 			RLAST_M1			,
	output logic 			RVALID_M1			,
	input 					RREADY_M1
);


	logic [7:0]			RID				;
	logic [31:0]		RDATA			;
	logic [1:0]			RRESP			;
	logic 				RLAST			;
	logic 				RVALID			;
	logic 				RREADY			;
	logic [1:0]			grant			;

// ***************************** FOR VIP ********************************** //
	logic 				RVALID_M0_vip	;
	logic 				RVALID_M1_vip	;

	logic 				RREADY_S0_vip	;
	logic 				RREADY_S1_vip	;
	logic 				RREADY_DS_vip	;

	assign 		RVALID_M0 	= 		RVALID_M0_vip;
	assign 		RVALID_M1 	=		RVALID_M1_vip;

	assign 		RREADY_S0 	= 		RREADY_S0_vip;
	assign 		RREADY_S1 	= 		RREADY_S1_vip;
	assign 		RREADY_DS 	= 		RREADY_DS_vip;

	assign		RID_M0 		= 		RID[3:0];
	assign		RDATA_M0 	= 		RDATA;
	assign		RRESP_M0 	= 		RRESP;
	assign		RLAST_M0 	= 		RLAST;

	assign		RID_M1 		= 		RID[3:0];
	assign		RDATA_M1 	= 		RDATA;
	assign		RRESP_M1 	= 		RRESP;
	assign		RLAST_M1 	= 		RLAST;



// ---------------------------------- Parameters -------------------------------------- //

 parameter M0VALID  	  = 	2'b10;
 parameter M1VALID  	  = 	2'b01;

 parameter S0VALID		  =		3'b100;
 parameter S1VALID		  =		3'b010;
 parameter DSVALID		  =		3'b001;

 parameter S0GRANT  	  = 	2'b00;
 parameter S1GRANT  	  = 	2'b01;
 parameter DSGRANT  	  = 	2'b10;

 parameter S0ADDR   	  = 	16'h0000;
 parameter S1ADDR   	  = 	16'h0001;

 parameter M0ID	 		  = 	2'b00;
 parameter M1ID  	      = 	2'b01;

// ------------------------------------------------------------------------------------ //


always_ff @(posedge ACLK or negedge ARESETn)begin
	if(~ARESETn)
		grant <= 2'd0;
	else begin
		case({RVALID_S0, RVALID_S1, RVALID_DS})
				S0VALID:	begin
					grant <=  2'd0;
				end

				S1VALID:	begin
					grant <=  2'd1;
				end

				DSVALID:	begin 
					grant <=  2'd2;
				end

				default: begin
					grant <=  grant;
				end
		endcase
	end
end

// ************** R Arbiter ******************* //
always_comb begin
	case(grant)
		S0GRANT: begin
			RREADY_S0_vip 	= 	RREADY;
			RREADY_S1_vip 	= 	1'b0;
			RREADY_DS_vip 	= 	1'b0;
		end
		S1GRANT: begin
			RREADY_S0_vip 	= 	1'b0;
			RREADY_S1_vip 	= 	RREADY;
			RREADY_DS_vip 	= 	1'b0;
		end
		DSGRANT: begin
			RREADY_S0_vip 	= 	1'b0;
			RREADY_S1_vip 	= 	1'b0;
			RREADY_DS_vip 	= 	RREADY;
		end
		default:begin
			RREADY_S0_vip 	= 	1'b0;
			RREADY_S1_vip 	= 	1'b0;
			RREADY_DS_vip 	= 	1'b0;
		end
	endcase
end


// ************* Read Channel Mux ************* //
always_comb begin
	case(grant)
		S0GRANT:begin
			RID 	= 	{RID_S0[7:6], 2'b00, RID_S0[3:0]};
			RDATA 	= 	RDATA_S0;
			RRESP 	= 	RRESP_S0;
			RLAST 	= 	RLAST_S0;
			RVALID 	= 	RVALID_S0;
		end
		S1GRANT:begin
			RID 	=  {RID_S1[7:6], 2'b01, RID_S1[3:0]};
			RDATA 	= 	RDATA_S1;
			RRESP 	= 	RRESP_S1;
			RLAST 	= 	RLAST_S1;
			RVALID 	= 	RVALID_S1;
		end
		DSGRANT:begin
			RID 	=  {RID_DS[7:6], 2'b10, RID_DS[3:0]};
			RDATA 	= 	32'd0;;
			RRESP 	= 	2'b11;
			RLAST 	= 	1'b1;
			RVALID 	= 	RVALID_DS;
		end
		default:begin
			RID 	= 	8'd0;
			RDATA 	= 	32'd0;
			RRESP 	= 	2'd0;
			RLAST 	= 	1'd0;
			RVALID 	= 	1'd0;
		end
	endcase
end

// ************* VALID DECODER ************* //
always_comb begin
	case(RID[7:6])
		M0ID: begin
			RVALID_M0_vip = RVALID;
			RVALID_M1_vip = 1'b0;
		end
		M1ID: begin
			RVALID_M0_vip = 1'b0;
			RVALID_M1_vip = RVALID;
		end
		default: begin
			RVALID_M0_vip = 1'b0;
			RVALID_M1_vip = 1'b0;
            end
	endcase
end

// ************** RREADY DECODER ************* //
always_comb begin
	case({RVALID_M0_vip, RVALID_M1_vip})
		M0VALID: begin
			RREADY = RREADY_M0;
		end
		M1VALID: begin 
			RREADY = RREADY_M1;
		end
		default: begin 
			RREADY = 1'd0;
		end
	endcase
end

endmodule
