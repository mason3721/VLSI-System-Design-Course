`include "AXI_define.svh"
module AR_channel (
    input                             ACLK,
    input                             ARESETn,

    //Master READ ADDRESS0
    input                             ARVALID_M0,
    input        [`AXI_ID_BITS-1:0]   ARID_M0,   //4
	input        [`AXI_ADDR_BITS-1:0] ARADDR_M0, //32
	input        [`AXI_LEN_BITS-1:0]  ARLEN_M0,  //4
	input        [`AXI_SIZE_BITS-1:0] ARSIZE_M0, //3
	input        [1:0]                ARBURST_M0,

    output logic                      ARREADY_M0,

    //Master READ ADDRESS1
    input                             ARVALID_M1,
    input        [`AXI_ID_BITS-1:0]   ARID_M1,   //4
	input        [`AXI_ADDR_BITS-1:0] ARADDR_M1, //32
	input        [`AXI_LEN_BITS-1:0]  ARLEN_M1,  //4
	input        [`AXI_SIZE_BITS-1:0] ARSIZE_M1, //3
	input        [1:0]                ARBURST_M1,

    output logic                      ARREADY_M1,
	
    //S0
    input                             ARREADY_S0,

    output logic                      ARVALID_S0,
    output logic [`AXI_IDS_BITS-1:0]  ARID_S0,   //8
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S0, //32
	output logic [`AXI_LEN_BITS-1:0]  ARLEN_S0,  //4
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0, //3
	output logic [1:0]                ARBURST_S0,

    //S1
    input                             ARREADY_S1,

    output logic                      ARVALID_S1,
    output logic [`AXI_IDS_BITS-1:0]  ARID_S1,   //8
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S1, //32
	output logic [`AXI_LEN_BITS-1:0]  ARLEN_S1,  //4
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1, //3
	output logic [1:0]                ARBURST_S1,

    //S2
    input                             ARREADY_S2,

    output logic                      ARVALID_S2,
    output logic [`AXI_IDS_BITS-1:0]  ARID_S2,   //8
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S2, //32
	output logic [`AXI_LEN_BITS-1:0]  ARLEN_S2,  //4
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S2, //3
	output logic [1:0]                ARBURST_S2,

    //S3
    input                             ARREADY_S3,

    output logic                      ARVALID_S3,
    output logic [`AXI_IDS_BITS-1:0]  ARID_S3,   //8
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S3, //32
	output logic [`AXI_LEN_BITS-1:0]  ARLEN_S3,  //4
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S3, //3
	output logic [1:0]                ARBURST_S3,

    //S4
    input                             ARREADY_S4,

    output logic                      ARVALID_S4,
    output logic [`AXI_IDS_BITS-1:0]  ARID_S4,   //8
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S4, //32
	output logic [`AXI_LEN_BITS-1:0]  ARLEN_S4,  //4
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S4, //3
	output logic [1:0]                ARBURST_S4,

    //S5
    input                             ARREADY_S5,

    output logic                      ARVALID_S5,
    output logic [`AXI_IDS_BITS-1:0]  ARID_S5,   //8
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S5, //32
	output logic [`AXI_LEN_BITS-1:0]  ARLEN_S5,  //4
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S5, //3
	output logic [1:0]                ARBURST_S5,

    //DS
    input                             ARREADY_DS,

    output logic                      ARVALID_DS,
    output logic [`AXI_IDS_BITS-1:0]  ARID_DS,    //8

    //for VIP
    input                             RVALID_S0,
	input                             RVALID_S1,
    input                             RVALID_S2,
	input                             RVALID_S3,
    input                             RVALID_S4,
	input                             RVALID_S5,
	input                             RVALID_DS,

    input                             RREADY_S0,
	input                             RREADY_S1,
    input                             RREADY_S2,
	input                             RREADY_S3,
    input                             RREADY_S4,
	input                             RREADY_S5,
	input                             RREADY_DS
);
    logic [1:0] current_grant;
    logic [1:0] next_grant;
    logic       keep;

    logic [`AXI_IDS_BITS-1:0]  ARID;   //8
	logic [`AXI_ADDR_BITS-1:0] ARADDR; //32
	logic [`AXI_LEN_BITS-1:0]  ARLEN;  //4
	logic [`AXI_SIZE_BITS-1:0] ARSIZE; //3
	logic [1:0]                ARBURST;

    always_ff @(posedge ACLK) begin
        priority if (~ARESETn) begin
            keep <= 1'b0;
        end else begin
            unique if (ARREADY_M0 || ARREADY_M1) begin
                keep <= 1'b1;
            end else if ((RREADY_S0 && RVALID_S0) || (RREADY_S1 && RVALID_S1) || (RREADY_S2 && RVALID_S2) || (RREADY_S3 && RVALID_S3) || (RREADY_S4 && RVALID_S4) || (RREADY_S5 && RVALID_S5) || (RREADY_DS && RVALID_DS)) begin
                keep <= 1'b0;
            end else begin
                keep <= keep;
            end
        end
    end

    //Arbiter
    always_ff @(posedge ACLK) begin
        priority if (~ARESETn) begin
            current_grant <= 2'b00;
        end else begin
            priority if (ARREADY_M0 || ARREADY_M1) begin
                current_grant <= ~next_grant;
            end else if (next_grant != 2'b00) begin
                current_grant <= next_grant;
            end else begin
                current_grant <= current_grant;
            end
        end
    end

    always_comb begin
        unique if (ARVALID_M0 && ARVALID_M1) begin
            next_grant = current_grant;
        end else begin
            priority if (ARVALID_M1 && (keep == 1'b0)) begin
                next_grant = 2'b10;
            end else if (ARVALID_M0 && (keep == 1'b0)) begin
                next_grant = 2'b01;
            end else begin
                next_grant = 2'b00;
            end
        end
    end

    //select slave
    always_comb begin
        ARVALID_S0 = 1'b0;
        ARVALID_S1 = 1'b0;
        ARVALID_S2 = 1'b0;
        ARVALID_S3 = 1'b0;
        ARVALID_S4 = 1'b0;
        ARVALID_S5 = 1'b0;
        ARVALID_DS = 1'b0;
        unique case (next_grant)
            2'b01:
            begin
                unique if ((ARADDR_M0 <= 32'h0000_1FFF) && (ARADDR_M0 >= 32'h0000_0000)) begin
                    ARVALID_S0 = ARVALID_M0;
                end else if ((ARADDR_M0 <= 32'h0001_FFFF) && (ARADDR_M0 >= 32'h0001_0000)) begin
                    ARVALID_S1 = ARVALID_M0;
                end else if ((ARADDR_M0 <= 32'h0002_FFFF) && (ARADDR_M0 >= 32'h0002_0000)) begin
                    ARVALID_S2 = ARVALID_M0;
                end else if ((ARADDR_M0 <= 32'h1000_03FF) && (ARADDR_M0 >= 32'h1000_0000)) begin
                    ARVALID_S3 = ARVALID_M0;
                end else if ((ARADDR_M0 <= 32'h1001_03FF) && (ARADDR_M0 >= 32'h1001_0000)) begin
                    ARVALID_S4 = ARVALID_M0;
                end else if ((ARADDR_M0 <= 32'h201F_FFFF) && (ARADDR_M0 >= 32'h2000_0000)) begin
                    ARVALID_S5 = ARVALID_M0;
                end else begin
                    ARVALID_DS = ARVALID_M0;
                end
            end 
            2'b10:
            begin
                unique if ((ARADDR_M1 <= 32'h0000_1FFF) && (ARADDR_M1 >= 32'h0000_0000)) begin
                    ARVALID_S0 = ARVALID_M1;
                end else if ((ARADDR_M1 <= 32'h0001_FFFF) && (ARADDR_M1 >= 32'h0001_0000)) begin
                    ARVALID_S1 = ARVALID_M1;
                end else if ((ARADDR_M1 <= 32'h0002_FFFF) && (ARADDR_M1 >= 32'h0002_0000)) begin
                    ARVALID_S2 = ARVALID_M1;
                end else if ((ARADDR_M1 <= 32'h1000_03FF) && (ARADDR_M1 >= 32'h1000_0000)) begin
                    ARVALID_S3 = ARVALID_M1;
                end else if ((ARADDR_M1 <= 32'h1001_03FF) && (ARADDR_M1 >= 32'h1001_0000)) begin
                    ARVALID_S4 = ARVALID_M1;
                end else if ((ARADDR_M1 <= 32'h201F_FFFF) && (ARADDR_M1 >= 32'h2000_0000)) begin
                    ARVALID_S5 = ARVALID_M1;
                end else begin
                    ARVALID_DS = ARVALID_M1;
                end
            end
            default: 
            begin
                ARVALID_S0 = 1'b0;
                ARVALID_S1 = 1'b0;
                ARVALID_S2 = 1'b0;
                ARVALID_S3 = 1'b0;
                ARVALID_S4 = 1'b0;
                ARVALID_S5 = 1'b0;
                ARVALID_DS = 1'b0;
            end
        endcase
    end

    //Mater_data_MUX
    always_comb begin
        unique case (next_grant)
            2'b01:
            begin
                ARID = {4'b0100, ARID_M0};
                ARADDR = ARADDR_M0;
                ARLEN = ARLEN_M0;
                ARSIZE = ARSIZE_M0;
                ARBURST = ARBURST_M0;
            end 
            2'b10:
            begin
                ARID = {4'b1000, ARID_M1};
                ARADDR = ARADDR_M1;
                ARLEN = ARLEN_M1;
                ARSIZE = ARSIZE_M1;
                ARBURST = ARBURST_M1;
            end
            default: 
            begin
                ARID = 8'd0;
                ARADDR = 32'd0;
                ARLEN = 4'd0;
                ARSIZE = 3'd0;
                ARBURST = 2'd0;
            end
        endcase
    end

    //Data from Master
    //S0
    assign ARID_S0 = ARID;
    assign ARADDR_S0 = ARADDR;
    assign ARLEN_S0 = ARLEN;
    assign ARSIZE_S0 = ARSIZE;
    assign ARBURST_S0 = ARBURST;

    //S1
    assign ARID_S1 = ARID;
    assign ARADDR_S1 = ARADDR;
    assign ARLEN_S1 = ARLEN;
    assign ARSIZE_S1 = ARSIZE;
    assign ARBURST_S1 = ARBURST;

    //S2
    assign ARID_S2 = ARID;
    assign ARADDR_S2 = ARADDR;
    assign ARLEN_S2 = ARLEN;
    assign ARSIZE_S2 = ARSIZE;
    assign ARBURST_S2 = ARBURST;

    //S3
    assign ARID_S3 = ARID;
    assign ARADDR_S3 = ARADDR;
    assign ARLEN_S3 = ARLEN;
    assign ARSIZE_S3 = ARSIZE;
    assign ARBURST_S3 = ARBURST;
                
    //S4
    assign ARID_S4 = ARID;
    assign ARADDR_S4 = ARADDR;
    assign ARLEN_S4 = ARLEN;
    assign ARSIZE_S4 = ARSIZE;
    assign ARBURST_S4 = ARBURST;

    //S5
    assign ARID_S5 = ARID;
    assign ARADDR_S5 = ARADDR;
    assign ARLEN_S5 = ARLEN;
    assign ARSIZE_S5 = ARSIZE;
    assign ARBURST_S5 = ARBURST;

    //DS
    assign ARID_DS = ARID;

    always_comb begin
        unique case ({ARVALID_S0, ARVALID_S1, ARVALID_S2, ARVALID_S3, ARVALID_S4, ARVALID_S5, ARVALID_DS})
            7'b1000000: 
            begin
                ARREADY_M0 = ARREADY_S0 && next_grant[0];
                ARREADY_M1 = ARREADY_S0 && next_grant[1];
            end
            7'b0100000: 
            begin
                ARREADY_M0 = ARREADY_S1 && next_grant[0];
                ARREADY_M1 = ARREADY_S1 && next_grant[1];
            end
            7'b0010000: 
            begin
                ARREADY_M0 = ARREADY_S2 && next_grant[0];
                ARREADY_M1 = ARREADY_S2 && next_grant[1];
            end
            7'b0001000: 
            begin
                ARREADY_M0 = ARREADY_S3 && next_grant[0];
                ARREADY_M1 = ARREADY_S3 && next_grant[1];
            end
            7'b0000100: 
            begin
                ARREADY_M0 = ARREADY_S4 && next_grant[0];
                ARREADY_M1 = ARREADY_S4 && next_grant[1];
            end
            7'b0000010: 
            begin
                ARREADY_M0 = ARREADY_S5 && next_grant[0];
                ARREADY_M1 = ARREADY_S5 && next_grant[1];
            end
            7'b0000001: 
            begin
                ARREADY_M0 = ARREADY_DS && next_grant[0];
                ARREADY_M1 = ARREADY_DS && next_grant[1];
            end
            default: 
            begin
                ARREADY_M0 = 1'b0;
                ARREADY_M1 = 1'b0;
            end
        endcase
    end
endmodule