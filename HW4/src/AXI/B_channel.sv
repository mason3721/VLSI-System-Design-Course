`include "AXI_define.svh"
module B_channel (
    input                             ACLK,
    input                             ARESETn,

    //S1
    input                             BVALID_S1,
    input        [`AXI_IDS_BITS-1:0]  BID_S1, //8
	input        [1:0]                BRESP_S1,

    output logic                      BREADY_S1,

    //S2
    input                             BVALID_S2,
    input        [`AXI_IDS_BITS-1:0]  BID_S2, //8
	input        [1:0]                BRESP_S2,

    output logic                      BREADY_S2,

    //S3
    input                             BVALID_S3,
    input        [`AXI_IDS_BITS-1:0]  BID_S3, //8
	input        [1:0]                BRESP_S3,

    output logic                      BREADY_S3,

    //S4
    input                             BVALID_S4,
    input        [`AXI_IDS_BITS-1:0]  BID_S4, //8
	input        [1:0]                BRESP_S4,

    output logic                      BREADY_S4,

    //S5
    input                             BVALID_S5,
    input        [`AXI_IDS_BITS-1:0]  BID_S5, //8
	input        [1:0]                BRESP_S5,

    output logic                      BREADY_S5,

    //DS
    input                             BVALID_DS,
    input        [`AXI_IDS_BITS-1:0]  BID_DS, //8

    output logic                      BREADY_DS,

    //Master WRITE RESPONSE1
    input                             BREADY_M1,

    output logic                      BVALID_M1,
	output logic [`AXI_ID_BITS-1:0]   BID_M1, //4
	output logic [1:0]                BRESP_M1
);
    logic [5:0] current_grant;
    logic [5:0] next_grant;

    //Arbiter
    always_ff @(posedge ACLK) begin
        unique if (~ARESETn) begin
            current_grant <= 6'b000000;
        end else begin
            unique if (BREADY_S1 || BREADY_S2 || BREADY_S3 || BREADY_S4 || BREADY_S5 || BREADY_DS) begin
                unique if (next_grant == 6'b100000) begin
                    current_grant <= 6'b000001;
                end else begin
                    current_grant <= {current_grant[4:0], 1'b0};
                end
            end else begin
                current_grant <= next_grant;
            end
        end
    end

    always_comb begin
        unique case ({BVALID_S1, BVALID_S2, BVALID_S3, BVALID_S4, BVALID_S5, BVALID_DS})
            6'b100000: next_grant = 6'b000001; 
            6'b010000: next_grant = 6'b000010; 
            6'b001000: next_grant = 6'b000100; 
            6'b000100: next_grant = 6'b001000; 
            6'b000010: next_grant = 6'b010000; 
            6'b000001: next_grant = 6'b100000; 
            default: next_grant = 6'b000000;
        endcase
    end

    //Slave_data_MUX
    always_comb begin
        unique case (next_grant)
            6'b000001:
            begin
                BVALID_M1 = BVALID_S1 && (BID_S1[7:6] == 2'b10);
                BID_M1 = BID_S1[3:0];
                BRESP_M1 = BRESP_S1;
            end 
            6'b000010:
            begin
                BVALID_M1 = BVALID_S2 && (BID_S2[7:6] == 2'b10);
                BID_M1 = BID_S2[3:0];
                BRESP_M1 = BRESP_S2;
            end
            6'b000100:
            begin
                BVALID_M1 = BVALID_S3 && (BID_S3[7:6] == 2'b10);
                BID_M1 = BID_S3[3:0];
                BRESP_M1 = BRESP_S3;
            end
            6'b001000:
            begin
                BVALID_M1 = BVALID_S4 && (BID_S4[7:6] == 2'b10);
                BID_M1 = BID_S4[3:0];
                BRESP_M1 = BRESP_S4;
            end
            6'b010000:
            begin
                BVALID_M1 = BVALID_S5 && (BID_S5[7:6] == 2'b10);
                BID_M1 = BID_S5[3:0];
                BRESP_M1 = BRESP_S5;
            end
            6'b100000:
            begin
                BVALID_M1 = BVALID_DS && (BID_DS[7:6] == 2'b10);
                BID_M1 = BID_DS[3:0];
                BRESP_M1 = 2'b11;
            end
            default:
            begin
                BVALID_M1 = 1'b0;
                BID_M1 = 4'd0;
                BRESP_M1 = 2'd0;
            end 
        endcase
    end

    //DE_MUX
    always_comb begin
        BREADY_S1 = BVALID_S1 && BREADY_M1 && (BID_S1[7:6] == 2'b10);
        BREADY_S2 = BVALID_S2 && BREADY_M1 && (BID_S2[7:6] == 2'b10);
        BREADY_S3 = BVALID_S3 && BREADY_M1 && (BID_S3[7:6] == 2'b10);
        BREADY_S4 = BVALID_S4 && BREADY_M1 && (BID_S4[7:6] == 2'b10);
        BREADY_S5 = BVALID_S5 && BREADY_M1 && (BID_S5[7:6] == 2'b10);
        BREADY_DS = BVALID_DS && BREADY_M1 && (BID_DS[7:6] == 2'b10);
    end
endmodule