`include "Adder.sv"
`include "Mux.sv"
`include "Reg_PC.sv"
`include "Decoder.sv"
//`include "Controller.sv"
`include "Imm_Ext.sv"
//`include "SRAM_Wrapper.sv"
`include "ALU.sv"
`include "JB_Unit.sv"
`include "LD_Filter.sv"
`include "Mux3.sv"
`include "Reg_D.sv"
`include "Reg_E.sv"
`include "Reg_M.sv"
`include "Reg_W.sv"
`include "RegFile.sv"
`include "CSR.sv"
`include "Shift_Addr.sv"
`include "Controller_jb_stall.sv"
`include "Controller_D.sv"
`include "Controller_E.sv"
`include "Controller_M.sv"
`include "Controller_W.sv"
`include "Overlap.sv"
//`include "Stall.sv"
//`include "Define.sv"

module CPU(
    input logic clk,
    input logic rst,

    input logic stall_AXI,
	input [31:0] IM_DO,
	input [31:0] DM_DO,

	output logic DM_OE,
	output logic[31:0]  IM_A,
	output logic [3:0]  DM_WEB,
	output logic [31:0] DM_A,
	output logic [31:0] DM_DI    
);

    // -----------------Control signal-------------------
    logic stall_CPU; 
    logic jb;

    //logic [3:0] F_im_w_en;
    //logic F_im_cs;

    logic  D_rs1_data_sel;
    logic  D_rs2_data_sel;

    logic [1:0] E_rs1_data_sel;
    logic [1:0] E_rs2_data_sel;
    logic E_jb_op1_sel;
    
    logic E_alu_op1_sel;
    logic E_alu_op2_sel;
    logic [4:0] E_op;
    logic [1:0] E_f7;
    logic [2:0] E_f3;

    logic [3:0] M_dm_w_en;
    logic M_dm_OE;

    logic  W_wb_en;
    logic [4:0] W_rd_index;
    logic [2:0] W_f3;
    logic [1:0] W_wb_data_sel;

    logic [1:0] stall_jb_sel;

    // ----------------------Data path-------------------
    logic [31:0] current_pc;
    logic [31:0] next_pc;

    logic [31:0] jb_pc;
    logic [31:0] current_pc_add4;

    logic [31:0] IM_inst_out;
    logic [31:0] IM_stall_inst_M;
    logic [31:0] IM_stall_inst_D;
    logic [1:0] stall_jc_sel;
    logic [31:0] inst_decode;

    logic [31:0] D_pc;

    logic [4:0] rs1_index;
    logic [4:0] rs2_index;
    logic [1:0] decoder_to_csr;

    logic [4:0] opcode;
    logic [2:0] func3;
    logic [1:0] func7;
    logic OE_info;   //****

    logic [4:0] rd_index;

    logic [31:0] imm_ext_out;

    logic [31:0] regf_rs1_data;
    logic [31:0] regf_rs2_data;

    logic [31:0] D_rs1_data;
    logic [31:0] D_rs2_data;

    logic [31:0] csr_out;

    logic [31:0] E_pc_out;
    logic [31:0] E_rs1_out;
    logic [31:0] E_rs2_out;
    logic [31:0] E_imm_out;
    logic [31:0] E_csr_out;

    logic [31:0] E_rs1_data;

    logic [31:0] E_rs2_data;

    logic [31:0] alu_in1;
    logic [31:0] alu_in2;

    logic [31:0] jb_unit_pc;

    logic [31:0] alu_out;

    logic [31:0] sa_out;

    logic [31:0] M_aluout_out;
    logic [31:0] DM_data_in;
    logic [31:0] M_csr_out;

    logic [31:0] DM_data_out;

    logic [31:0] W_aluout_out;
    logic [31:0] ld_filter_out;
    logic [31:0] W_csr_out;

    logic [31:0] wb_data;

    logic [4:0] E_op_M;
    logic [2:0] E_f3_M;
    logic [4:0] E_rd_M;
    logic [4:0] E_rs1_index_out;
    logic [4:0] E_rs2_index_out;
    logic [1:0] E_f7_out;

    logic E_OE_M; //******

    logic [4:0] M_op_W;
    logic [2:0] M_f3_W;
    logic [4:0] M_rd_W;  

    logic [4:0] W_op_C;
    logic [2:0] W_f3_C;
    logic [4:0] W_rd_C;

    logic D_use_rs1_E;
    logic D_use_rs2_E;
    logic D_use_rd_E;

    logic E_use_rs1_M;
    logic E_use_rs2_M;
    logic E_use_rd_M;

    logic M_use_rs1_W;
    logic M_use_rs2_W;
    logic M_use_rd_W;

    logic M_OE_C; //******

    logic W_use_rd_C;

    // ************* Assign CPU Outputs to CPU Wrappper ************* //
    //assign  IM_DO       =   IM_inst_out;
    assign  IM_inst_out =   IM_DO;
    //assign  DM_DO       =   DM_data_out;
    assign  DM_data_out =   DM_DO;
    
    assign  DM_OE       =   M_dm_OE;
	assign  IM_A        =   current_pc;
	assign  DM_WEB      =   M_dm_w_en;
	assign  DM_A        =   M_aluout_out;
	assign  DM_DI       =   DM_data_in;
    // ----------------------------------------------------------------- //
    //assign  stall    =   stall_CPU || stall_AXI;

    Adder Adder(
        .data_1(current_pc),
        .data_2(32'd4),
        .data_out(current_pc_add4)
    );
    Mux Mux_PC(
        .data_in1(jb_pc),
        .data_in2(current_pc_add4),
        .select_line(jb),
        .data_out(next_pc) 
    );
    Reg_PC Reg_PC(
        .clk(clk),
        .rst(rst),
        .next_pc(next_pc),
        .stall_CPU(stall_CPU),
        .stall_AXI(stall_AXI),
        .current_pc(current_pc)
    );

    /*SRAM_wrapper IM1(  //IM
        .CK(clk),
        .CS(1'b1),
        .OE(1'd1),
        .WEB(4'b1111),
        .A(current_pc[15:2]),
        .DI(32'b0),
        .DO(IM_inst_out)
    );*/


    Mux3 Mux_IMDO(
    .data_in1(IM_stall_inst_D),
    .data_in2(IM_inst_out),
    .data_in3(32'd0),
    .select_line(stall_jb_sel),
    .data_out(inst_decode)
    );


    Reg_D Reg_D(
        .clk(clk),
        .rst(rst),
        .stall_CPU(stall_CPU),
        .stall_AXI(stall_AXI),
        .jb(jb),
        .D_pc_in(current_pc),
        .DO_mux3_out(inst_decode),
        .D_pc_out(D_pc),
        .stall_inst(IM_stall_inst_D),
        .D_stall_jb_flush(stall_jb_sel)
    );

    Decoder Decoder(
        .inst(inst_decode),
        .dc_out_opcode(opcode),
        .dc_out_func3(func3),
        .dc_out_func7(func7),
        .dc_out_rs1_index(rs1_index),
        .dc_out_rs2_index(rs2_index),
        .dc_out_rd_index(rd_index),
        .dc_out_csr_info(decoder_to_csr),
        .dc_out_OE_info(OE_info)
    );
    Imm_Ext Imm_Ext(
        .inst(inst_decode),
        .imm_ext_out(imm_ext_out)
    );

    Overlap Overlap(
        .opcode(opcode),
        .inst_use_rs1(D_use_rs1_E),
        .inst_use_rs2(D_use_rs2_E),
        .inst_use_rd(D_use_rd_E)
    );


    Controller_jb_stall Controller_jb_stall(
        .opcode(opcode),
        .dc_rs1(rs1_index),
        .dc_rs2(rs2_index),
        .alu_out(alu_out[0]),
        .E_op(E_op_M),
        .E_rd(E_rd_M),
        .is_D_use_rs1(D_use_rs1_E),
        .is_D_use_rs2(D_use_rs2_E),
        .next_pc_sel(jb),
        .stall_CPU(stall_CPU)
    );

    Controller_D Controller_D(
        .opcode(opcode),
        .dc_rs1(rs1_index),
        .dc_rs2(rs2_index),
        .E_op(E_op_M),
        .E_rd(E_rd_M),
        .W_op(W_op_C),
        .W_rd(W_rd_C),
        .is_D_use_rs1(D_use_rs1_E),  //****
        .is_D_use_rs2(D_use_rs2_E),
        .is_W_use_rd(W_use_rd_C),
        .D_rs1_data_sel(D_rs1_data_sel),
        .D_rs2_data_sel(D_rs2_data_sel)
    );

    Controller_E Controller_E(
        .E_op(E_op_M),
        .E_f3(E_f3_M),
        .E_rd(E_rd_M),
        .E_rs1(E_rs1_index_out),
        .E_rs2(E_rs2_index_out),
        .E_f7(E_f7_out),
        .M_op(M_op_W),
        .M_rd(M_rd_W),
        .W_op(W_op_C),
        .W_rd(W_rd_C),

        .is_E_use_rs1(E_use_rs1_M),
        .is_E_use_rs2(E_use_rs2_M),
        .is_M_use_rd(M_use_rd_W),
        .is_W_use_rd(W_use_rd_C),

        .E_rs1_data_sel(E_rs1_data_sel),
        .E_rs2_data_sel(E_rs2_data_sel),
        .E_alu_op1_sel(E_alu_op1_sel),
        .E_alu_op2_sel(E_alu_op2_sel),
        .E_jb_op1_sel(E_jb_op1_sel),
        .E_op_out(E_op),
        .E_f3_out(E_f3),
        .E_f7_out(E_f7)
    );


    Controller_M Controller_M(
        .Reg_M_alu_out(M_aluout_out[1:0]),
        .M_op(M_op_W),
        .M_f3(M_f3_W),
        .M_OE_info(M_OE_C),
        .M_dm_w_en(M_dm_w_en),
        .M_dm_OE(M_dm_OE)
    );

    Controller_W Controller_W(
        .W_op(W_op_C),
        .W_f3(W_f3_C),
        .W_rd(W_rd_C),
        .W_wb_en(W_wb_en),
        .W_rd_index(W_rd_index),
        .W_f3_out(W_f3),
        .W_wb_data_sel(W_wb_data_sel)
    );


    RegFile regfile(
        .clk(clk),
        //.rst(rst),
        .wb_en(W_wb_en),
        .wb_data(wb_data),
        .rd_index(W_rd_index),
        .rs1_index(rs1_index),
        .rs2_index(rs2_index),
        .rs1_data_out(regf_rs1_data),
        .rs2_data_out(regf_rs2_data)
    );



    Mux Mux_rs1data(
        .data_in1(wb_data),
        .data_in2(regf_rs1_data),
        .select_line(D_rs1_data_sel),
        .data_out(D_rs1_data)
    );
    Mux Mux_rs2data(
        .data_in1(wb_data),
        .data_in2(regf_rs2_data),
        .select_line(D_rs2_data_sel),
        .data_out(D_rs2_data)
    );

    Reg_E Reg_E(
        .clk(clk),
        .rst(rst),
        .stall_CPU(stall_CPU),
        .stall_AXI(stall_AXI),
        .jb(jb),
        .E_pc_in(D_pc),
        .E_rs1_in(D_rs1_data),
        .E_rs2_in(D_rs2_data),
        .E_imm_in(imm_ext_out),
        .E_csr_in(csr_out),

        .E_op_in(opcode),  //****
        .E_f3_in(func3),
        .E_rd_in(rd_index),
        .E_rs1_index_in(rs1_index),
        .E_rs2_index_in(rs2_index),
        .E_f7_in(func7),   // *****

        .E_use_rs1_in(D_use_rs1_E),
        .E_use_rs2_in(D_use_rs2_E),
        .E_use_rd_in(D_use_rd_E),

        .E_OE_info_in(OE_info),

        .E_pc_out(E_pc_out),
        .E_rs1_out(E_rs1_out),
        .E_rs2_out(E_rs2_out),
        .E_imm_out(E_imm_out),
        .E_csr_out(E_csr_out),

  
        .E_op_out(E_op_M),
        .E_f3_out(E_f3_M),
        .E_rd_out(E_rd_M), //***
        .E_rs1_index_out(E_rs1_index_out),
        .E_rs2_index_out(E_rs2_index_out),
        .E_f7_out(E_f7_out),

        .E_use_rs1_out(E_use_rs1_M),
        .E_use_rs2_out(E_use_rs2_M),
        .E_use_rd_out(E_use_rd_M),

        .E_OE_info_out(E_OE_M)
    );

    Mux3 Mux3_rs1data(
        .data_in1(wb_data),
        .data_in2(M_aluout_out),
        .data_in3(E_rs1_out),
        .select_line(E_rs1_data_sel),
        .data_out(E_rs1_data)
    );
    Mux3 Mux3_rs2data(
        .data_in1(wb_data),
        .data_in2(M_aluout_out),
        .data_in3(E_rs2_out),
        .select_line(E_rs2_data_sel),
        .data_out(E_rs2_data)
    );
    Mux Mux_rs1(
        .data_in1(E_rs1_data),
        .data_in2(E_pc_out),
        .select_line(E_alu_op1_sel),
        .data_out(alu_in1) 
    );
    Mux Mux_rs2(
        .data_in1(E_rs2_data),
        .data_in2(E_imm_out),
        .select_line(E_alu_op2_sel),
        .data_out(alu_in2) 
    );
    Mux Mux_JB(
        .data_in1(E_rs1_data),
        .data_in2(E_pc_out),
        .select_line(E_jb_op1_sel),
        .data_out(jb_unit_pc)  
    );
    ALU ALU(
        .opcode(E_op),
        .func3(E_f3),
        .func7(E_f7),
        .operand1(alu_in1),
        .operand2(alu_in2),
        .alu_out(alu_out)
    );
    JB_Unit JB_Unit(
        .operand1(jb_unit_pc),
        .operand2(E_imm_out),
        .jb_out(jb_pc)
    );

    Shift_Addr Shift_Addr(
        .func3(E_f3),
        .shift_addr_sel(alu_out[1:0]),
        .addr_in(E_rs2_data),
        .addr_out(sa_out)
    );

    Reg_M Reg_M(
        .clk(clk),
        .rst(rst),
        .stall_AXI(stall_AXI),

        .M_aluout_in(alu_out),
        .M_rs2_in(sa_out),
        .M_csr_in(E_csr_out),

        .M_op_in(E_op_M), //****
        .M_f3_in(E_f3_M),
        .M_rd_in(E_rd_M),

        .M_OE_info_in(E_OE_M),

        .M_use_rs1_in(E_use_rs1_M),
        .M_use_rs2_in(E_use_rs2_M),
        .M_use_rd_in(E_use_rd_M),

        .M_aluout_out(M_aluout_out),
        .M_rs2_out(DM_data_in),
        .M_csr_out(M_csr_out),

        .M_op_out(M_op_W),  //*****
        .M_f3_out(M_f3_W),
        .M_rd_out(M_rd_W),

        .M_use_rs1_out(M_use_rs1_W),
        .M_use_rs2_out(M_use_rs2_W),
        .M_use_rd_out(M_use_rd_W),

        .M_OE_info_out(M_OE_C)
    );

    /*SRAM_wrapper DM1(
        .CK(clk),
        .CS(1'b1),
        .OE(M_dm_cs),
        .WEB(M_dm_w_en),
        .A(M_aluout_out[15:2]),
        .DI(DM_data_in),
        .DO(DM_data_out)
    );*/

    Reg_W Reg_W(
        .clk(clk),
        .rst(rst),
        .stall_AXI(stall_AXI),

        .W_aluout_in(M_aluout_out),
        .W_csr_in(M_csr_out),

        .W_op_in(M_op_W), //****
        .W_f3_in(M_f3_W),
        .W_rd_in(M_rd_W),

        .W_use_rs1_in(M_use_rs1_W),
        .W_use_rs2_in(M_use_rs2_W),
        .W_use_rd_in(M_use_rd_W),
    
        .W_aluout_out(W_aluout_out),
        .W_csr_out(W_csr_out),

        .W_op_out(W_op_C), //****
        .W_f3_out(W_f3_C),
        .W_rd_out(W_rd_C),

        //.W_use_rs1_out(W_use_rs1_C),
        //.W_use_rs2_out(W_use_rs2_C),
        .W_use_rd_out(W_use_rd_C)
    
    );

    LD_Filter LD_Filter(
        .func3(W_f3),
        .ld_data(DM_data_out),
        .ld_data_f(ld_filter_out)
    );

    Mux3 Mux_wb(
        .data_in1(W_aluout_out),
        .data_in2(ld_filter_out),
        .data_in3(W_csr_out),
        .select_line(W_wb_data_sel),
        .data_out(wb_data)  
    );

    CSR CSR(
     .clk(clk),
     .rst(rst),
     .stall_controller(stall_CPU),
     .stall_AXI(stall_AXI),
     .jb(jb),
     .CSR_in(decoder_to_csr),
     .CSR_out(csr_out)

    );
 

    /*CSR CSR(
        .clk(clk),
        .rst(rst),
        .csr_info(decoder_to_csr),
        .stall_AXI(stall_AXI),
        .stall_CPU(stall_CPU),
        .jb(jb),
        .csr_data_out(csr_out)
    );*/

    /*Stall Stall(
        .stall_CPU(stall_CPU),
        .stall_AXI(stall_AXI),
        .stall(stall)
    );*/

endmodule


