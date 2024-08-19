//================================================
// Auther:      Lin Meng-Yu            
// Filename:    WDT_wrapper.sv                            
// Description: Watch Dog Timer Wrapper module                   
// Version:     HW3 Submit Version 
// Date:        2023/11/23
//================================================

`include "AXI_define.svh"
`include "WDT.sv"
module WDT_wrapper (
    input                             clk,    // CPU clock (Fast)
    input                             rst,
    input                             clk2,   // WDT clock (Slow)  
    input                             rst2,

    // *******************  WRITE ADDRESS CHANNEL ****************** // 
  	input        [`AXI_IDS_BITS-1:0]  AWID,   
	input        [`AXI_ADDR_BITS-1:0] AWADDR, 
	input        [`AXI_LEN_BITS-1:0]  AWLEN,  
	input        [`AXI_SIZE_BITS-1:0] AWSIZE, 
	input        [1:0]                AWBURST,
	input                             AWVALID,

    output logic                      AWREADY,

    // **********************  WRITE DATA CHANNEL ****************** //
    input        [`AXI_DATA_BITS-1:0] WDATA,
	input        [`AXI_STRB_BITS-1:0] WSTRB, 
	input                             WLAST,
	input                             WVALID,

    output logic                      WREADY,

    // *******************  WRITE RESPONSE CHANNEL ***************** //
    output logic [`AXI_IDS_BITS-1:0]  BID, //8
	output logic [1:0]                BRESP,
	output logic                      BVALID,

    input                             BREADY,

    // *******************  READ ADDRESS CHANNEL ****************** // 
    input        [`AXI_IDS_BITS-1:0]  ARID,   
	input        [`AXI_ADDR_BITS-1:0] ARADDR, 
	input        [`AXI_LEN_BITS-1:0]  ARLEN,  
	input        [`AXI_SIZE_BITS-1:0] ARSIZE, 
	input        [1:0]                ARBURST,
	input                             ARVALID,

    output logic                      ARREADY,

    // *******************  READ DATA CHANNEL ********************* //
    output logic [`AXI_IDS_BITS-1:0]  RID,   
	output logic [`AXI_DATA_BITS-1:0] RDATA, 
	output logic [1:0]                RRESP,
	output logic                      RLAST,
	output logic                      RVALID,

    input                             RREADY,

    // *********************** WDT Signal *********************** //
    output logic                      WTO
);

    // ---------------------- State Parameters ------------------- //
    parameter   [2:0]    IDLE = 3'd0    ,
	                     AR   = 3'd1    ,
	                     R    = 3'd2    ,
	                     AW   = 3'd3    ,
	                     W    = 3'd4    ,
	                     B    = 3'd5    ;

    logic        WDEN;
    logic        WDLIVE;
    logic [31:0] WTOCNT;

    logic [2:0]  current_state;
	logic [2:0]  next_state;

    logic [15:0] AWADDR_temp; 
    logic [7:0]  AWID_temp;
    logic [7:0]  ARID_temp;

    WDT WDT(
        .clk    (clk),
        .clk2   (clk2),
        .rst    (rst),
        .rst2   (rst2),
        .WDEN   (WDEN),
        .WDLIVE (WDLIVE),
        .WTOCNT (WTOCNT),
        .WTO    (WTO)
    );


    // ------------------------ Sequential ------------------------ //
	always_ff @(posedge clk) begin
        if (rst) begin
            WDEN <= 1'b0;
            WDLIVE <= 1'b0;
            WTOCNT <= 32'd0;
        end 
        else if (WTO) begin
            WDEN <= 1'b0;
            WDLIVE <= 1'b0;
            WTOCNT <= 32'd0;
        end 
        else if (current_state == W) begin
            WDEN <= (AWADDR_temp == 16'h0100) ? 1'b1 : WDEN;
            WDLIVE <= (AWADDR_temp == 16'h0200) ? 1'b1 : WDLIVE;
            WTOCNT <= (AWADDR_temp == 16'h0300) ? WDATA : WTOCNT;
        end 
        else begin
            WDEN <= WDEN;
            WDLIVE <= WDLIVE;
            WTOCNT <= WTOCNT;
        end
    end


    always_ff @(posedge clk) begin
		if (rst) begin
            AWADDR_temp <= 16'd0;
            AWID_temp <= 8'd0;
            ARID_temp <= 8'd0;
		end 
        else begin
            unique case (current_state)
                AR:
                begin
                    AWADDR_temp <= AWADDR_temp;
                    AWID_temp <= AWID_temp;
                    ARID_temp <= ARID;
                end
                AW:
                begin
                    AWADDR_temp <= AWADDR[15:0];
                    AWID_temp <= AWID;
                    ARID_temp <= ARID_temp;
                end 
                default: 
                begin
                    AWADDR_temp <= AWADDR_temp;
                    AWID_temp <= AWID_temp;
                    ARID_temp <= ARID_temp;
                end
            endcase
		end
	end

	always_ff @(posedge clk) begin
		if (rst) begin
			current_state <= IDLE;
		end
        else begin
			current_state <= next_state;
		end
	end

	// ----------------- Next State Combinational Logic ------------------ //
    always_comb begin
        case (current_state)
			IDLE: 
			begin
				if (AWVALID) begin
                    next_state = AW; 
				end 
                else if (ARVALID) begin
					next_state = AR;
				end 
                else begin
					next_state = IDLE;
				end
			end
			AR: 
			begin
				if (ARVALID && ARREADY) begin
					next_state = R;
				end 
                else begin
					next_state = AR;
				end
			end
			R: 
			begin
                if (RREADY && RVALID && RLAST) begin
                    next_state = IDLE;
				end 
                else begin
					next_state = R;
				end
			end
			AW: 
			begin
				if (AWVALID && AWREADY) begin
					next_state = W;
				end 
                else begin
					next_state = AW;
				end
			end
			W: 
			begin
				if (WVALID && WREADY && WLAST) begin
					next_state = B;
				end 
                else begin
					next_state = W;
				end
			end
			B: 
			begin
				if (BREADY && BVALID) begin
                    next_state = IDLE;
				end 
                else begin
					next_state = B;
				end
			end 
			default:
			begin
				next_state = IDLE;
			end 
		endcase
    end

    // ******************** Output Combinational Logic ********************* //
    // ******** Constant Outputs ******** //
    assign BRESP = 2'd0;
    assign RRESP = 2'd0;

    // ******** Control Outputs  ******** //
    always_comb begin
        case (current_state)
			IDLE: 
			begin
                AWREADY = 1'b0;
                WREADY = 1'b0;
                BID = 8'd0;
                BVALID = 1'b0;
                ARREADY = 1'b0;
                RID = 8'd0;
                RDATA = 32'd0;
                RLAST = 1'b0;
                RVALID = 1'b0;
			end
			AR: 
			begin
                AWREADY = 1'b0;
                WREADY = 1'b0;
                BID = 8'd0;
                BVALID = 1'b0;
                ARREADY = 1'd1;
                RID = 8'd0;
                RDATA = 32'd0;
                RLAST = 1'b0;
                RVALID = 1'b0;
			end
			R: 
			begin
                AWREADY = 1'b0;
                WREADY = 1'b0;
                BID = 8'd0;
                BVALID = 1'b0;
                ARREADY = 1'd0;
                RID = ARID_temp;
                RDATA = 32'd0;
                RLAST = 1'b1;
                RVALID = 1'b1;
			end
			AW: 
			begin
                AWREADY = 1'b1;
                WREADY = 1'b0;
                BID = 8'd0;
                BVALID = 1'b0;
                ARREADY = 1'b0;
                RID = 8'd0;
                RDATA = 32'd0;
                RLAST = 1'b0;
                RVALID = 1'b0;
			end
			W: 
			begin
                AWREADY = 1'b0;
                WREADY = 1'b1;
                BID = 8'd0;
                BVALID = 1'b0;
                ARREADY = 1'b0;
                RID = 8'd0;
                RDATA = 32'd0;
                RLAST = 1'b0;
                RVALID = 1'b0;
			end
			B: 
			begin
                AWREADY = 1'b0;
                WREADY = 1'b0;
                BID = AWID_temp;
                BVALID = 1'b1;
                ARREADY = 1'd0;
                RID = 8'd0;
                RDATA = 32'd0;
                RLAST = 1'b0;
                RVALID = 1'b0;
			end 
			default:
			begin
                AWREADY = 1'b0;
                WREADY = 1'b0;
                BID = 8'd0;
                BVALID = 1'b0;
                ARREADY = 1'd0;
                RID = 8'd0;
                RDATA = 32'd0;
                RLAST = 1'b0;
                RVALID = 1'b0;
			end 
		endcase
    end
endmodule