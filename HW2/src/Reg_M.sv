module Reg_M (
    input logic clk,
    input logic rst,
    input logic stall_AXI,

    input logic [31:0] M_aluout_in,
    input logic [31:0] M_rs2_in,
    input logic [31:0] M_csr_in,

    input logic [4:0] M_op_in,
    input logic [2:0] M_f3_in,
    input logic [4:0] M_rd_in,

    input logic M_use_rs1_in,
    input logic M_use_rs2_in,
    input logic M_use_rd_in,    

    input logic M_OE_info_in,

    output logic [31:0] M_aluout_out,
    output logic [31:0] M_rs2_out,
    output logic [31:0] M_csr_out,

    output logic [4:0] M_op_out,
    output logic [2:0] M_f3_out,
    output logic [4:0] M_rd_out,

    output logic M_use_rs1_out,
    output logic M_use_rs2_out,
    output logic M_use_rd_out,

    output logic M_OE_info_out

);
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            M_aluout_out <= 32'd0;
            M_rs2_out <= 32'd0;
            M_csr_out <= 32'd0; 

            M_op_out <= 5'd0;
            M_f3_out <= 3'd0;
            M_rd_out <= 5'd0;

            M_use_rs1_out <= 1'd0;
            M_use_rs2_out <= 1'd0;
            M_use_rd_out  <= 1'd0;

            M_OE_info_out <= 1'd0;
        end

        else begin
            if(stall_AXI) begin
                M_aluout_out <= M_aluout_out;
                M_rs2_out <= M_rs2_out;
                M_csr_out <= M_csr_out;

                M_op_out <= M_op_out;
                M_f3_out <= M_f3_out;
                M_rd_out <= M_rd_out;
                
                M_use_rs1_out <= M_use_rs1_out;
                M_use_rs2_out <= M_use_rs2_out;
                M_use_rd_out  <= M_use_rd_out;

                M_OE_info_out <= M_OE_info_out;
            end

            else begin
                M_aluout_out <= M_aluout_in;
                M_rs2_out <= M_rs2_in;
                M_csr_out <= M_csr_in;

                M_op_out <= M_op_in;
                M_f3_out <= M_f3_in;
                M_rd_out <= M_rd_in;

                M_use_rs1_out <= M_use_rs1_in;
                M_use_rs2_out <= M_use_rs2_in;
                M_use_rd_out  <= M_use_rd_in;

                M_OE_info_out <= M_OE_info_in;
            end
        end
    end

endmodule