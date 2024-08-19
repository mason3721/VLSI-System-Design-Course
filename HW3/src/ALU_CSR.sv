//================================================
// Auther:      Lin Meng-Yu            
// Filename:    ALU_CSR.sv                            
// Description: CSR ALU module of CPU                  
// Version:     HW3 Submit Version
// Date:        2023/11/23
//================================================
module ALU_CSR(
    input logic [31:0] operand1,
    input logic [31:0] operand2,
    input logic [1:0] CSR_ALU_op,
    input logic [11:0] CSR_addr,
    input logic [4:0] CSR_rs1_index,
    input logic [4:0] CSR_rd_index,
    output logic [31:0] CSR_alu_out 
);

    parameter 	 OP_Rw           =   2'b00       ;
	parameter    OP_Rs           =   2'b01       ;
	parameter	 OP_Rc           =   2'b10       ;
			 
    parameter   MSTATUS_ADDR    =    12'h300     ;
    parameter   MTVEC_ADDR      =    12'h305     ;
    parameter   MIE_ADDR        =    12'h304     ;
    parameter   MEPC_ADDR       =    12'h341     ;
    parameter   MIP_ADDR        =    12'h344     ;
    parameter   MCYCLE_ADDR     =    12'hb00     ;
    parameter   MCYCLEH_ADDR    =    12'hb80     ;
    parameter   MINSTRET_ADDR   =    12'hb02     ;
    parameter   MINSTRETH_ADDR  =    12'hb82     ;

    logic [31:0]  CSR_temp;

    always_comb begin
        case (CSR_ALU_op)
            OP_Rw: begin
                if(CSR_rs1_index != 5'd0) begin
                    CSR_temp = operand1;          		 // RW_CSR
                end
                else begin
                    CSR_temp = operand2;          		 // RW_CSR
                end
            end
            OP_Rs:
                if(CSR_rs1_index != 5'd0) begin
                    CSR_temp = operand1 | operand2;      // RS_CSR
                end
                else begin
                    CSR_temp = operand2;          		 // RS_CSR
                end
            
            OP_Rc: 
                if(CSR_rs1_index != 5'd0) begin
                    CSR_temp = operand2 & (~operand1);      // RC_CSR
                end
                else begin
                    CSR_temp = operand2;          		 
                end
            
    		default: CSR_temp = 32'd0;
        endcase
    end
    always_comb begin
        case(CSR_addr)
            MSTATUS_ADDR    :   CSR_alu_out     =   {19'd0, CSR_temp[12:11], 3'd0, CSR_temp[7], 3'd0, CSR_temp[3], 3'd0};
    		MTVEC_ADDR	    :   CSR_alu_out     =   32'h0001_0000; 
    		MIP_ADDR 	    :   CSR_alu_out     =   operand2;  
            MIE_ADDR	    :   CSR_alu_out     =   {20'd0, CSR_temp[11], 3'd0, CSR_temp[7], 7'd0};
            MEPC_ADDR	    :   CSR_alu_out     =   CSR_temp;
    		MCYCLE_ADDR	    :   CSR_alu_out     =   operand2;
    		MINSTRET_ADDR   :   CSR_alu_out     =   operand2;
    		MCYCLEH_ADDR    :   CSR_alu_out     =   operand2;
    		MINSTRETH_ADDR  :   CSR_alu_out     =   operand2;
            default         :   CSR_alu_out     =   operand2;
        endcase
    end   
endmodule