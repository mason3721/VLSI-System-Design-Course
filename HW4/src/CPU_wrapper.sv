`include "AXI_define.svh"
`include "L1C_data.sv"
`include "L1C_inst.sv"
`include "CPU.sv"

module CPU_wrapper (
    input                             ACLK,
    input                             ARESETn,
    
    //WRITE ADDRESS (DM)
    output logic [`AXI_ID_BITS-1:0]   AWID_M1,
    output logic [`AXI_ADDR_BITS-1:0] AWADDR_M1,
    output logic [`AXI_LEN_BITS-1:0]  AWLEN_M1,
    output logic [`AXI_SIZE_BITS-1:0] AWSIZE_M1,
    output logic [1:0]                AWBURST_M1,
    output logic                      AWVALID_M1,
    input                             AWREADY_M1,

    //WRITE DATA (DM)
    output logic [`AXI_DATA_BITS-1:0] WDATA_M1,
    output logic [`AXI_STRB_BITS-1:0] WSTRB_M1,
    output logic                      WLAST_M1,
    output logic                      WVALID_M1,
    input                             WREADY_M1,

    //WRITE RESPONSE (DM)
    input        [`AXI_ID_BITS-1:0]   BID_M1,
    input        [1:0]                BRESP_M1,
    input                             BVALID_M1,
    output logic                      BREADY_M1,

    //READ ADDRESS (IM)
    output logic [`AXI_ID_BITS-1:0]   ARID_M0,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_M0,
    output logic [`AXI_LEN_BITS-1:0]  ARLEN_M0,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M0,
    output logic [1:0]                ARBURST_M0,
    output logic                      ARVALID_M0,
    input                             ARREADY_M0,

    //READ DATA (IM)
    input [`AXI_ID_BITS-1:0]          RID_M0,
    input [`AXI_DATA_BITS-1:0]        RDATA_M0,
    input [1:0]                       RRESP_M0,
    input                             RLAST_M0,
    input                             RVALID_M0,
    output logic                      RREADY_M0,

    //READ ADDRESS (DM)
    output logic [`AXI_ID_BITS-1:0]   ARID_M1,
    output logic [`AXI_ADDR_BITS-1:0] ARADDR_M1,
    output logic [`AXI_LEN_BITS-1:0]  ARLEN_M1,
    output logic [`AXI_SIZE_BITS-1:0] ARSIZE_M1,
    output logic [1:0]                ARBURST_M1,
    output logic                      ARVALID_M1,
    input                             ARREADY_M1,

    //READ DATA (DM)
    input [`AXI_ID_BITS-1:0]          RID_M1,
    input [`AXI_DATA_BITS-1:0]        RDATA_M1,
    input [1:0]                       RRESP_M1,
    input                             RLAST_M1,
    input                             RVALID_M1,
    output logic                      RREADY_M1,

    //Interrupt
    input                             Interrupt_SCtrl,
	input                             WTO
);
    logic        core_req_I;
    logic        core_write_I;
    logic        core_wait_I;
    logic        I_wait;
    logic        I_req;
    logic        I_write;

    logic [31:0] I_addr;
    logic [31:0] core_addr_I;
    logic [31:0] core_in_I;
    logic [31:0] core_out_I;
    logic [31:0] I_out;
    logic [31:0] I_in;

    logic        core_req_D;
    logic        core_write_D;
    logic        core_wait_D;
    logic        D_wait;
    logic        D_req;
    logic        D_write;

    logic [31:0] D_addr;
    logic [31:0] core_addr_D;
    logic [31:0] core_in_D;
    logic [31:0] core_out_D;
    logic [31:0] D_out;
    logic [31:0] D_in;

    logic [2:0]  core_type_I;
    logic [2:0]  core_type_D;
    logic [2:0]  I_type, D_type;

    logic [31:0] A_IM;
    logic [31:0] DO_IM;
    logic [3:0]  WEB_DM;
    logic [31:0] A_DM;
    logic [31:0] DI_DM;
    logic [31:0] DO_DM;
    logic        DataRead;
    logic        DataWrite;

    CPU CPU(
        .clk             (ACLK     ),
        .rst             (~ARESETn ),
        .A_IM            (A_IM     ),
        .DO_IM           (DO_IM    ),
        .WEB_DM          (WEB_DM   ),
        .A_DM            (A_DM     ),
        .DI_DM           (DI_DM    ),
        .DO_DM           (DO_DM    ),
        .DM_Read         (DataRead  ),
        .DM_Write        (DataWrite ),
        .DM_Funct3       (core_type_D),
        .IM_Stall        (core_wait_I ), 
        .DM_Stall        (core_wait_D ), 
        .Interrupt_SCtrl (Interrupt_SCtrl),
        .WTO             (WTO)
    );

    //Cache_inst
    L1C_inst L1C_inst(
        .clk        (ACLK       ),
        .rst        (~ARESETn   ),
        .core_addr  (core_addr_I),
        .core_req   (core_req_I ),
        .core_write (1'b0),
        .core_in    (32'd0  ),
        .core_type  (`CACHE_WORD),
        .I_out      (I_out      ),
        .I_wait     (I_wait     ),
        .core_out   (core_out_I ),
        .core_wait  (core_wait_I),
        .I_req      (I_req      ),
        .I_addr     (I_addr     )
    );

    //Cache_data
    L1C_data L1C_data(
        .clk        (ACLK       ),
        .rst        (~ARESETn   ),
        .core_addr  (core_addr_D),
        .core_req   (core_req_D ),
        .core_write (core_write_D),
        .core_in    (core_in_D  ),
        .core_type  (core_type_D),
        .D_out      (D_out      ),
        .D_wait     (D_wait     ),
        .core_out   (core_out_D ),
        .core_wait  (core_wait_D),
        .D_req      (D_req      ),
        .D_addr     (D_addr     ),
        .D_write    (D_write    ),
        .D_in       (D_in       ),
        .D_type     (D_type     )
    );

    //IM Wrapper
    enum logic [1:0] {IM_rst, IM_IDLE, IM_READ} IM_current_state, IM_next_state;
    logic [31:0] DO_IM_reg;
    logic [31:0] A_IM_reg;
    logic IM_Stall;

    //Sequential Circuit
    always_ff @(posedge ACLK) begin
        priority if (!ARESETn) begin
            IM_current_state <= IM_rst;
            DO_IM_reg <= 32'd0;
            A_IM_reg <= 32'd0;
        end else begin
            IM_current_state <= IM_next_state;
            DO_IM_reg <= (RREADY_M0 && RVALID_M0) ? RDATA_M0 : DO_IM_reg;  
            A_IM_reg <= A_IM;      
        end
    end

    //next_state: Combinational Circuit
    always_comb begin
        unique case (IM_current_state)
            IM_rst:
            begin
                IM_next_state = IM_IDLE;
            end
            IM_IDLE:
            begin
                unique if (ARVALID_M0 && ARREADY_M0) begin
                    IM_next_state = IM_READ;
                end else begin
                    IM_next_state = IM_IDLE;
                end
            end
            IM_READ:
            begin
                unique if (RVALID_M0 && RREADY_M0) begin
                    IM_next_state = IM_IDLE; 
                end else begin
                    IM_next_state = IM_READ;
                end
            end
            default:
            begin
                IM_next_state = IM_rst;
            end
        endcase
    end

    //output: Combinational Circuit
    always_comb begin
        unique case (IM_current_state)
            IM_rst:
            begin
                ARID_M0 = 4'd0;
                ARADDR_M0 = 32'd0;
                ARLEN_M0 = 4'd0;
                ARSIZE_M0 = `AXI_SIZE_WORD;
                ARBURST_M0 = `AXI_BURST_INC;
                ARVALID_M0 = 1'b0;

                RREADY_M0 = 1'b0;

                I_wait = 1'b1;
                I_out = 32'd0;
            end
            IM_IDLE:
            begin
                ARID_M0 = 4'd0;
                ARLEN_M0 = 4'd0;
                ARSIZE_M0 = `AXI_SIZE_WORD;
                ARBURST_M0 = `AXI_BURST_INC;
                ARVALID_M0 = I_req;
                ARADDR_M0 = I_addr;

                RREADY_M0 = 1'b0;

                I_wait = I_req;
                I_out = DO_IM_reg;
            end
            IM_READ:
            begin
                ARID_M0 = 4'd0;
                ARADDR_M0 = 32'd0;
                ARLEN_M0 = 4'd0;
                ARSIZE_M0 = `AXI_SIZE_WORD;
                ARBURST_M0 = `AXI_BURST_INC;
                ARVALID_M0 = 1'b0;

                RREADY_M0 = (RRESP_M0 == `AXI_RESP_DECERR) ? 1'b0 : RVALID_M0;

                I_wait = ~RVALID_M0;
                I_out = RDATA_M0;
            end
            default:
            begin
                ARID_M0 = 4'd0;
                ARADDR_M0 = 32'd0;
                ARLEN_M0 = 4'd0;
                ARSIZE_M0 = `AXI_SIZE_WORD;
                ARBURST_M0 = `AXI_BURST_INC;
                ARVALID_M0 = 1'b0;

                RREADY_M0 = 1'b0;

                I_wait = 1'b0;
                I_out = 32'd0;
            end
        endcase
    end

    //DM Wrapper
    enum logic [2:0] {DM_rst, DM_IDLE, DM_READ, DM_WRITE, DM_BACK} DM_current_state, DM_next_state;
    logic [31:0] DO_DM_Hold;

    //Sequential Circuit
    always_ff @(posedge ACLK) begin
        priority if (!ARESETn) begin
            DM_current_state <= DM_rst;
            DO_DM_Hold <= 32'd0;
        end else begin
            DM_current_state <= DM_next_state;
            DO_DM_Hold <= (RVALID_M1 && RREADY_M1) ? RDATA_M1 : DO_DM_Hold;
        end
    end

    //next_state: Combinational Circuit
    always_comb begin
        unique case (DM_current_state)
            DM_rst:
            begin
                DM_next_state = DM_IDLE;
            end
            DM_IDLE:
            begin
                unique if (ARREADY_M1 && ARVALID_M1) begin
                    DM_next_state = DM_READ;
                end else if (AWREADY_M1 && AWVALID_M1) begin
                    DM_next_state = DM_WRITE;
                end else begin
                    DM_next_state = DM_IDLE;
                end
            end
            DM_READ:
            begin
                unique if (RVALID_M1 && RREADY_M1) begin
                    DM_next_state = DM_IDLE; 
                end else begin
                    DM_next_state = DM_READ;
                end
            end
            DM_WRITE:
            begin
                unique if (WVALID_M1 && WREADY_M1) begin
                    DM_next_state = DM_BACK;
                end else begin
                    DM_next_state = DM_WRITE;
                end
            end
            DM_BACK:
            begin
                unique if (BVALID_M1 && BREADY_M1) begin
                    DM_next_state = DM_IDLE;
                end else begin
                    DM_next_state = DM_BACK;
                end
            end
            default:
            begin
                DM_next_state = DM_rst;
            end
        endcase
    end

    //output: Combinational Circuit
    always_comb begin
        unique case (DM_current_state)
            DM_rst:
            begin
                ARID_M1 = 4'd0;
                ARADDR_M1 = 32'd0;
                ARLEN_M1 = 4'd0;
                ARSIZE_M1 = `AXI_SIZE_WORD;
                ARBURST_M1 = `AXI_BURST_INC;
                ARVALID_M1 = 1'b0;

                RREADY_M1 = 1'b0;

                AWID_M1 = 4'd0;
                AWLEN_M1 = 4'd0;
                AWADDR_M1 = 32'd0;
                AWLEN_M1 = 4'd0;
                AWSIZE_M1 = `AXI_SIZE_WORD;
                AWBURST_M1 = `AXI_BURST_INC;
                AWVALID_M1 = 1'b0;

                WDATA_M1 = 32'd0;
                WSTRB_M1 = 4'b1111;
                WLAST_M1 = 1'b0;
                WVALID_M1 = 1'b0;

                BREADY_M1 = 1'b0;

                D_wait = 1'b0;
                D_out = 32'd0;
            end
            DM_IDLE:
            begin
                ARVALID_M1 = ( D_req & ~D_write); //only cache do
                ARADDR_M1 = D_addr; 
                ARID_M1 = 4'd0;
                ARLEN_M1 = 4'd0;
                ARSIZE_M1 = `AXI_SIZE_WORD;
                ARBURST_M1 = `AXI_BURST_INC;

                RREADY_M1 = 1'b0;

                AWVALID_M1 = (D_req & D_write); //only cache do
                AWADDR_M1 = D_addr;
                AWID_M1 = 4'd0;
                AWLEN_M1 = 4'd0;
                AWLEN_M1 = 4'd0;
                AWSIZE_M1 = `AXI_SIZE_WORD;
                AWBURST_M1 = `AXI_BURST_INC;

                WDATA_M1 = 32'd0;
                WSTRB_M1 = 4'b1111;
                WLAST_M1 = 1'b0;
                WVALID_M1 = 1'b0;

                BREADY_M1 = 1'b0;

                D_wait = (ARVALID_M1 || AWVALID_M1);
                D_out = DO_DM_Hold;
            end
            DM_READ:
            begin
                ARID_M1 = 4'd0;
                ARADDR_M1 = 32'd0;
                ARLEN_M1 = 4'd0;
                ARSIZE_M1 = `AXI_SIZE_WORD;
                ARBURST_M1 = `AXI_BURST_INC;
                ARVALID_M1 = 1'b0;

                RREADY_M1 = (RRESP_M1 == `AXI_RESP_DECERR) ? 1'b0 : RVALID_M1;

                AWID_M1 = 4'd0;
                AWLEN_M1 = 4'd0;
                AWADDR_M1 = 32'd0;
                AWLEN_M1 = 4'd0;
                AWSIZE_M1 = `AXI_SIZE_WORD;
                AWBURST_M1 = `AXI_BURST_INC;
                AWVALID_M1 = 1'b0; 

                WDATA_M1 = 32'd0;
                WSTRB_M1 = 4'b1111;
                WLAST_M1 = 1'b0;
                WVALID_M1 = 1'b0;

                BREADY_M1 = 1'b0;

                D_wait = ~RVALID_M1;
                D_out = RDATA_M1;
            end
            DM_WRITE:
            begin
                ARID_M1 = 4'd0;
                ARADDR_M1 = 32'd0;
                ARLEN_M1 = 4'd0;
                ARSIZE_M1 = `AXI_SIZE_WORD;
                ARBURST_M1 = `AXI_BURST_INC;
                ARVALID_M1 = 1'b0;
                
                RREADY_M1 = 1'b0;

                AWID_M1 = 4'd0;
                AWLEN_M1 = 4'd0;
                AWADDR_M1 = 32'd0;
                AWLEN_M1 = 4'd0;
                AWSIZE_M1 = `AXI_SIZE_WORD;
                AWBURST_M1 = `AXI_BURST_INC;
                AWVALID_M1 = 1'b0;

                WDATA_M1 = D_in;
                WSTRB_M1 = WEB_DM;
                WLAST_M1 = 1'b1;
                WVALID_M1 = 1'b1;

                BREADY_M1 = 1'b0;

                D_wait = 1'b1;
                D_out = 32'd0;
            end
            DM_BACK:begin
                ARID_M1 = 4'd0;
                ARADDR_M1 = 32'd0;
                ARLEN_M1 = 4'd0;
                ARSIZE_M1 = `AXI_SIZE_WORD;
                ARBURST_M1 = `AXI_BURST_INC;
                ARVALID_M1 = 1'b0;

                RREADY_M1 = 1'b0;

                AWID_M1 = 4'd0;
                AWLEN_M1 = 4'd0;
                AWADDR_M1 = 32'd0;
                AWLEN_M1 = 4'd0;
                AWSIZE_M1 = `AXI_SIZE_WORD;
                AWBURST_M1 = `AXI_BURST_INC;
                AWVALID_M1 = 1'b0;

                WDATA_M1 = 32'd0;
                WSTRB_M1 = 4'b1111;
                WLAST_M1 = 1'b0;
                WVALID_M1 = 1'b0;

                BREADY_M1 = (BRESP_M1 == `AXI_RESP_DECERR) ? 1'b0 : BVALID_M1;

                D_wait = ~BVALID_M1;
                D_out = 32'd0;
            end
            default:
            begin
                ARID_M1 = 4'd0;
                ARADDR_M1 = 32'd0;
                ARLEN_M1 = 4'd0;
                ARSIZE_M1 = `AXI_SIZE_WORD;
                ARBURST_M1 = `AXI_BURST_INC;
                ARVALID_M1 = 1'b0;

                RREADY_M1 = 1'b0;

                AWID_M1 = 4'd0;
                AWLEN_M1 = 4'd0;
                AWADDR_M1 = 32'd0;
                AWLEN_M1 = 4'd0;
                AWSIZE_M1 = `AXI_SIZE_WORD;
                AWBURST_M1 = `AXI_BURST_INC;
                AWVALID_M1 = 1'b0;

                WDATA_M1 = 32'd0;
                WSTRB_M1 = 4'b1111;
                WLAST_M1 = 1'b0;
                WVALID_M1 = 1'b0;

                BREADY_M1 = 1'b0;

                D_wait = 1'b0;
                D_out = 32'd0;
            end
        endcase
    end

    always_comb begin
    //IM
        core_addr_I = A_IM;
        DO_IM = core_out_I;
        unique if (A_IM_reg != A_IM) begin
            core_req_I = 1'b1;
        end else begin
            core_req_I = 1'b0;
        end
    //DM
        core_addr_D = A_DM;
        core_in_D = DI_DM;
        DO_DM = core_out_D;
        core_req_D = (DataRead | DataWrite); 
        core_write_D = DataWrite;
    end
endmodule