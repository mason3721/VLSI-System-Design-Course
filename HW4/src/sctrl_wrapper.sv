`include "AXI_define.svh"
`include "sensor_ctrl.sv"

module sctrl_wrapper (
    input                             clk,
    input                             rst,
  
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

    //sensor control
    // core output
    output logic                      sctrl_interrupt,
    // output from sensor(off chip)
    input                             sensor_ready,
    input        [31:0]               sensor_out,
    // input to sensor(off chip)
    output logic                      sensor_en
);
    //sensor control
    logic        sctrl_en;
    logic        sctrl_clear; 
    logic [5:0]  sctrl_addr;
    logic [31:0] sctrl_out;
    //relay
    logic        relay_sctrl_en;
    logic        relay_sctrl_clear;

    //state
    enum logic [2:0] {IDLE, AR, R, AW, W, B} current_state, next_state;

    //relay
    logic [31:0] relay_AWADDR;
    logic [7:0]  relay_AWID;
    logic [31:0] relay_ARADDR;
    logic [7:0]  relay_ARID;

    sensor_ctrl sensor_ctrl (
        .clk             (clk),
        .rst             (rst),
        .sctrl_en        (sctrl_en),        
        .sctrl_clear     (sctrl_clear),
        .sctrl_addr      (sctrl_addr),
        .sensor_ready    (sensor_ready),
        .sensor_out      (sensor_out),
        .sctrl_interrupt (sctrl_interrupt),
        .sctrl_out       (sctrl_out),
        .sensor_en       (sensor_en)
    );

    //WRITE RESPONSE
    assign BRESP = 2'd0;
    //READ DATA
    assign RRESP = 2'd0;

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
            relay_sctrl_en <= 1'b0;
            relay_sctrl_clear <= 1'b0;
            relay_AWADDR <= 32'd0;
            relay_AWID <= 8'd0;
            relay_ARADDR <= 32'd0;
            relay_ARID <= 8'd0;
		end else begin
            relay_sctrl_en <= sctrl_en;
            relay_sctrl_clear <= sctrl_clear;
            unique if ((current_state == AR) && (next_state == R)) begin
                relay_ARADDR <= ARADDR;
                relay_ARID <= ARID;
            end else begin
                relay_ARADDR <= relay_ARADDR;
                relay_ARID <= relay_ARID;
            end
            unique if ((current_state == AW) && (next_state == W)) begin
                relay_AWADDR <= AWADDR;
                relay_AWID <= AWID;
            end else begin
                relay_AWADDR <= relay_AWADDR;
                relay_AWID <= relay_AWID;
            end
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

                //sensor control
                sctrl_clear = relay_sctrl_clear;
                sctrl_en = relay_sctrl_en;
                sctrl_addr = 6'd0;
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

                //sensor control
                sctrl_clear = relay_sctrl_clear;
                sctrl_en = relay_sctrl_en;
                sctrl_addr = 6'd0;
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
                RDATA = sctrl_out;
                RLAST = 1'b1;
                RVALID = 1'b1;

                //sensor control
                sctrl_clear = relay_sctrl_clear;
                sctrl_en = relay_sctrl_en;
                sctrl_addr = relay_ARADDR[7:2];
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

                //sensor control
                sctrl_clear = relay_sctrl_clear;
                sctrl_en = relay_sctrl_en;
                sctrl_addr = 6'd0;
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

                //sensor control
                //Write non-zero value in 0x1000_0100 or 0x1000_0200 to enable stcrl_en or stcrl_clear
                sctrl_clear = (relay_AWADDR[15:0] == 16'h0200) ? (|WDATA) : relay_sctrl_clear;
                sctrl_en = (relay_AWADDR[15:0] == 16'h0100) ? (|WDATA) : relay_sctrl_en;
                sctrl_addr = 6'd0;
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

                //sensor control
                sctrl_clear = relay_sctrl_clear;
                sctrl_en = relay_sctrl_en;
                sctrl_addr = 6'd0;
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

                //sensor control
                sctrl_clear = relay_sctrl_clear;
                sctrl_en = relay_sctrl_en;
                sctrl_addr = 6'd0;
			end 
		endcase
    end
endmodule