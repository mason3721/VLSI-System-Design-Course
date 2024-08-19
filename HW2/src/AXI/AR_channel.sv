//================================================
// Auther:      Lin Meng-Yu            
// Filename:    AR_channel.sv                            
// Description: Address Read Channel module of AXI bridge                  
// Version:     Submit Version 
// Date:		2023/10/31
//================================================

`include "AXI_define.svh"

module AR_channel(
	
	input ACLK,
	input ARESETn,
	
// **************************** READ ADDRESS M0 ************************** //

	input [`AXI_ID_BITS-1:0] 				ARID_M0				,
	input [`AXI_ADDR_BITS-1:0] 				ARADDR_M0			,
	input [`AXI_LEN_BITS-1:0] 				ARLEN_M0			,
	input [`AXI_SIZE_BITS-1:0] 				ARSIZE_M0			,
	input [1:0] 							ARBURST_M0			,
	input 									ARVALID_M0			,
	
// *************************** READ ADDRESS M1 *************************** //
	input [`AXI_ID_BITS-1:0]   				ARID_M1				,
	input [`AXI_ADDR_BITS-1:0] 				ARADDR_M1			,
	input [`AXI_LEN_BITS-1:0]   			ARLEN_M1			,
	input [`AXI_SIZE_BITS-1:0] 				ARSIZE_M1			,
	input [1:0] 							ARBURST_M1			,
	input 									ARVALID_M1			,

// ****************** SIGNAL FROM SLAVES TO MASTERS ************************ //
	input ARREADY_S0,
	input ARREADY_S1,
	input ARREADY_DS,

	input RVALID_S0,
	input RVALID_S1,
	input RVALID_DS,

	input RREADY_S0,
	input RREADY_S1,
	input RREADY_DS,

// ************** SIGNAL FROM MASTERS TO SLAVES ************************** //
	output logic [7:0] ARID,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR,
	output logic [`AXI_LEN_BITS-1:0] ARLEN,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE,
	output logic [1:0] ARBURST,
	//output logic ARVALID,
	
	output logic ARVALID_S0,
	output logic ARVALID_S1,
	output logic ARVALID_DS,
	
	output logic ARREADY_M0,
	output logic ARREADY_M1
);

// **************** AXI WIRES *************//

logic ARVALID;
logic ARREADY;
logic grant;


// ***************************** FOR VIP ********************************** //
logic ARVALID_S0_vip;
logic ARVALID_S1_vip;
logic ARVALID_DS_vip;

logic ARREADY_M0_vip;
logic ARREADY_M1_vip;

assign ARREADY_M0 = ARREADY_M0_vip;
assign ARREADY_M1 = ARREADY_M1_vip;


assign ARVALID_S0 = ARVALID_S0_vip;
assign ARVALID_S1 = ARVALID_S1_vip;
assign ARVALID_DS = ARVALID_DS_vip;

logic next_S0_return;	     
logic next_S1_return;
logic next_DS_return;


logic S0_return;	     	 //	retrun 	  : 	1	
logic S1_return;			 // no return : 	0
logic DS_return;

// ---------------------------------- Parameters -------------------------------------- //

 parameter M0VALID  	  = 	2'b10;
 parameter M1VALID  	  = 	2'b01;

 parameter S0VALID		  =		3'b100;
 parameter S1VALID		  =		3'b010;
 parameter DSVALID		  =		3'b001;

 parameter M0GRANT  	  = 	1'b0;
 parameter M1GRANT  	  = 	1'b1;

 parameter S0ADDR   	  = 	16'h0000;
 parameter S1ADDR   	  = 	16'h0001;

// ------------------------------------------------------------------------------------ //



// ----------------------------- NEXT STATE / RETURN LOGIC -------------------------------- //
// *********** S0  NEXT RETURN *************** //

always_comb begin
	if(ARVALID_S0 && ARREADY_S0) begin
		next_S0_return = 1'b0;
	end

	else if(RVALID_S0 && RREADY_S0)begin
		next_S0_return = 1'b1;
	end
	else begin
		next_S0_return = S0_return;
	end

end


