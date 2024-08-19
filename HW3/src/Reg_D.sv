//================================================
// Auther:      Lin Meng-Yu            
// Filename:    Reg_D.sv                            
// Description: IF/ID Register of CPU                  
// Version:     HW3 Submit Version
// Date:        2023/11/23
//================================================

module Reg_D (
    input logic clk,
    input logic rst,
    input logic stall_CPU,
    input logic stall_AXI,
    input logic jb,
    input logic flush,                      
    input logic [31:0] D_pc_in,
    input logic [31:0] DO_mux3_out,
    input logic tim_interrupt,            
    output logic [31:0] D_pc_out,
    output logic [31:0] stall_inst,
    output logic [1:0]  D_stall_jb_flush 
);
    logic stall;
    
    assign  stall = stall_CPU || stall_AXI;

    always_ff @(posedge clk) begin
        if (rst) begin
            D_pc_out <= 32'd0;
            D_stall_jb_flush <= 2'd0;
            stall_inst <= 32'd0;
        end

        else if(tim_interrupt) begin
            D_pc_out <= 32'd0;
            D_stall_jb_flush <= 2'd0;
            stall_inst <= 32'd0;        
        end

        else if (stall) begin
            D_pc_out <= D_pc_out;
            D_stall_jb_flush <= 2'd0;
            stall_inst <= DO_mux3_out;
        end
        else if (jb || flush) begin
            D_pc_out <= 32'b0;
            D_stall_jb_flush <= 2'd2;
            stall_inst <= DO_mux3_out;
        end
        else begin
            D_pc_out <= D_pc_in;
            D_stall_jb_flush <= 2'd1;
            stall_inst <= DO_mux3_out;
        end

    end
endmodule