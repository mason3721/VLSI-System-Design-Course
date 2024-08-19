module CSR (
    input               clk,
    input               rst,
    input               AXI_Stall,
    input        [11:0] CSR_ReadAddress,
    input               CSR_RegWrite,
    input        [11:0] CSR_WriteAddress,
    input        [31:0] CSR_WriteData,          //CSR ALU_result

    input               Interrupt_SCtrl,
    input               WFI,
    input               MRET,
	
	input               WTO,
	
    input        [31:0] CSR_PC, //pc+4
    input               Instret,

    output logic [31:0] CSR_ReadData,
    output logic [31:0] CSR_mtvec,
    output logic [31:0] CSR_mepc,
    output logic        Interrupt_Confirm,
	output logic        Interrupt_Confirm_Timer
);
    localparam mstatus_addr   = 12'h300;
    localparam mie_addr       = 12'h304;
    localparam mtvec_addr     = 12'h305;
    localparam mepc_addr      = 12'h341;
    localparam mip_addr       = 12'h344;
    localparam mcycle_addr    = 12'hC00;
    localparam minstret_addr  = 12'hC02;
    localparam mcycleh_addr   = 12'hC80;
    localparam minstreth_addr = 12'hC82;

    logic [31:0] mstatus_reg;
    logic [31:0] mie_reg;
    logic [31:0] mtvec_reg;
    logic [31:0] mepc_reg;
    logic [31:0] mip_reg;
    logic [31:0] mcycle_reg;
    logic [31:0] minstret_reg;
    logic [31:0] mcycleh_reg;
    logic [31:0] minstreth_reg;

    assign CSR_mtvec = {mtvec_reg[31:2], 2'b00};
    assign CSR_mepc = mepc_reg;
    assign Interrupt_Confirm = (WFI & Interrupt_SCtrl & mie_reg[11]);   
    assign Interrupt_Confirm_Timer = (WTO & mie_reg[7]);

    //write CSR
    always_ff @(posedge clk) begin
        priority if (rst) begin
            mstatus_reg <= 32'd0;  //rst
            mie_reg <= 32'd0;
            mip_reg <= 32'd0;
            mtvec_reg <= 32'd0;
            mepc_reg <= 32'd0;
            mcycle_reg <= 32'd0;
            minstret_reg <= 32'd0;
            mcycleh_reg <= 32'd0;
            minstreth_reg <= 32'd0;
        end else if (Interrupt_Confirm_Timer) begin
            mstatus_reg <= 32'd0;  //rst
            mie_reg <= mie_reg;
            mip_reg <= 32'd0;
            mtvec_reg <= 32'd0;
            mepc_reg <= 32'd0;
            mcycle_reg <= 32'd0;
            minstret_reg <= 32'd0;
            mcycleh_reg <= 32'd0;
            minstreth_reg <= 32'd0;
        end else begin //mie[11] mie[7]
            priority if ((Interrupt_SCtrl & mie_reg[11]) || (WTO & mie_reg[7])) begin
                mstatus_reg <= {19'd0, 2'b11, 3'd0, mstatus_reg[3],3'd0, 1'b0, 3'd0};
            end else if (MRET) begin
                mstatus_reg <= {19'd0, 2'b11, 3'd0, 1'b1, 3'd0, mstatus_reg[7],3'd0};
            end else begin
                mstatus_reg <= mstatus_reg;
            end
            unique if (WTO) begin
                mie_reg <= {mie_reg[31:8], 1'd1, mie_reg[6:0]};  //set by CSR
            end else begin
                mie_reg <= mie_reg;
            end
            mip_reg <= {20'd0, (Interrupt_SCtrl & mie_reg[11]), 3'd0 ,(WTO & mie_reg[7]), 7'd0};  //11: EXTERNAL, 7: TIMER
            mtvec_reg <= 32'h0001_0000;
            unique if (Interrupt_Confirm) begin 
                mepc_reg <= CSR_PC; //interrupt mepc = pc+4
            end else begin
                mepc_reg <= mepc_reg;
            end         
            {mcycleh_reg, mcycle_reg} <= {mcycleh_reg, mcycle_reg} + 64'd1;  //cycle +1
            {minstreth_reg, minstret_reg} <= (Instret) ? {minstreth_reg, minstret_reg} + 64'd1 : {minstreth_reg, minstret_reg};   //instret+1 : instret
            
            if (CSR_RegWrite) begin
                case (CSR_WriteAddress)
                    mstatus_addr: mstatus_reg <= CSR_WriteData;
                    mtvec_addr: mtvec_reg <= CSR_WriteData;
                    mip_addr: mip_reg <= CSR_WriteData;
                    mie_addr: mie_reg <= CSR_WriteData;
                    mepc_addr: mepc_reg <= CSR_WriteData;
                    mcycle_addr: mcycle_reg <= CSR_WriteData;
                    minstret_addr: minstret_reg <= CSR_WriteData;
                    mcycleh_addr: mcycleh_reg <= CSR_WriteData;
                    minstreth_addr: minstreth_reg <= CSR_WriteData;	
                endcase
            end
        end
    end

    //read CSR
    always_ff @(posedge clk) begin
        priority if (rst) begin
            CSR_ReadData <= 32'd0;
        end else if (Interrupt_Confirm_Timer) begin
            CSR_ReadData <= 32'd0;
        end else if (!AXI_Stall) begin
            unique if (CSR_WriteAddress == CSR_ReadAddress) begin
                unique case (CSR_WriteAddress)
                    mstatus_addr: CSR_ReadData <= {19'd0, CSR_WriteData[12:11], 3'd0, CSR_WriteData[7], 3'd0, CSR_WriteData[3], 3'd0};
                    mie_addr: CSR_ReadData <= {20'b0, CSR_WriteData[11], 11'b0};
                    mtvec_addr: CSR_ReadData <= CSR_WriteData;
                    mepc_addr: CSR_ReadData <= CSR_WriteData;
                    mip_addr: CSR_ReadData <= {20'd0, CSR_WriteData[11], 11'd0};
                    mcycle_addr: CSR_ReadData <= CSR_WriteData;
                    minstret_addr: CSR_ReadData <= CSR_WriteData;
                    mcycleh_addr: CSR_ReadData <= CSR_WriteData;
                    minstreth_addr: CSR_ReadData <= CSR_WriteData;
                    default: CSR_ReadData <= 32'd0;
                endcase
            end else begin
                unique case (CSR_ReadAddress)
                    mstatus_addr: CSR_ReadData <= mstatus_reg;
                    mie_addr: CSR_ReadData <= mie_reg;
                    mtvec_addr: CSR_ReadData <= mtvec_reg;
                    mepc_addr: CSR_ReadData <= mepc_reg;
                    mip_addr: CSR_ReadData <= mip_reg;
                    mcycle_addr: CSR_ReadData <= mcycle_reg;
                    minstret_addr: CSR_ReadData <= minstret_reg;
                    mcycleh_addr: CSR_ReadData <= mcycleh_reg;
                    minstreth_addr: CSR_ReadData <= minstreth_reg;
                    default: CSR_ReadData <= 32'd0;
                endcase
            end
        end else begin
            CSR_ReadData <= CSR_ReadData;
        end
    end
endmodule
