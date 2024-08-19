module IDEX (
    input               clk,
    input               rst,
    input               stall,
    input               flush,
       
    input        [31:0] ID_imm,
    input        [31:0] ID_Pc,
    input        [31:0] ID_PcPlus4,
    input        [4:0]  ID_Rs1,
    input        [4:0]  ID_Rs2,
    input        [4:0]  ID_Rd,
    input        [11:0] ID_CSR_WriteAddress,
       
    input        [1:0]  ID_AluSrc1,
    input        [1:0]  ID_AluSrc2,
    input        [4:0]  ID_AluOp,
    input               ID_MemToReg,
    input               ID_RegWrite,
    input        [3:0]  ID_MemRead,
    input        [2:0]  ID_MemWrite,
    input               ID_WbSel,
    input               ID_Jump,
    input               ID_Jalr,
    input               ID_Branch,
    input               ID_WFI,
    input               ID_MRET,
    input               ID_AluSrc_CSR,
    input        [1:0]  ID_AluOp_CSR,
    input               ID_RegWrite_CSR,
    input        [2:0]  ID_Funct3,
	input               Interrupt_Confirm_Timer,
    output logic [31:0] EXE_imm,
    output logic [31:0] EXE_Pc,
    output logic [31:0] EXE_PcPlus4,
    output logic [4:0]  EXE_Rs1,
    output logic [4:0]  EXE_Rs2,
    output logic [4:0]  EXE_Rd,
    output logic [11:0] EXE_CSR_WriteAddress,

    output logic [1:0]  EXE_AluSrc1,
    output logic [1:0]  EXE_AluSrc2,
    output logic [4:0]  EXE_AluOp,
    output logic        EXE_MemToReg,
    output logic        EXE_RegWrite,
    output logic [3:0]  EXE_MemRead,
    output logic [2:0]  EXE_MemWrite,
    output logic        EXE_WbSel,
    output logic        EXE_Jump,
    output logic        EXE_Jalr,
    output logic        EXE_Branch,
    output logic        EXE_WFI,
    output logic        EXE_MRET,
    output logic        EXE_AluSrc_CSR,
    output logic [1:0]  EXE_AluOp_CSR,
    output logic        EXE_RegWrite_CSR,
    output logic [2:0]  EXE_Funct3
);

always_ff @(posedge clk) begin
    priority if (rst) begin
        EXE_imm <= 32'd0;
        EXE_Pc <= 32'd0;
        EXE_PcPlus4 <= 32'd0;
        EXE_Rs1 <= 5'd0;
        EXE_Rs2 <= 5'd0;
        EXE_Rd <= 5'd0;
        EXE_CSR_WriteAddress <= 12'd0;

        EXE_AluSrc1 <= 2'd0;
        EXE_AluSrc2 <= 2'd0;
        EXE_AluOp <= 4'd0;
        EXE_MemToReg <= 1'd0;
        EXE_RegWrite <= 1'd0;
        EXE_MemRead <= 4'd0;
        EXE_MemWrite <= 3'd0;
        EXE_WbSel <= 1'd0;
        EXE_Jump <= 1'd0;
        EXE_Jalr <= 1'd0;
        EXE_Branch <= 1'd0;
        EXE_WFI <= 1'b0;
        EXE_MRET <= 1'b0;
        EXE_AluSrc_CSR <= 1'b0;
        EXE_AluOp_CSR <= 2'd0;
        EXE_RegWrite_CSR <= 1'b0;
        EXE_Funct3 <= 3'd0;
    end else if (Interrupt_Confirm_Timer | flush) begin
        EXE_imm <= 32'd0;
        EXE_Pc <= 32'd0;
        EXE_PcPlus4 <= 32'd0;
        EXE_Rs1 <= 5'd0;
        EXE_Rs2 <= 5'd0;
        EXE_Rd <= 5'd0;
        EXE_CSR_WriteAddress <= 12'd0;

        EXE_AluSrc1 <= 2'd0;
        EXE_AluSrc2 <= 2'd0;
        EXE_AluOp <= 4'd0;
        EXE_MemToReg <= 1'd0;
        EXE_RegWrite <= 1'd0;
        EXE_MemRead <= 4'd0;
        EXE_MemWrite <= 3'd0;
        EXE_WbSel <= 1'd0;
        EXE_Jump <= 1'd0;
        EXE_Jalr <= 1'd0;
        EXE_Branch <= 1'd0;
        EXE_WFI <= 1'b0;
        EXE_MRET <= 1'b0;
        EXE_AluSrc_CSR <= 1'b0;
        EXE_AluOp_CSR <= 2'd0;
        EXE_RegWrite_CSR <= 1'b0;
        EXE_Funct3 <= 3'd0;
    end else if (~stall) begin
        EXE_imm <= ID_imm;
        EXE_Pc <= ID_Pc;
        EXE_PcPlus4 <= ID_PcPlus4;
        EXE_Rs1 <= ID_Rs1;
        EXE_Rs2 <= ID_Rs2;
        EXE_Rd <= ID_Rd;
        EXE_CSR_WriteAddress <= ID_CSR_WriteAddress;

        EXE_AluSrc1 <= ID_AluSrc1;
        EXE_AluSrc2 <= ID_AluSrc2;
        EXE_AluOp <= ID_AluOp;
        EXE_MemToReg <= ID_MemToReg;
        EXE_RegWrite <= ID_RegWrite;
        EXE_MemRead <= ID_MemRead;
        EXE_MemWrite <= ID_MemWrite;
        EXE_WbSel <= ID_WbSel;
        EXE_Jump <= ID_Jump;
        EXE_Jalr <= ID_Jalr;
        EXE_Branch <= ID_Branch;
        EXE_WFI <= ID_WFI;
        EXE_MRET <= ID_MRET;
        EXE_AluSrc_CSR <= ID_AluSrc_CSR;
        EXE_AluOp_CSR <= ID_AluOp_CSR;
        EXE_RegWrite_CSR <= ID_RegWrite_CSR;
        EXE_Funct3 <= ID_Funct3;
    end else begin
        EXE_imm <= EXE_imm;
        EXE_Pc <= EXE_Pc;
        EXE_PcPlus4 <= EXE_PcPlus4;
        EXE_Rs1 <= EXE_Rs1;
        EXE_Rs2 <= EXE_Rs2;
        EXE_Rd <= EXE_Rd;
        EXE_CSR_WriteAddress <= EXE_CSR_WriteAddress;

        EXE_AluSrc1 <= EXE_AluSrc1;
        EXE_AluSrc2 <= EXE_AluSrc2;
        EXE_AluOp <= EXE_AluOp;
        EXE_MemToReg <= EXE_MemToReg;
        EXE_RegWrite <= EXE_RegWrite;
        EXE_MemRead <= EXE_MemRead;
        EXE_MemWrite <= EXE_MemWrite;
        EXE_WbSel <= EXE_WbSel;
        EXE_Jump <= EXE_Jump;
        EXE_Jalr <= EXE_Jalr;
        EXE_Branch <= EXE_Branch;
        EXE_WFI <= EXE_WFI;
        EXE_MRET <= EXE_MRET;
        EXE_AluSrc_CSR <= EXE_AluSrc_CSR;
        EXE_AluOp_CSR <= EXE_AluOp_CSR;
        EXE_RegWrite_CSR <= EXE_RegWrite_CSR;
        EXE_Funct3 <= EXE_Funct3;	
	end
end   
endmodule
