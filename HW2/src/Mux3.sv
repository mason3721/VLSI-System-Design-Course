module Mux3(
    input logic [31:0] data_in1,
    input logic [31:0] data_in2,
    input logic [31:0] data_in3,
    input logic [1:0] select_line,
    output logic [31:0] data_out 
);
    always_comb begin
        case(select_line)
        2'd0:
            data_out = data_in1;
        2'd1:
            data_out = data_in2;
        2'd2:
            data_out = data_in3;
        default:
            data_out = data_in2;
        endcase
    end
endmodule