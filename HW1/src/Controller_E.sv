`include "Define.sv"

module Controller_E(

    input logic [4:0] E_op, //******************
    input logic [2:0] E_f3,
    input logic [4:0] E_rd,
    input logic [4:0] E_rs1,
    input logic [4:0] E_rs2,
    
    input logic [1:0] E_f7,

    input logic [4:0] M_op,
    input logic [4:0] M_rd,
    input logic [4:0] W_op,
    input logic [4:0] W_rd,

    input logic is_E_use_rs1,
    input logic is_E_use_rs2,
    input logic is_M_use_rd,
    input logic is_W_use_rd,

    output logic [1:0] E_rs1_data_sel,
    output logic [1:0] E_rs2_data_sel,
    output logic E_alu_op1_sel,
    output logic E_alu_op2_sel,
    output logic E_jb_op1_sel,
    output logic [4:0] E_op_out,
    output logic [2:0] E_f3_out,
    output logic [1:0] E_f7_out

);
    always_comb begin
        //if(((E_op != `U1) & (E_op != `U2) & (E_op != `J) & (M_op != `S) & (M_op != `B)) & (E_rs1 == M_rd) & M_rd != 0)

        if(( is_E_use_rs1 & is_M_use_rd ) & (E_rs1 == M_rd) & M_rd != 5'd0)
            E_rs1_data_sel = 2'd1;
        else begin
            if ((is_E_use_rs1) & is_W_use_rd & (E_rs1 == W_rd) & W_rd != 5'd0)
                E_rs1_data_sel = 2'd0;
            else
                E_rs1_data_sel = 2'd2;
        end
           
        if((is_E_use_rs2) & is_M_use_rd & (E_rs2 == M_rd) & M_rd != 5'd0)
            E_rs2_data_sel = 2'd1;
        else begin
            if ((is_E_use_rs2) & is_W_use_rd & (E_rs2 == W_rd) & W_rd != 5'd0)
                E_rs2_data_sel = 2'd0;
            else
                E_rs2_data_sel = 2'd2;
        end

    
        E_op_out = E_op;
        E_f3_out = E_f3;
        E_f7_out = E_f7;

        case(E_op)
            `R: begin
                E_alu_op1_sel = 1'd1;
                E_alu_op2_sel = 1'd1;
                E_jb_op1_sel = 1'd0; //do not care
                
            end
            `I1: begin//lb
                E_alu_op1_sel = 1'd1;
                E_alu_op2_sel = 1'd0;
                E_jb_op1_sel = 1'd0;//do not care
            end

            `I2: begin//addi
                E_alu_op1_sel = 1'd1;
                E_alu_op2_sel = 1'd0;
                E_jb_op1_sel = 1'd0;//do not care
            end

            `I3: begin //jalr
                E_alu_op1_sel = 1'd0; // pc
                E_alu_op2_sel = 1'd0; // do not care
                E_jb_op1_sel = 1'd1; // rs1
            end

            `S: begin
                E_alu_op1_sel = 1'd1; //rs1
                E_alu_op2_sel = 1'd0; //imm
                E_jb_op1_sel = 1'd0;//do not care
            end

            `B: begin
                E_alu_op1_sel = 1'd1;
                E_alu_op2_sel = 1'd1;
                E_jb_op1_sel = 1'd0;
            end
            `U1: begin //lui
                E_alu_op1_sel = 1'd0;//do not care
                E_alu_op2_sel = 1'd0;
                E_jb_op1_sel= 1'd0;// do not care
            end
            `U2: begin //auipc;

                E_alu_op1_sel = 1'd0; //pc
                E_alu_op2_sel = 1'd0;//imm
                E_jb_op1_sel = 1'd0;//do not care
            end
            `J: begin //jal
                E_alu_op1_sel = 1'd0;
                E_alu_op2_sel = 1'd0;//do not care
                E_jb_op1_sel = 1'd0;
            end

            `CSR: begin

                E_alu_op1_sel = 1'd0; // don't care
                E_alu_op2_sel = 1'd0; // don't care
                E_jb_op1_sel = 1'd0;                
            end
            
            default: begin
                E_alu_op1_sel = 1'd0;
                E_alu_op2_sel = 1'd0; 
                E_jb_op1_sel = 1'd0;
            end
        endcase

    end

endmodule