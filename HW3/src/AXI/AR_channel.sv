//================================================
// Auther:      Lin Meng-Yu            
// Filename:    AR_channel.sv                            
// Description: Read Address Channel module of AXI bridge                  
// Version:     HW3 Submit version 
// Date:		2023/11/23
//================================================

`include "AXI_define.svh"

module AR_channel(

    input  ACLK,
    input  ARESETn,

    // ********************* Masters ******************** //
	input logic  [`AXI_ID_BITS-1:0]    ARID_M0      ,
	input logic  [`AXI_ADDR_BITS-1:0]  ARADDR_M0    ,
	input logic  [`AXI_LEN_BITS-1:0]   ARLEN_M0     ,
	input logic  [`AXI_SIZE_BITS-1:0]  ARSIZE_M0    ,
	input logic  [1:0]                 ARBURST_M0   ,
	input logic                        ARVALID_M0   ,

	input  [`AXI_ID_BITS-1:0]          ARID_M1      ,
	input  [`AXI_ADDR_BITS-1:0]        ARADDR_M1    ,
	input  [`AXI_LEN_BITS-1:0]         ARLEN_M1     ,
	input  [`AXI_SIZE_BITS-1:0]        ARSIZE_M1    ,
	input  [1:0]                       ARBURST_M1   ,
	input  logic                       ARVALID_M1   ,

	output logic                       ARREADY_M0   ,
	output logic                       ARREADY_M1   ,

    // ********************* Slaves ******************** //
    input logic                        RVALID_S0    ,
    input logic                        RREADY_S0    ,
    input logic                        RLAST_S0     ,

    input logic                        RVALID_S1    ,
    input logic                        RREADY_S1    ,
    input logic                        RLAST_S1     ,
	
    input logic                        RVALID_S2    ,
    input logic                        RREADY_S2    ,
    input logic                        RLAST_S2     ,
	
    input logic                        RVALID_S3    ,
    input logic                        RREADY_S3    ,
    input logic                        RLAST_S3     ,
	
	input logic                        RVALID_S4    ,
    input logic                        RREADY_S4    ,
    input logic                        RLAST_S4     ,
	
    input logic                        RVALID_S5    ,
    input logic                        RREADY_S5    ,
    input logic                        RLAST_S5     ,

    input logic                        RVALID_SD    ,
    input logic                        RREADY_SD    ,
    input logic                        RLAST_SD     ,

	input logic                        ARREADY_S0   ,
	input logic                        ARREADY_S1   ,
	input logic                        ARREADY_S2   ,
	input logic                        ARREADY_S3   ,
	input logic                        ARREADY_S4   ,
	input logic                        ARREADY_S5   ,
	input logic                        ARREADY_SD   ,

	output logic [`AXI_IDS_BITS-1:0]   ARID_S0      ,
	output logic [`AXI_ADDR_BITS-1:0]  ARADDR_S0    ,
	output logic [`AXI_LEN_BITS-1:0]   ARLEN_S0     ,
	output logic [`AXI_SIZE_BITS-1:0]  ARSIZE_S0    ,
	output logic [1:0] ARBURST_S0,
	output logic ARVALID_S0,
	
	output logic [`AXI_IDS_BITS-1:0]   ARID_S1      ,
	output logic [`AXI_ADDR_BITS-1:0]  ARADDR_S1    ,
	output logic [`AXI_LEN_BITS-1:0]   ARLEN_S1     ,
	output logic [`AXI_SIZE_BITS-1:0]  ARSIZE_S1    ,
	output logic [1:0]                 ARBURST_S1   ,
	output logic                       ARVALID_S1   ,

    output logic [`AXI_IDS_BITS-1:0]   ARID_S2      ,
	output logic [`AXI_ADDR_BITS-1:0]  ARADDR_S2    ,
	output logic [`AXI_LEN_BITS-1:0]   ARLEN_S2     ,
	output logic [`AXI_SIZE_BITS-1:0]  ARSIZE_S2    ,
	output logic [1:0]                 ARBURST_S2   ,
	output logic                       ARVALID_S2   ,

    output logic [`AXI_IDS_BITS-1:0]   ARID_S3      ,
	output logic [`AXI_ADDR_BITS-1:0]  ARADDR_S3    ,
	output logic [`AXI_LEN_BITS-1:0]   ARLEN_S3     ,
	output logic [`AXI_SIZE_BITS-1:0]  ARSIZE_S3    ,
	output logic [1:0]                 ARBURST_S3   ,
	output logic                       ARVALID_S3   ,
	
	output logic [`AXI_IDS_BITS-1:0]   ARID_S4      ,
	output logic [`AXI_ADDR_BITS-1:0]  ARADDR_S4    ,
	output logic [`AXI_LEN_BITS-1:0]   ARLEN_S4     ,
	output logic [`AXI_SIZE_BITS-1:0]  ARSIZE_S4    ,
	output logic [1:0]                 ARBURST_S4   ,
	output logic                       ARVALID_S4   ,

    output logic [`AXI_IDS_BITS-1:0]   ARID_S5      ,
	output logic [`AXI_ADDR_BITS-1:0]  ARADDR_S5    ,
	output logic [`AXI_LEN_BITS-1:0]   ARLEN_S5     ,
	output logic [`AXI_SIZE_BITS-1:0]  ARSIZE_S5    ,
	output logic [1:0]                 ARBURST_S5   ,
	output logic                       ARVALID_S5   ,
	
	output logic [`AXI_IDS_BITS-1:0]   ARID_SD      ,
	output logic [`AXI_ADDR_BITS-1:0]  ARADDR_SD    ,
	output logic [`AXI_LEN_BITS-1:0]   ARLEN_SD     ,
	output logic [`AXI_SIZE_BITS-1:0]  ARSIZE_SD    ,
	output logic [1:0]                 ARBURST_SD   ,
	output logic                       ARVALID_SD
    );

    logic [1:0]     grant_AR;
    logic [1:0]     next_grant_AR;

    logic           stall_AR;

always_ff @(posedge ACLK) begin
    
    if (!ARESETn) begin
        grant_AR <= 2'b00;
    end
    else begin
        if (ARREADY_M0 | ARREADY_M1) begin
            grant_AR <= ~next_grant_AR;
        end
        else if (next_grant_AR != 2'b00)begin
            grant_AR <= next_grant_AR;
        end
		else begin
			grant_AR <= grant_AR;
		end
    end
end

    always_comb begin
        if (ARVALID_M0 & ARVALID_M1) begin
            next_grant_AR = grant_AR;
        end
        else begin
            if (ARVALID_M1 & !stall_AR) begin
                next_grant_AR = 2'b10;
            end
            else if(ARVALID_M0 & !stall_AR)begin
                next_grant_AR = 2'b01;
            end
            else begin
                next_grant_AR = 2'b00;
            end
        end
    end


    always_ff @(posedge ACLK) begin
        if (!ARESETn) begin
            stall_AR <= 1'b0;
        end
        else begin
            if (ARREADY_M0 | ARREADY_M1) begin
                stall_AR <= 1'b1;
            end
            else if ((RREADY_S0 && RVALID_S0 && RLAST_S0)  || (RREADY_S1 && RVALID_S1 && RLAST_S1)  || (RREADY_S2 && RVALID_S2 && RLAST_S2)
                    ||(RREADY_S3 && RVALID_S3 && RLAST_S3) || (RREADY_S4 && RVALID_S4 && RLAST_S4)  || (RREADY_S5 && RVALID_S5 && RLAST_S5) ||(RREADY_SD && RVALID_SD && RLAST_SD))
            begin
                stall_AR <= 1'b0;
            end
    		else begin
    			stall_AR <= stall_AR;
            end
        end
    end

always_comb begin
    case (next_grant_AR)
        2'b01:begin
            ARID_S0 = {4'b0001, ARID_M0};
            ARADDR_S0 = ARADDR_M0;
            ARLEN_S0 = ARLEN_M0;
            ARSIZE_S0 = ARSIZE_M0;
            ARBURST_S0 = ARBURST_M0;
            ARVALID_S0 = 1'd0;

            ARID_S1 = {4'b0001, ARID_M0};
            ARADDR_S1 = ARADDR_M0;
            ARLEN_S1 = ARLEN_M0;
            ARSIZE_S1 = ARSIZE_M0;
            ARBURST_S1 = ARBURST_M0;
            ARVALID_S1 = 1'd0;

            ARID_S2 = {4'b0001, ARID_M0};
            ARADDR_S2 = ARADDR_M0;
            ARLEN_S2 = ARLEN_M0;
            ARSIZE_S2 = ARSIZE_M0;
            ARBURST_S2 = ARBURST_M0;
            ARVALID_S2 = 1'd0;

            ARID_S3 = {4'b0001, ARID_M0};
            ARADDR_S3 = ARADDR_M0;
            ARLEN_S3 = ARLEN_M0;
            ARSIZE_S3 = ARSIZE_M0;
            ARBURST_S3 = ARBURST_M0;
            ARVALID_S3 = 1'd0;
			
			ARID_S4 = {4'b0001, ARID_M0};
            ARADDR_S4 = ARADDR_M0;
            ARLEN_S4 = ARLEN_M0;
            ARSIZE_S4 = ARSIZE_M0;
            ARBURST_S4 = ARBURST_M0;
            ARVALID_S4 = 1'd0;

            ARID_S5 = {4'b0001, ARID_M0};
            ARADDR_S5 = ARADDR_M0;
            ARLEN_S5 = ARLEN_M0;
            ARSIZE_S5 = ARSIZE_M0;
            ARBURST_S5 = ARBURST_M0;
            ARVALID_S5 = 1'd0;

            ARID_SD = {4'b0001, ARID_M0};
            ARADDR_SD = ARADDR_M0;
            ARLEN_SD = ARLEN_M0;
            ARSIZE_SD = ARSIZE_M0;
            ARBURST_SD = ARBURST_M0;
            ARVALID_SD = 1'd0;

            if (32'h00002000 > ARADDR_M0 && ARADDR_M0 >= 32'h00000000) begin
                ARVALID_S0 = ARVALID_M0;
            end
            else if (32'h00020000 > ARADDR_M0 && ARADDR_M0 >= 32'h00010000) begin
                ARVALID_S1 = ARVALID_M0;
            end
            else if (32'h00030000 > ARADDR_M0 && ARADDR_M0 >= 32'h00020000) begin
                ARVALID_S2 = ARVALID_M0;
            end
            else if (32'h10000400 > ARADDR_M0 && ARADDR_M0 >= 32'h10000000) begin
                ARVALID_S3 = ARVALID_M0;
            end
			else if (32'h10010400 > ARADDR_M0 && ARADDR_M0 >= 32'h10010000) begin
                ARVALID_S4 = ARVALID_M0;
            end
            else if (32'h20200000 > ARADDR_M0 && ARADDR_M0 >= 32'h20000000) begin
                ARVALID_S5 = ARVALID_M0;
            end
            else begin
                ARVALID_SD = ARVALID_M0;
            end

        end
        2'b10:begin
            ARID_S0 = {4'b0010, ARID_M1};
            ARADDR_S0 = ARADDR_M1;
            ARLEN_S0 = ARLEN_M1;
            ARSIZE_S0 = ARSIZE_M1;
            ARBURST_S0 = ARBURST_M1;
            ARVALID_S0 = 1'd0;

            ARID_S1 = {4'b0010, ARID_M1};
            ARADDR_S1 = ARADDR_M1;
            ARLEN_S1 = ARLEN_M1;
            ARSIZE_S1 = ARSIZE_M1;
            ARBURST_S1 = ARBURST_M1;
            ARVALID_S1 = 1'd0;

            ARID_S2 = {4'b0010, ARID_M1};
            ARADDR_S2 = ARADDR_M1;
            ARLEN_S2 = ARLEN_M1;
            ARSIZE_S2 = ARSIZE_M1;
            ARBURST_S2 = ARBURST_M1;
            ARVALID_S2 = 1'd0;

            ARID_S3 = {4'b0010, ARID_M1};
            ARADDR_S3 = ARADDR_M1;
            ARLEN_S3 = ARLEN_M1;
            ARSIZE_S3 = ARSIZE_M1;
            ARBURST_S3 = ARBURST_M1;
            ARVALID_S3 = 1'd0;
			
			ARID_S4 = {4'b0010, ARID_M1};
            ARADDR_S4 = ARADDR_M1;
            ARLEN_S4 = ARLEN_M1;
            ARSIZE_S4 = ARSIZE_M1;
            ARBURST_S4 = ARBURST_M1;
            ARVALID_S4 = 1'd0;

            ARID_S5 = {4'b0010, ARID_M1};
            ARADDR_S5 = ARADDR_M1;
            ARLEN_S5 = ARLEN_M1;
            ARSIZE_S5 = ARSIZE_M1;
            ARBURST_S5 = ARBURST_M1;
            ARVALID_S5 = 1'd0;

            ARID_SD = {4'b0010, ARID_M1};
            ARADDR_SD = ARADDR_M1;
            ARLEN_SD = ARLEN_M1;
            ARSIZE_SD = ARSIZE_M1;
            ARBURST_SD = ARBURST_M1;
            ARVALID_SD = 1'd0;

            if (32'h00002000 > ARADDR_M1 && ARADDR_M1 >= 32'h00000000) begin
                ARVALID_S0 = ARVALID_M1;
            end
            else if (32'h00020000 > ARADDR_M1 && ARADDR_M1 >= 32'h00010000) begin
                ARVALID_S1 = ARVALID_M1;
            end
            else if (32'h00030000 > ARADDR_M1 && ARADDR_M1 >= 32'h00020000) begin
                ARVALID_S2 = ARVALID_M1;
            end
            else if (32'h10000400 > ARADDR_M1 && ARADDR_M1 >= 32'h00010000) begin
                ARVALID_S3 = ARVALID_M1;
            end
			else if (32'h10010400 > ARADDR_M1 && ARADDR_M1 >= 32'h10010000) begin
                ARVALID_S4 = ARVALID_M1;
            end
            else if (32'h20200000 > ARADDR_M1 && ARADDR_M1 >= 32'h20000000) begin
                ARVALID_S5 = ARVALID_M1;
            end
            else begin
                ARVALID_SD = ARVALID_M1;
            end
        end
		default: begin
			ARID_S0 = 8'd0;
			ARADDR_S0 = 32'd0;
			ARLEN_S0 = 4'd0;
			ARSIZE_S0 = 3'd0;
			ARBURST_S0 = 2'd0;
			ARVALID_S0 = 1'd0;

			ARID_S1 = 8'd0;
			ARADDR_S1 = 32'd0;
			ARLEN_S1 = 4'd0;
			ARSIZE_S1 = 3'd0;
			ARBURST_S1 = 2'd0;
			ARVALID_S1 = 1'd0;

			ARID_S2 = 8'd0;
			ARADDR_S2 = 32'd0;
			ARLEN_S2 = 4'd0;
			ARSIZE_S2 = 3'd0;
			ARBURST_S2 = 2'd0;
			ARVALID_S2 = 1'd0;

			ARID_S3 = 8'd0;
			ARADDR_S3 = 32'd0;
			ARLEN_S3 = 4'd0;
			ARSIZE_S3 = 3'd0;
			ARBURST_S3 = 2'd0;
			ARVALID_S3 = 1'd0;

			ARID_S4 = 8'd0;
			ARADDR_S4 = 32'd0;
			ARLEN_S4 = 4'd0;
			ARSIZE_S4 = 3'd0;
			ARBURST_S4 = 2'd0;
			ARVALID_S4 = 1'd0;

			ARID_S5 = 8'd0;
			ARADDR_S5 = 32'd0;
			ARLEN_S5 = 4'd0;
			ARSIZE_S5 = 3'd0;
			ARBURST_S5 = 2'd0;
			ARVALID_S5 = 1'd0;

			ARID_SD = 8'd0;
			ARADDR_SD = 32'd0;
			ARLEN_SD = 4'd0;
			ARSIZE_SD = 3'd0;
			ARBURST_SD = 2'd0;
			ARVALID_SD = 1'd0;
		end
    endcase
end

always_comb begin
    case ({ARVALID_SD, ARVALID_S5, ARVALID_S4, ARVALID_S3, ARVALID_S2, ARVALID_S1, ARVALID_S0})
        7'b0000001:begin
            ARREADY_M0 = ARREADY_S0 && next_grant_AR[0];
            ARREADY_M1 = ARREADY_S0 && next_grant_AR[1];
        end

        7'b0000010:begin
            ARREADY_M0 = ARREADY_S1 && next_grant_AR[0];
            ARREADY_M1 = ARREADY_S1 && next_grant_AR[1];
        end

        7'b0000100:begin
            ARREADY_M0 = ARREADY_S2 && next_grant_AR[0];
            ARREADY_M1 = ARREADY_S2 && next_grant_AR[1];
        end

        7'b0001000:begin
            ARREADY_M0 = ARREADY_S3 && next_grant_AR[0];
            ARREADY_M1 = ARREADY_S3 && next_grant_AR[1];
        end
		
		7'b0010000:begin
            ARREADY_M0 = ARREADY_S4 && next_grant_AR[0];
            ARREADY_M1 = ARREADY_S4 && next_grant_AR[1];
        end

        7'b0100000:begin
            ARREADY_M0 = ARREADY_S5 && next_grant_AR[0];
            ARREADY_M1 = ARREADY_S5 && next_grant_AR[1];
        end

        7'b1000000:begin
            ARREADY_M0 = ARREADY_SD && next_grant_AR[0];
            ARREADY_M1 = ARREADY_SD && next_grant_AR[1];
        end
		default: begin
			ARREADY_M0 = 1'b0;
			ARREADY_M1 = 1'b0;
		end
    endcase
end

endmodule
