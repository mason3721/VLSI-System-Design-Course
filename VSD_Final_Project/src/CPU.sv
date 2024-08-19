`include "ALU.sv"
`include "Comparator.sv"
`include "Control.sv"
`include "CSR.sv"
`include "EXE_MEM.sv"
`include "Forwarding.sv"
`include "Hazard_detector.sv"
`include "ID_EXE.sv"
`include "IF_ID.sv"
`include "Imm_generator.sv"
`include "MEM_WB.sv"
`include "Mux16_1.sv"
`include "Mux8_1.sv"
`include "Mux4_1.sv"
`include "Mux2_1.sv"
`include "PC.sv"
`include "PC_delay.sv"
`include "Reg_file.sv"
`include "store_data_shift.sv"
`include "LH_LB_shift.sv"
module CPU(
	clk,
	rst,
	IM_raddr,
	IM_rdata,
	IM_ren,
	DM_addr,
	DM_wdata,
	DM_wen,
	DM_rdata,
	DM_ren,
	waiting,
	WTO,
	sctrl_interrupt
);

input clk,rst,WTO,sctrl_interrupt;
input [31:0] IM_rdata;
input [31:0] DM_rdata;
input waiting;

output logic IM_ren;
output logic [31:0] IM_raddr,DM_addr;
output logic [31:0] DM_wdata;
output logic DM_ren;
output logic [3:0] DM_wen;

logic [31:0] IF_ID_PC_in,instruction,PC_4,jump_PC_4,PC_in,PC_out,jump_PC,PC_curr,IM_read_addr,reg1data,reg2data,imm_result,M_ALU_result,reg1out,PC_rs1,write_data_out;
logic [31:0] EXE_PC_out,EXE_reg1data,EXE_reg2data,EXE_imm,rs1_temp,WE_result,ALU_in1,ALU_in2,comp_in1,comp_in2,rs2_temp_out,M_ALU_result_out,MTVEC,MEPC;
logic [31:0] rs2_temp,CSR_out,ALU_result,DM_data_out,MTVEC_4,MEPC_4;
logic [1:0] B_type_JALR_hazard_PC,forward_out_EX_rs1,forward_out_EX_rs2;
logic stall,JALR_mux,comparator_out,forward_ID_comp_rs1,forward_ID_JALR,forward_ID_comp_rs2;
logic [17:0] EX,EX_out;
logic [4:0] WE,EXE_WE_out,WE_out,M_WE_out;
logic [4:0] M,EXE_M_out,forward_EX_rs1,forward_EX_rs2,forward_EX_rd,forward_M_rd,forward_WE_rd;
logic M_out;
logic [3:0] DM_wen_temp;
logic [3:0] hazard_jump_sel;
logic [2:0]counter,sel;
logic WFI,MEIP_MTIP,MRET,interrupt,q,sen_pulse;
logic WTO_reg;

assign PC_4=PC_out+32'd4;
assign jump_PC_4=jump_PC+32'd4;
assign MTVEC_4=MTVEC+32'd4;
assign MEPC_4=MEPC+32'd4;
assign hazard_jump_sel={MRET,q,stall,B_type_JALR_hazard_PC[0]};
assign sel={MRET,q,B_type_JALR_hazard_PC[0]};

