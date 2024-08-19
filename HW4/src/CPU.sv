`include "Forwarding.sv"
`include "HazardDetection.sv"
`include "PC.sv"
`include "IFID.sv"
`include "IDEX.sv"
`include "EXMEM.sv"
`include "MEMWB.sv"
`include "ControlUnit.sv"
`include "RegisterFile.sv"
`include "CSR.sv"
`include "ImmGen.sv"
`include "ALU.sv"
`include "ALUCSR.sv"

module CPU (
    input               clk,
    input               rst,

    //IM
    output logic [31:0] A_IM,
    input        [31:0] DO_IM,

    //DM
    output logic [3:0]  WEB_DM,
    output logic [31:0] A_DM,
    output logic [31:0] DI_DM,
    input        [31:0] DO_DM,
    
    //Cache
    output logic [2:0] DM_Funct3,
    output logic       DM_Read,
    output logic       DM_Write,
    input              IM_Stall,
    input              DM_Stall,

    //Interrupt
    input             Interrupt_SCtrl,
	input             WTO
);
    //IF stage
    logic [31:0] IF_PC_out;
    logic [31:0] IF_Pc_;
    logic [31:0] IF_Pc;
    logic [31:0] IF_PcPlus4;

    //ID stage
    logic        stall; //Hazard Detection
    logic        flush;
    logic [1:0]  PcSel;

    logic [31:0] ID_Instruction;
    logic [31:0] ID_imm;
    logic [31:0] ID_Pc;
    logic [31:0] ID_PcPlus4;
    logic [11:0] ID_CSR_Address;
    logic        ID_Interrupt_Confirm;
    logic        ID_Interrupt_Confirm_Timer;
    logic [31:0] ID_mtvec;
    logic [31:0] ID_mepc;

    //ID Control signal
    logic [1:0]  ID_AluSrc1;
    logic [1:0]  ID_AluSrc2;
    logic [2:0]  ID_ImmSel;
    logic [4:0]  ID_AluOp;
    logic        ID_MemToReg;
    logic        ID_RegWrite;
    logic [3:0]  ID_MemRead;
    logic [2:0]  ID_MemWrite;
    logic        ID_WbSel;
    logic        ID_Jump;
    logic        ID_Jalr;
    logic        ID_Branch;
    logic        ID_WFI;
    logic        ID_MRET;
    logic        ID_AluSrc_CSR;
    logic [1:0]  ID_AluOp_CSR;
    logic        ID_RegWrite_CSR;

    //EXE stage
    logic [1:0]  FA; //Fing
    logic [1:0]  FB;
    logic [1:0]  FC;

    logic [31:0] EXE_Rs1Data;
    logic [31:0] EXE_Rs2Data;
    logic [31:0] EXE_imm;
    logic [31:0] EXE_FAOut;
    logic [31:0] EXE_FBOut;
    logic [31:0] EXE_FCOut;
    logic [31:0] EXE_AluSrc1Out;
    logic [31:0] EXE_AluSrc2Out;
    logic [31:0] EXE_ALU_Result;
    logic [31:0] EXE_CSR_AluSrc1Out;
    logic [31:0] EXE_CSR_AluSrc2Out;
    logic [31:0] EXE_CSR_ALU_Result;
    logic        EXE_BranchFlag;
    logic [31:0] EXE_BranchPC;

    logic [31:0] EXE_Pc;
    logic [31:0] EXE_PcPlus4;
    logic [4:0]  EXE_Rs1;
    logic [4:0]  EXE_Rs2;
    logic [4:0]  EXE_Rd;

    logic [31:0] EXE_ReadData_CSR;
    logic [11:0] EXE_CSR_WriteAddress;
    logic [31:0] EXE_CSR_WriteData;

    //EXE Control Signal
    logic [1:0]  EXE_AluSrc1;
    logic [1:0]  EXE_AluSrc2;
    logic [4:0]  EXE_AluOp;
    logic        EXE_MemToReg;
    logic        EXE_RegWrite;
    logic [3:0]  EXE_MemRead;
    logic [2:0]  EXE_MemWrite;
    logic        EXE_WbSel;
    logic        EXE_Jump;
    logic        EXE_Jalr;
    logic        EXE_Branch;
    logic        EXE_WFI;
    logic        EXE_MRET;
    logic        EXE_AluSrc_CSR;
    logic [1:0]  EXE_AluOp_CSR;
    logic        EXE_RegWrite_CSR;
    logic [2:0]  EXE_Funct3;

    //MEM stage
    logic [31:0] MEM_ALU_Result;
    logic [31:0] MEM_Rs2Data;
    logic        MEM_BranchFlag;
    logic [31:0] MEM_BranchPC;

    logic [31:0] MEM_PcPlus4;
    logic [4:0]  MEM_Rd;
    logic [11:0] MEM_CSR_WriteAddress;
    logic [31:0] MEM_CSR_WriteData;

    //MEM Control Signal
    logic        MEM_MemToReg;
    logic        MEM_RegWrite;
    logic [3:0]  MEM_MemRead;
    logic [2:0]  MEM_MemWrite;
    logic        MEM_WbSel;
    logic        MEM_Jump;
    logic        MEM_Jalr;
    logic        MEM_Branch;
    logic        MEM_WFI;
    logic        MEM_MRET;
    logic        MEM_RegWrite_CSR;
    logic [2:0]  MEM_Funct3;

    //WB stage
    logic [31:0] WB_MemReadData;
    logic [31:0] WB_ALU_Result;
    logic [31:0] WB_ToRegData;
    logic [31:0] WB_PcPlus4;
    logic [31:0] WB_WriteBackData;

    logic [4:0]  WB_Rd;
    logic [11:0] WB_CSR_WriteAddress;
    logic [31:0] WB_CSR_WriteData;

    //WB Control Signal
    logic [3:0]  WB_MemRead;
    logic        WB_MemToReg;
    logic        WB_RegWrite;
    logic        WB_WbSel;
    logic        WB_RegWrite_CSR;

    //==============================//

    Forwarding Forwarding (
        .MEM_RegWrite     (MEM_RegWrite),
        .WB_RegWrite      (WB_RegWrite),
        .EXE_RS1          (EXE_Rs1),
        .EXE_RS2          (EXE_Rs2),
        .MEM_WA           (MEM_Rd),
        .WB_WA            (WB_Rd),
        .MEM_RegWrite_CSR (MEM_RegWrite_CSR),
        .WB_RegWrite_CSR  (WB_RegWrite_CSR),
        .EXE_ADDR_CSR     (EXE_CSR_WriteAddress),
        .MEM_ADDR_CSR     (MEM_CSR_WriteAddress),
        .WB_ADDR_CSR      (WB_CSR_WriteAddress),
        .FA               (FA),
        .FB               (FB),
        .FC               (FC)
    );

    //IF Stage
    PC PC (
        .clk                     (clk),
        .rst                     (rst),
        .Interrupt_Confirm_Timer (ID_Interrupt_Confirm_Timer),
        .stall                   (stall | IM_Stall | DM_Stall),
        .PC_in                   (IF_PcPlus4),
        .PC_out                  (IF_PC_out )
    );

    always_comb begin
        unique if (ID_Interrupt_Confirm_Timer) begin
            IF_Pc_ = 32'd0;
        end else begin
            unique case (PcSel)
                2'b01: IF_Pc_ = MEM_BranchPC;
                2'b10: IF_Pc_ = MEM_ALU_Result;
                default: IF_Pc_ = IF_PC_out;
            endcase
        end
    end

    always_comb begin
        unique if (ID_Interrupt_Confirm) begin
            IF_Pc = ID_mtvec;
        end else if (MEM_MRET) begin
            IF_Pc = ID_mepc;
        end else if (ID_Interrupt_Confirm_Timer)
            IF_Pc = 32'd0;
        else begin
            IF_Pc = IF_Pc_;
        end
    end

    assign IF_PcPlus4 = IF_Pc + 32'd4;

    //IFID
    assign A_IM = IF_Pc;
    assign ID_Instruction = DO_IM;

    //IF/ID pipeline
    IFID IFID (
        .clk                     (clk),
        .rst                     (rst),
        .Interrupt_Confirm_Timer (ID_Interrupt_Confirm_Timer),
        .stall                   (stall),
        .IF_Pc                   (IF_Pc),
        .IF_PcPlus4              (IF_PcPlus4),
        .ID_Pc                   (ID_Pc),
        .ID_PcPlus4              (ID_PcPlus4)
    );

    //ID stage
    //Hazard Detection Unit
    HazardDetection HazardDetection (
        .ID_EX_MemRead              (EXE_MemRead[2] | EXE_MemRead[1] | EXE_MemRead[0]),
        .ID_EX_Rd                   (EXE_Rd),
        .IF_ID_Rs1                  (ID_Instruction[19:15]),
        .IF_ID_Rs2                  (ID_Instruction[24:20]),
        .Branchflag                 (MEM_BranchFlag),
        .EXE_MEM_Jump               (MEM_Jump),
        .EXE_MEM_Jalr               (MEM_Jalr),
        .EXE_MEM_Branch             (MEM_Branch),
        .AXI_Stall                  (IM_Stall | DM_Stall),
        .ID_Interrupt_Confirm       (ID_Interrupt_Confirm),
        .ID_Interrupt_Confirm_Timer (ID_Interrupt_Confirm_Timer),
        .MEM_MRET                   (MEM_MRET),
        .Hazard_Stall               (stall),
        .Hazard_Flush               (flush),
        .PcSel                      (PcSel)
    );

    ControlUnit ControlUnit (
        .Opcode       (ID_Instruction[6:0]),
        .funct3       (ID_Instruction[14:12]),
        .funct7       (ID_Instruction[31:25]),
        .csr_imm      (ID_Instruction[31:20]),
        .stall        (stall),
        .ALU_src1     (ID_AluSrc1),
        .ALU_src2     (ID_AluSrc2),
        .ImmSel       (ID_ImmSel),
        .ALU_op       (ID_AluOp),
        .MemToReg     (ID_MemToReg),
        .RegWrite     (ID_RegWrite),
        .MemRead      (ID_MemRead),
        .MemWrite     (ID_MemWrite),
        .WbSel        (ID_WbSel),
        .Jump         (ID_Jump),
        .Jalr         (ID_Jalr),
        .Branch       (ID_Branch),
        .WFI          (ID_WFI),
        .MRET         (ID_MRET),
        .ALUSrc_CSR   (ID_AluSrc_CSR),
        .ALU_op_CSR   (ID_AluOp_CSR),
        .RegWrite_CSR (ID_RegWrite_CSR)
    );

    RegisterFile RegisterFile (
        .clk                     (clk),
        .rst                     (rst),
        .Interrupt_Confirm_Timer (ID_Interrupt_Confirm_Timer),
        .AXI_Stall               (IM_Stall | DM_Stall),
        .ReadRegister1           (ID_Instruction[19:15]),
        .ReadRegister2           (ID_Instruction[24:20]),
        .RegWrite                (WB_RegWrite),
        .WriteRegister           (WB_Rd),
        .WriteData               (WB_WriteBackData),
        .ReadData1               (EXE_Rs1Data),
        .ReadData2               (EXE_Rs2Data)
    );

    CSR CSR (
        .clk                     (clk),
        .rst                     (rst),
        .AXI_Stall               (IM_Stall | DM_Stall),
        .CSR_ReadAddress         (ID_Instruction[31:20]),
        .CSR_RegWrite            (WB_RegWrite_CSR),
        .CSR_WriteAddress        (WB_CSR_WriteAddress),
        .CSR_WriteData           (WB_CSR_WriteData),
        .Interrupt_SCtrl         (Interrupt_SCtrl),
        .WFI                     (MEM_WFI),
        .MRET                    (MEM_MRET),
        .CSR_PC                  (MEM_PcPlus4 ),
        
        .WTO                     (WTO),
        .Instret                 (~(stall | IM_Stall | DM_Stall)),
        .CSR_ReadData            (EXE_ReadData_CSR),
        .CSR_mtvec               (ID_mtvec),
        .CSR_mepc                (ID_mepc),
        .Interrupt_Confirm       (ID_Interrupt_Confirm),
        .Interrupt_Confirm_Timer (ID_Interrupt_Confirm_Timer)
    );

    ImmGen ImmGen (
        .Instruction (ID_Instruction),
        .ImmSel      (ID_ImmSel),
        .imm         (ID_imm)
    );

    //ID/EXE pipeline
    IDEX IDEX (
        .clk                     (clk),
        .rst                     (rst),
        .Interrupt_Confirm_Timer (ID_Interrupt_Confirm_Timer),
        .stall                   (IM_Stall | DM_Stall),
        .flush                   (1'b0),
        .ID_imm                  (ID_imm),
        .ID_Pc                   (ID_Pc),
        .ID_PcPlus4              (ID_PcPlus4),
        .ID_Rs1                  (ID_Instruction[19:15]),
        .ID_Rs2                  (ID_Instruction[24:20]),
        .ID_Rd                   (ID_Instruction[11:7] ),
        .ID_CSR_WriteAddress     (ID_Instruction[31:20]),
        .ID_AluSrc1              (ID_AluSrc1),
        .ID_AluSrc2              (ID_AluSrc2),
        .ID_AluOp                (ID_AluOp),
        .ID_MemToReg             (ID_MemToReg),
        .ID_RegWrite             (ID_RegWrite),
        .ID_MemRead              (ID_MemRead),
        .ID_MemWrite             (ID_MemWrite),
        .ID_WbSel                (ID_WbSel),
        .ID_Jump                 (ID_Jump),
        .ID_Jalr                 (ID_Jalr),
        .ID_Branch               (ID_Branch),
        .ID_WFI                  (ID_WFI),
        .ID_MRET                 (ID_MRET),
        .ID_AluSrc_CSR           (ID_AluSrc_CSR),
        .ID_AluOp_CSR            (ID_AluOp_CSR),
        .ID_RegWrite_CSR         (ID_RegWrite_CSR),
        .ID_Funct3               (ID_Instruction[14:12]),
        .EXE_imm                 (EXE_imm),
        .EXE_Pc                  (EXE_Pc),
        .EXE_PcPlus4             (EXE_PcPlus4),
        .EXE_Rs1                 (EXE_Rs1),
        .EXE_Rs2                 (EXE_Rs2),
        .EXE_Rd                  (EXE_Rd),
        .EXE_CSR_WriteAddress    (EXE_CSR_WriteAddress),
        .EXE_AluSrc1             (EXE_AluSrc1),
        .EXE_AluSrc2             (EXE_AluSrc2),
        .EXE_AluOp               (EXE_AluOp),
        .EXE_MemToReg            (EXE_MemToReg),
        .EXE_RegWrite            (EXE_RegWrite),
        .EXE_MemRead             (EXE_MemRead),
        .EXE_MemWrite            (EXE_MemWrite),
        .EXE_WbSel               (EXE_WbSel),
        .EXE_Jump                (EXE_Jump),
        .EXE_Jalr                (EXE_Jalr),
        .EXE_Branch              (EXE_Branch),
        .EXE_WFI                 (EXE_WFI),
        .EXE_MRET                (EXE_MRET),
        .EXE_AluSrc_CSR          (EXE_AluSrc_CSR),
        .EXE_AluOp_CSR           (EXE_AluOp_CSR ),
        .EXE_RegWrite_CSR        (EXE_RegWrite_CSR ),
        .EXE_Funct3              (EXE_Funct3)
    );

    //EXE stage
    assign EXE_BranchPC = EXE_Pc + (EXE_imm);

    always_comb begin
        unique case (FA)
            2'b01: EXE_FAOut = WB_WriteBackData;
            2'b10: EXE_FAOut = MEM_ALU_Result;
            default: EXE_FAOut = EXE_Rs1Data;
        endcase

        unique case (FB)
            2'b01: EXE_FBOut = WB_WriteBackData;
            2'b10: EXE_FBOut = MEM_ALU_Result;
            default: EXE_FBOut = EXE_Rs2Data;
        endcase

        unique case (FC)
            2'b01: EXE_FCOut = WB_CSR_WriteData;
            2'b10: EXE_FCOut = MEM_CSR_WriteData;
            default: EXE_FCOut = EXE_ReadData_CSR;
        endcase
    end

    always_comb begin
        unique case (EXE_AluSrc1)
            2'b01: EXE_AluSrc1Out = EXE_Pc;
            2'b10: EXE_AluSrc1Out = 32'd0;
            default: EXE_AluSrc1Out = EXE_FAOut;
        endcase

        unique case (EXE_AluSrc2)
            2'b01: EXE_AluSrc2Out = EXE_imm;
            2'b10: EXE_AluSrc2Out = EXE_FCOut;
            default: EXE_AluSrc2Out = EXE_FBOut;
        endcase
    end

    assign EXE_CSR_AluSrc1Out = EXE_FCOut;
    assign EXE_CSR_AluSrc2Out = (EXE_AluSrc_CSR) ? EXE_imm : EXE_FAOut;

    ALU ALU (
        .ALU_in1     (EXE_AluSrc1Out),
        .ALU_in2     (EXE_AluSrc2Out),
        .ALU_sel     (EXE_AluOp),
        .ALU_result  (EXE_ALU_Result),
        .Branch_flag (EXE_BranchFlag)
    );

    ALUCSR ALUCSR (
        .src1_CSR       (EXE_CSR_AluSrc1Out),
        .src2_CSR       (EXE_CSR_AluSrc2Out),
        .ALUop_CSR      (EXE_AluOp_CSR),
        .address_CSR    (EXE_CSR_WriteAddress),
        .ALU_result_CSR (EXE_CSR_ALU_Result)
    );

    //EXE/MEM pipeline
    EXMEM EXMEM (
        .clk                     (clk),
        .rst                     (rst),
        .Interrupt_Confirm_Timer (ID_Interrupt_Confirm_Timer),
        .stall                   (IM_Stall | DM_Stall),
        .flush                   (flush),
        .EXE_ALU_Result          (EXE_ALU_Result),
        .EXE_BranchPC            (EXE_BranchPC),
        .EXE_BranchFlag          (EXE_BranchFlag),
        .EXE_Rs2Data             (EXE_FBOut),
        .EXE_PcPlus4             (EXE_PcPlus4),
        .EXE_Rd                  (EXE_Rd),
        .EXE_CSR_WriteAddress    (EXE_CSR_WriteAddress),
        .EXE_CSR_WriteData       (EXE_CSR_ALU_Result),
        .EXE_MemToReg            (EXE_MemToReg),
        .EXE_RegWrite            (EXE_RegWrite),
        .EXE_MemRead             (EXE_MemRead),
        .EXE_MemWrite            (EXE_MemWrite),
        .EXE_WbSel               (EXE_WbSel),
        .EXE_Jump                (EXE_Jump),
        .EXE_Jalr                (EXE_Jalr),
        .EXE_Branch              (EXE_Branch),
        .EXE_WFI                 (EXE_WFI),
        .EXE_MRET                (EXE_MRET),
        .EXE_RegWrite_CSR        (EXE_RegWrite_CSR),
        .EXE_Funct3              (EXE_Funct3),
        .MEM_ALU_Result          (MEM_ALU_Result),
        .MEM_BranchPC            (MEM_BranchPC),
        .MEM_BranchFlag          (MEM_BranchFlag),
        .MEM_Rs2Data             (MEM_Rs2Data),
        .MEM_PcPlus4             (MEM_PcPlus4),
        .MEM_Rd                  (MEM_Rd),
        .MEM_CSR_WriteAddress    (MEM_CSR_WriteAddress),
        .MEM_CSR_WriteData       (MEM_CSR_WriteData),
        .MEM_MemToReg            (MEM_MemToReg),
        .MEM_RegWrite            (MEM_RegWrite),
        .MEM_MemRead             (MEM_MemRead),
        .MEM_MemWrite            (MEM_MemWrite),
        .MEM_WbSel               (MEM_WbSel),
        .MEM_Jump                (MEM_Jump),
        .MEM_Jalr                (MEM_Jalr),
        .MEM_Branch              (MEM_Branch),
        .MEM_WFI                 (MEM_WFI),
        .MEM_MRET                (MEM_MRET),
        .MEM_RegWrite_CSR        (MEM_RegWrite_CSR),
        .MEM_Funct3              (MEM_Funct3)
    );

    //MEM stage
    assign A_DM = MEM_ALU_Result;
    assign DM_Read = |MEM_MemRead;
    assign DM_Write = |MEM_MemWrite;
    assign DM_Funct3 = MEM_Funct3;

    always_comb begin
        unique case (MEM_MemWrite)
            3'b001:
            begin
                WEB_DM = 4'b0000;
                DI_DM = MEM_Rs2Data;
            end
            3'b010:
            begin
                case (MEM_ALU_Result[1])
                    1'b0:
                    begin
                        WEB_DM = 4'b1100;
                        DI_DM = MEM_Rs2Data;
                    end
                    1'b1:
                    begin
                        WEB_DM = 4'b0011;
                        DI_DM = {MEM_Rs2Data[15:0], 16'd0};
                    end 
                endcase
            end
            3'b100:
            begin
                case (MEM_ALU_Result[1:0])
                2'b00:
                begin
                    WEB_DM = 4'b1110;
                    DI_DM = MEM_Rs2Data;
                end
                2'b01:
                begin
                    WEB_DM = 4'b1101;
                    DI_DM = {MEM_Rs2Data[23:0], 8'd0};
                end
                2'b10:
                begin
                    WEB_DM = 4'b1011;
                    DI_DM = {MEM_Rs2Data[15:0], 16'd0};
                end 
                2'b11:
                begin
                    WEB_DM = 4'b0111;
                    DI_DM = {MEM_Rs2Data[7:0], 24'd0};
                end 
                endcase  
            end
            default:
            begin
                WEB_DM = 4'b1111;
                DI_DM = 32'd0;
            end 
        endcase
    end

    //MEM/WB pipeline
    MEMWB MEMWB (
        .clk                     (clk),
        .rst                     (rst),
        .Interrupt_Confirm_Timer (ID_Interrupt_Confirm_Timer),
        .MEM_ALU_Result          (MEM_ALU_Result),
        .MEM_PcPlus4             (MEM_PcPlus4),
        .MEM_Rd                  (MEM_Rd),
        .MEM_CSR_WriteAddress    (MEM_CSR_WriteAddress),
        .MEM_CSR_WriteData       (MEM_CSR_WriteData),
        .MEM_MemRead             (MEM_MemRead),
        .MEM_MemToReg            (MEM_MemToReg),
        .MEM_RegWrite            (MEM_RegWrite),
        .MEM_WbSel               (MEM_WbSel),
        .MEM_RegWrite_CSR        (MEM_RegWrite_CSR),
        .WB_ALU_Result           (WB_ALU_Result),
        .WB_PcPlus4              (WB_PcPlus4),
        .WB_Rd                   (WB_Rd),
        .WB_CSR_WriteAddress     (WB_CSR_WriteAddress),
        .WB_CSR_WriteData        (WB_CSR_WriteData),
        .WB_MemRead              (WB_MemRead),
        .WB_MemToReg             (WB_MemToReg),
        .WB_RegWrite             (WB_RegWrite),
        .WB_WbSel                (WB_WbSel),
        .WB_RegWrite_CSR         (WB_RegWrite_CSR)
    );

    //WB stage
    always_comb begin
        unique case (WB_MemRead)
            4'b0010:
            begin
                case (WB_ALU_Result[1])
                    1'b0: WB_MemReadData = {{16{DO_DM[15]}}, DO_DM[15:0]};
                    1'b1: WB_MemReadData = {{16{DO_DM[31]}}, DO_DM[31:16]};
                endcase
            end
            4'b1010:
            begin
                case (WB_ALU_Result[1])
                    1'b0: WB_MemReadData = {{16{1'b0}}, DO_DM[15:0]};
                    1'b1: WB_MemReadData = {{16{1'b0}}, DO_DM[31:16]};
                endcase
            end
            4'b0100:
            begin
                case (WB_ALU_Result[1:0])
                    2'b00: WB_MemReadData = {{24{DO_DM[7]}}, DO_DM[7:0]};
                    2'b01: WB_MemReadData = {{24{DO_DM[15]}}, DO_DM[15:8]};
                    2'b10: WB_MemReadData = {{24{DO_DM[23]}}, DO_DM[23:16]};
                    2'b11: WB_MemReadData = {{24{DO_DM[31]}}, DO_DM[31:24]};
                endcase
            end
            4'b1100:
            begin
                case (WB_ALU_Result[1:0])
                    2'b00: WB_MemReadData = {{24{1'b0}}, DO_DM[7:0]};
                    2'b01: WB_MemReadData = {{24{1'b0}}, DO_DM[15:8]};
                    2'b10: WB_MemReadData = {{24{1'b0}}, DO_DM[23:16]};
                    2'b11: WB_MemReadData = {{24{1'b0}}, DO_DM[31:24]};
                endcase
            end
            default: WB_MemReadData = DO_DM;
        endcase
    end
            
    always_comb begin
        unique if (WB_MemToReg) begin
            WB_ToRegData = WB_MemReadData;
        end else begin
            WB_ToRegData = WB_ALU_Result;
        end

        unique if (WB_WbSel) begin
            WB_WriteBackData = WB_PcPlus4;
        end else begin
            WB_WriteBackData = WB_ToRegData;
        end
    end
endmodule 