`include "AXI_define.svh"

module DRAM_wrapper(
    input                             ACLK,
    input                             ARESETn,
    // AR channel
    input        [`AXI_IDS_BITS -1:0] ARID,
    input        [`AXI_ADDR_BITS-1:0] ARADDR,
    input        [`AXI_LEN_BITS -1:0] ARLEN,
    input        [`AXI_SIZE_BITS-1:0] ARSIZE,
    input        [1:0]                ARBURST,
    input                             ARVALID,
    output logic                      ARREADY,
    // R channel
    output logic [`AXI_IDS_BITS -1:0] RID,
    output logic [`AXI_DATA_BITS-1:0] RDATA,
    output logic [1:0]                RRESP,
    output logic                      RLAST,
    output logic                      RVALID,
    input                             RREADY,

    // AW channel
    input        [`AXI_IDS_BITS -1:0] AWID,
    input        [`AXI_ADDR_BITS-1:0] AWADDR,
    input        [`AXI_LEN_BITS -1:0] AWLEN,
    input        [`AXI_SIZE_BITS-1:0] AWSIZE,
    input        [1:0]                AWBURST,
    input                             AWVALID,
    output logic                      AWREADY,
    // W channel
    input        [`AXI_DATA_BITS-1:0] WDATA,
    input        [`AXI_STRB_BITS-1:0] WSTRB,
    input                             WLAST,
    input                             WVALID,
    output logic                      WREADY,
    // B channel
    output logic [`AXI_IDS_BITS -1:0] BID,
    output logic [1:0]                BRESP,
    output logic                      BVALID,
    input                             BREADY,
    
    //DRAM top
    output logic                      DRAM_CSn,
    output logic [3:0]                DRAM_WEn,
    output logic                      DRAM_RASn,
    output logic                      DRAM_CASn,
    output logic [10:0]               DRAM_A,
    output logic [31:0]               DRAM_D,
    input        [31:0]               DRAM_Q,
    input                             DRAM_VALID
);
    //AXI interface
    typedef struct packed {
            logic [`AXI_IDS_BITS-1:0]  id;
            logic [`AXI_ADDR_BITS-1:0] addr;
            logic [`AXI_LEN_BITS-1:0]  len;
            logic [`AXI_SIZE_BITS-1:0] size;
            logic [1:0]                burst;
        } AXI_REQ_T;

    //AXI state
    enum logic [1:0] {AXI_IDLE, AXI_READ, AXI_WRITE, AXI_BACK} current_AXI_State, next_AXI_State;
    AXI_REQ_T current_AXI_Req, next_AXI_Req;
    logic [3:0] current_count, next_count;
    logic [31:0] DO_Hold;

    //AXI-DRAM Bridge
    logic readDone;
    logic writeDone;
    logic backDone;

    //Sequential Circuit
    always_ff @(posedge ACLK) begin
        priority if (!ARESETn) begin
            current_AXI_State <= AXI_IDLE;
            current_AXI_Req <= 49'd0;
            current_count <= 4'd0;
            DO_Hold <= 32'd0;
        end else begin
            current_AXI_State <= next_AXI_State;
            current_AXI_Req <= next_AXI_Req;
            current_count <= next_count;
            DO_Hold <= (RREADY && RVALID) ? DRAM_Q :DO_Hold;
        end
    end

    //next_state: Combinational Circuit
    always_comb begin
        next_AXI_State = current_AXI_State;
        next_AXI_Req = current_AXI_Req;
        next_count = current_count;

        case (current_AXI_State)
            AXI_IDLE:
            begin
                if (AWVALID) begin //wait write
                    next_AXI_Req = {AWID, AWADDR, AWLEN, AWSIZE, AWBURST};
                    next_AXI_State = AXI_WRITE;
                    next_count = 4'd1;
                end else if (ARVALID) begin //wait read
                    next_AXI_Req = {ARID, ARADDR, ARLEN, ARSIZE, ARBURST};
                    next_AXI_State = AXI_READ;
                    next_count = 4'd1;
                end
            end
            AXI_READ:
            begin
                if (RVALID && RREADY) begin
                    next_AXI_Req.addr = current_AXI_Req.addr + 32'd4;
                    next_count = current_count + 4'd1;
                    next_AXI_State = AXI_IDLE;
                end
            end
            AXI_WRITE:
            begin
                if (WVALID & WREADY) begin
                    if (WLAST) begin
                        next_AXI_State = AXI_BACK;
                    end
                    next_AXI_Req.addr = current_AXI_Req.addr + 32'd4;
                    next_count = current_count + 4'd1;
                end
            end
            AXI_BACK:
            begin
                if (BVALID && BREADY) begin
                    next_AXI_State = AXI_IDLE;
                end
            end
        endcase
    end

    //output: Combinational Circuit
    always_comb begin
        AWREADY = 1'b0;
        ARREADY = 1'b0;
        WREADY = 1'b0;
        BID = 8'd0;
        BRESP = 2'd0;
        BVALID = 1'b0;
        RID = 8'd0;
        RDATA = 32'd0;
        RRESP = 2'd0;
        RLAST = 1'b0;
        RVALID = 1'b0;
        
        case (current_AXI_State)
            AXI_IDLE:
            begin
                RDATA = DO_Hold;
                if (AWVALID) begin
                    AWREADY = 1'b1;
                end else if (ARVALID) begin
                    ARREADY = 1'b1;
                end
            end
            AXI_READ:
            begin
                RVALID = readDone;
                RDATA = DRAM_Q;
                RID = current_AXI_Req.id;
                RLAST = (current_count == current_AXI_Req.len + 4'd1);
            end
            AXI_WRITE:
            begin
                WREADY = writeDone;
            end
            AXI_BACK:
            begin
                BVALID = backDone;
                BID = current_AXI_Req.id;
            end
        endcase
    end

    //DRAM state
    enum logic [5:0] {  IDLE
                      , R_PRE0, R_PRE1, R_PRE2, R_PRE3, R_PRE4
                      , R_ROW0, R_ROW1, R_ROW2, R_ROW3, R_ROW4
                      , R_COL0, R_COL1, R_COL2, R_COL3, R_COL4
                      , W_PRE0, W_PRE1, W_PRE2, W_PRE3, W_PRE4
                      , W_ROW0, W_ROW1, W_ROW2, W_ROW3, W_ROW4
                      , W_COL0, W_COL1, W_COL2, W_COL3, W_COL4
                      , W_BACK
                     } current_DRAM_State, next_DRAM_State;

    logic [31:0] current_Address_Hold, next_Address_Hold;
    logic [10:0] current_Row_Hold, next_Row_Hold;

    //Sequential Circuit
    always_ff @(posedge ACLK) begin
        if (!ARESETn) begin
            current_DRAM_State <= IDLE;
            current_Address_Hold <= 32'd0;
            current_Row_Hold <= 11'd1;
        end
        else begin
            current_DRAM_State <= next_DRAM_State;
            current_Address_Hold <= next_Address_Hold;
            current_Row_Hold <= next_Row_Hold;
        end
    end

    //next_state: Combinational Circuit
    always_comb begin
        next_DRAM_State = current_DRAM_State;
        next_Address_Hold = current_Address_Hold;
        next_Row_Hold = current_Row_Hold;

        case (current_DRAM_State)
            IDLE:
            begin
                if (ARVALID) begin
                    next_Address_Hold = ARADDR;
                    unique if (ARADDR[22:12] == current_Row_Hold) begin
                        next_DRAM_State = R_COL0;
                    end else begin
                        next_DRAM_State = R_PRE0;
                    end
                end else if (AWVALID) begin
                    next_Address_Hold = AWADDR;
                    unique if (AWADDR[22:12] == current_Row_Hold) begin
                        next_DRAM_State = W_COL0;
                    end else begin
                        next_DRAM_State = W_PRE0;
                    end
                end
            end

            R_PRE0: next_DRAM_State = R_PRE1;
            R_PRE1: next_DRAM_State = R_PRE2;
            R_PRE2: next_DRAM_State = R_PRE3;
            R_PRE3: next_DRAM_State = R_PRE4;
            R_PRE4: next_DRAM_State = R_ROW0;

            R_ROW0: next_DRAM_State = R_ROW1;
            R_ROW1: next_DRAM_State = R_ROW2;
            R_ROW2: next_DRAM_State = R_ROW3;
            R_ROW3: next_DRAM_State = R_ROW4;
            R_ROW4: next_DRAM_State = R_COL0;

            R_COL0: 
            begin 
                next_Row_Hold = current_Address_Hold[22:12];
                next_DRAM_State = R_COL1;
            end
            R_COL1: next_DRAM_State = R_COL2;
            R_COL2: next_DRAM_State = R_COL3;
            R_COL3: next_DRAM_State = R_COL4;
            R_COL4:
            begin
                if (RVALID & RREADY) begin
                    next_DRAM_State = IDLE;
                end
            end

            W_PRE0: next_DRAM_State = W_PRE1;
            W_PRE1: next_DRAM_State = W_PRE2;
            W_PRE2: next_DRAM_State = W_PRE3;
            W_PRE3: next_DRAM_State = W_PRE4;
            W_PRE4: next_DRAM_State = W_ROW0;

            W_ROW0: next_DRAM_State = W_ROW1;
            W_ROW1: next_DRAM_State = W_ROW2;
            W_ROW2: next_DRAM_State = W_ROW3;
            W_ROW3: next_DRAM_State = W_ROW4;
            W_ROW4: next_DRAM_State = W_COL0;

            W_COL0:
            begin
                next_Row_Hold = current_Address_Hold[22:12];
                next_DRAM_State = W_COL1;
            end
            W_COL1: next_DRAM_State = W_COL2;
            W_COL2: next_DRAM_State = W_COL3;
            W_COL3: next_DRAM_State = W_COL4;
            W_COL4: 
            begin
                if (WVALID & WREADY) begin
                    next_DRAM_State = W_BACK;
                end
            end

            W_BACK: begin
                if (BVALID & BREADY) begin
                    next_DRAM_State = IDLE;
                end
            end
        endcase
    end

    //output: Combinational Circuit
    always_comb begin
        DRAM_CSn = 1'b0;    //always on
        DRAM_WEn = 4'b1111;
        DRAM_RASn = 1'b1;
        DRAM_CASn = 1'b1;
        DRAM_A = 11'd0;
        DRAM_D = 32'd0;

        readDone = 1'b0;
        writeDone = 1'b0;
        backDone = 1'b0;

        case (current_DRAM_State)
            R_PRE0:
            begin
                DRAM_WEn = 4'b0000;
                DRAM_RASn = 1'b0;
                DRAM_A = (current_Row_Hold == 11'd1) ? 11'd0 : current_Row_Hold;
            end
            R_PRE1: DRAM_A = (current_Row_Hold == 11'd1) ? 11'd0 : current_Row_Hold;
            R_PRE2: DRAM_A = (current_Row_Hold == 11'd1) ? 11'd0 : current_Row_Hold;
            R_PRE3: DRAM_A = (current_Row_Hold == 11'd1) ? 11'd0 : current_Row_Hold;
            R_PRE4: DRAM_A = (current_Row_Hold == 11'd1) ? 11'd0 : current_Row_Hold;

            R_ROW0:
            begin
                DRAM_RASn = 1'b0;
                DRAM_A = current_Address_Hold[22:12];
            end
            R_ROW1: DRAM_A = current_Address_Hold[22:12];
            R_ROW2: DRAM_A = current_Address_Hold[22:12];
            R_ROW3: DRAM_A = current_Address_Hold[22:12];
            R_ROW4: DRAM_A = current_Address_Hold[22:12];

            R_COL0:
            begin
                DRAM_CASn = 1'b0;
                DRAM_A = {1'b0, current_Address_Hold[11:2]};
            end
            R_COL1: DRAM_A = {1'b0, current_Address_Hold[11:2]};
            R_COL2: DRAM_A = {1'b0, current_Address_Hold[11:2]};
            R_COL3: DRAM_A = {1'b0, current_Address_Hold[11:2]};
            R_COL4:
            begin
                DRAM_A = {1'b0, current_Address_Hold[11:2]};
                readDone = DRAM_VALID;
            end

            W_PRE0:
            begin
                DRAM_WEn = 4'b0000;
                DRAM_RASn = 1'b0;
                DRAM_A = (current_Row_Hold == 11'd1) ? 11'd0 : current_Row_Hold;
            end
            W_PRE1: DRAM_A = (current_Row_Hold == 11'd1) ? 11'd0 : current_Row_Hold;
            W_PRE2: DRAM_A = (current_Row_Hold == 11'd1) ? 11'd0 : current_Row_Hold;
            W_PRE3: DRAM_A = (current_Row_Hold == 11'd1) ? 11'd0 : current_Row_Hold;
            W_PRE4: DRAM_A = (current_Row_Hold == 11'd1) ? 11'd0 : current_Row_Hold;
            
            W_ROW0:
            begin
                DRAM_RASn = 1'b0;
                DRAM_A = current_Address_Hold[22:12];
            end
            W_ROW1: DRAM_A = current_Address_Hold[22:12];
            W_ROW2: DRAM_A = current_Address_Hold[22:12];
            W_ROW3: DRAM_A = current_Address_Hold[22:12];
            W_ROW4: DRAM_A = current_Address_Hold[22:12];

            W_COL0:
            begin
                DRAM_WEn = WSTRB;
                DRAM_CASn = 1'b0;
                DRAM_A = {1'b0, current_Address_Hold[11:2]};
            end
            W_COL1: DRAM_A = {1'b0, current_Address_Hold[11:2]};
            W_COL2: DRAM_A = {1'b0, current_Address_Hold[11:2]};
            W_COL3: DRAM_A = {1'b0, current_Address_Hold[11:2]};
            W_COL4: 
            begin 
                DRAM_A = {1'b0, current_Address_Hold[11:2]};
                DRAM_D = WDATA;
                if (WVALID) begin
                    writeDone = 1'b1;
                end else begin
                    writeDone = 1'b0;
                end
            end

            W_BACK:
            begin
                backDone = 1'b1;
            end
        endcase
    end
endmodule
