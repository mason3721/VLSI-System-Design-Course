//================================================
// Auther:      Lin Meng-Yu            
// Filename:    Controller_CSR.sv                            
// Description: CSR Controller module of CPU                  
// Version:     HW3 Submit Version
// Date:        2023/11/23
//================================================

`include "Define.sv"

module Controller_CSR(
    input logic [21:0] CSR_info,
    /*input logic [6:0] CSR_opcode,
    input logic [2:0] CSR_func3,
    input logic [11:0] CSR_imm,*/
    input logic ext_interrupt,
    input logic tim_interrupt,
    input logic E_MRET,

    output logic CSR_write_en,
    output logic CSR_MRET,
    output logic CSR_WFI,
    output logic CSR_op1_sel,
    output logic [1:0] CSR_ALU_op,
    output logic flush

);
    logic [6:0] CSR_opcode;
    logic [2:0] CSR_func3;
    logic [11:0] CSR_imm;

    assign CSR_opcode = CSR_info[6:0];
    assign CSR_func3 = CSR_info[9:7];
    assign CSR_imm = CSR_info[21:10];

    always_comb begin
        if(CSR_opcode == 7'b1110011) begin
            if (CSR_imm == 12'b0011_0000_0010) begin    //MRET
                CSR_MRET = 1'd1;
                CSR_WFI = 1'd0;
                CSR_write_en = 1'd0;
                CSR_op1_sel = 1'd0;  // don't care
                CSR_ALU_op = 2'd0;
            end
            else if (CSR_imm == 12'b0001_0000_0101) begin   //WFI
                CSR_MRET = 1'd0;
                CSR_WFI = 1'd1;
                CSR_write_en = 1'd0;
                CSR_op1_sel = 1'd0;  // don't care
                CSR_ALU_op = 2'd0;
            end
            else begin  // csr
                CSR_MRET = 1'd0;
                CSR_WFI = 1'd0;
                CSR_write_en = 1'd1;
                case (CSR_func3)
                    3'b001: begin             // CSRRW
                        CSR_op1_sel = 1'b1;
                        CSR_ALU_op = 2'b00;
                    end

                    3'b010: begin             // CSRRS
                        CSR_op1_sel = 1'b1;
                        CSR_ALU_op = 2'b01;
                    end

                    3'b011: begin             // CSRRC
                        CSR_op1_sel = 1'b1;
                        CSR_ALU_op = 2'b10;
                    end

                    3'b101:begin              // CSRRWI
                        CSR_op1_sel = 1'b0;
                        CSR_ALU_op = 2'b00;
                    end

                    3'b110:begin             // CSRRSI
                        CSR_op1_sel = 1'b0;
                        CSR_ALU_op = 2'b01;
                    end

                    3'b111:begin             // CSRRCI
                        CSR_op1_sel = 1'b0;
                        CSR_ALU_op = 2'b10;
                    end

                    default: begin
                        CSR_op1_sel = 1'b0;
                        CSR_ALU_op = 2'b00;
                    end
                endcase
            end
        end

        else begin
            CSR_MRET = 1'd0;
            CSR_WFI = 1'd0;
            CSR_write_en = 1'd0;
            CSR_op1_sel = 1'd0;  // don't care
            CSR_ALU_op = 2'd0;
        end
    end

    always_comb begin
        if(ext_interrupt || tim_interrupt || E_MRET) begin
            flush = 1'd1;
        end
        else begin
            flush = 1'd0;
        end
    end

endmodule