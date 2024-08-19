`include "Define.sv"

module Overlap (
    input logic [4:0] opcode,
    output logic  inst_use_rs1,
    output logic  inst_use_rs2,
    output logic  inst_use_rd

);
    always_comb begin
        inst_use_rs1 = (opcode != `U1) & (opcode != `U2) & (opcode != `J);
        inst_use_rs2 = (opcode == `S) | (opcode == `B) | (opcode == `R);
        inst_use_rd = (opcode != `S) & (opcode != `B);
    end
        

        //E_use_rs1_W_use_rd = (E_op != `U1) & (E_op != `U2) & (E_op != `J) & ((W_op != `S) & (W_op != `B));
        //E_use_rs1_M_use_rd = (E_op != `U1) & (E_op != `U2) & (E_op != `J) & ((M_op != `S) & (M_op != `B));

        //E_use_rs2_W_use_rd = ((E_op == `S) | (E_op == `B) | (E_op == `R)) & (M_op != `S) & (M_op != `B);
        //E_use_rs2_M_use_rd = ((E_op == `S) | (E_op == `B) | (E_op == `R)) & (W_op != `S) & (W_op != `B);

        //stall = (E_op == 5'b0) & (((opcode != `U1) & (opcode != `U2) & (opcode != `J)  & (dc_rs1 == E_rd) & E_rd != 0)
         //| (((opcode == `S) | (opcode == `B) | (opcode == `R)) & (dc_rs2 == E_rd) & E_rd != 0));
endmodule