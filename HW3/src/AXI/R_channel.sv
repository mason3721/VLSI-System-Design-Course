//================================================
// Auther:      Lin Meng-Yu            
// Filename:    R_channel.sv                            
// Description: Read Data Channel module of AXI bridge                  
// Version:     HW3 Submit version 
// Date:		2023/11/23
//================================================

`include "AXI_define.svh"

module R_channel(
    input  ACLK,
	input  ARESETn,

    // ********************* Masters ******************** //
	output logic [`AXI_ID_BITS-1:0]     RID_M0      ,
	output logic [`AXI_DATA_BITS-1:0]   RDATA_M0    ,
	output logic [1:0]                  RRESP_M0    ,
	output logic                        RLAST_M0    ,
	output logic                        RVALID_M0   ,

	output logic [`AXI_ID_BITS-1:0]     RID_M1      ,
	output logic [`AXI_DATA_BITS-1:0]   RDATA_M1    ,
	output logic [1:0]                  RRESP_M1    ,
	output logic                        RLAST_M1    ,
	output logic                        RVALID_M1   ,

    input                               RREADY_M0   ,
	input                               RREADY_M1   ,

    // ********************* Slaves ******************** //
	input  [`AXI_IDS_BITS-1:0]          RID_S0      ,
	input  [`AXI_DATA_BITS-1:0]         RDATA_S0    ,
	input  [1:0]                        RRESP_S0    ,
	input                               RLAST_S0    ,
	input                               RVALID_S0   ,

	input  [`AXI_IDS_BITS-1:0]          RID_S1      ,
	input  [`AXI_DATA_BITS-1:0]         RDATA_S1    ,
	input  [1:0]                        RRESP_S1    ,
	input                               RLAST_S1    ,
	input                               RVALID_S1   ,

    input  [`AXI_IDS_BITS-1:0]          RID_S2      ,
	input  [`AXI_DATA_BITS-1:0]         RDATA_S2    ,
	input  [1:0]                        RRESP_S2    ,
	input                               RLAST_S2    ,
	input                               RVALID_S2   ,

    input  [`AXI_IDS_BITS-1:0]          RID_S3      ,
	input  [`AXI_DATA_BITS-1:0]         RDATA_S3    ,
	input  [1:0]                        RRESP_S3    ,
	input                               RLAST_S3    ,
	input                               RVALID_S3   ,
	
	input  [`AXI_IDS_BITS-1:0]          RID_S4      ,
	input  [`AXI_DATA_BITS-1:0]         RDATA_S4    ,
	input  [1:0]                        RRESP_S4    ,
	input                               RLAST_S4    ,
	input                               RVALID_S4   ,

    input  [`AXI_IDS_BITS-1:0]          RID_S5      ,
	input  [`AXI_DATA_BITS-1:0]         RDATA_S5    ,
	input  [1:0]                        RRESP_S5    ,
	input                               RLAST_S5    ,
	input                               RVALID_S5   ,
	
	input  [`AXI_IDS_BITS-1:0]          RID_SD      ,
	input  [`AXI_DATA_BITS-1:0]         RDATA_SD    ,
	input  [1:0]                        RRESP_SD    ,
	input                               RLAST_SD    ,
	input                               RVALID_SD   ,

    output logic                        RREADY_S0   ,
	output logic                        RREADY_S1   ,
	output logic                        RREADY_S2   ,
	output logic                        RREADY_S3   ,
	output logic                        RREADY_S4   ,
    output logic                        RREADY_S5   ,
	output logic                        RREADY_SD
);

// ---------------------- Grant R ---------------------- //
    logic [6:0]     grant_R       ;
    logic [6:0]     next_grant_R  ;


    /*always_comb begin
    	if (RVALID_S0) begin
    		next_grant_R = 7'b0000001;
    	end
    	else if (RVALID_S1) begin
    		next_grant_R = 7'b0000010;
    	end
    	else if (RVALID_S2) begin
    		next_grant_R = 7'b0000100;
    	end
    	else if (RVALID_S3) begin
    		next_grant_R = 7'b0001000;
    	end
    	else if (RVALID_S4) begin
    		next_grant_R = 7'b0010000;
    	end		
    	else if (RVALID_S5) begin
    		next_grant_R = 7'b0100000;
    	end
    	else if (RVALID_SD) begin
    		next_grant_R = 7'b1000000;
    	end
    	else begin
    		next_grant_R = 7'b0000000;
    	end
    end*/

    always_comb begin
        case ({RVALID_SD, RVALID_S5, RVALID_S4, RVALID_S3, RVALID_S2, RVALID_S1, RVALID_S0})
            7'b0000001:begin
    		    next_grant_R = 7'b0000001;                
            end
            7'b0000010:begin
    		    next_grant_R = 7'b0000010;                
            end            
            7'b0000100:begin
    		    next_grant_R = 7'b0000100;                
            end
            7'b0001000:begin
    		    next_grant_R = 7'b0001000;                
            end
            7'b0010000:begin
    		    next_grant_R = 7'b0010000;                
            end
            7'b0100000:begin
    		    next_grant_R = 7'b0100000;                
            end
            7'b1000000:begin
    		    next_grant_R = 7'b1000000;                
            end     
            default: begin
                next_grant_R = 7'b0000000; 
            end       
        endcase
    end


    always_comb begin
        case (next_grant_R)
            7'b0000001:begin
                RID_M0 = RID_S0[3:0];
                RDATA_M0 = RDATA_S0;
                RRESP_M0 = RRESP_S0;
                RLAST_M0 = RLAST_S0;

                RID_M1 = RID_S0[3:0];
                RDATA_M1 = RDATA_S0;
                RRESP_M1 = RRESP_S0;
                RLAST_M1 = RLAST_S0;

                RVALID_M0 = RVALID_S0 & (RID_S0[7:4] == 4'b0001);
                RVALID_M1 = RVALID_S0 & (RID_S0[7:4] == 4'b0010);
            end
            7'b0000010:begin
                RID_M0   = RID_S1[3:0];
                RDATA_M0 = RDATA_S1;
                RRESP_M0 = RRESP_S1;
                RLAST_M0 = RLAST_S1;

                RID_M1 = RID_S1[3:0];
                RDATA_M1 = RDATA_S1;
                RRESP_M1 = RRESP_S1;
                RLAST_M1 = RLAST_S1;

                RVALID_M0 = RVALID_S1 & (RID_S1[7:4] == 4'b0001);
                RVALID_M1 = RVALID_S1 & (RID_S1[7:4] == 4'b0010);
            end
            7'b0000100:begin
                RID_M0   = RID_S2[3:0];
                RDATA_M0 = RDATA_S2;
                RRESP_M0 = RRESP_S2;
                RLAST_M0 = RLAST_S2;

                RID_M1 = RID_S2[3:0];
                RDATA_M1 = RDATA_S2;
                RRESP_M1 = RRESP_S2;
                RLAST_M1 = RLAST_S2;

                RVALID_M0 = RVALID_S2 & (RID_S2[7:4] == 4'b0001);
                RVALID_M1 = RVALID_S2 & (RID_S2[7:4] == 4'b0010);
            end
            7'b0001000:begin
                RID_M0   = RID_S3[3:0];
                RDATA_M0 = RDATA_S3;
                RRESP_M0 = RRESP_S3;
                RLAST_M0 = RLAST_S3;

                RID_M1   = RID_S3[3:0];
                RDATA_M1 = RDATA_S3;
                RRESP_M1 = RRESP_S3;
                RLAST_M1 = RLAST_S3;

                RVALID_M0 = RVALID_S3 & (RID_S3[7:4] == 4'b0001);
                RVALID_M1 = RVALID_S3 & (RID_S3[7:4] == 4'b0010);
            end
            7'b0010000:begin
                RID_M0   = RID_S4[3:0];
                RDATA_M0 = RDATA_S4;
                RRESP_M0 = RRESP_S4;
                RLAST_M0 = RLAST_S4;

                RID_M1 = RID_S4[3:0];
                RDATA_M1 = RDATA_S4;
                RRESP_M1 = RRESP_S4;
                RLAST_M1 = RLAST_S4;

                RVALID_M0 = RVALID_S4 & (RID_S4[7:4] == 4'b0001);
                RVALID_M1 = RVALID_S4 & (RID_S4[7:4] == 4'b0010);
            end		
            7'b0100000:begin
                RID_M0   = RID_S5[3:0];
                RDATA_M0 = RDATA_S5;
                RRESP_M0 = RRESP_S5;
                RLAST_M0 = RLAST_S5;

                RID_M1 = RID_S5[3:0];
                RDATA_M1 = RDATA_S5;
                RRESP_M1 = RRESP_S5;
                RLAST_M1 = RLAST_S5;

                RVALID_M0 = RVALID_S5 & (RID_S5[7:4] == 4'b0001);
                RVALID_M1 = RVALID_S5 & (RID_S5[7:4] == 4'b0010);
            end
            7'b1000000:begin
                RID_M0 = RID_SD[3:0];
                RDATA_M0 = RDATA_SD;
                RRESP_M0 = RRESP_SD;
                RLAST_M0 = RLAST_SD;

                RID_M1 = RID_SD[3:0];
                RDATA_M1 = RDATA_SD;
                RRESP_M1 = RRESP_SD;
                RLAST_M1 = RLAST_SD;

                RVALID_M0 = RVALID_SD & (RID_SD[7:4] == 4'b0001);
                RVALID_M1 = RVALID_SD & (RID_SD[7:4] == 4'b0010);
            end
    		default: begin
    			RID_M0 = 4'd0;
    			RDATA_M0 = 32'd0;
    			RRESP_M0 = 2'h0;
    			RLAST_M0 = 1'd0;
    			RVALID_M0 = 1'd0;
    
    			RID_M1 = 4'd0;
    			RDATA_M1 = 32'd0;
    			RRESP_M1 = 2'h0;
    			RLAST_M1 = 1'd0;
    			RVALID_M1 = 1'd0;
    		end
        endcase
    end

    always_comb begin
        case ({RVALID_M1, RVALID_M0})
            2'b01: begin
                RREADY_S0 = RREADY_M0 && (RID_S0[7:4] == 4'b0001);
                RREADY_S1 = RREADY_M0 && (RID_S1[7:4] == 4'b0001);
                RREADY_S2 = RREADY_M0 && (RID_S2[7:4] == 4'b0001);
                RREADY_S3 = RREADY_M0 && (RID_S3[7:4] == 4'b0001);
                RREADY_S4 = RREADY_M0 && (RID_S4[7:4] == 4'b0001);			
                RREADY_S5 = RREADY_M0 && (RID_S5[7:4] == 4'b0001);
                RREADY_SD = RREADY_M0 && (RID_SD[7:4] == 4'b0001);
            end

            2'b10: begin
                RREADY_S0 = RREADY_M1 && (RID_S0[7:4] == 4'b0010);
                RREADY_S1 = RREADY_M1 && (RID_S1[7:4] == 4'b0010);
                RREADY_S2 = RREADY_M1 && (RID_S2[7:4] == 4'b0010);
                RREADY_S3 = RREADY_M1 && (RID_S3[7:4] == 4'b0010);
                RREADY_S4 = RREADY_M1 && (RID_S4[7:4] == 4'b0010);			
                RREADY_S5 = RREADY_M1 && (RID_S5[7:4] == 4'b0010);
                RREADY_SD = RREADY_M1 && (RID_SD[7:4] == 4'b0010);
            end

     		2'b11: begin
    			RREADY_S0 = 1'd0;
    			RREADY_S1 = 1'd0;
    			RREADY_S2 = 1'd0;
    			RREADY_S3 = 1'd0;
    			RREADY_S4 = 1'd0;
    			RREADY_S5 = 1'd0;
    			RREADY_SD = 1'd0;
    		end           

    		default: begin
    			RREADY_S0 = 1'd0;
    			RREADY_S1 = 1'd0;
    			RREADY_S2 = 1'd0;
    			RREADY_S3 = 1'd0;
    			RREADY_S4 = 1'd0;
    			RREADY_S5 = 1'd0;
    			RREADY_SD = 1'd0;
    		end
        endcase
    end

    always_ff @(posedge ACLK) begin
        if (!ARESETn) begin
            grant_R <= 7'd0;
        end
        else begin
            if (RREADY_S0 | RREADY_S1 | RREADY_S2 | RREADY_S3 | RREADY_S4 | RREADY_S5 | RREADY_SD) begin
                if (next_grant_R == 7'b1000000) begin
                    grant_R <= 7'b0000001;
                end
                else begin
                    grant_R <= {grant_R[5:0], 1'b0};
                end
            end
            else begin
                grant_R <= next_grant_R;
            end
        end
    end
    
endmodule
