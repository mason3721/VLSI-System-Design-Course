`include "Define.sv"


module Controller_jb_stall (
    input logic [4:0] opcode,

    input logic [4:0] dc_rs1,
    input logic [4:0] dc_rs2,

    input logic  alu_out, //****

    input logic [4:0] E_op, //******************
    input logic [4:0] E_rd,

    input logic is_D_use_rs1,
    input logic is_D_use_rs2,

    output logic next_pc_sel, // (jb) -> for control hazard
    output logic stall_CPU // for data hazard of lw, lh, lb instruction 

);
    always_comb begin
        /*stall = (E_op == 5'b0) & (((opcode != `U1) & (opcode != `U2) & (opcode != `J)
                               & (dc_rs1 == E_rd) & E_rd != 0)
                               | (((opcode == `S) | (opcode == `B) | (opcode == `R))
                               & (dc_rs2 == E_rd) & E_rd != 0));*/

        stall_CPU = (E_op == 5'd0) & ((is_D_use_rs1
                               & (dc_rs1 == E_rd) & E_rd != 5'd0)
                               | ((is_D_use_rs2)
                               & (dc_rs2 == E_rd) & E_rd != 5'd0));

        case(E_op)
            `R: begin
                next_pc_sel = 1'd0;               
            end
            `I1: begin//lb
                next_pc_sel = 1'd0;
            end

            `I2: begin//addi
                next_pc_sel = 1'd0;

            end
            `I3: begin //jalr
                next_pc_sel = 1'd1;

            end
            `S: begin
                next_pc_sel = 1'd0;

            end
            `B: begin
                if(alu_out == 1'd1) //
                    next_pc_sel = 1'd1;
                else
                    next_pc_sel = 1'd0;
            end
            `U1: begin //lui
                next_pc_sel = 1'd0;
            end
            `U2: begin //auipc;
                next_pc_sel = 1'd0; 
            end
            `J: begin //jal
                next_pc_sel = 1'd1;
            end
            `CSR: begin
                next_pc_sel = 1'd0;        
            end 
            default: begin
                next_pc_sel = 1'd0;

            end
        endcase
    end

endmodule