//================================================
// Auther:      Lin Meng-Yu            
// Filename:    Reg_D.sv                            
// Description: MEM/WB Register of CPU                  
// Version:     HW3 Submit Version
// Date:        2023/11/23
//================================================

module Reg_W (
    input logic clk,
    input logic rst,
    input logic tim_interrupt,
    input logic stall_AXI,

    input logic [31:0] W_aluout_in,
    input logic [31:0] W_csr_in,

    input logic [11:0] W_CSR_write_addr_in,
    input logic W_CSR_write_en_in,

    input logic [4:0] W_op_in,
    input logic [2:0] W_f3_in,
    input logic [4:0] W_rd_in,

    input logic W_use_rs1_in,
    input logic W_use_rs2_in,
    input logic W_use_rd_in,    

    output logic [31:0] W_aluout_out,
    output logic [31:0] W_csr_out,

    output logic [11:0] W_CSR_write_addr_out,
    output logic W_CSR_write_en_out, 
    

    output logic [4:0] W_op_out,
    output logic [2:0] W_f3_out,
    output logic [4:0] W_rd_out,

    output logic W_use_rd_out    
);

    always_ff @(posedge clk) begin
        if(rst) begin
            W_aluout_out <= 32'b0;
            W_csr_out <= 32'b0;

            W_CSR_write_addr_out <= 12'd0;
            W_CSR_write_en_out <= 1'd0;
            
            W_op_out <= 5'd0;
            W_f3_out <= 3'd0;
            W_rd_out <= 5'd0;

            W_use_rd_out  <= 1'd0;
        end

        else if(tim_interrupt) begin
            W_aluout_out <= 32'b0;
            W_csr_out <= 32'b0;

            W_CSR_write_addr_out <= 12'd0;
            W_CSR_write_en_out <= 1'd0;
            
            W_op_out <= 5'd0;
            W_f3_out <= 3'd0;
            W_rd_out <= 5'd0;

            W_use_rd_out  <= 1'd0;
        end

        else begin
            if(stall_AXI) begin
                W_aluout_out <= W_aluout_out;
                W_csr_out <= W_csr_out;

                W_CSR_write_addr_out <= W_CSR_write_addr_out;
                W_CSR_write_en_out <= W_CSR_write_en_out;

                W_op_out <= W_op_out;
                W_f3_out <= W_f3_out;
                W_rd_out <= W_rd_out;

                W_use_rd_out  <= W_use_rd_out;
            end

            else begin
                W_aluout_out <= W_aluout_in;
                W_csr_out <= W_csr_in;
                W_CSR_write_addr_out <= W_CSR_write_addr_in;
                W_CSR_write_en_out <= W_CSR_write_en_in;

                W_op_out <= W_op_in;
                W_f3_out <= W_f3_in;
                W_rd_out <= W_rd_in;

                W_use_rd_out  <= W_use_rd_in;
            end
        end
    end

endmodule