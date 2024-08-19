//================================================
// Auther:      Lin Meng-Yu            
// Filename:    Controller_W.sv                            
// Description: WB Stage Controller module of CPU                  
// Version:     HW3 Submit Version
// Date:        2023/11/23
//================================================

`include "Define.sv"

module Controller_W(

    input logic [4:0] W_op,
    input logic [2:0] W_f3,
    input logic [4:0] W_rd,

    output logic W_wb_en,
    output logic [4:0] W_rd_index,
    output logic [2:0] W_f3_out,
    output logic [1:0] W_wb_data_sel

);
    always_comb begin  
        W_f3_out = W_f3;
        case (W_op)
            `R: begin
                W_wb_en = 1'd1;
                W_wb_data_sel = 2'd0;
                W_rd_index=W_rd;
            end
            `I1: begin // lb
                W_wb_en = 1'd1;
                W_wb_data_sel= 2'd1;
                W_rd_index = W_rd;
            end
            `I2: begin//addi
                W_wb_en = 1'd1;
                W_wb_data_sel = 2'd0;
                W_rd_index = W_rd;
            end
            `I3: begin //jalr
                W_wb_en = 1'd1;//rd=pc+4
                W_wb_data_sel= 2'd0;
                W_rd_index = W_rd;
            end
            `S: begin
                W_wb_en = 1'd0; //not
                W_wb_data_sel= 2'd0; //do not care
                W_rd_index=W_rd;
            end
            `B: begin
                W_wb_en = 1'd0;
                W_wb_data_sel = 2'd0;//do not care
                W_rd_index=W_rd;
            end
            `U1: begin //lui
                W_wb_en = 1'd1;
                W_wb_data_sel = 2'd0;
                W_rd_index=W_rd;
            end
            `U2: begin // auipc;
                W_wb_en = 1'd1;
                W_wb_data_sel = 2'd0;
                W_rd_index = W_rd;
            end
            `J: begin // jal
                W_wb_en = 1'd1;
                W_wb_data_sel = 2'd0;
                W_rd_index = W_rd;
            end

            `CSR: begin
                W_wb_en = 1'd1;
                W_wb_data_sel = 2'd2;
                W_rd_index = W_rd;
            end 

            default: begin
                W_wb_en = 1'd1;
                W_wb_data_sel = 2'd0;
                W_rd_index = W_rd;
            end
        endcase
    end

endmodule