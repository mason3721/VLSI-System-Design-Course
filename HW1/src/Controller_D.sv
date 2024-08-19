`include "Define.sv"

module Controller_D(
    input logic [4:0] opcode,
    input logic [4:0] dc_rs1,
    input logic [4:0] dc_rs2,

    input logic [4:0] E_op, //******************
    input logic [4:0] E_rd,

    input logic [4:0] W_op,
    input logic [4:0] W_rd,

    input logic is_D_use_rs1,  //****
    input logic is_D_use_rs2,
    input logic is_W_use_rd,

    output logic D_rs1_data_sel,
    output logic D_rs2_data_sel

);
    always_comb begin
        //D_rs1_data_sel = (((opcode != `U1) & (opcode != `U2) & (opcode != `J))
        // & ((W_op != `S) & (W_op != `B)) & (dc_rs1 == W_rd) & W_rd != 0);

         D_rs1_data_sel = (is_D_use_rs1) & (is_W_use_rd) & (dc_rs1 == W_rd) & W_rd != 5'd0;

        //D_rs2_data_sel = (((opcode == `S) | (opcode == `B) | (opcode == `R))
         //& (W_op != `S) & (W_op != `B) & (dc_rs2 == W_rd) & W_rd != 0);

         D_rs2_data_sel = (is_D_use_rs2) & (is_W_use_rd) & (dc_rs2 == W_rd) & W_rd != 5'd0;
    end

endmodule