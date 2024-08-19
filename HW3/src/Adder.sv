//================================================
// Auther:      Lin Meng-Yu            
// Filename:    Adder.sv                            
// Description: Adder module of CPU                  
// Version:     HW3 Submit Version
// Date:        2023/11/23
//================================================

module Adder (
    input logic [31:0] data_1,
    input logic [31:0] data_2,
    output logic [31:0] data_out
);
    always_comb begin
        data_out = data_1 + data_2;
    end
endmodule