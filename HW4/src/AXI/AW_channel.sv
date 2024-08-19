`include "AXI_define.svh"
module AW_channel (
    //Master WRITE ADDRESS1
    input                             AWVALID_M1,
    input        [`AXI_ID_BITS-1:0]   AWID_M1,   //4
	input        [`AXI_ADDR_BITS-1:0] AWADDR_M1, //32
	input        [`AXI_LEN_BITS-1:0]  AWLEN_M1,  //4
	input        [`AXI_SIZE_BITS-1:0] AWSIZE_M1, //3
	input        [1:0]                AWBURST_M1,                 
	
	output logic                      AWREADY_M1,

    //S1
    input                             AWREADY_S1,

    output logic                      AWVALID_S1,
    output logic [`AXI_IDS_BITS-1:0]  AWID_S1,   //8
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S1, //32
	output logic [`AXI_LEN_BITS-1:0]  AWLEN_S1,  //4
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1, //3
	output logic [1:0]                AWBURST_S1,

    //S2
    input                             AWREADY_S2,

    output logic                      AWVALID_S2,
    output logic [`AXI_IDS_BITS-1:0]  AWID_S2,   //8
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S2, //32
	output logic [`AXI_LEN_BITS-1:0]  AWLEN_S2,  //4
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S2, //3
	output logic [1:0]                AWBURST_S2,

    //S3
    input                             AWREADY_S3,

    output logic                      AWVALID_S3,
    output logic [`AXI_IDS_BITS-1:0]  AWID_S3,   //8
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S3, //32
	output logic [`AXI_LEN_BITS-1:0]  AWLEN_S3,  //4
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S3, //3
	output logic [1:0]                AWBURST_S3,

    //S4
    input                             AWREADY_S4,

    output logic                      AWVALID_S4,
    output logic [`AXI_IDS_BITS-1:0]  AWID_S4,   //8
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S4, //32
	output logic [`AXI_LEN_BITS-1:0]  AWLEN_S4,  //4
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S4, //3
	output logic [1:0]                AWBURST_S4,

    //S5
    input                             AWREADY_S5,

    output logic                      AWVALID_S5,
    output logic [`AXI_IDS_BITS-1:0]  AWID_S5,   //8
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S5, //32
	output logic [`AXI_LEN_BITS-1:0]  AWLEN_S5,  //4
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S5, //3
	output logic [1:0]                AWBURST_S5,

    //DS
    input                             AWREADY_DS,

    output logic                      AWVALID_DS,
    output logic [`AXI_IDS_BITS-1:0]  AWID_DS   //8
);
    //S1
    assign AWID_S1 = {4'b1000,AWID_M1};
    assign AWADDR_S1 = AWADDR_M1;
    assign AWLEN_S1	 = AWLEN_M1;
    assign AWSIZE_S1 = AWSIZE_M1;
    assign AWBURST_S1 =	AWBURST_M1;   

    //S2
    assign AWID_S2 = {4'b1000,AWID_M1};
    assign AWADDR_S2 = AWADDR_M1;
    assign AWLEN_S2	= AWLEN_M1;
    assign AWSIZE_S2 = AWSIZE_M1;
    assign AWBURST_S2 = AWBURST_M1;   

    //S3
    assign AWID_S3 = {4'b1000,AWID_M1};
    assign AWADDR_S3 = AWADDR_M1;
    assign AWLEN_S3	= AWLEN_M1;
    assign AWSIZE_S3 = AWSIZE_M1;
    assign AWBURST_S3 = AWBURST_M1;

    //S4
    assign AWID_S4 = {4'b1000,AWID_M1};
    assign AWADDR_S4 = AWADDR_M1;
    assign AWLEN_S4	= AWLEN_M1;
    assign AWSIZE_S4 = AWSIZE_M1;
    assign AWBURST_S4 = AWBURST_M1;

    //S5
    assign AWID_S5 = {4'b1000,AWID_M1};
    assign AWADDR_S5 = AWADDR_M1;
    assign AWLEN_S5	= AWLEN_M1;
    assign AWSIZE_S5 = AWSIZE_M1;
    assign AWBURST_S5 = AWBURST_M1;

    //DS    
    assign AWID_DS = {4'b1000,AWID_M1}; 

    //Valid_Decoder
    always_comb begin
        AWVALID_S1 = 1'b0;
        AWVALID_S2 = 1'b0;
        AWVALID_S3 = 1'b0;
        AWVALID_S4 = 1'b0;
        AWVALID_S5 = 1'b0;
        AWVALID_DS = 1'b0;
        unique if ((AWADDR_M1 <= 32'h0001_FFFF) && (AWADDR_M1 >= 32'h0001_0000)) begin
            AWVALID_S1 = AWVALID_M1;
        end else if ((AWADDR_M1 <= 32'h0002_FFFF) && (AWADDR_M1 >= 32'h0002_0000)) begin
            AWVALID_S2 = AWVALID_M1;
        end else if ((AWADDR_M1 <= 32'h1000_03FF) && (AWADDR_M1 >= 32'h1000_0000)) begin
            AWVALID_S3 = AWVALID_M1;
        end else if ((AWADDR_M1 <= 32'h1001_03FF) && (AWADDR_M1 >= 32'h1001_0000)) begin
            AWVALID_S4 = AWVALID_M1;
        end else if ((AWADDR_M1 <= 32'h201F_FFFF) && (AWADDR_M1 >= 32'h2000_0000)) begin
            AWVALID_S5 = AWVALID_M1;
        end else begin
            AWVALID_DS = AWVALID_M1;
        end
    end

    //Slave_data_MUX
    always_comb begin
        unique case ({AWVALID_S1, AWVALID_S2, AWVALID_S3, AWVALID_S4, AWVALID_S5, AWVALID_DS})
            6'b100000: AWREADY_M1 = AWVALID_S1 && AWREADY_S1;
            6'b010000: AWREADY_M1 = AWVALID_S2 && AWREADY_S2;
            6'b001000: AWREADY_M1 = AWVALID_S3 && AWREADY_S3;
            6'b000100: AWREADY_M1 = AWVALID_S4 && AWREADY_S4;
            6'b000010: AWREADY_M1 = AWVALID_S5 && AWREADY_S5;
            6'b000001: AWREADY_M1 = AWVALID_DS && AWREADY_DS;
            default: AWREADY_M1 = 1'b0;
        endcase
    end
endmodule