//================================================
// Auther:      Lin Meng-Yu            
// Filename:    CPU.sv                            
// Description: Top module of CPU                
// Version:     HW3 Submit Version
// Date:        2023/11/23
//================================================

`include "Adder.sv"
`include "Mux.sv"
`include "Reg_PC.sv"
`include "Decoder.sv"
`include "Imm_Ext.sv"
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
`include "Controller_CSR.sv"
`include "CSR_Forwarding.sv"
`include "ALU_CSR.sv"
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
	output logic [31:0] DM_DI,    

    input logic Interrupt_SCtrl,
    input logic WTO
);

    // **************** Wire Declaration ***************** //
    // -----------------Control signal-------------------
    logic stall_CPU; 
    logic jb;

    logic  D_rs1_data_sel;
    logic  [1:0] D_rs2_data_sel;

    logic [1:0] E_rs1_data_sel;
    logic [1:0] E_rs2_data_sel;

    logic E_jb_op1_sel;

    logic E_csr_rs2_data_sel;
    
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

    logic E_MRET;          // *** New
    logic E_WFI;
    logic ext_interrupt;   // *** New
    logic tim_interrupt;   // *** New
    //logic sctrl_interrupt;  // *** New
    //logic wdt_interrupt;   // *** New

    logic csr_write_en;    // *** New
    logic csr_MRET;
    logic csr_WFI;
    logic csr_op1_sel;
    logic [1:0] csr_alu_op;
    logic flush;           // *** New 

    logic E_csr_op1_sel_out;
    logic [1:0] E_csr_alu_op_out;
    logic [1:0] csr_op2_sel;

    // ----------------------Data path-------------------
    logic [31:0] current_pc;
    logic [31:0] next_pc;
    logic [31:0] Reg_pc_out; 
    logic [31:0] mtvec;      
    logic [31:0] mepc;      
    logic [31:0] Reg_pc_in;

    logic [31:0] jb_pc;
    logic [31:0] current_pc_add4;

    logic [31:0] IM_inst_out;
    logic [31:0] IM_stall_inst_M;
    logic [31:0] IM_stall_inst_D;
    logic [1:0] stall_jc_sel;
    logic [31:0] inst_decode;

    logic [31:0] csr_op_imm_out; // *** //

    logic [31:0] D_pc_out;

    logic [4:0] rs1_index;
    logic [4:0] rs2_index;

    logic [21:0] csr_info;   
    logic [11:0] csr_imm;    

    logic [4:0] opcode;
    logic [2:0] func3;
    logic [1:0] func7;
    logic OE_info;   

    logic [4:0] rd_index;

    logic [31:0] imm_ext_out;

    logic [31:0] regf_rs1_data;
    logic [31:0] regf_rs2_data;

    logic [31:0] D_rs1_data;
    logic [31:0] D_rs2_data;

    logic [31:0] csr_out;
    //logic [31:0] csr_read_data;

    logic [31:0] E_pc_out;
    logic [31:0] E_rs1_out;
    logic [31:0] E_rs2_out;
    logic [31:0] E_imm_out;
    logic [31:0] E_csr_out;

    logic [11:0] E_csr_write_addr_out;   
    logic E_csr_write_en_out;            

    logic [31:0] E_csr_op_imm_out;  // *** // 

    logic [31:0] E_rs1_data;

    logic [31:0] E_rs2_data;

    //logic [31:0] E_rs1_data_f;
    //logic [31:0] E_rs2_data_f;


    logic [31:0] alu_in1;
    logic [31:0] alu_in2;

    logic [31:0] jb_unit_pc;

    logic [31:0] E_pc_add4;

    logic [31:0] alu_out;

    logic [31:0] csr_alu_in1;
    logic [31:0] csr_alu_in2;
    logic [31:0] csr_alu_out;

    logic [31:0] sa_out;

    logic [31:0] M_aluout_out;

    //logic [31:0] M_aluout_out_f;  //*** New ***//

    logic [31:0] DM_data_in;
    //logic [31:0] DM_data_in_f;    //*** New ***//
  
    logic [31:0] M_csr_out;

    logic [11:0] M_csr_write_addr_out;   
    logic M_csr_write_en_out;            

    logic [31:0] DM_data_out;

    logic [31:0] W_aluout_out;
    logic [31:0] ld_filter_out;
    logic [31:0] W_csr_out;

    logic W_csr_write_en_out;              
    logic [11:0] W_csr_write_addr_out;     

    logic [31:0] wb_data;

    logic [4:0] E_op_M;
    logic [2:0] E_f3_M;
    logic [4:0] E_rd_M;
    logic [4:0] E_rs1_index_out;
    logic [4:0] E_rs2_index_out;
    logic [1:0] E_f7_out;

    logic E_OE_M; 

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

    logic M_OE_C; 

    logic W_use_rd_C;

    logic [31:0] Mux3_csr1_out;  // ***New!!!!

    // ************* Assign CPU Outputs to CPU Wrappper ************* //
    assign  IM_inst_out =   IM_DO;
    assign  DM_data_out =   DM_DO;
    
    assign  DM_OE       =   M_dm_OE;
	assign  IM_A        =   Reg_pc_out;
	assign  DM_WEB      =   M_dm_w_en;
	assign  DM_A        =   M_aluout_out;
	assign  DM_DI       =   DM_data_in;
    // ----------------------------------------------------------------- //
    
    // --------------------------- IF Stage -------------------------- //
    Adder Adder(
        .data_1(Reg_pc_out),
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
        .next_pc(Reg_pc_in),
        .stall_CPU(stall_CPU),
        .stall_AXI(stall_AXI),
        .tim_interrupt(tim_interrupt),       // *** New
        .Reg_pc_out(Reg_pc_out)              // *** Mod
    );

    Mux3 Mux_PC_Interrupt(
        .data_in1(next_pc),
        .data_in2(mtvec),
        .data_in3(mepc),
        .select_line({E_MRET, ext_interrupt}),
        .data_out(Reg_pc_in)
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
        .E_imm_out(E_imm_out[11:0]),        // Special Case: For mtvec add
        .next_pc_sel(jb),
        .stall_CPU(stall_CPU)
    );

    // --------------------------- IF Stage -------------------------- //

    // --------------------------- ID Stage -------------------------- //

    Controller_D Controller_D(
        .opcode(opcode),
        .dc_rs1(rs1_index),
        .dc_rs2(rs2_index),
        .E_op(E_op_M),
        .E_rd(E_rd_M),
        .W_op(W_op_C),
        .W_rd(W_rd_C),
        .M_op(M_op_W),      /***/
        .is_D_use_rs1(D_use_rs1_E),  
        .is_D_use_rs2(D_use_rs2_E),
        .is_W_use_rd(W_use_rd_C),
        .D_rs1_data_sel(D_rs1_data_sel),
        .D_rs2_data_sel(D_rs2_data_sel)
    );

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
        .flush(flush),                      
        .D_pc_in(Reg_pc_out),
        .DO_mux3_out(inst_decode),
        .tim_interrupt(tim_interrupt),     
        .D_pc_out(D_pc_out),
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
        .dc_out_csr_info(csr_info),
        .dc_out_csr_imm(csr_imm),
        .dc_out_csr_op_imm(csr_op_imm_out),
        .dc_out_OE_info(OE_info)
    );

    Imm_Ext Imm_Ext(
        .inst(inst_decode),
        .imm_ext_out(imm_ext_out)
    );

    RegFile Regfile(
        .clk(clk),
        .rst(rst),
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
    Mux3 Mux_rs2data(
        .data_in1(regf_rs2_data),
        .data_in2(wb_data),
        .data_in3(csr_alu_out),
        .select_line(D_rs2_data_sel),
        .data_out(D_rs2_data)
    );

    CSR CSR(                        
        .clk(clk),
        .rst(rst),
        .jb(jb),
        .stall_CPU(stall_CPU),
        .stall_AXI(stall_AXI),
        .sctrl_interrupt(Interrupt_SCtrl),
        .wdt_interrupt(WTO),
        .E_WFI(E_WFI),
        .E_MRET(E_MRET),
        .E_pc_add4(E_pc_add4),
        .CSR_read_addr(csr_imm),
        .E_CSR_write_addr(E_csr_write_addr_out),
        .E_CSR_write_data(csr_alu_out),
        .E_CSR_write_en(E_csr_write_en_out),
        .CSR_read_data(csr_out),
        .mtvec(mtvec),
        .mepc(mepc),
        .ext_interrupt(ext_interrupt),
        .tim_interrupt(tim_interrupt)
    );

    Controller_CSR Controller_CSR(  // ***New ***
        .CSR_info(csr_info),
        .ext_interrupt(ext_interrupt),
        .tim_interrupt(tim_interrupt),
        .E_MRET(E_MRET),
        .CSR_write_en(csr_write_en),
        .CSR_MRET(csr_MRET),
        .CSR_WFI(csr_WFI),
        .CSR_op1_sel(csr_op1_sel),
        .CSR_ALU_op(csr_alu_op),
        .flush(flush)
    );

    Overlap Overlap(
        .opcode(opcode),
        .inst_use_rs1(D_use_rs1_E),
        .inst_use_rs2(D_use_rs2_E),
        .inst_use_rd(D_use_rd_E)
    );

    // --------------------------- ID Stage -------------------------- //

    // --------------------------- EX Stage -------------------------- //
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
        .E_rs2_data_sel(E_rs2_data_sel), // *** //
        .E_alu_op1_sel(E_alu_op1_sel),
        .E_alu_op2_sel(E_alu_op2_sel),
        .E_jb_op1_sel(E_jb_op1_sel),

        //.E_csr_rs2_data_sel(E_csr_rs2_data_sel), // For CSR <-> rs2 store address forwarding

        .E_op_out(E_op),
        .E_f3_out(E_f3),
        .E_f7_out(E_f7)
    );

    Reg_E Reg_E(
        .clk(clk),
        .rst(rst),
        .stall_CPU(stall_CPU),
        .stall_AXI(stall_AXI),
        .jb(jb),
        .tim_interrupt(tim_interrupt),  
        .flush(flush),                  
        .E_pc_in(D_pc_out),
        .E_rs1_in(D_rs1_data),
        .E_rs2_in(D_rs2_data),
        .E_imm_in(imm_ext_out),
        //.E_csr_in(csr_out),

        .E_op_in(opcode), 
        .E_f3_in(func3),
        .E_rd_in(rd_index),
        .E_rs1_index_in(rs1_index),
        .E_rs2_index_in(rs2_index),
        .E_f7_in(func7),   

        .E_use_rs1_in(D_use_rs1_E),
        .E_use_rs2_in(D_use_rs2_E),
        .E_use_rd_in(D_use_rd_E),

        .E_OE_info_in(OE_info),
        .E_CSR_write_addr_in(csr_imm),            
        .E_CSR_read_data_in(csr_out),             
        .E_CSR_write_en_in(csr_write_en),         
        .E_MRET_in(csr_MRET),                     
        .E_WFI_in(csr_WFI),                       
        .E_CSR_op1_sel_in(csr_op1_sel),           
        .E_CSR_ALU_op_in(csr_alu_op),             

        .E_CSR_op_imm_in(csr_op_imm_out),

        .E_pc_out(E_pc_out),
        .E_rs1_out(E_rs1_out),
        .E_rs2_out(E_rs2_out),
        .E_imm_out(E_imm_out),
        //.E_csr_out(E_csr_out),

        .E_op_out(E_op_M),
        .E_f3_out(E_f3_M),
        .E_rd_out(E_rd_M), 
        .E_rs1_index_out(E_rs1_index_out),
        .E_rs2_index_out(E_rs2_index_out),
        .E_f7_out(E_f7_out),

        .E_use_rs1_out(E_use_rs1_M),
        .E_use_rs2_out(E_use_rs2_M),
        .E_use_rd_out(E_use_rd_M),

        .E_CSR_write_addr_out(E_csr_write_addr_out),            
        .E_CSR_read_data_out(E_csr_out),                         
        .E_CSR_write_en_out(E_csr_write_en_out),              
        .E_MRET_out(E_MRET),                                
        .E_WFI_out(E_WFI),                                  
        .E_CSR_op1_sel_out(E_csr_op1_sel_out),              
        .E_CSR_ALU_op_out(E_csr_alu_op_out),                

        .E_CSR_op_imm_out(E_csr_op_imm_out),

        .E_OE_info_out(E_OE_M)
    );


    Mux3 Mux3_rs1data(
        .data_in1(wb_data),
        .data_in2(M_aluout_out),
        .data_in3(E_rs1_out),
        .select_line(E_rs1_data_sel),
        .data_out(E_rs1_data)
    );

    /*Mux4 Mux4_rs2data(
        .data_in1(wb_data),
        .data_in2(M_aluout_out),
        .data_in3(E_rs2_out),
        .data_in4(M_csr_out),
        .select_line(E_rs2_data_sel),
        .data_out(E_rs2_data)
    );*/   

    Mux3 Mux3_rs2data(
        .data_in1(wb_data),
        .data_in2(M_aluout_out),
        .data_in3(E_rs2_out),
        .select_line(E_rs2_data_sel),
        .data_out(E_rs2_data)
    );
 

    /*Mux Mux_csr_rs2data(                    // For CSR <-> rs2 store address forwarding
        .data_in1(M_csr_out),
        .data_in2(E_rs2_data),
        .select_line(E_csr_rs2_data_sel),
        .data_out(E_rs2_data_f)        
    );*/

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

    Adder Adder_CSR(
        .data_1(E_pc_out),
        .data_2(32'd4),
        .data_out(E_pc_add4)        
    );

    ALU_CSR ALU_CSR(
        .operand1(csr_alu_in1),
        .operand2(csr_alu_in2),
        .CSR_ALU_op(E_csr_alu_op_out),
        .CSR_addr(E_csr_write_addr_out),
        .CSR_rs1_index(E_rs1_index_out), 
        .CSR_rd_index(E_rd_M),
        .CSR_alu_out(csr_alu_out)         
    );

    Mux Mux_csr1(                   
        .data_in1(alu_in1),
        .data_in2(E_csr_op_imm_out),  
        .select_line(E_csr_op1_sel_out),
        .data_out(csr_alu_in1) 
    );

    Mux3 Mux3_csr2(                 
        .data_in1(E_csr_out),
        .data_in2(M_csr_out),
        .data_in3(W_csr_out),
        .select_line(csr_op2_sel),
        .data_out(csr_alu_in2) 
    );

    CSR_Forwarding CSR_Forwarding(    
        .E_CSR_write_addr(E_csr_write_addr_out),
        .M_CSR_write_addr(M_csr_write_addr_out),
        .M_CSR_write_en(M_csr_write_en_out),
        .W_CSR_write_addr(W_csr_write_addr_out),
        .W_CSR_write_en(W_csr_write_en_out),
        .CSR_op2_sel(csr_op2_sel)
    );

    // --------------------------- EX Stage -------------------------- //

    // --------------------------- MEM Stage -------------------------- //

    Controller_M Controller_M(
        .Reg_M_alu_out(M_aluout_out[1:0]),
        .M_op(M_op_W),
        .M_f3(M_f3_W),
        .M_OE_info(M_OE_C),
        .M_dm_w_en(M_dm_w_en),
        .M_dm_OE(M_dm_OE)
    );

    Reg_M Reg_M(
        .clk(clk),
        .rst(rst),
        .stall_AXI(stall_AXI),
        .tim_interrupt(tim_interrupt),   

        .M_aluout_in(alu_out),
        .M_rs2_in(sa_out),
        .M_csr_in(csr_alu_out),

        .M_op_in(E_op_M), 
        .M_f3_in(E_f3_M),
        .M_rd_in(E_rd_M),

        .M_CSR_write_addr_in(E_csr_write_addr_out), 
        .M_CSR_write_en_in(E_csr_write_en_out),     

        .M_OE_info_in(E_OE_M),

        .M_use_rs1_in(E_use_rs1_M),
        .M_use_rs2_in(E_use_rs2_M),
        .M_use_rd_in(E_use_rd_M),

        .M_aluout_out(M_aluout_out),
        .M_rs2_out(DM_data_in),
        .M_csr_out(M_csr_out),

        .M_op_out(M_op_W),  
        .M_f3_out(M_f3_W),
        .M_rd_out(M_rd_W),

        .M_use_rs1_out(M_use_rs1_W),
        .M_use_rs2_out(M_use_rs2_W),
        .M_use_rd_out(M_use_rd_W),

        .M_CSR_write_addr_out(M_csr_write_addr_out), 
        .M_CSR_write_en_out(M_csr_write_en_out),     

        .M_OE_info_out(M_OE_C)
    );


    /*ALU_Trans ALU_Trans(
        .M_csr_out(M_csr_out),
        .M_aluout_out(M_aluout_out),
        .select_line(E_csr_rs2_data_sel),
        .M_aluout_out_f(M_aluout_out_f)

    );

    Addr_Trans Addr_Trans (
        .M_csr_out(M_csr_out),
        .DM_data_in(DM_data_in),
        .select_line(E_csr_rs2_data_sel),
        .DM_data_in_f(DM_data_in_f)
    );*/

   // --------------------------- MEM Stage -------------------------- //

   // --------------------------- WB Stage -------------------------- //
    Controller_W Controller_W(
        .W_op(W_op_C),
        .W_f3(W_f3_C),
        .W_rd(W_rd_C),
        .W_wb_en(W_wb_en),
        .W_rd_index(W_rd_index),
        .W_f3_out(W_f3),
        .W_wb_data_sel(W_wb_data_sel)
    );

    Reg_W Reg_W(
        .clk(clk),
        .rst(rst),
        .stall_AXI(stall_AXI),
        .tim_interrupt(tim_interrupt),

        .W_aluout_in(M_aluout_out),
        .W_csr_in(M_csr_out),

        .W_CSR_write_addr_in(M_csr_write_addr_out), 
        .W_CSR_write_en_in(M_csr_write_en_out),   

        .W_op_in(M_op_W), 
        .W_f3_in(M_f3_W),
        .W_rd_in(M_rd_W),

        .W_use_rs1_in(M_use_rs1_W),
        .W_use_rs2_in(M_use_rs2_W),
        .W_use_rd_in(M_use_rd_W),
    
        .W_aluout_out(W_aluout_out),
        .W_csr_out(W_csr_out),

        .W_CSR_write_addr_out(W_csr_write_addr_out), 
        .W_CSR_write_en_out(W_csr_write_en_out),    

        .W_op_out(W_op_C), 
        .W_f3_out(W_f3_C),
        .W_rd_out(W_rd_C),

        .W_use_rd_out(W_use_rd_C)
    
    );

    LD_Filter LD_Filter(
        .func3(W_f3),
        .ld_data(DM_data_out),
        .W_aluout(W_aluout_out[1:0]),
        .ld_data_f(ld_filter_out)
    );

    Mux3 Mux_wb(
        .data_in1(W_aluout_out),
        .data_in2(ld_filter_out),
        .data_in3(W_csr_out),
        .select_line(W_wb_data_sel),
        .data_out(wb_data)  
    );

endmodule