assign IM_raddr=IM_read_addr;
assign IM_ren=(counter>=3'd6)?1'd1:1'd0;
assign DM_addr=ALU_result;
assign DM_ren=EXE_M_out[4];
assign DM_wdata=rs2_temp_out;
assign DM_wen=DM_wen_temp;
assign q=sen_pulse || WTO_reg;

always_ff@(posedge clk) begin
	if(rst) WTO_reg<=1'd0;
	else if (WTO==1'd1) WTO_reg<= 1'd1;
	else if (waiting==1'd1) WTO_reg<=WTO_reg;
	else WTO_reg<=1'd0;
end


always_ff @( posedge clk) begin 
    if(rst) counter<=3'd0;
    else begin
		if(counter==3'd6) counter<=3'd6;
		else counter<=counter+3'd1;
	end
end

always_ff @( posedge clk) begin 
    if(rst) begin
		interrupt<=1'd0;
	end
    else interrupt <= MEIP_MTIP; // MEIP_MTIP is from CSR for sctrl_interrupt
end

always_ff @( posedge clk) begin
	if(rst) sen_pulse<=1'd0;
	else if(interrupt==1'd0 && MEIP_MTIP==1'd1 && WFI==1'd1) sen_pulse<=1'd1;
	else if(waiting) sen_pulse<=sen_pulse;
	else sen_pulse<=1'd0;
end

store_data_shift store_data_shift0(
	.ALU_out_10(ALU_result[1:0]),
	.EXE_M_wen(EXE_M_out[3:0]),
	.rs2_temp(rs2_temp),
	.rs2_temp_out(rs2_temp_out),
	.EXE_M_wen_out(DM_wen_temp)
);

Mux8_1 Mux8_1_0(
	.I0(PC_4),
	.I1(jump_PC_4),
	.I2(MTVEC_4),
	.I3(MTVEC_4),
	.I4(MEPC_4),
	.I5(MEPC_4),
	.I6(MEPC_4),
	.I7(MEPC_4),
	.sel(sel),
	.out(PC_in)
);

PC PC0(
	.clk(clk),
    .rst(rst),
    .stall(stall),
    .in(PC_in),
    .out(PC_out),
	.waiting(waiting),
	.WFI(WFI),
	.sen_pulse(sen_pulse)
);

PC_delay PC_delay0(
	.clk(clk),
    .rst(rst),
    .in(IM_read_addr),
    .out(IF_ID_PC_in),
	.waiting(waiting)
);

Mux16_1 Mux16_1_0(
	.I0(PC_out),
	.I1(jump_PC),
	.I2(IF_ID_PC_in),
	.I3(IF_ID_PC_in),
	.I4(MTVEC),
	.I5(MTVEC),
	.I6(MTVEC),
	.I7(MTVEC),
	.I8(MEPC),
	.I9(MEPC),
	.I10(MEPC),
	.I11(MEPC),
	.I12(MEPC),
	.I13(MEPC),
	.I14(MEPC),
	.I15(MEPC),
	.sel(hazard_jump_sel),
	.out(IM_read_addr)
);
/*
SRAM_wrapper IM1(
	.CK(clk),
	.CS(1'b1),
	.OE(1'b1),
	.WEB(4'b1111),
	.A(IM_read_addr[15:2]),
	.DI(32'd0),
	.DO(Instruction)
);
*/
IF_ID IF_ID0(
	.clk(clk),
    .rst(rst),
    .flush(B_type_JALR_hazard_PC[0]),
    .instruction_in(IM_rdata),
    .instruction_out(instruction),
    .PC_in(IF_ID_PC_in),
    .stall(stall),
    .PC_out(PC_curr),
	.waiting(waiting),
	.WFI(WFI),
	.MRET(MRET),
	.p(q)
);

Hazard_detector Hazard_detector0(
	.clk(clk),
	.rst(rst),
	.EX_Mread(EXE_M_out[4]),
    .EX_rd(forward_EX_rd),
    .ID_rs1(instruction[19:15]),
    .ID_rs2(instruction[24:20]),
    .M_Mread(M_out),
    .M_rd(forward_M_rd),
    .EX_regwrite(EXE_WE_out[1]),
    .B_type_JALR(B_type_JALR_hazard_PC[1]),
    .stall(stall)
);

Control Control0(
	.clk(clk),
	.rst(rst),
	.instruction(instruction),
    .brantch_take(comparator_out),
    .EX(EX),
    .M(M),
    .WE(WE),
    .B_type_JALR_hazard_PC(B_type_JALR_hazard_PC),
    .JALR_mux(JALR_mux),
	.WFI_reg(WFI),
	.MRET(MRET),
	.sctrl_interrupt(sctrl_interrupt)
);

Mux2_1 Mux2_1_2(
	.I0(reg1data),
	.I1(M_ALU_result),
	.sel(forward_ID_JALR),
	.out(reg1out)
);

Mux2_1 Mux2_1_3(
	.I0(PC_curr),
	.I1(reg1out),
	.sel(JALR_mux),
	.out(PC_rs1)
);

assign jump_PC=imm_result+PC_rs1;

Reg_file Reg_file0(
	.clk(clk),
    .rst(rst),
    .read_reg1(instruction[19:15]),
    .outdata1(reg1data),
    .read_reg2(instruction[24:20]),
    .outdata2(reg2data),
    .write_reg(forward_WE_rd),
    .write_data(WE_result),
    .waiting(waiting),
	.Regwrite(WE_out[3:1])
);

Imm_generator Imm_generator0(
	.instruction(instruction),
    .imm_result(imm_result)
);

Mux2_1 Mux2_14(
	.I0(reg1data),
    .I1(M_ALU_result),
    .sel(forward_ID_comp_rs1),
    .out(comp_in1)
);

Mux2_1 Mux2_15(
	.I0(reg2data),
    .I1(M_ALU_result),
    .sel(forward_ID_comp_rs2),
    .out(comp_in2)
);

Comparator Comparator0(
	.in_1(comp_in1),
    .in_2(comp_in2),
	.funct3(instruction[14:12]),
    .branch_take(comparator_out)
);

ID_EXE ID_EXE(
	.clk(clk),
    .rst(rst),
    .EX_in(EX),
    .EX_out(EX_out),
    .M_in(M),
    .M_out(EXE_M_out),
    .WE_in(WE),
    .WE_out(EXE_WE_out),
    .PC_in(PC_curr),
    .PC_out(EXE_PC_out),
    .indata1(reg1data),
    .outdata1(EXE_reg1data),
    .indata2(reg2data),
    .outdata2(EXE_reg2data),
    .imm_in(imm_result),
    .imm_out(EXE_imm),
    .forward_EX_rs1_in(instruction[19:15]),
    .forward_EX_rs1_out(forward_EX_rs1),
    .forward_EX_rs2_in(instruction[24:20]),
    .forward_EX_rs2_out(forward_EX_rs2),
    .forward_rd_in(instruction[11:7]),
    .forward_rd_out(forward_EX_rd),
    .flush(stall),
	.waiting(waiting),
	.WFI(WFI)
);

Mux4_1 Mux4_11(
	.I0(EXE_reg1data),
    .I1(M_ALU_result),
    .I2(WE_result),
    .I3(M_ALU_result),
    .sel(forward_out_EX_rs1),
    .out(rs1_temp)
);

Mux4_1 Mux4_12(
	.I0(rs1_temp),
    .I1(EXE_PC_out),
    .I2(CSR_out),
    .I3(32'd0),
    .sel(EX_out[7:6]),
    .out(ALU_in1)
);

Mux4_1 Mux4_13(
	.I0(EXE_reg2data),
    .I1(M_ALU_result),
    .I2(WE_result),
    .I3(M_ALU_result),
    .sel(forward_out_EX_rs2),
    .out(rs2_temp)
);

Mux4_1 Mux4_14(
	.I0(rs2_temp),
    .I1(EXE_imm),
    .I2(32'd0),
    .I3(32'd4),
    .sel(EX_out[5:4]),
    .out(ALU_in2)
);

ALU ALU0(
	.rs1(ALU_in1),
    .rs2(ALU_in2),
    .ALUop(EX_out[3:0]),
    .result(ALU_result)
);

CSR CSR0(
	.clk(clk),
    .rst(rst),
    .branch_take(B_type_JALR_hazard_PC[0]),
    .stall(stall),
    .CSR_sel(EX_out[17:8]),
    .out(CSR_out),
	.waiting(waiting),
	.imm(EXE_imm[31:20]),
	.rs1(rs1_temp),
	.WTO(WTO_reg),
	.sctrl_interrupt(sctrl_interrupt),
	.PC_out(PC_out),
	.MEIP_MTIP(MEIP_MTIP),
	.MTVEC(MTVEC),
	.MEPC(MEPC),
	.q(q),
	.WFI(WFI)
);

Forwarding Forwarding0(
	.ID_rs1(instruction[19:15]),
	.ID_rs2(instruction[24:20]),
	.EX_rs1(forward_EX_rs1),
	.EX_rs2(forward_EX_rs2),
	.M_rd(forward_M_rd),
	.WE_rd(forward_WE_rd),
	.M_regwrite(M_WE_out[1]),
	.WE_regwrite(WE_out[1]),
	.forward_EX_rs1(forward_out_EX_rs1),
	.forward_EX_rs2(forward_out_EX_rs2),
	.forward_ID_comp_rs1(forward_ID_comp_rs1),
	.forward_ID_comp_rs2(forward_ID_comp_rs2),
	.forward_ID_JALR(forward_ID_JALR)
);

EXE_MEM EXE_MEM0(
	.clk(clk),
    .rst(rst),
    .WE_in(EXE_WE_out),
    .WE_out(M_WE_out),
    .M_in_read(EXE_M_out[4]),
    .M_out_read(M_out),
    .ALU_in(ALU_result),
    .ALU_out(M_ALU_result),
    /*.sr2_data_in(rs2_temp),
    .sr2_data_out(rs2_temp_out),*/
    .forward_rd_in(forward_EX_rd),
    .forward_rd_out(forward_M_rd),
	.waiting(waiting)
);

/*SRAM_wrapper DM1(
	.CK(clk),
	.CS(1'b1),
	.OE(M_out[4]),
	.WEB(M_out[3:0]),
	.A(M_ALU_result[15:2]),
	.DI(rs2_temp_out),
	.DO(load_data_out)
);*/

MEM_WB MEM_WB0(
	.clk(clk),
    .rst(rst),
    .WE_in(M_WE_out),
    .WE_out(WE_out),
    .ALU_in(M_ALU_result),
    .ALU_out(M_ALU_result_out),
    .forward_rd_in(forward_M_rd),
    .forward_rd_out(forward_WE_rd),
	.DM_data_out(DM_data_out),
	.DM_data_in(DM_rdata),
	.waiting(waiting)
);

LH_LB_shift LH_LB_shift1(
	.Regsign(WE_out[4]),
    .Regwrite(WE_out[3:1]),
    .write_data(DM_data_out),
	.addr_10(M_ALU_result_out[1:0]),
	.write_data_out(write_data_out),
	.write_reg(forward_WE_rd)
);

Mux2_1 Mux2_16(
	.I0(write_data_out),
    .I1(M_ALU_result_out),
    .sel(WE_out[0]),
    .out(WE_result)
);
endmodule
