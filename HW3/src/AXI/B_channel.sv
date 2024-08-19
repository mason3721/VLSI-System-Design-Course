//================================================
// Auther:      Lin Meng-Yu            
// Filename:    AR_channel.sv                            
// Description: Write Response Channel module of AXI bridge                  
// Version:     HW3 Submit version 
// Date:		2023/11/19
//================================================

`include "AXI_define.svh"

module B_channel(
    input  ACLK,
	input  ARESETn,

    // ********************* Masters ******************** //
	output logic [`AXI_ID_BITS-1:0] 	BID_M1		,
	output logic [1:0] 					BRESP_M1	,
	output logic 						BVALID_M1	,
	input  								BREADY_M1	,

   // ********************* Slaves ******************** //		
	input logic  [`AXI_IDS_BITS-1:0] 	BID_S1		,
	input logic  [1:0] 					BRESP_S1	,
	input logic  						BVALID_S1	,

    input logic  [`AXI_IDS_BITS-1:0] 	BID_S2		,
	input logic  [1:0] 					BRESP_S2	,
	input logic  						BVALID_S2	,

    input logic  [`AXI_IDS_BITS-1:0]	BID_S3		,
	input logic  [1:0] 					BRESP_S3	,
	input logic  						BVALID_S3	,
	
	input logic  [`AXI_IDS_BITS-1:0] 	BID_S4		,
	input logic  [1:0] 					BRESP_S4	,
	input logic  						BVALID_S4	,

    input logic [`AXI_IDS_BITS-1:0] 	BID_S5		,
	input logic [1:0] 					BRESP_S5	,
	input logic 						BVALID_S5	,
	
	input logic [`AXI_IDS_BITS-1:0] 	BID_SD		,
	input logic [1:0] 					BRESP_SD	,
	input logic 						BVALID_SD	,

	output logic 						BREADY_S1	,
	output logic 						BREADY_S2	,
	output logic 						BREADY_S3	,
	output logic 						BREADY_S4	,
	output logic 						BREADY_S5	,
	output logic 						BREADY_SD
);

	logic [5:0] grant_B;
	logic [5:0] next_grant_B;

	always_ff @(posedge ACLK) begin 
	    if (!ARESETn) begin
	        grant_B <= 6'b000000;
	    end
	    else begin
	        if ( BREADY_S1 | BREADY_S2 | BREADY_S3 | BREADY_S4 | BREADY_S5 |BREADY_SD) begin
	            if (next_grant_B == 6'b100000) begin
	                grant_B <= 6'b000001;
	            end
	            else begin
	                grant_B <= {grant_B[4:0], 1'b0};
	            end
	        end
	        else begin
	            grant_B <= next_grant_B;
	        end
	    end
	end

	/*always_comb begin
		if (BVALID_S1) begin
			next_grant_B = 6'b000001;
		end
		else if(BVALID_S2)begin
			next_grant_B = 6'b000010;
		end
		else if(BVALID_S3)begin
			next_grant_B = 6'b000100;
		end
		else if(BVALID_S4)begin
			next_grant_B = 6'b001000;
		end
		else if(BVALID_S5)begin
			next_grant_B = 6'b010000;
		end
		else if(BVALID_SD)begin
			next_grant_B = 6'b100000;
		end
		else begin
			next_grant_B = 6'b000000;
		end
	end*/
	always_comb begin
		case ({BVALID_SD, BVALID_S5, BVALID_S4, BVALID_S3, BVALID_S2, BVALID_S1})
			6'b000001:begin
				next_grant_B = 6'b000001;
			end
			6'b000010:begin
				next_grant_B = 6'b000010;
			end
			6'b000100:begin
				next_grant_B = 6'b000100;
			end
			6'b001000:begin
				next_grant_B = 6'b001000;
			end
			6'b010000:begin
				next_grant_B = 6'b010000;
			end
			6'b100000:begin
				next_grant_B = 6'b100000;
			end
			default: begin
				next_grant_B = 6'b000000;
			end
		endcase

	end

	always_comb begin
	    case (next_grant_B)
			6'b000001: begin
				BID_M1 = BID_S1[3:0];
				BRESP_M1 = BRESP_S1;
				BVALID_M1 = BVALID_S1 & (BID_S1[7:4] == 4'b0010);
			end
			6'b000010: begin
				BID_M1 = BID_S2[3:0];
				BRESP_M1 = BRESP_S2;
				BVALID_M1 = BVALID_S2 & (BID_S2[7:4] == 4'b0010);
			end
			6'b000100: begin
				BID_M1 = BID_S3[3:0];
				BRESP_M1 = BRESP_S3;
				BVALID_M1 = BVALID_S3 & (BID_S3[7:4] == 4'b0010);
			end
			6'b001000: begin
				BID_M1 = BID_S4[3:0];
				BRESP_M1 = BRESP_S4;
				BVALID_M1 = BVALID_S4 & (BID_S4[7:4] == 4'b0010);
			end
			6'b010000: begin
				BID_M1 = BID_S5[3:0];
				BRESP_M1 = BRESP_S5;
				BVALID_M1 = BVALID_S5 & (BID_S5[7:4] == 4'b0010);
			end
			6'b100000: begin
				BID_M1 = BID_SD[3:0];
				BRESP_M1 = BRESP_SD;
				BVALID_M1 = BVALID_SD & (BID_SD[7:4] == 4'b0010);
			end
			default: begin
				BID_M1 = 4'd0;
				BRESP_M1 = 2'h0;
				BVALID_M1 = 1'd0;
			end
	    endcase
	end


	assign  BREADY_S1 = BREADY_M1 && (BID_S1[7:4] == 4'b0010);
	assign  BREADY_S2 = BREADY_M1 && (BID_S2[7:4] == 4'b0010);
	assign  BREADY_S3 = BREADY_M1 && (BID_S3[7:4] == 4'b0010);
	assign  BREADY_S4 = BREADY_M1 && (BID_S4[7:4] == 4'b0010);	
	assign  BREADY_S5 = BREADY_M1 && (BID_S5[7:4] == 4'b0010);
	assign  BREADY_SD = BREADY_M1 && (BID_SD[7:4] == 4'b0010);

    
endmodule