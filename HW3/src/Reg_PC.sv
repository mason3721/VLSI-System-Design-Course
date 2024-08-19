//================================================
// Auther:      Lin Meng-Yu            
// Filename:    Reg_D.sv                            
// Description: PC Register of CPU                  
// Version:     HW3 Submit Version
// Date:        2023/11/23
//================================================

module Reg_PC (
    input logic clk,
    input logic rst,
    input logic [31:0] next_pc,
    input logic stall_CPU,
    input logic stall_AXI,   
    input logic tim_interrupt, 
    output logic [31:0] Reg_pc_out
);
    logic stall;

    assign  stall = stall_CPU || stall_AXI;

    always_ff @(posedge clk) begin
        if(rst) begin
            Reg_pc_out <= 32'd0;
        end

        else if(tim_interrupt) begin
            Reg_pc_out <= 32'd0;
        end

        else if(stall) begin
            Reg_pc_out <= Reg_pc_out;
        end

        else begin
            Reg_pc_out <= next_pc;
        end
    end
endmodule