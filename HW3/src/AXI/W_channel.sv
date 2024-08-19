//================================================
// Auther:      Lin Meng-Yu            
// Filename:    W_channel.sv                            
// Description: Write Data Channel module of AXI bridge                  
// Version:     HW3 Submit version 
// Date:		2023/11/23
//================================================

`include "AXI_define.svh"

module W_channel(
    input  ACLK,
	input  ARESETn,

    // ********************* Masters ******************** //
    input logic  [`AXI_ADDR_BITS-1:0] 	AWADDR_M1	,
	input logic  					  	AWVALID_M1	,
	input logic  					  	AWREADY_M1	,
	input logic  [`AXI_DATA_BITS-1:0] 	WDATA_M1	,
	input logic  [`AXI_STRB_BITS-1:0] 	WSTRB_M1	,
	input logic  					  	WLAST_M1	,
	input logic  					  	WVALID_M1	,

	output logic 				      	WREADY_M1	,

   // ********************* Slaves ******************** //	
	output logic [`AXI_DATA_BITS-1:0] 	WDATA_S1	,
	output logic [`AXI_STRB_BITS-1:0] 	WSTRB_S1	,
	output logic 						WLAST_S1	,
	output logic 						WVALID_S1	,

    output logic [`AXI_DATA_BITS-1:0] 	WDATA_S2	,
	output logic [`AXI_STRB_BITS-1:0] 	WSTRB_S2	,
	output logic 						WLAST_S2	,
	output logic 						WVALID_S2	,

    output logic [`AXI_DATA_BITS-1:0] 	WDATA_S3	,
	output logic [`AXI_STRB_BITS-1:0] 	WSTRB_S3	,
	output logic 						WLAST_S3	,
	output logic 						WVALID_S3	,
	
	output logic [`AXI_DATA_BITS-1:0] 	WDATA_S4	,
	output logic [`AXI_STRB_BITS-1:0] 	WSTRB_S4	,
	output logic 						WLAST_S4	,
	output logic 						WVALID_S4	,

    output logic [`AXI_DATA_BITS-1:0] 	WDATA_S5	,
	output logic [`AXI_STRB_BITS-1:0] 	WSTRB_S5	,
	output logic 						WLAST_S5	,
	output logic 						WVALID_S5	,
	
	output logic 						WLAST_SD	,
	output logic 						WVALID_SD	,

	input logic  						WREADY_S1	,
	input logic  						WREADY_S2	,
	input logic  						WREADY_S3	,
	input logic  						WREADY_S4	,
	input logic  						WREADY_S5	,			
	input logic  						WREADY_SD

);

	// ------------------ AWADDR Reg --------------------//
	logic [31:0] AWADDR;
	logic [31:0] AWADDR_temp;

	always_ff @(posedge ACLK) begin
	    if (!ARESETn) begin
	        AWADDR_temp <= 32'd0;
	    end
	    else begin
	        AWADDR_temp <= AWADDR;
	    end
	end

	assign AWADDR = (AWVALID_M1 & AWREADY_M1) ? AWADDR_M1 : AWADDR_temp;

    assign WDATA_S1 = WDATA_M1;
    assign WSTRB_S1 = WSTRB_M1;
    assign WLAST_S1 = WLAST_M1;
 
    assign WDATA_S2 = WDATA_M1;
    assign WSTRB_S2 = WSTRB_M1;
    assign WLAST_S2 = WLAST_M1;
 
    assign WDATA_S3 = WDATA_M1;
    assign WSTRB_S3 = WSTRB_M1;
    assign WLAST_S3 = WLAST_M1;

	assign WDATA_S4 = WDATA_M1;
    assign WSTRB_S4 = WSTRB_M1;
    assign WLAST_S4 = WLAST_M1;
 
    assign WDATA_S5 = WDATA_M1;
    assign WSTRB_S5 = WSTRB_M1;
    assign WLAST_S5 = WLAST_M1;
 
    assign WLAST_SD = WLAST_M1;

	always_comb begin
		WVALID_S1  =   1'd0;
		WVALID_S2  =   1'd0;
		WVALID_S3  =   1'd0;
		WVALID_S4  =   1'd0;
		WVALID_S5  =   1'd0;	
		WVALID_SD  =   1'd0;
	
	    if (32'h00020000 > AWADDR && AWADDR >= 32'h00010000) begin
			WVALID_S1 = WVALID_M1;
		end
		else if (32'h00030000 > AWADDR && AWADDR >= 32'h00020000) begin
			WVALID_S2 = WVALID_M1;
		end
		else if (32'h10000400 > AWADDR && AWADDR >= 32'h10000000) begin
			WVALID_S3 = WVALID_M1;
		end
		else if (32'h10010400 > AWADDR && AWADDR >= 32'h10010000) begin
			WVALID_S4 = WVALID_M1;
		end
		else if (32'h20200000 > AWADDR && AWADDR >= 32'h20000000) begin
			WVALID_S5 = WVALID_M1;
		end
		else begin
			WVALID_SD = WVALID_M1;
		end
	end

	always_comb begin
	    case ({WVALID_SD, WVALID_S5, WVALID_S4, WVALID_S3, WVALID_S2, WVALID_S1})
	        6'b000001: begin 
				WREADY_M1 = WVALID_S1 && WREADY_S1;
			end
	        6'b000010: begin
				WREADY_M1 = WVALID_S2 && WREADY_S2;
			end
	        6'b000100: begin
				WREADY_M1 = WVALID_S3 && WREADY_S3;
			end
			6'b001000: begin
				WREADY_M1 = WVALID_S4 && WREADY_S4;
			end
	        6'b010000: begin 
				WREADY_M1 = WVALID_S5 && WREADY_S5;   
			end     
	        6'b100000: begin 
				WREADY_M1 = WVALID_SD && WVALID_SD;
			end
			default: begin 
				WREADY_M1 = 1'b0;
			end
	    endcase
	end
endmodule
