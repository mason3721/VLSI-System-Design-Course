//================================================
// Auther:      Lin Meng-Yu            
// Filename:    JB_Unit.sv                            
// Description: Jump/Branch module of CPU                  
// Version:     HW3 Submit Version
// Date:        2023/11/23
//================================================

module JB_Unit (
    input logic [31:0] operand1,
    input logic [31:0] operand2,
    output logic [31:0] jb_out
);
    assign jb_out = (operand1 + operand2) & (~32'd1);
endmodule