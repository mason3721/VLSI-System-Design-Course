`include "AXI_define.svh"

module ROM_wrapper (
    input                             ACLK,
    input                             ARESETn,

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
	input                             RREADY,

    output logic                      ROM_read,
    output logic                      ROM_enable,
    output logic [11:0]               ROM_address,
    input        [31:0]               ROM_out
);
	//AXI interface
	typedef struct packed {
		logic [`AXI_IDS_BITS-1:0] ID;
		logic [`AXI_ADDR_BITS-1:0] addr;
		logic [`AXI_LEN_BITS-1:0] len;
		logic [`AXI_SIZE_BITS-1:0] size;
		logic [1:0] burst;
		} AXI_REQ_T;

	enum logic {AR, R} current_state, next_state;

	AXI_REQ_T current_AXI_Req, next_AXI_Req;
	logic [3:0]  current_count, next_count;
	logic [31:0] DO_reg;

	//Sequential Circuit
	always_ff @(posedge ACLK) begin
		priority if (!ARESETn) begin
			current_state <= AR;
			current_AXI_Req <= 49'd0;
			current_count <= 4'd0;
			DO_reg <= 32'd0;
		end else begin
			current_state <= next_state;
			current_AXI_Req <= next_AXI_Req;
			current_count <= next_count;
			DO_reg <= (RREADY) ? ROM_out : DO_reg;
		end
	end

	//next_state: Combinational Circuit
	always_comb begin
		next_state = current_state;
		next_AXI_Req = current_AXI_Req;
		next_count = current_count;

		case (current_state)
			AR:
			begin
				if (ARVALID) begin
					next_AXI_Req = {ARID, ARADDR, ARLEN, ARSIZE, ARBURST};
					next_state = R;
					next_count = 4'd1;
				end
			end
			R:
			begin
				if (RREADY) begin
					next_AXI_Req.addr = current_AXI_Req.addr + 32'd4;
					next_count = current_count + 4'd1;
					next_state = AR;
				end
			end
		endcase
	end

	//output: Combinational Circuit
	always_comb begin
		case(current_state) 
			AR:
			begin
				ROM_enable = 1'b1;
				ROM_read = 1'b1;
				RID = 8'd0;
				RRESP = 2'd0;
				RLAST = 1'b0;
				RVALID = 1'b0;
				RDATA = DO_reg;
				unique if (ARVALID) begin
					ARREADY = 1'b1;
					ROM_address = ARADDR[13:2];
				end else begin
					ARREADY = 1'b0;
					ROM_address = 12'd0;
				end
			end
			R:begin
				ROM_enable = 1'b1;
				ROM_read = 1'b1;
				ARREADY = 1'b0;
				RRESP = 2'd0;
				RVALID = 1'b1;
				ROM_address = current_AXI_Req.addr[13:2];
				RDATA = ROM_out;
				RID = current_AXI_Req.ID;
				RLAST = (current_count == current_AXI_Req.len + 4'd1);
			end
		endcase
	end
endmodule