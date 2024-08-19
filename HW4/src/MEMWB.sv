module MEMWB (
    input               clk,
    input               rst,

    input        [31:0] MEM_ALU_Result,
    input        [31:0] MEM_PcPlus4,
    input        [4:0]  MEM_Rd,
    input        [11:0] MEM_CSR_WriteAddress,
    input        [31:0] MEM_CSR_WriteData,
	input               Interrupt_Confirm_Timer,
    input        [3:0]  MEM_MemRead,
    input               MEM_MemToReg,
    input               MEM_RegWrite,
    input               MEM_WbSel,
    input               MEM_RegWrite_CSR, 

    output logic [31:0] WB_ALU_Result,
    output logic [31:0] WB_PcPlus4,
    output logic [4:0]  WB_Rd,
    output logic [11:0] WB_CSR_WriteAddress,
    output logic [31:0] WB_CSR_WriteData,

    output logic [3:0]  WB_MemRead,
    output logic        WB_MemToReg,
    output logic        WB_RegWrite,
    output logic        WB_WbSel,
    output logic        WB_RegWrite_CSR
);
    always_ff @(posedge clk) begin
        priority if (rst) begin
            WB_ALU_Result <= 32'd0;
            WB_PcPlus4 <= 32'd0;
            WB_Rd <= 5'd0;
            WB_CSR_WriteAddress <= 12'd0;
            WB_CSR_WriteData <= 32'd0;

            WB_MemRead <= 4'd0;
            WB_MemToReg <= 1'd0;
            WB_RegWrite <= 1'd0;
            WB_WbSel <= 1'd0;
            WB_RegWrite_CSR <= 1'd0;
        end else if (Interrupt_Confirm_Timer) begin
            WB_ALU_Result <= 32'd0;
            WB_PcPlus4 <= 32'd0;
            WB_Rd <= 5'd0;
            WB_CSR_WriteAddress <= 12'd0;
            WB_CSR_WriteData <= 32'd0;

            WB_MemRead <= 4'd0;
            WB_MemToReg <= 1'd0;
            WB_RegWrite <= 1'd0;
            WB_WbSel <= 1'd0;
            WB_RegWrite_CSR <= 1'd0;
        end else begin
            WB_ALU_Result <= MEM_ALU_Result;
            WB_PcPlus4 <= MEM_PcPlus4;
            WB_Rd <= MEM_Rd;
            WB_CSR_WriteAddress <= MEM_CSR_WriteAddress;
            WB_CSR_WriteData <= MEM_CSR_WriteData;

            WB_MemRead <= MEM_MemRead;
            WB_MemToReg <= MEM_MemToReg;
            WB_RegWrite <= MEM_RegWrite;
            WB_WbSel <= MEM_WbSel;
            WB_RegWrite_CSR <= MEM_RegWrite_CSR;
        end
    end   
endmodule