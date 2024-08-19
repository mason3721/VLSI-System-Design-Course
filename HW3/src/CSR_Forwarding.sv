//================================================
// Auther:      Lin Meng-Yu            
// Filename:    CSR Forwarding.sv                            
// Description: CSR Forwarding module of CPU              
// Version:     HW3 Submit Version
// Date:        2023/11/23
//================================================

module CSR_Forwarding(
    input logic  [11:0] E_CSR_write_addr,
    input logic  [11:0] M_CSR_write_addr,
    input logic         M_CSR_write_en,
    input logic  [11:0] W_CSR_write_addr,
    input logic         W_CSR_write_en,
    output logic [1:0] CSR_op2_sel 
);
    always_comb begin
        if( (E_CSR_write_addr == M_CSR_write_addr)  &&  M_CSR_write_en == 1'd1) begin
            CSR_op2_sel = 2'b01;
        end

        else if( (E_CSR_write_addr == W_CSR_write_addr) && W_CSR_write_en == 1'd1) begin
            CSR_op2_sel = 2'b10;
        end
        else begin
            CSR_op2_sel = 2'b00;
        end

    end
endmodule