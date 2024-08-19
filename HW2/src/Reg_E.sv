module Reg_E (
    input logic clk,
    input logic rst,
    input logic stall_CPU,
    input logic stall_AXI,
    input logic jb,
    input logic [31:0] E_pc_in,
    input logic [31:0] E_rs1_in,
    input logic [31:0] E_rs2_in,
    input logic [31:0] E_imm_in,
    input logic [31:0] E_csr_in,

    input logic [4:0] E_op_in,
    input logic [2:0] E_f3_in,
    input logic [4:0] E_rd_in,
    input logic [4:0] E_rs1_index_in,
    input logic [4:0] E_rs2_index_in,
    input logic [1:0] E_f7_in,

    input logic E_use_rs1_in,
    input logic E_use_rs2_in,
    input logic E_use_rd_in,

    input logic E_OE_info_in,

    output logic [31:0] E_pc_out,
    output logic [31:0] E_rs1_out,
    output logic [31:0] E_rs2_out,
    output logic [31:0] E_imm_out,
    output logic [31:0] E_csr_out,

    output logic [4:0] E_op_out,
    output logic [2:0] E_f3_out,
    output logic [4:0] E_rd_out,
    output logic [4:0] E_rs1_index_out,
    output logic [4:0] E_rs2_index_out,
    output logic [1:0] E_f7_out,

    output logic E_use_rs1_out,  //******
    output logic E_use_rs2_out,
    output logic E_use_rd_out,

    output logic E_OE_info_out
);


    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            E_pc_out <= 32'd0;
            E_rs1_out <= 32'd0;
            E_rs2_out <= 32'd0;
            E_imm_out <= 32'd0;
            E_csr_out <= 32'd0;

            E_op_out <= 5'd0;
            E_f3_out <= 3'd0;
            E_rd_out <= 5'd0;
            E_rs1_index_out <= 5'd0;
            E_rs2_index_out <= 5'd0;
            E_f7_out <= 2'd0;

            E_use_rs1_out <= 1'd0; //****
            E_use_rs2_out <= 1'd0;
            E_use_rd_out  <= 1'd0;

            E_OE_info_out <= 1'd0;

        end

        else if(stall_AXI) begin
            E_pc_out <=  E_pc_out;
            E_rs1_out <= E_rs1_out;
            E_rs2_out <= E_rs2_out;
            E_imm_out <= E_imm_out;
            E_csr_out <= E_csr_out;
            
            E_op_out <= E_op_out;
            E_f3_out <= E_f3_out;
            E_rd_out <= E_rd_out;
            E_rs1_index_out <= E_rs1_index_out;
            E_rs2_index_out <= E_rs2_index_out;
            E_f7_out <= E_f7_out;

            E_use_rs1_out <= E_use_rs1_out; //****
            E_use_rs2_out <= E_use_rs2_out;
            E_use_rd_out  <= E_use_rd_out;

            E_OE_info_out <= E_OE_info_out;            
        end

        else if (stall_CPU || jb || E_pc_in == 32'b0) begin  // flush
            E_pc_out <= 32'd0;
            E_rs1_out <= 32'd0;
            E_rs2_out <= 32'd0;
            E_imm_out <= 32'd0;
            E_csr_out <= 32'd0;
            
            E_op_out <= 5'd0;
            E_f3_out <= 3'd0;
            E_rd_out <= 5'd0;
            E_rs1_index_out <= 5'd0;
            E_rs2_index_out <= 5'd0;
            E_f7_out <= 2'd0;

            E_use_rs1_out <= 1'd0; //****
            E_use_rs2_out <= 1'd0;
            E_use_rd_out  <= 1'd0;

            E_OE_info_out <= 1'd0;
        end
        else begin
            E_pc_out <= E_pc_in;
            E_rs1_out <= E_rs1_in;
            E_rs2_out <= E_rs2_in;
            E_imm_out <= E_imm_in;
            E_csr_out <= E_csr_in;

            E_op_out <= E_op_in;
            E_f3_out <= E_f3_in;
            E_rd_out <= E_rd_in;
            E_rs1_index_out <= E_rs1_index_in;
            E_rs2_index_out <= E_rs2_index_in;
            E_f7_out <= E_f7_in;

            E_use_rs1_out <= E_use_rs1_in; //***
            E_use_rs2_out <= E_use_rs2_in;
            E_use_rd_out  <= E_use_rd_in;

            E_OE_info_out <= E_OE_info_in;
        end
    end

endmodule