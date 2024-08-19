module HazardDetection (
    input              ID_EX_MemRead,
    input        [4:0] ID_EX_Rd,
    input        [4:0] IF_ID_Rs1,
    input        [4:0] IF_ID_Rs2,

    input              Branchflag,
    input              EXE_MEM_Jump,
    input              EXE_MEM_Jalr,
    input              EXE_MEM_Branch,
    input              AXI_Stall,
    input              ID_Interrupt_Confirm,
	input              ID_Interrupt_Confirm_Timer,
    input              MEM_MRET,

    output logic       Hazard_Stall,
    output logic       Hazard_Flush,
    output logic [1:0] PcSel
);

always_comb begin
    //Load use data hazard
    Hazard_Stall = ((ID_EX_MemRead) && ((ID_EX_Rd == IF_ID_Rs1) || (ID_EX_Rd == IF_ID_Rs2)));
    //Control Hazard
    Hazard_Flush = (EXE_MEM_Jump | EXE_MEM_Jalr | (EXE_MEM_Branch && Branchflag) | ID_Interrupt_Confirm | MEM_MRET | ID_Interrupt_Confirm_Timer);

    if (AXI_Stall) begin
        Hazard_Flush = 1'b0;
        Hazard_Stall = 1'b0;
    end 
    if (Hazard_Stall == 1'b1 && Hazard_Flush == 1'b1) begin
        Hazard_Stall = 1'b0;
    end
end

always_comb begin
	unique if(EXE_MEM_Branch && Branchflag) begin
		PcSel = 2'b01;
    end else if (EXE_MEM_Jump || EXE_MEM_Jalr) begin
		PcSel = 2'b10;
    end else begin
		PcSel = 2'b00;
    end
end
endmodule