module Imm_generator(
    instruction,
    imm_result
);

input [31:0] instruction;
output logic [31:0] imm_result;

always_comb begin
    unique case(instruction[6:0])
        7'b0110011: imm_result=32'd0; //R_type
        7'b0010011: imm_result={{20{instruction[31]}},instruction[31:20]}; //I_type 
        7'b1100111: imm_result={{20{instruction[31]}},instruction[31:20]}; //JALR
        7'b0000011: imm_result={{20{instruction[31]}},instruction[31:20]}; //LOAD
        7'b0100011: imm_result={{20{instruction[31]}},instruction[31:25],instruction[11:7]}; //S_type
        7'b1100011: imm_result={{20{instruction[31]}},instruction[7],instruction[30:25],instruction[11:8],1'b0}; //B_type
        7'b0010111: imm_result={instruction[31:12],12'd0}; //AUIPC
        7'b0110111: imm_result={instruction[31:12],12'd0}; //LUI
        7'b1101111: imm_result={{12{instruction[31]}},instruction[19:12],instruction[20],instruction[30:21],1'b0}; //J_type
        7'b1110011: imm_result={instruction[31:20],20'd0}; //Crs
		default: imm_result=32'd0;
    endcase
end
endmodule