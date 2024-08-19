//================================================
// Auther:      Lin Meng-Yu            
// Filename:    AW_channel.sv                            
// Description: Write Address Channel module of AXI bridge                  
// Version:     HW3 Submit version 
// Date:		2023/11/23
//================================================

`include "AXI_define.svh"

module AW_channel(
    input  ACLK,
	input  ARESETn,

    // ********************* Masters ******************** //
	input logic  [`AXI_ID_BITS-1:0] 	AWID_M1		,
	input logic  [`AXI_ADDR_BITS-1:0]	AWADDR_M1	,
	input logic  [`AXI_LEN_BITS-1:0] 	AWLEN_M1	,
	input logic  [`AXI_SIZE_BITS-1:0] 	AWSIZE_M1	,
	input logic  [1:0] 				    AWBURST_M1	,
	input logic 	 					AWVALID_M1	,

	output logic 					    AWREADY_M1	,

   // ********************* Slaves ******************** //	
	output logic [`AXI_IDS_BITS-1:0] 	AWID_S1		,
	output logic [`AXI_ADDR_BITS-1:0] 	AWADDR_S1	,
	output logic [`AXI_LEN_BITS-1:0] 	AWLEN_S1	,
	output logic [`AXI_SIZE_BITS-1:0] 	AWSIZE_S1	,
	output logic [1:0] 					AWBURST_S1	,
	output logic 						AWVALID_S1	,

	output logic [`AXI_IDS_BITS-1:0] 	AWID_S2		,
	output logic [`AXI_ADDR_BITS-1:0] 	AWADDR_S2	,
	output logic [`AXI_LEN_BITS-1:0] 	AWLEN_S2	,
	output logic [`AXI_SIZE_BITS-1:0] 	AWSIZE_S2	,
	output logic [1:0] 					AWBURST_S2	,
	output logic 						AWVALID_S2	,

	output logic [`AXI_IDS_BITS-1:0] 	AWID_S3		,
	output logic [`AXI_ADDR_BITS-1:0] 	AWADDR_S3	,
	output logic [`AXI_LEN_BITS-1:0] 	AWLEN_S3	,
	output logic [`AXI_SIZE_BITS-1:0]	AWSIZE_S3	,
	output logic [1:0] 					AWBURST_S3	,
	output logic 						AWVALID_S3	,
	
	output logic [`AXI_IDS_BITS-1:0] 	AWID_S4		,
	output logic [`AXI_ADDR_BITS-1:0] 	AWADDR_S4	,
	output logic [`AXI_LEN_BITS-1:0] 	AWLEN_S4	,
	output logic [`AXI_SIZE_BITS-1:0] 	AWSIZE_S4	,
	output logic [1:0] 					AWBURST_S4	,
	output logic 						AWVALID_S4	,

	output logic [`AXI_IDS_BITS-1:0] 	AWID_S5		,
	output logic [`AXI_ADDR_BITS-1:0] 	AWADDR_S5	,
	output logic [`AXI_LEN_BITS-1:0] 	AWLEN_S5	,
	output logic [`AXI_SIZE_BITS-1:0] 	AWSIZE_S5	,
	output logic [1:0] 					AWBURST_S5	,
	output logic 						AWVALID_S5	,
	
	output logic [`AXI_IDS_BITS-1:0] 	AWID_SD		,
	output logic 						AWVALID_SD	,

	input  logic					    AWREADY_S1	,
	input  logic					    AWREADY_S2	,
	input  logic					    AWREADY_S3	,
	input  logic					    AWREADY_S4	,
	input  logic					    AWREADY_S5	,
	input  logic 						AWREADY_SD
);


	assign	AWID_S1 = {4'b0010,AWID_M1};
	assign	AWADDR_S1 = AWADDR_M1;
	assign	AWLEN_S1 = AWLEN_M1;
	assign	AWSIZE_S1 = AWSIZE_M1;
	assign	AWBURST_S1 = AWBURST_M1;
	
	assign	AWID_S2 = {4'b0010,AWID_M1};
	assign	AWADDR_S2 = AWADDR_M1;
	assign	AWLEN_S2 = AWLEN_M1;
	assign	AWSIZE_S2 = AWSIZE_M1;
	assign	AWBURST_S2 = AWBURST_M1;
	
	assign	AWID_S3 = {4'b0010,AWID_M1};
	assign	AWADDR_S3 = AWADDR_M1;
	assign	AWLEN_S3 = AWLEN_M1;
	assign	AWSIZE_S3 = AWSIZE_M1;
	assign	AWBURST_S3 = AWBURST_M1;
		
	assign	AWID_S4 = {4'b0010,AWID_M1};
	assign	AWADDR_S4 = AWADDR_M1;
	assign	AWLEN_S4 = AWLEN_M1;
	assign	AWSIZE_S4 = AWSIZE_M1;
	assign	AWBURST_S4 = AWBURST_M1;
	
	assign	AWID_S5 = {4'b0010,AWID_M1};
	assign	AWADDR_S5 = AWADDR_M1;
	assign	AWLEN_S5 = AWLEN_M1;
	assign	AWSIZE_S5 = AWSIZE_M1;
	assign	AWBURST_S5 = AWBURST_M1;
					
	assign	AWID_SD = {4'b0010,AWID_M1};

	always_comb begin		
		AWVALID_S1 = 1'd0;
		AWVALID_S2 = 1'd0;
		AWVALID_S3 = 1'd0;
		AWVALID_S4 = 1'd0;
		AWVALID_S5 = 1'd0;
		AWVALID_SD = 1'd0;

		if (32'h00020000 > AWADDR_M1 && AWADDR_M1 >= 32'h00010000) begin
			AWVALID_S1 = AWVALID_M1;
		end
		else if (32'h00030000 > AWADDR_M1 && AWADDR_M1 >= 32'h00020000) begin
			AWVALID_S2 = AWVALID_M1;
		end
		else if (32'h10000400 > AWADDR_M1 && AWADDR_M1 >= 32'h10000000) begin
			AWVALID_S3 = AWVALID_M1;
		end
		else if (32'h10010400 > AWADDR_M1 && AWADDR_M1 >= 32'h10010000) begin
			AWVALID_S4 = AWVALID_M1;
		end	
		else if (32'h20200000 > AWADDR_M1 && AWADDR_M1 >= 32'h20000000) begin
			AWVALID_S5 = AWVALID_M1;
		end
		else begin
			AWVALID_SD = AWVALID_M1;
		end
	end

	always_comb begin
	    case ({AWVALID_SD, AWVALID_S5, AWVALID_S4, AWVALID_S3, AWVALID_S2, AWVALID_S1})
	        6'b000001:begin
	            AWREADY_M1 = AWVALID_S1 & AWREADY_S1;
	        end
			6'b000010:begin
	            AWREADY_M1 = AWVALID_S2 & AWREADY_S2;
	        end
			6'b000100:begin
	            AWREADY_M1 = AWVALID_S3 & AWREADY_S3;
	        end
			6'b001000:begin
	            AWREADY_M1 = AWVALID_S4 & AWREADY_S4;
	        end
			6'b010000:begin
	            AWREADY_M1 = AWVALID_S5 & AWREADY_S5;
	        end
	        6'b100000:begin
	            AWREADY_M1 = AWVALID_SD & AWREADY_SD;
	        end
			default:begin
	            AWREADY_M1 = 1'd0;
	        end
	    endcase
	end
endmodule