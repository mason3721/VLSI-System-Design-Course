`include "AXI_define.svh"

module SRAM_wrapper (
	input                             ACLK,
	input                             ARESETn,

	input        [`AXI_IDS_BITS-1:0]  AWID,
	input        [`AXI_ADDR_BITS-1:0] AWADDR,
	input        [`AXI_LEN_BITS-1:0]  AWLEN,
	input        [`AXI_SIZE_BITS-1:0] AWSIZE,
	input        [1:0]                AWBURST,
	input                             AWVALID,
	output logic                      AWREADY,

	input        [`AXI_DATA_BITS-1:0] WDATA,
	input        [`AXI_STRB_BITS-1:0] WSTRB,
	input                             WLAST,
	input                             WVALID,
	output logic                      WREADY,

	output logic [`AXI_IDS_BITS-1:0]  BID,
	output logic [1:0]                BRESP,
	output logic                      BVALID,
	input                             BREADY,

	input        [`AXI_IDS_BITS-1:0]  ARID,
	input        [`AXI_ADDR_BITS-1:0] ARADDR,
	input        [`AXI_LEN_BITS-1:0]  ARLEN,
	input        [`AXI_SIZE_BITS-1:0] ARSIZE,
	input        [1:0]                ARBURST,
	input                             ARVALID,
	output logic                      ARREADY,

	output logic [`AXI_IDS_BITS-1:0]  RID,
	output logic [`AXI_DATA_BITS-1:0] RDATA,
	output logic [1:0]                RRESP,
	output logic                      RLAST,
	output logic                      RVALID,
	input                             RREADY
);
	//AXI interface
	typedef struct packed {
	logic [`AXI_IDS_BITS-1:0]  id;
	logic [`AXI_ADDR_BITS-1:0] addr;
	logic [`AXI_LEN_BITS-1:0]  len;
	logic [`AXI_SIZE_BITS-1:0] size;
	logic [1:0]                burst;
	} AXI_REQ_T;

	logic        CK;
	logic        OE;
	logic [3:0]  WEB;
	logic [13:0] A;
	logic [31:0] DI;
	logic [31:0] DO;

	enum logic [1:0] {IDLE, READ, WRITE, BACK} current_State, next_State;
	AXI_REQ_T current_AXI_Req, next_AXI_Req;
	logic [3:0]  current_count, next_count;
	logic [31:0] DO_reg;

	//Sequential Circuit
	always_ff @(posedge ACLK) begin
		priority if (!ARESETn) begin
			current_State <= IDLE;
			current_AXI_Req <= 49'd0;
			current_count <= 4'd0;
			DO_reg <= 32'd0;
		end else begin
			current_State <= next_State;
			current_AXI_Req <= next_AXI_Req;
			current_count <= next_count;
			DO_reg <= (RREADY && RVALID) ? DO : DO_reg;
		end
	end

	//next_state: Combinational Circuit
	always_comb begin
	next_AXI_Req = current_AXI_Req;
		case (current_State)
			IDLE:
			begin
				unique if (AWVALID) begin
					next_AXI_Req = {AWID, AWADDR, AWLEN, AWSIZE, AWBURST};
					next_State = WRITE;
					next_count = 4'd1;
				end else if (ARVALID) begin
					next_AXI_Req = {ARID, ARADDR, ARLEN, ARSIZE, ARBURST};
					next_State = READ;
					next_count = 4'd1;
				end else begin
					next_State = IDLE;
					next_AXI_Req = current_AXI_Req;
					next_count = current_count;			
				end
			end
			READ:
			begin
				unique if (RREADY) begin
					next_AXI_Req.addr = current_AXI_Req.addr + 32'd4;
					next_count = current_count + 4'd1;
					next_State = IDLE;
				end else begin
					next_State = READ;
					next_AXI_Req = current_AXI_Req;
					next_count = current_count;			
				end
			end
			WRITE:
			begin
				unique if (WVALID) begin
					unique if (WLAST) begin
						next_State = BACK;
					end else begin
						next_State = WRITE;
					end
					next_AXI_Req.addr = current_AXI_Req.addr + 32'd4;
					next_count = current_count + 4'd1;
				end else begin
					next_State = current_State;
					next_AXI_Req = current_AXI_Req;
					next_count = current_count;			
				end
			end
			BACK:
			begin
				next_AXI_Req = current_AXI_Req;
				next_count = current_count;
				unique if (BREADY) begin
					next_State = IDLE;
				end else begin
					next_State = BACK;
				end
			end
		endcase
	end

	//output: Combinational Circuit
	always_comb begin
		AWREADY = 1'b0;
		ARREADY = 1'b0;
		case (current_State)
			IDLE:
			begin
				CK = ACLK;
				OE = 1'b0;
				DI = WDATA;
				WEB = 4'b1111;
				ARREADY = 1'b0;
				WREADY = 1'b0;
				BID = 8'd0;
				BRESP = 2'd0;
				BVALID = 1'b0;
				RID = 8'd0;
				RRESP = 2'd0;
				RLAST = 1'b0;
				RVALID = 1'b0;
				RDATA = DO_reg;
				unique if (AWVALID) begin
					AWREADY = 1'b1;
					A = AWADDR[15:2];
				end else if (ARVALID) begin
					ARREADY = 1'b1;
					A = ARADDR[15:2];
				end else begin
					ARREADY = 1'b0;
					A = 14'd0;
				end
			end
			READ:
			begin
				CK = ACLK;
				DI = WDATA;
				WEB = 4'b1111;
				AWREADY = 1'b0;
				ARREADY = 1'b0;
				WREADY = 1'b0;
				BID = 8'd0;
				BRESP = 2'd0;
				BVALID = 1'b0;
				RRESP = 2'd0;
				RVALID = 1'b1;
				OE = 1'b1;
				A = current_AXI_Req.addr[15:2];
				RDATA = DO;
				RID = current_AXI_Req.id;
				RLAST = (current_count == current_AXI_Req.len + 4'd1);
			end
			WRITE:
			begin
				unique if (WVALID) begin
					WREADY = 1'b1;
				end else begin
					WREADY = 1'b0;
				end
				WEB = WSTRB;
				A = current_AXI_Req.addr[15:2];
				CK = ACLK;
				OE = 1'b0;
				DI = WDATA;
				AWREADY = 1'b0;
				ARREADY = 1'b0;
				BID = 8'd0;
				BRESP = 2'd0;
				BVALID = 1'b0;
				RID = 8'd0;
				RDATA = 32'd0;
				RRESP = 2'd0;
				RLAST = 1'b0;
				RVALID = 1'b0;
			end
			BACK:
			begin
				CK = ACLK;
				OE = 1'b0;
				A = 14'd0;
				DI = WDATA;
				WEB = 4'b1111;
				AWREADY = 1'b0;
				ARREADY = 1'b0;
				WREADY = 1'b0;
				BRESP = 2'd0;
				RID = 8'd0;
				RDATA = 32'd0;
				RRESP = 2'd0;
				RLAST = 1'b0;
				RVALID = 1'b0;
				BVALID = 1'b1;
				BID = current_AXI_Req.id;
			end
		endcase
	end

	SRAM i_SRAM (
		.A0   (A[0]  ),
		.A1   (A[1]  ),
		.A2   (A[2]  ),
		.A3   (A[3]  ),
		.A4   (A[4]  ),
		.A5   (A[5]  ),
		.A6   (A[6]  ),
		.A7   (A[7]  ),
		.A8   (A[8]  ),
		.A9   (A[9]  ),
		.A10  (A[10] ),
		.A11  (A[11] ),
		.A12  (A[12] ),
		.A13  (A[13] ),
		.DO0  (DO[0] ),
		.DO1  (DO[1] ),
		.DO2  (DO[2] ),
		.DO3  (DO[3] ),
		.DO4  (DO[4] ),
		.DO5  (DO[5] ),
		.DO6  (DO[6] ),
		.DO7  (DO[7] ),
		.DO8  (DO[8] ),
		.DO9  (DO[9] ),
		.DO10 (DO[10]),
		.DO11 (DO[11]),
		.DO12 (DO[12]),
		.DO13 (DO[13]),
		.DO14 (DO[14]),
		.DO15 (DO[15]),
		.DO16 (DO[16]),
		.DO17 (DO[17]),
		.DO18 (DO[18]),
		.DO19 (DO[19]),
		.DO20 (DO[20]),
		.DO21 (DO[21]),
		.DO22 (DO[22]),
		.DO23 (DO[23]),
		.DO24 (DO[24]),
		.DO25 (DO[25]),
		.DO26 (DO[26]),
		.DO27 (DO[27]),
		.DO28 (DO[28]),
		.DO29 (DO[29]),
		.DO30 (DO[30]),
		.DO31 (DO[31]),
		.DI0  (DI[0] ),
		.DI1  (DI[1] ),
		.DI2  (DI[2] ),
		.DI3  (DI[3] ),
		.DI4  (DI[4] ),
		.DI5  (DI[5] ),
		.DI6  (DI[6] ),
		.DI7  (DI[7] ),
		.DI8  (DI[8] ),
		.DI9  (DI[9] ),
		.DI10 (DI[10]),
		.DI11 (DI[11]),
		.DI12 (DI[12]),
		.DI13 (DI[13]),
		.DI14 (DI[14]),
		.DI15 (DI[15]),
		.DI16 (DI[16]),
		.DI17 (DI[17]),
		.DI18 (DI[18]),
		.DI19 (DI[19]),
		.DI20 (DI[20]),
		.DI21 (DI[21]),
		.DI22 (DI[22]),
		.DI23 (DI[23]),
		.DI24 (DI[24]),
		.DI25 (DI[25]),
		.DI26 (DI[26]),
		.DI27 (DI[27]),
		.DI28 (DI[28]),
		.DI29 (DI[29]),
		.DI30 (DI[30]),
		.DI31 (DI[31]),
		.CK   (CK    ),
		.WEB0 (WEB[0]),
		.WEB1 (WEB[1]),
		.WEB2 (WEB[2]),
		.WEB3 (WEB[3]),
		.OE   (OE    ),
		.CS   (1'b1  )
	);
endmodule