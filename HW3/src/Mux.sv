//================================================
// Auther:      Lin Meng-Yu            
// Filename:    Mux.sv                            
// Description: Mux2 module of CPU                  
// Version:     HW3 Submit Version
// Date:        2023/11/23
//================================================

module Mux(
    input logic [31:0] data_in1,
    input logic [31:0] data_in2,
    input logic select_line,
    output logic [31:0] data_out 
);
    always_comb begin
        if(select_line)
            data_out = data_in1;
        else
            data_out = data_in2;
    end
endmodule