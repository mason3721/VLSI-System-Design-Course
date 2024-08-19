`include "Define.sv"

module Imm_Ext (
    input logic [31:0] inst,
    output logic [31:0] imm_ext_out
);
    always_comb begin
        case(inst[6:2])
            `R: begin // R-type
                imm_ext_out = 32'b0;
            end

            `I1: begin // I-type-1 (lb..)
                imm_ext_out = {{20{inst[31]}}, inst[31: 20]};
            end

            `I2: begin // I-type2 (addi...)
                imm_ext_out = {{20{inst[31]}}, inst[31: 20]};
            end
            `I3: begin // I-type-3 (jalr...)
                imm_ext_out = {{20{inst[31]}}, inst[31: 20]};
            end

            `S: begin // S-type
                imm_ext_out = {{20{inst[31]}}, inst[31: 25], inst[11: 7]};
            end

            `B: begin // B-type
                imm_ext_out = {{20{inst[31]}},inst[7] , inst[30: 25] , inst[11: 8] , 1'b0};
            end

            `U1: begin // U-type-1
                imm_ext_out = {inst[31:12] , 12'b0};
            end
            `U2: begin // U-type-1
                imm_ext_out = {inst[31:12] , 12'b0};
            end

            `J: begin // J-type
                imm_ext_out = {{12{inst[31]}}, inst[19: 12] , inst[20] , inst[30: 21] , 1'b0};
            end

            `CSR:begin // CSR-instructions
                imm_ext_out = {{20{inst[31]}}, inst[31: 20]};
            end

            default: begin
                imm_ext_out = 32'b0;
            end
        endcase
    end
endmodule
