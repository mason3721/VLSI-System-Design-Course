`include "AXI_define.svh"
`include "WDT.sv"

module WDT_wrapper (
    input                             clk,    // system clock
    input                             clk2,   // WDT clock
    input                             rst,
    input                             rst2,

    //WRITE ADDRESS
  	input        [`AXI_IDS_BITS-1:0]  AWID,   //8
	input        [`AXI_ADDR_BITS-1:0] AWADDR, //32
	input        [`AXI_LEN_BITS-1:0]  AWLEN,  //4
	input        [`AXI_SIZE_BITS-1:0] AWSIZE, //3
	input        [1:0]                AWBURST,
	input                             AWVALID,

    output logic                      AWREADY,

    //WRITE DATA
    input        [`AXI_DATA_BITS-1:0] WDATA, //32
	input        [`AXI_STRB_BITS-1:0] WSTRB, //4
	input                             WLAST,
	input                             WVALID,

    output logic                      WREADY,

    //WRITE RESPONSE
    output logic [`AXI_IDS_BITS-1:0]  BID, //8
	output logic [1:0]                BRESP,
	output logic                      BVALID,

    input                             BREADY,

    //READ ADDRESS
    input        [`AXI_IDS_BITS-1:0]  ARID,   //8
	input        [`AXI_ADDR_BITS-1:0] ARADDR, //32
	input        [`AXI_LEN_BITS-1:0]  ARLEN,  //4
	input        [`AXI_SIZE_BITS-1:0] ARSIZE, //3
	input        [1:0]                ARBURST,
	input                             ARVALID,

    output logic                      ARREADY,

    //READ DATA
    output logic [`AXI_IDS_BITS-1:0]  RID,   //8
	output logic [`AXI_DATA_BITS-1:0] RDATA, //32
	output logic [1:0]                RRESP,
	output logic                      RLAST,
	output logic                      RVALID,

    input                             RREADY,

    //WDT
    output logic                      WTO
);
    //WDT
    logic        WDEN;
    logic        WDLIVE;
    logic [31:0] WTOCNT;

    //state
    enum logic [2:0] {IDLE, AR, R, AW, W, B} current_state, next_state;

    //relay
    logic [15:0] relay_AWADDR; // only need AWADDR[15:0]
    logic [7:0]  relay_AWID;
    logic [7:0]  relay_ARID;

    WDT wdt(
        .clk    (clk),
        .clk2   (clk2),
        .rst    (rst),
        .rst2   (rst2),
        .WDEN   (WDEN),
        .WDLIVE (WDLIVE),
        .WTOCNT (WTOCNT),
        .WTO    (WTO)
    );

    //WRITE RESPONSE
    assign BRESP = 2'd0;
    //READ DATA
    assign RRESP = 2'd0;

    //WDT input signal: Sequential Circuit
	always_ff @(posedge clk) begin
        priority if (rst) begin
            WDEN <= 1'b0;
            WDLIVE <= 1'b0;
            WTOCNT <= 32'd0;
        end else if (WTO) begin
            WDEN <= 1'b0;
            WDLIVE <= 1'b0;
            WTOCNT <= 32'd0;
        end else if (current_state == W) begin
            WDEN <= (relay_AWADDR == 16'h0100) ? 1'b1 : WDEN;
            WDLIVE <= (relay_AWADDR == 16'h0200) ? 1'b1 : WDLIVE;
            WTOCNT <= (relay_AWADDR == 16'h0300) ? WDATA : WTOCNT;
        end else begin
            WDEN <= WDEN;
            WDLIVE <= WDLIVE;
            WTOCNT <= WTOCNT;
        end
    end

    //state: Sequential Circuit
	always_ff @(posedge clk) begin
		priority if (rst) begin
			current_state <= IDLE;
		end else begin
			current_state <= next_state;
		end
	end

    //Store some data => state: Sequential Circuit
    always_ff @(posedge clk) begin
		priority if (rst) begin
            relay_AWADDR <= 16'd0;
            relay_AWID <= 8'd0;
            relay_ARID <= 8'd0;
		end else begin
            unique case (current_state)
                AR:
                begin
                    relay_AWADDR <= relay_AWADDR;
                    relay_AWID <= relay_AWID;
                    relay_ARID <= ARID;
                end
                AW:
                begin
                    relay_AWADDR <= AWADDR[15:0];
                    relay_AWID <= AWID;
                    relay_ARID <= relay_ARID;
                end 
                default: 
                begin
                    relay_AWADDR <= relay_AWADDR;
                    relay_AWID <= relay_AWID;
                    relay_ARID <= relay_ARID;
                end
            endcase
		end
	end

    //next_state: Combinational Circuit
    always_comb begin
        unique case (current_state)
			IDLE: 
			begin
				unique if (AWVALID) begin
                    next_state = AW; 
				end else if (ARVALID) begin
					next_state = AR;
				end else begin
					next_state = IDLE;
				end
			end
			AR: 
			begin
				unique if (ARVALID && ARREADY) begin
					next_state = R;
				end else begin
					next_state = AR;
				end
			end
			R: 
			begin
                unique if (RREADY && RVALID && RLAST) begin
                    next_state = IDLE;
				end else begin
					next_state = R;
				end
			end
			AW: 
			begin
				unique if (AWVALID && AWREADY) begin
					next_state = W;
				end else begin
					next_state = AW;
				end
			end
			W: 
			begin
				unique if (WVALID && WREADY && WLAST) begin
					next_state = B;
				end else begin
					next_state = W;
				end
			end
			B: 
			begin
				unique if (BREADY && BVALID) begin
                    next_state = IDLE;
				end else begin
					next_state = B;
				end
			end 
			default:
			begin
				next_state = IDLE;
			end 
		endcase
    end

    //output: Combinational Circuit
    always_comb begin
        unique case (current_state)
			IDLE: 
			begin
				//WRITE ADDRESS
                AWREADY = 1'b0;

                //WRITE DATA 
                WREADY = 1'b0;

                //WRITE RESPONSE
                BID = 8'd0;
                BVALID = 1'b0;

                //READ ADDRESS
                ARREADY = 1'b0;

                //READ DATA
                RID = 8'd0;
                RDATA = 32'd0;
                RLAST = 1'b0;
                RVALID = 1'b0;
			end
			AR: 
			begin
				//WRITE ADDRESS
                AWREADY = 1'b0;

                //WRITE DATA 
                WREADY = 1'b0;

                //WRITE RESPONSE
                BID = 8'd0;
                BVALID = 1'b0;

                //READ ADDRESS
                ARREADY = 1'd1;

                //READ DATA
                RID = 8'd0;
                RDATA = 32'd0;
                RLAST = 1'b0;
                RVALID = 1'b0;
			end
			R: 
			begin
				//WRITE ADDRESS
                AWREADY = 1'b0;

                //WRITE DATA 
                WREADY = 1'b0;

                //WRITE RESPONSE
                BID = 8'd0;
                BVALID = 1'b0;

                //READ ADDRESS
                ARREADY = 1'd0;

                //READ DATA
                RID = relay_ARID;
                RDATA = 32'd0;
                RLAST = 1'b1;
                RVALID = 1'b1;
			end
			AW: 
			begin
				//WRITE ADDRESS
                AWREADY = 1'b1;

                //WRITE DATA 
                WREADY = 1'b0;

                //WRITE RESPONSE
                BID = 8'd0;
                BVALID = 1'b0;

                //READ ADDRESS
                ARREADY = 1'b0;

                //READ DATA
                RID = 8'd0;
                RDATA = 32'd0;
                RLAST = 1'b0;
                RVALID = 1'b0;
			end
			W: 
			begin
				//WRITE ADDRESS
                AWREADY = 1'b0;

                //WRITE DATA 
                unique if (WVALID) begin
                    WREADY = 1'b1;
                end else begin
                    WREADY = 1'b0;
                end

                //WRITE RESPONSE
                BID = 8'd0;
                BVALID = 1'b0;

                //READ ADDRESS
                ARREADY = 1'b0;

                //READ DATA
                RID = 8'd0;
                RDATA = 32'd0;
                RLAST = 1'b0;
                RVALID = 1'b0;
			end
			B: 
			begin
				//WRITE ADDRESS
                AWREADY = 1'b0;

                //WRITE DATA 
                WREADY = 1'b0;

                //WRITE RESPONSE
                BID = relay_AWID;
                BVALID = 1'b1;

                //READ ADDRESS
                ARREADY = 1'd0;

                //READ DATA
                RID = 8'd0;
                RDATA = 32'd0;
                RLAST = 1'b0;
                RVALID = 1'b0;
			end 
			default:
			begin
				//WRITE ADDRESS
                AWREADY = 1'b0;

                //WRITE DATA 
                WREADY = 1'b0;

                //WRITE RESPONSE
                BID = 8'd0;
                BVALID = 1'b0;

                //READ ADDRESS
                ARREADY = 1'd0;

                //READ DATA
                RID = 8'd0;
                RDATA = 32'd0;
                RLAST = 1'b0;
                RVALID = 1'b0;
			end 
		endcase
    end
endmodule