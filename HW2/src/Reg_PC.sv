module Reg_PC (
    input logic clk,
    input logic rst,
    input logic [31:0] next_pc,
    input logic stall_CPU,
    input logic stall_AXI,    
    output logic [31:0] current_pc
);
    logic stall;

    assign  stall = stall_CPU || stall_AXI;

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            current_pc <= 32'd0;
        end

        else if(stall) begin
            current_pc <= current_pc;
        end

        else begin
            current_pc <= next_pc;
        end
    end
endmodule