module LD_Filter (
    input logic [2:0] func3,
    input logic [31:0] ld_data,
    output logic [31:0] ld_data_f
);
    always_comb begin
        case(func3)
            3'b000: begin // lb
                ld_data_f = {{24{ld_data[7]}},ld_data[7:0]};
            end
            3'b001: begin // lh
                ld_data_f = {{16{ld_data[15]}},ld_data[15:0]};
            end
            3'b010: begin // lw
                ld_data_f = ld_data; 
            end
            3'b100: begin // lbu
                ld_data_f = {24'b0,ld_data[7:0]};
            end
            3'b101: begin //lhu
                ld_data_f = {16'b0,ld_data[15:0]};
            end
            default: begin
                ld_data_f = 32'b0;
            end
        endcase
    end 
endmodule