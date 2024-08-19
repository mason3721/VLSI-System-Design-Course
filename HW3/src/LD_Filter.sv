//================================================
// Auther:      Lin Meng-Yu            
// Filename:    LD_Filter.sv                            
// Description: Load Filter module of CPU                  
// Version:     HW3 Submit Version
// Date:        2023/11/23
//================================================

module LD_Filter (
    input logic [2:0]  func3,
    input logic [31:0] ld_data,
    input logic [1:0]  W_aluout,
    output logic [31:0] ld_data_f
);
    always_comb begin
        /*case(func3)
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
        endcase*/

    case (func3)
         3'b000: begin       // lb
            case (W_aluout)
                2'b00: ld_data_f = {{24{ld_data[7]}}, ld_data[7:0]};
                2'b01: ld_data_f = {{24{ld_data[15]}}, ld_data[15:8]};
                2'b10: ld_data_f = {{24{ld_data[23]}}, ld_data[23:16]};
                2'b11: ld_data_f = {{24{ld_data[31]}}, ld_data[31:24]};
            endcase
        end   

        3'b001: begin       // lh
            case (W_aluout[1])
                1'b0: ld_data_f = {{16{ld_data[15]}}, ld_data[15:0]};
                1'b1: ld_data_f = {{16{ld_data[31]}}, ld_data[31:16]};
            endcase
        end

        3'b010: begin       // lw
                       ld_data_f = ld_data;  
        end   

        3'b100: begin       // lbu
            case (W_aluout)
                2'b00: ld_data_f = {{24{1'b0}}, ld_data[7:0]};
                2'b01: ld_data_f = {{24{1'b0}}, ld_data[15:8]};
                2'b10: ld_data_f = {{24{1'b0}}, ld_data[23:16]};
                2'b11: ld_data_f = {{24{1'b0}}, ld_data[31:24]};
            endcase
        end

        3'b101: begin   // lhu
            case (W_aluout[1])
                1'b0: ld_data_f = {{16{1'b0}}, ld_data[15:0]};
                1'b1: ld_data_f = {{16{1'b0}}, ld_data[31:16]};
            endcase
        end

        default: 
            ld_data_f = 32'd0;
    endcase
    end 
endmodule
