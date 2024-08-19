module Adder (
    input logic [31:0] data_1,
    input logic [31:0] data_2,
    output logic [31:0] data_out
);
    always_comb begin
        data_out = data_1 + data_2;
    end
endmodule