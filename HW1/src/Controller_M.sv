`include "Define.sv"

module Controller_M(

    input logic [1:0] Reg_M_alu_out, //***
    input logic [4:0] M_op,
    input logic [2:0] M_f3,

    output logic [3:0] M_dm_w_en,
    output logic M_dm_cs
);
    always_comb begin
        case (M_op)
            `R: begin
                M_dm_w_en = 4'b1111;
            end
            `I1: begin //lb
                M_dm_w_en = 4'b1111;
            end
            `I2: begin //addi
                M_dm_w_en = 4'b1111;
            end
            `I3: begin //jalr
                M_dm_w_en = 4'b1111;
            end
            `S: begin
                if(Reg_M_alu_out != 2'd0) begin
                    M_dm_w_en = 4'b0000;   
                end

                else begin
                    if(M_f3 == 3'b000)      // sb
                        M_dm_w_en = 4'b1110;
                    else if(M_f3 == 3'b001) // sh
                        M_dm_w_en = 4'b1100;
                    else                    // sw
                        M_dm_w_en = 4'b0000;
                end
            end
            `B: begin
                M_dm_w_en= 4'b1111;
            end
            `U1: begin //lui
                M_dm_w_en = 4'b1111;
            end
            `U2: begin//auipc;
                M_dm_w_en = 4'b1111;
            end
            `J: begin//jal
                M_dm_w_en = 4'b1111;
            end 

            `CSR: begin
                M_dm_w_en = 4'b1111;
            end

            default: begin
                M_dm_w_en = 4'b1111;
            end
        endcase

            M_dm_cs = 1'd1;
    end

endmodule