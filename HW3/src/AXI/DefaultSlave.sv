//================================================
// Auther:      Lin Meng-Yu            
// Filename:    DefaultSlave.sv                            
// Description: DefaultSlave module                   
// Version:     HW3 Submit version 
// Date:		2023/11/23
//================================================

`include "AXI_define.svh"

module DefaultSlave(
    input  ACLK,
	input  ARESETn,

	input  [`AXI_IDS_BITS-1:0] AWID_SD,
	input  AWVALID_SD,
	output logic AWREADY_SD,
	
	input  WLAST_SD,
	input  WVALID_SD,
	output logic WREADY_SD,
	
	output logic [`AXI_IDS_BITS-1:0] BID_SD,
	output logic [1:0] BRESP_SD,
	output logic BVALID_SD,
	input  BREADY_SD,
	
	input  [`AXI_IDS_BITS-1:0] ARID_SD,
    input  [3:0] ARLEN_SD,
	input  ARVALID_SD,
	output logic ARREADY_SD,
	
	output logic [`AXI_IDS_BITS-1:0] RID_SD,
	output logic [`AXI_DATA_BITS-1:0] RDATA_SD,
	output logic [1:0] RRESP_SD,
	output logic RLAST_SD,
	output logic RVALID_SD,
	input  RREADY_SD
);

enum logic[1:0] { IDLE, READ, WRITE, BACK } C_RState, N_RState, C_WState, N_WState;
logic [`AXI_IDS_BITS-1:0] C_ARID, N_ARID, C_AWID, N_AWID;
logic [3:0] C_WCnt, N_WCnt;
logic [3:0] C_RCnt, N_RCnt;
logic [3:0] C_RLength, N_RLength;

//Read

always_ff @(posedge ACLK) begin
    if (!ARESETn) begin
        C_RState <= IDLE;
        C_ARID <= 8'd0;
        C_RCnt <= 4'd0;
        C_RLength <= 4'd0;
    end
    else begin
        C_RState <= N_RState;
        C_ARID <= N_ARID;
        C_RCnt <= N_RCnt;
        C_RLength <= N_RLength;
    end
end

always_comb begin
    case (C_RState)
        IDLE:begin
            if (ARVALID_SD) begin
                N_RState = READ;
                N_ARID = ARID_SD;
                N_RCnt = 4'd1;
                N_RLength = ARLEN_SD;
            end
			else begin
				N_RState = C_RState;
				N_ARID = C_ARID;
				N_RCnt = C_RCnt;
				N_RLength = C_RLength;
			end
        end
        READ:begin
			N_ARID = C_ARID;
			N_RLength = C_RLength;
			
            if (RREADY_SD) begin
                N_RState = IDLE;
                N_RCnt = C_RCnt + 4'd1;
            end
			else begin
				N_RState = C_RState;
				N_RCnt = C_RCnt;
			end
        end
		default:begin
			N_RState = C_RState;
			N_ARID = C_ARID;
			N_RCnt = C_RCnt;
			N_RLength = C_RLength;
		end
    endcase
end

always_comb begin
    case (C_RState)
		IDLE:begin
			RID_SD = 8'd0;
			RDATA_SD =32'd0;
			RRESP_SD =2'h0;
			RLAST_SD =1'd0;
			RVALID_SD =1'd0;
			ARREADY_SD = 1'b1;
		end
		READ:begin
			ARREADY_SD=1'd0;
			RDATA_SD =32'd0;
			RID_SD = C_ARID;
			RRESP_SD =2'h2;
			RLAST_SD = (C_RCnt == C_RLength + 4'd1);
			RVALID_SD = 1'b1;
		end
		default:begin
			ARREADY_SD=1'd0;
			RID_SD = 8'd0;
			RDATA_SD =32'd0;
			RRESP_SD =2'h0;
			RLAST_SD =1'd0;
			RVALID_SD =1'd0;
		end
    endcase
end

always_ff @(posedge ACLK) begin
    if (!ARESETn) begin
        C_WState <= IDLE;
        C_AWID <= 8'd0;
        C_WCnt <= 4'd0;
    end
    else begin
        C_WState <= N_WState;
        C_AWID <= N_AWID;
        C_WCnt <= N_WCnt;
    end
end

always_comb begin


    case (C_WState)
        IDLE:begin
            if (AWVALID_SD) begin
                N_WState = WRITE;
                N_AWID = AWID_SD;
                N_WCnt = 4'd1;
			end
			else begin
			    N_WState = C_WState;
				N_AWID = C_AWID;
				N_WCnt = C_WCnt;
			end
        end
        WRITE:begin
            if (WVALID_SD) begin
				N_WCnt = C_WCnt + 4'd1;
				N_AWID = C_AWID;
                if (WLAST_SD) begin
                    N_WState = BACK;
                end
				else begin
					N_WState = C_WState;
				end
			end
             else begin
				N_WState = C_WState;
				N_AWID = C_AWID;
				N_WCnt = C_WCnt;
            end
        end
        BACK:begin
			N_AWID = C_AWID;
			N_WCnt = C_WCnt;
	
            if (BREADY_SD) begin
                N_WState = IDLE;
			end
			else begin
				N_WState = BACK;
			
            end
        end
		default: begin
			N_WState = C_WState;
			N_AWID = C_AWID;
			N_WCnt = C_WCnt;
		end
    endcase

end

always_comb begin
    case (C_WState)
		IDLE:begin
			WREADY_SD = 1'd0;
			BID_SD = 8'd0;
			BRESP_SD = 2'h0;
			BVALID_SD = 1'd0;
			AWREADY_SD = 1'b1;
		end
		WRITE:begin
			AWREADY_SD = 1'd0;
			BID_SD = 8'd0;
			BRESP_SD = 2'h0;
			BVALID_SD = 1'd0;
			WREADY_SD = 1'b1;
		end

		BACK:begin
			AWREADY_SD = 1'd0;
			WREADY_SD = 1'd0;
			BID_SD = C_AWID;
			BRESP_SD = 2'h2;
			BVALID_SD = 1'b1;
		end
		default:begin
			WREADY_SD = 1'd0;
			BID_SD = 8'd0;
			BRESP_SD = 2'h0;
			BVALID_SD = 1'd0;
			AWREADY_SD = 1'b0;
		end
    endcase
end

endmodule
