//================================================
// Auther:      Lin Meng-Yu            
// Filename:    DRAM_wrapper.sv                            
// Description: DRAM Wrapper module                  
// Version:     HW3 Submit Version
// Date:        2023/11/23
//================================================


`include "AXI_define.svh"
module DRAM_wrapper (
    input                             ACLK        ,
    input                             ARESETn     ,

    // *******************  WRITE ADDRESS CHANNEL ****************** // 
  	input        [`AXI_IDS_BITS-1:0]  AWID        ,   
	input        [`AXI_ADDR_BITS-1:0] AWADDR      , 
	input        [`AXI_LEN_BITS-1:0]  AWLEN       ,  
	input        [`AXI_SIZE_BITS-1:0] AWSIZE      , 
	input        [1:0]                AWBURST     ,
	input                             AWVALID     ,

    output logic                      AWREADY     ,

    // **********************  WRITE DATA CHANNEL ****************** //
    input        [`AXI_DATA_BITS-1:0] WDATA       , 
	input        [`AXI_STRB_BITS-1:0] WSTRB       ,
	input                             WLAST       ,
	input                             WVALID      ,

    output logic                      WREADY      ,

    // *******************  WRITE RESPONSE CHANNEL ***************** //
    output logic [`AXI_IDS_BITS-1:0]  BID         , 
	output logic [1:0]                BRESP       ,
	output logic                      BVALID      ,

    input                             BREADY      ,

    // *******************  READ ADDRESS CHANNEL ****************** // 
    input        [`AXI_IDS_BITS-1:0]  ARID        ,   
	input        [`AXI_ADDR_BITS-1:0] ARADDR      , 
	input        [`AXI_LEN_BITS-1:0]  ARLEN       ,  
	input        [`AXI_SIZE_BITS-1:0] ARSIZE      , 
	input        [1:0]                ARBURST     ,
	input                             ARVALID     ,
    output logic                      ARREADY     ,

    // *******************  READ DATA CHANNEL ********************* //
    output logic [`AXI_IDS_BITS-1:0]  RID         ,   
	output logic [`AXI_DATA_BITS-1:0] RDATA       , 
	output logic [1:0]                RRESP       ,
	output logic                      RLAST       ,
	output logic                      RVALID      ,

    input                             RREADY      ,
    
    // *********************** DRAM Signal *********************** //
    input        [31:0]               DRAM_Q      ,
    input                             DRAM_VALID  ,      
    output logic                      DRAM_CSn    ,
    output logic [3:0]                DRAM_WEn    ,
    output logic                      DRAM_RASn   ,
    output logic                      DRAM_CASn   ,
    output logic [10:0]               DRAM_A      ,
    output logic [31:0]               DRAM_D
);

    // ---------------------- State Parameters ------------------- //
    parameter[3:0]  IDLE        = 4'd0      ,
	                AR          = 4'd1      ,
	                R_PRE       = 4'd2      ,
                    R_ROW       = 4'd3      ,
                    R_COL       = 4'd4      ,
	                AW          = 4'd5      ,
	                W_PRE       = 4'd6      ,
                    W_ROW       = 4'd7      ,
                    W_COL       = 4'd8      ,
	                B           = 4'd9      ;
 
    logic [3:0]  current_state  ;
	logic [3:0]  next_state     ;

    logic [2:0]  DRAM_state_cnt ;
    logic [31:0] addr_temp      ;
    logic [10:0] row_temp       ;
    logic [7:0]  AWID_temp      ;
    logic [7:0]  ARID_temp      ;

	// ----------------- Sequential  ------------------ //

    always_ff @(posedge ACLK) begin
		if (~ARESETn) begin
			DRAM_state_cnt <= 3'd0;
        end
        else if ((DRAM_state_cnt != 3'd5) && (current_state == R_COL)) begin 
            DRAM_state_cnt <= DRAM_state_cnt + 3'd1;
		end
        else if ((DRAM_state_cnt == 3'd5) || (DRAM_state_cnt == 3'd4) || (current_state == IDLE) || (current_state == AR) || (current_state == AW) || (current_state == B)) begin
			DRAM_state_cnt <= 3'd0;
        end
        else begin
            DRAM_state_cnt <= DRAM_state_cnt + 3'd1;
        end
	end


    always_ff @(posedge ACLK) begin
		if (~ARESETn) begin
            addr_temp <= 32'd0;
            row_temp <= 11'd1;
            AWID_temp <= 8'd0;
            ARID_temp <= 8'd0;
		end
        else begin
            case (current_state)
                AR: begin
                    addr_temp <= ARADDR;
                    row_temp <= row_temp;
                    AWID_temp <= AWID_temp;
                    ARID_temp <= ARID;
                end

                R_COL: begin
                    addr_temp <= addr_temp;
                    row_temp <= addr_temp[22:12];
                    AWID_temp <= AWID_temp;
                    ARID_temp <= ARID_temp;
                end

                AW: begin
                    addr_temp <= AWADDR;
                    row_temp <= row_temp;
                    AWID_temp <= AWID;
                    ARID_temp <= ARID_temp;
                end

                W_COL: begin
                    addr_temp <= addr_temp;
                    row_temp <= addr_temp[22:12];
                    AWID_temp <= AWID_temp;
                    ARID_temp <= ARID_temp;
                end

                default: begin
                    addr_temp <= addr_temp;
                    row_temp <= row_temp;
                    AWID_temp <= AWID_temp;
                    ARID_temp <= ARID_temp;
                end
            endcase
		end
	end


    always_ff @(posedge ACLK) begin
		if (~ARESETn) begin
			current_state <= IDLE;
		end
        else begin
			current_state <= next_state;
		end
	end


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
                    if (ARADDR[22:12] == row_temp) begin
                        next_state = R_COL;
                    end 
                    else begin
                        next_state = R_PRE;
                    end  
				end 
                else begin
					next_state = AR;
				end
			end 
            R_PRE:
            begin
                if (DRAM_state_cnt == 3'd4) begin
                    next_state = R_ROW;
                end 
                else begin
                    next_state = R_PRE;
                end
            end
            R_ROW:
            begin
                if (DRAM_state_cnt == 3'd4) begin
                    next_state = R_COL;
                end 
                else begin
                    next_state = R_ROW;
                end
            end
            R_COL:
            begin
                if (RREADY && RVALID && RLAST) begin
                    next_state = IDLE;
                end 
                else begin
                    next_state = R_COL;
                end
            end
            AW:
            begin
                if (AWVALID && AWREADY) begin
					if (AWADDR[22:12] == row_temp) begin
                        next_state = W_COL;
                    end 
                    else begin
                        next_state = W_PRE;
                    end 
				end else begin
					next_state = AW;
				end
            end
            W_PRE:
            begin
                if (DRAM_state_cnt == 3'd4) begin
                    next_state = W_ROW;
                end 
                else begin
                    next_state = W_PRE;
                end
            end
            W_ROW:
            begin
                if (DRAM_state_cnt == 3'd4) begin
                    next_state = W_COL;
                end 
                else begin
                    next_state = W_ROW;
                end
            end
            W_COL:
            begin
                if (WVALID && WREADY && WLAST) begin
                    next_state = B;
                end 
                else begin
                    next_state = W_COL;
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

	// ----------------- Output Combinational Logic ------------------ //
   // ******** Constant Outputs  ******** //
    assign BRESP = 2'd0;
    assign RRESP = 2'd0;
    assign DRAM_CSn = 1'b0; 

    // ******** Control Outputs  ******** //
    always_comb begin
         unique case (current_state)
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

                DRAM_WEn = 4'b1111;
                DRAM_RASn = 1'b1;
                DRAM_CASn = 1'b1;
                DRAM_A = 11'd0;
                DRAM_D = 32'd0;
			end
			AR: 
			begin
                AWREADY = 1'b0;
                WREADY = 1'b0;
                BID = 8'd0;
                BVALID = 1'b0;
                ARREADY = 1'b1;
                RID = 8'd0;
                RDATA = 32'd0;
                RLAST = 1'b0;
                RVALID = 1'b0;

                DRAM_WEn = 4'b1111;
                DRAM_RASn = 1'b1;
                DRAM_CASn = 1'b1;
                DRAM_A = 11'd0;
                DRAM_D = 32'd0;
			end 
            R_PRE:
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

                if (DRAM_state_cnt == 3'd0) begin
                    DRAM_WEn = 4'b0000;
                    DRAM_RASn = 1'b0;
                end
                else begin
                    DRAM_WEn = 4'b1111;
                    DRAM_RASn = 1'b1;
                end
                DRAM_CASn = 1'b1;
                DRAM_A = (row_temp == 11'd1) ? 11'd0 : row_temp;
                DRAM_D = 32'd0;
            end
            R_ROW:
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

                if (DRAM_state_cnt == 3'd0) begin
                    DRAM_RASn = 1'b0;
                end
                else begin
                    DRAM_RASn = 1'b1;
                end
                DRAM_WEn = 4'b1111;
                DRAM_CASn = 1'b1;
                DRAM_A = addr_temp[22:12];
                DRAM_D = 32'd0;
            end
            R_COL:
            begin
                AWREADY = 1'b0;
                WREADY = 1'b0;
                BID = 8'd0;
                BVALID = 1'b0;
                ARREADY = 1'b0;
                RID = ARID_temp;
                RDATA = DRAM_Q;
                if (DRAM_state_cnt == 3'd5) begin
                    RLAST = 1'b1;
                    RVALID = DRAM_VALID;
                end
                 else begin
                    RLAST = 1'b0;
                    RVALID = 1'b0;
                end

                if (DRAM_state_cnt == 3'd0) begin
                    DRAM_CASn = 1'b0;
                end
                 else begin
                    DRAM_CASn = 1'b1;
                end
                DRAM_WEn = 4'b1111;
                DRAM_RASn = 1'b1;
                DRAM_A = {1'b0, addr_temp[11:2]};
                DRAM_D = 32'd0;
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

                DRAM_WEn = 4'b1111;
                DRAM_RASn = 1'b1;
                DRAM_CASn = 1'b1;
                DRAM_A = 11'd0;
                DRAM_D = 32'd0;
            end
            W_PRE:
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

                unique if (DRAM_state_cnt == 3'd0) begin
                    DRAM_WEn = 4'b0000;
                    DRAM_RASn = 1'b0;
                end else begin
                    DRAM_WEn = 4'b1111;
                    DRAM_RASn = 1'b1;
                end
                DRAM_CASn = 1'b1;
                DRAM_A = (row_temp == 11'd1) ? 11'd0 : row_temp;
                DRAM_D = 32'd0;
            end
            W_ROW:
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

                if (DRAM_state_cnt == 3'd0) begin
                    DRAM_RASn = 1'b0;
                end
                else begin
                    DRAM_RASn = 1'b1;
                end
                DRAM_WEn = 4'b1111;
                DRAM_CASn = 1'b1;
                DRAM_A = addr_temp[22:12];
                DRAM_D = 32'd0;
            end
            W_COL:
            begin
                AWREADY = 1'b0;
                if (DRAM_state_cnt == 3'd4) begin
                    WREADY = 1'b1;
                end
                else begin
                    WREADY = 1'b0;
                end
                BID = 8'd0;
                BVALID = 1'b0;
                ARREADY = 1'b0;
                RID = 8'd0;
                RDATA = 32'd0;
                RLAST = 1'b0;
                RVALID = 1'b0;

                if (DRAM_state_cnt == 3'd0) begin
                    DRAM_WEn = WSTRB;
                    DRAM_CASn = 1'b0;
                end
                else begin
                    DRAM_WEn = 4'b1111;
                    DRAM_CASn = 1'b1;
                end
                DRAM_RASn = 1'b1;
                DRAM_A = {1'b0, addr_temp[11:2]};
                if (DRAM_state_cnt == 3'd4) begin
                    DRAM_D = WDATA;
                end
                else begin
                    DRAM_D = 32'd0;
                end
            end
            B:
            begin
                AWREADY = 1'b0;
                WREADY = 1'b0;
                BID = AWID_temp;
                BVALID = 1'b1;
                ARREADY = 1'b0;
                RID = 8'd0;
                RDATA = 32'd0;
                RLAST = 1'b0;
                RVALID = 1'b0;

                DRAM_WEn = 4'b1111;
                DRAM_RASn = 1'b1;
                DRAM_CASn = 1'b1;
                DRAM_A = 11'd0;
                DRAM_D = 32'd0;
            end
            default:
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

                DRAM_WEn = 4'b1111;
                DRAM_RASn = 1'b1;
                DRAM_CASn = 1'b1;
                DRAM_A = 11'd0;
                DRAM_D = 32'd0;
			end 
        endcase
    end
endmodule
