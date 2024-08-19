`include "AXI_define.svh"
module W_channel (
    //for VIP
    input                             ACLK,
    input                             ARESETn,

    //Master WRITE ADDRESS1 for selecting slave
	input        [`AXI_ADDR_BITS-1:0] AWADDR_M1,  //32 
    input                             AWVALID_M1, //for VIP
    input                             AWREADY_M1, //for VIP

    //Master WRITE DATA1
    input                             WVALID_M1,
	input        [`AXI_DATA_BITS-1:0] WDATA_M1, //32
	input        [`AXI_STRB_BITS-1:0] WSTRB_M1, //4
	input                             WLAST_M1,
	
	output logic                      WREADY_M1,

    //S1
    input                             WREADY_S1,

    output logic                      WVALID_S1,
    output logic [`AXI_DATA_BITS-1:0] WDATA_S1, //32
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S1, //4
	output logic                      WLAST_S1,

    //S2
    input                             WREADY_S2,

    output logic                      WVALID_S2,
    output logic [`AXI_DATA_BITS-1:0] WDATA_S2, //32
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S2, //4
	output logic                      WLAST_S2,

    //S3
    input                             WREADY_S3,

    output logic                      WVALID_S3,
    output logic [`AXI_DATA_BITS-1:0] WDATA_S3, //32
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S3, //4
	output logic                      WLAST_S3,

    //S4
    input                             WREADY_S4,

    output logic                      WVALID_S4,
    output logic [`AXI_DATA_BITS-1:0] WDATA_S4, //32
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S4, //4
	output logic                      WLAST_S4,

    //S5
    input                             WREADY_S5,

    output logic                      WVALID_S5,
    output logic [`AXI_DATA_BITS-1:0] WDATA_S5, //32
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S5, //4
	output logic                      WLAST_S5,

    //DS
    input                             WREADY_DS,

	output logic                      WVALID_DS
);
    //S1
    assign WDATA_S1 = WDATA_M1;
    assign WSTRB_S1 = WSTRB_M1;
    assign WLAST_S1 = WLAST_M1;

    //S2
    assign WDATA_S2 = WDATA_M1;
    assign WSTRB_S2 = WSTRB_M1;
    assign WLAST_S2 = WLAST_M1;

    //S3
    assign WDATA_S3 = WDATA_M1;
    assign WSTRB_S3 = WSTRB_M1;
    assign WLAST_S3 = WLAST_M1;

    //S4
    assign WDATA_S4 = WDATA_M1;
    assign WSTRB_S4 = WSTRB_M1;
    assign WLAST_S4 = WLAST_M1;

    //S5
    assign WDATA_S5 = WDATA_M1;
    assign WSTRB_S5 = WSTRB_M1;
    assign WLAST_S5 = WLAST_M1;

    logic [`AXI_ADDR_BITS-1:0] AWADDR;
    logic [`AXI_ADDR_BITS-1:0] AWADDR_hold;

    assign AWADDR = (AWVALID_M1 && AWREADY_M1) ? AWADDR_M1 : AWADDR_hold;

    always_ff @(posedge ACLK) begin
        unique if (~ARESETn) begin
            AWADDR_hold <= 32'd0;
        end else begin
            AWADDR_hold <= AWADDR;
        end
    end

    //Valid_Decoder
    always_comb begin
        WVALID_S1 = 1'b0;
        WVALID_S2 = 1'b0;
        WVALID_S3 = 1'b0;
        WVALID_S4 = 1'b0;
        WVALID_S5 = 1'b0;
        WVALID_DS = 1'b0;
        unique if ((AWADDR <= 32'h0001_FFFF) && (AWADDR >= 32'h0001_0000)) begin
            WVALID_S1 = WVALID_M1;
        end else if ((AWADDR <= 32'h0002_FFFF) && (AWADDR >= 32'h0002_0000)) begin
            WVALID_S2 = WVALID_M1;
        end else if ((AWADDR <= 32'h1000_03FF) && (AWADDR >= 32'h1000_0000)) begin
            WVALID_S3 = WVALID_M1;
        end else if ((AWADDR <= 32'h1001_03FF) && (AWADDR >= 32'h1001_0000)) begin
            WVALID_S4 = WVALID_M1;
        end else if ((AWADDR <= 32'h201F_FFFF) && (AWADDR >= 32'h2000_0000)) begin
            WVALID_S5 = WVALID_M1;
        end else begin
            WVALID_DS = WVALID_M1;
        end
    end

    //Slave_data_MUX
    always_comb begin
        unique case ({WVALID_S1, WVALID_S2, WVALID_S3, WVALID_S4, WVALID_S5, WVALID_DS})
            6'b100000: WREADY_M1 = WVALID_S1 && WREADY_S1; 
            6'b010000: WREADY_M1 = WVALID_S2 && WREADY_S2;
            6'b001000: WREADY_M1 = WVALID_S3 && WREADY_S3;
            6'b000100: WREADY_M1 = WVALID_S4 && WREADY_S4;
            6'b000010: WREADY_M1 = WVALID_S5 && WREADY_S5;
            6'b000001: WREADY_M1 = WVALID_DS && WREADY_DS;
            default: WREADY_M1 = 1'b0;
        endcase
    end
endmodule