module EXMEM (
    input               clk,
    input               rst,
    input               stall,
    input               flush,
    
    input        [31:0] EXE_ALU_Result,
    input        [31:0] EXE_BranchPC,
    input               EXE_BranchFlag,
    input        [31:0] EXE_Rs2Data,
    input        [31:0] EXE_PcPlus4,
    input        [4:0]  EXE_Rd,
    input        [11:0] EXE_CSR_WriteAddress,
    input        [31:0] EXE_CSR_WriteData,
	input               Interrupt_Confirm_Timer,

    input               EXE_MemToReg, 
    input               EXE_RegWrite,
    input        [3:0]  EXE_MemRead,
    input        [2:0]  EXE_MemWrite,
    input               EXE_WbSel,
    input               EXE_Jump,
    input               EXE_Jalr,
    input               EXE_Branch,
    input               EXE_WFI,
    input               EXE_MRET,
    input               EXE_RegWrite_CSR,
    input        [2:0]  EXE_Funct3,

    output logic [31:0] MEM_ALU_Result,
    output logic [31:0] MEM_BranchPC,
    output logic        MEM_BranchFlag,
    output logic [31:0] MEM_Rs2Data,
    output logic [31:0] MEM_PcPlus4,
    output logic [4:0]  MEM_Rd,
    output logic [11:0] MEM_CSR_WriteAddress,
    output logic [31:0] MEM_CSR_WriteData,

    output logic        MEM_MemToReg, 
    output logic        MEM_RegWrite,
    output logic [3:0]  MEM_MemRead,
    output logic [2:0]  MEM_MemWrite,
    output logic        MEM_WbSel,
    output logic        MEM_Jump,
    output logic        MEM_Jalr,
    output logic        MEM_Branch,
    output logic        MEM_WFI,
    output logic        MEM_MRET,
    output logic        MEM_RegWrite_CSR,
    output logic [2:0]  MEM_Funct3
);

    always_ff @(posedge clk)begin
        priority if (rst) begin
            MEM_ALU_Result <= 32'd0;
            MEM_BranchPC <= 32'd0;
            MEM_BranchFlag <= 1'd0;
            MEM_Rs2Data <= 32'd0;
            MEM_PcPlus4 <= 32'd0;
            MEM_Rd <= 5'd0;
            MEM_CSR_WriteAddress <= 12'd0;
            MEM_CSR_WriteData <= 32'd0;

            MEM_MemToReg <= 1'd0;
            MEM_RegWrite <= 1'd0;
            MEM_MemRead <= 4'd0;
            MEM_MemWrite <= 3'd0;
            MEM_WbSel <= 1'd0;
            MEM_Jump <= 1'd0;
            MEM_Jalr <= 1'd0;
            MEM_Branch <= 1'd0;
            MEM_WFI <= 1'd0;
            MEM_MRET <= 1'd0;
            MEM_RegWrite_CSR <= 1'b0;
            MEM_Funct3 <= 3'd0;
        end else if (Interrupt_Confirm_Timer) begin
            MEM_ALU_Result <= 32'd0;
            MEM_BranchPC <= 32'd0;
            MEM_BranchFlag <= 1'd0;
            MEM_Rs2Data <= 32'd0;
            MEM_PcPlus4 <= 32'd0;
            MEM_Rd <= 5'd0;
            MEM_CSR_WriteAddress <= 12'd0;
            MEM_CSR_WriteData <= 32'd0;

            MEM_MemToReg <= 1'd0;
            MEM_RegWrite <= 1'd0;
            MEM_MemRead <= 4'd0;
            MEM_MemWrite <= 3'd0;
            MEM_WbSel <= 1'd0;
            MEM_Jump <= 1'd0;
            MEM_Jalr <= 1'd0;
            MEM_Branch <= 1'd0;
            MEM_WFI <= 1'd0;
            MEM_MRET <= 1'd0;
            MEM_RegWrite_CSR <= 1'b0;
            MEM_Funct3 <= 3'd0;
        end else if (flush) begin
            MEM_ALU_Result <= 32'd0;
            MEM_BranchPC <= 32'd0;
            MEM_BranchFlag <= 1'd0;
            MEM_Rs2Data <= 32'd0;
            MEM_PcPlus4 <= 32'd0;
            MEM_Rd <= 5'd0;
            MEM_CSR_WriteAddress <= 12'd0;
            MEM_CSR_WriteData <= 32'd0;

            MEM_MemToReg <= 1'd0;
            MEM_RegWrite <= 1'd0;
            MEM_MemRead <= 4'd0;
            MEM_MemWrite <= 3'd0;
            MEM_WbSel <= 1'd0;
            MEM_Jump <= 1'd0;
            MEM_Jalr <= 1'd0;
            MEM_Branch <= 1'd0;
            MEM_WFI <= 1'd0;
            MEM_MRET <= 1'd0;
            MEM_RegWrite_CSR <= 1'b0;
            MEM_Funct3 <= 3'd0;
        end else if (~stall) begin
            MEM_ALU_Result <= EXE_ALU_Result;
            MEM_BranchPC <= EXE_BranchPC;
            MEM_BranchFlag <= EXE_BranchFlag;
            MEM_Rs2Data <= EXE_Rs2Data;
            MEM_PcPlus4 <= EXE_PcPlus4;
            MEM_Rd <= EXE_Rd;
            MEM_CSR_WriteAddress <= EXE_CSR_WriteAddress;
            MEM_CSR_WriteData <= EXE_CSR_WriteData;

            MEM_MemToReg <= EXE_MemToReg;
            MEM_RegWrite <= EXE_RegWrite;
            MEM_MemRead <= EXE_MemRead;
            MEM_MemWrite <= EXE_MemWrite;
            MEM_WbSel <= EXE_WbSel;
            MEM_Jump <= EXE_Jump;
            MEM_Jalr <= EXE_Jalr;
            MEM_Branch <= EXE_Branch;
            MEM_WFI <= EXE_WFI;
            MEM_MRET <= EXE_MRET;
            MEM_RegWrite_CSR <= EXE_RegWrite_CSR;
            MEM_Funct3 <= EXE_Funct3;
        end else begin
            MEM_ALU_Result <= MEM_ALU_Result;
            MEM_BranchPC <= MEM_BranchPC;
            MEM_BranchFlag <= MEM_BranchFlag;
            MEM_Rs2Data <= MEM_Rs2Data;
            MEM_PcPlus4 <= MEM_PcPlus4;
            MEM_Rd <= MEM_Rd;
            MEM_CSR_WriteAddress <= MEM_CSR_WriteAddress;
            MEM_CSR_WriteData <= MEM_CSR_WriteData;
            
            MEM_MemToReg <= MEM_MemToReg;
            MEM_RegWrite <= MEM_RegWrite;
            MEM_MemRead <= MEM_MemRead;
            MEM_MemWrite <= MEM_MemWrite;
            MEM_WbSel <= MEM_WbSel;
            MEM_Jump <= MEM_Jump;
            MEM_Jalr <= MEM_Jalr;
            MEM_Branch <= MEM_Branch;
            MEM_WFI <= MEM_WFI;
            MEM_MRET <= MEM_MRET;
            MEM_RegWrite_CSR <= MEM_RegWrite_CSR;
            MEM_Funct3 <= MEM_Funct3;
        end
    end   
endmodule