// *********** S1 NEXT RETURN *************** //
always_comb begin
	if(ARVALID_S1 && ARREADY_S1) begin
		next_S1_return = 1'b0;
	end
	else if(RVALID_S1 && RREADY_S1) begin
		next_S1_return = 1'b1;
	end
	else begin
		next_S1_return = S1_return;
	end

end

// *********** DS NEXT RETURN *************** //
always_comb begin		
	if(ARVALID_DS && ARREADY_DS) begin
		next_DS_return = 1'b0;
	end
	else if(RVALID_DS && RREADY_DS) begin
		next_DS_return = 1'b0;
	end
	else begin
		next_DS_return = 1'b0;
	end
end
// --------------------------------------------------------------------- //

// ------------------------- Sequential -------------------------------- //
// *********** Return *************** //

always_ff@(posedge ACLK or negedge ARESETn) begin
	if(~ARESETn) begin
		S0_return 		<= 		1'b1;
		S1_return 		<= 		1'b1;
		DS_return 		<= 		1'b0;
	end

	else begin
		S0_return 		<= 		next_S0_return;
		S1_return 		<=	 	next_S1_return;
		DS_return 		<= 		next_DS_return;
	end
end

// ************ AR Arbiter *********** //

always_ff @(posedge ACLK or negedge ARESETn) begin
	if(~ARESETn)
		grant <= 1'b0;
	else begin
		case({ARVALID_M0, ARVALID_M1})
			M0VALID: begin
				grant <= 1'b0;
			end
			M1VALID: begin
				grant <= 1'b1;
			end
			default: begin 
				grant <= grant;
			end
		endcase
	end
end

// ----------------------------------------------------------------------- //

// --------------------------- Combinational Select ---------------------------- //
// ************** MUX **************** //
always_comb begin
	case(grant)
		M0GRANT:begin
			ARID 		= 		{4'b0000, ARID_M0};
			ARADDR  	= 		ARADDR_M0;
			ARLEN 		= 		ARLEN_M0;
			ARSIZE  	= 		ARSIZE_M0;
			ARBURST 	= 		ARBURST_M0;
			ARVALID 	= 		ARVALID_M0;
		end

		M1GRANT:begin
			ARID 		= 		{4'b0100, ARID_M1};
			ARADDR 		= 		ARADDR_M1;
			ARLEN 		= 		ARLEN_M1;
			ARSIZE 		= 		ARSIZE_M1;
			ARBURST 	= 		ARBURST_M1;
			ARVALID 	= 		ARVALID_M1;
		end
	endcase
end

// ************ VALID Decoder ************** //
always_comb begin
	case(ARADDR[31:16])
		S0ADDR: begin     // Slave S0
			ARVALID_S0_vip 		= 		(S0_return && &(grant ~^ 1'b0)) ? ARVALID : 1'd0;
			ARVALID_S1_vip 		= 		1'd0;
			ARVALID_DS_vip 		= 		1'd0;
		end

		S1ADDR: begin     // S1ave S1
			ARVALID_S0_vip 		= 		1'd0;
			ARVALID_S1_vip 		= 		(S1_return && &(grant ~^ 1'b1)) ? ARVALID : 1'd0;
			ARVALID_DS_vip 		= 		1'd0;
		end

		default: begin      // Default Slave
			ARVALID_S0_vip 		= 		1'd0;
			ARVALID_S1_vip 		= 		1'd0;
			ARVALID_DS_vip 		= 		1'd0;
		end
	endcase
end

// ***************** AR DE MUX ********************* //
always_comb begin
	case(grant)
		M0GRANT: begin
			ARREADY_M0_vip = ARREADY;
			ARREADY_M1_vip = 1'b0;
		end


		M1GRANT:begin
			ARREADY_M0_vip = 1'b0;
			ARREADY_M1_vip = ARREADY;
		end
	endcase
end

// ************** READY DECODER ***************** //
always_comb begin
	case({ARVALID_S0_vip , ARVALID_S1_vip , ARVALID_DS_vip})
		S0VALID: begin
			 ARREADY = ARREADY_S0;
		end

		S1VALID:begin
			 ARREADY = ARREADY_S1;
		end

		DSVALID: begin 
			ARREADY = ARREADY_DS;
		end

		default: begin 
			ARREADY = 1'b0;
		end
	endcase
end
// ----------------------------------------------------------------------- //

endmodule
