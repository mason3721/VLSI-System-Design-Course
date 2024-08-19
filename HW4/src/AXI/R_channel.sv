`include "AXI_define.svh"
module R_channel (
    input                             ACLK,
    input                             ARESETn,

    //S0
    input                             RVALID_S0,
    input        [`AXI_IDS_BITS-1:0]  RID_S0,   //8
	input        [`AXI_DATA_BITS-1:0] RDATA_S0, //32
	input        [1:0]                RRESP_S0,
	input                             RLAST_S0,

    output logic                      RREADY_S0,

    //S1
    input                             RVALID_S1,
    input        [`AXI_IDS_BITS-1:0]  RID_S1,   //8
	input        [`AXI_DATA_BITS-1:0] RDATA_S1, //32
	input        [1:0]                RRESP_S1,
	input                             RLAST_S1,

    output logic                      RREADY_S1,

    //S2
    input                             RVALID_S2,
    input        [`AXI_IDS_BITS-1:0]  RID_S2,   //8
	input        [`AXI_DATA_BITS-1:0] RDATA_S2, //32
	input        [1:0]                RRESP_S2,
	input                             RLAST_S2,

    output logic                      RREADY_S2,

    //S3
    input                             RVALID_S3,
    input        [`AXI_IDS_BITS-1:0]  RID_S3,   //8
	input        [`AXI_DATA_BITS-1:0] RDATA_S3, //32
	input        [1:0]                RRESP_S3,
	input                             RLAST_S3,

    output logic                      RREADY_S3,

    //S4
    input                             RVALID_S4,
    input        [`AXI_IDS_BITS-1:0]  RID_S4,   //8
	input        [`AXI_DATA_BITS-1:0] RDATA_S4, //32
	input        [1:0]                RRESP_S4,
	input                             RLAST_S4,

    output logic                      RREADY_S4,

    //S5
    input                             RVALID_S5,
    input        [`AXI_IDS_BITS-1:0]  RID_S5,   //8
	input        [`AXI_DATA_BITS-1:0] RDATA_S5, //32
	input        [1:0]                RRESP_S5,
	input                             RLAST_S5,

    output logic                      RREADY_S5,

    //DS
    input                             RVALID_DS,
    input        [`AXI_IDS_BITS-1:0]  RID_DS,   //8

    output logic                      RREADY_DS,

    //Master READ DATA0
    input                             RREADY_M0,

    output logic [`AXI_ID_BITS-1:0]   RID_M0,   //4
	output logic [`AXI_DATA_BITS-1:0] RDATA_M0, //32
	output logic [1:0]                RRESP_M0,
	output logic                      RLAST_M0,
	output logic                      RVALID_M0,

    //Master READ DATA1
    input                             RREADY_M1,

    output logic [`AXI_ID_BITS-1:0]   RID_M1,   //4
	output logic [`AXI_DATA_BITS-1:0] RDATA_M1, //32
	output logic [1:0]                RRESP_M1,
	output logic                      RLAST_M1,
	output logic                      RVALID_M1
);
    logic [6:0] current_grant;
    logic [6:0] next_grant;

    always_ff @(posedge ACLK) begin
        unique if (~ARESETn) begin
            current_grant <= 7'b0000000;
        end else begin
            unique if (RVALID_S0 || RVALID_S1 || RVALID_S2 || RVALID_S3 || RVALID_S4 || RVALID_S5 || RVALID_DS) begin
                unique if (next_grant == 7'b1000000) begin
                    current_grant <= 7'b0000001;
                end else begin
                    current_grant <= {current_grant[5:0], 1'b0};
                end
            end else begin
                current_grant <= next_grant;
            end
        end
    end

    always_comb begin
        unique case ({RVALID_S0, RVALID_S1, RVALID_S2, RVALID_S3, RVALID_S4, RVALID_S5, RVALID_DS})
            7'b1000000: next_grant = 7'b0000001; 
            7'b0100000: next_grant = 7'b0000010;
            7'b0010000: next_grant = 7'b0000100;
            7'b0001000: next_grant = 7'b0001000;
            7'b0000100: next_grant = 7'b0010000;
            7'b0000010: next_grant = 7'b0100000;
            7'b0000001: next_grant = 7'b1000000;
            default: next_grant = 7'b0000000;
        endcase
    end

    always_comb begin
        unique case (next_grant)
            7'b0000001:
            begin
                RVALID_M0 = RVALID_S0 && (RID_S0[7:6] == 2'b01);
                RID_M0 = RID_S0[3:0];
                RDATA_M0 = RDATA_S0;
                RRESP_M0 = RRESP_S0;
                RLAST_M0 = RLAST_S0;

                RVALID_M1 = RVALID_S0 && (RID_S0[7:6] == 2'b10);
                RID_M1 = RID_S0[3:0];
                RDATA_M1 = RDATA_S0;
                RRESP_M1 = RRESP_S0;
                RLAST_M1 = RLAST_S0;
            end 
            7'b0000010:
            begin
                RVALID_M0 = RVALID_S1 && (RID_S1[7:6] == 2'b01);
                RID_M0 = RID_S1[3:0];
                RDATA_M0 = RDATA_S1;
                RRESP_M0 = RRESP_S1;
                RLAST_M0 = RLAST_S1;

                RVALID_M1 = RVALID_S1 && (RID_S1[7:6] == 2'b10);
                RID_M1 = RID_S1[3:0];
                RDATA_M1 = RDATA_S1;
                RRESP_M1 = RRESP_S1;
                RLAST_M1 = RLAST_S1;
            end 
            7'b0000100:
            begin
                RVALID_M0 = RVALID_S2 && (RID_S2[7:6] == 2'b01);
                RID_M0 = RID_S2[3:0];
                RDATA_M0 = RDATA_S2;
                RRESP_M0 = RRESP_S2;
                RLAST_M0 = RLAST_S2;

                RVALID_M1 = RVALID_S2 && (RID_S2[7:6] == 2'b10);
                RID_M1 = RID_S2[3:0];
                RDATA_M1 = RDATA_S2;
                RRESP_M1 = RRESP_S2;
                RLAST_M1 = RLAST_S2;
            end 
            7'b0001000:
            begin
                RVALID_M0 = RVALID_S3 && (RID_S3[7:6] == 2'b01);
                RID_M0 = RID_S3[3:0];
                RDATA_M0 = RDATA_S3;
                RRESP_M0 = RRESP_S3;
                RLAST_M0 = RLAST_S3;

                RVALID_M1 = RVALID_S3 && (RID_S3[7:6] == 2'b10);
                RID_M1 = RID_S3[3:0];
                RDATA_M1 = RDATA_S3;
                RRESP_M1 = RRESP_S3;
                RLAST_M1 = RLAST_S3;
            end 
            7'b0010000:
            begin
                RVALID_M0 = RVALID_S4 && (RID_S4[7:6] == 2'b01);
                RID_M0 = RID_S4[3:0];
                RDATA_M0 = RDATA_S4;
                RRESP_M0 = RRESP_S4;
                RLAST_M0 = RLAST_S4;

                RVALID_M1 = RVALID_S4 && (RID_S4[7:6] == 2'b10);
                RID_M1 = RID_S4[3:0];
                RDATA_M1 = RDATA_S4;
                RRESP_M1 = RRESP_S4;
                RLAST_M1 = RLAST_S4;
            end 
            7'b0100000:
            begin
                RVALID_M0 = RVALID_S5 && (RID_S5[7:6] == 2'b01);
                RID_M0 = RID_S5[3:0];
                RDATA_M0 = RDATA_S5;
                RRESP_M0 = RRESP_S5;
                RLAST_M0 = RLAST_S5;

                RVALID_M1 = RVALID_S5 && (RID_S5[7:6] == 2'b10);
                RID_M1 = RID_S5[3:0];
                RDATA_M1 = RDATA_S5;
                RRESP_M1 = RRESP_S5;
                RLAST_M1 = RLAST_S5;
            end 
            7'b1000000:
            begin
                RVALID_M0 = RVALID_DS && (RID_DS[7:6] == 2'b01);
                RID_M0 = RID_DS[3:0];
                RDATA_M0 = 32'd0;
                RRESP_M0 = 2'd0;
                RLAST_M0 = 1'b0;

                RVALID_M1 = RVALID_DS && (RID_DS[7:6] == 2'b10);
                RID_M1 = RID_DS[3:0];
                RDATA_M1 = 32'd0;
                RRESP_M1 = 2'd0;
                RLAST_M1 = 1'b0;
            end 
            default: 
            begin
                RVALID_M0 = 1'b0;
                RID_M0 = 4'd0;
                RDATA_M0 = 32'd0;
                RRESP_M0 = 2'd0;
                RLAST_M0 = 1'b0;

                RVALID_M1 = 1'b0;
                RID_M1 = 4'd0;
                RDATA_M1 = 32'd0;
                RRESP_M1 = 2'd0;
                RLAST_M1 = 1'b0;
            end
        endcase
    end

    always_comb begin
        unique case ({RVALID_M0, RVALID_M1})
            2'b10:
            begin
                RREADY_S0 = RVALID_S0 && RREADY_M0 && (RID_S0[7:6] == 2'b01);
                RREADY_S1 = RVALID_S1 && RREADY_M0 && (RID_S1[7:6] == 2'b01);
                RREADY_S2 = RVALID_S2 && RREADY_M0 && (RID_S2[7:6] == 2'b01);
                RREADY_S3 = RVALID_S3 && RREADY_M0 && (RID_S3[7:6] == 2'b01);
                RREADY_S4 = RVALID_S4 && RREADY_M0 && (RID_S4[7:6] == 2'b01);
                RREADY_S5 = RVALID_S5 && RREADY_M0 && (RID_S5[7:6] == 2'b01);
                RREADY_DS = RVALID_DS && RREADY_M0 && (RID_DS[7:6] == 2'b01);
            end 
            2'b01:
            begin
                RREADY_S0 = RVALID_S0 && RREADY_M1 && (RID_S0[7:6] == 2'b10);
                RREADY_S1 = RVALID_S1 && RREADY_M1 && (RID_S1[7:6] == 2'b10);
                RREADY_S2 = RVALID_S2 && RREADY_M1 && (RID_S2[7:6] == 2'b10);
                RREADY_S3 = RVALID_S3 && RREADY_M1 && (RID_S3[7:6] == 2'b10);
                RREADY_S4 = RVALID_S4 && RREADY_M1 && (RID_S4[7:6] == 2'b10);
                RREADY_S5 = RVALID_S5 && RREADY_M1 && (RID_S5[7:6] == 2'b10);
                RREADY_DS = RVALID_DS && RREADY_M1 && (RID_DS[7:6] == 2'b10);
            end
            default: 
            begin
                RREADY_S0 = 1'b0;
                RREADY_S1 = 1'b0;
                RREADY_S2 = 1'b0;
                RREADY_S3 = 1'b0;
                RREADY_S4 = 1'b0;
                RREADY_S5 = 1'b0;
                RREADY_DS = 1'b0;
            end
        endcase
    end
endmodule