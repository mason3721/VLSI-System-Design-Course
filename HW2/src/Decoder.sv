module Decoder (
    input logic [31:0] inst,
    output logic [4:0] dc_out_opcode,     
    output logic [2:0] dc_out_func3,
    output logic [1:0] dc_out_func7,     
    output logic [4:0] dc_out_rs1_index,
    output logic [4:0] dc_out_rs2_index,
    output logic [4:0] dc_out_rd_index,
    output logic [1:0] dc_out_csr_info,
    output logic dc_out_OE_info
);
    always_comb begin
        dc_out_opcode = inst[6:2];     // the last 2 bits of the opcode are always '11'-> only 5 bits required
        dc_out_func3 = inst[14:12];  
        dc_out_func7 = {inst[30], inst[25]};  // function7 of R-format instruction (add multiplication extension)
        dc_out_rs1_index = inst[19:15];
        dc_out_rs2_index = inst[24:20];
        dc_out_rd_index = inst[11:7];
        dc_out_csr_info = {inst[27], inst[21]};
        dc_out_OE_info  = {inst[1]};
    end
endmodule