module JB_Unit (
    input logic [31:0] operand1,
    input logic [31:0] operand2,
    output logic [31:0] jb_out
);
    assign jb_out = (operand1 + operand2) & (~32'd1);
endmodule