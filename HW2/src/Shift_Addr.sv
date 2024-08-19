module Shift_Addr (
    input logic [2:0] func3,
    input logic [1:0] shift_addr_sel,
    input logic [31:0] addr_in,
    output logic [31:0] addr_out
);
    always_comb begin
            case(func3)
            3'b010: // sw
                addr_out = addr_in;
            3'b001: // sh
                if(shift_addr_sel == 2'b00)
                    addr_out = {16'd0, addr_in[15:0]};
                else
                    addr_out = {addr_in[15:0], 16'd0};
            3'b000: // sb
                if(shift_addr_sel == 2'b00)       // 4-byte aligned
                    addr_out = {24'd0, addr_in[7:0]};
                else if(shift_addr_sel == 2'b11)  // 1-byte aligned
                    addr_out = {addr_in[7:0], 24'd0};
                else if(shift_addr_sel == 2'b10)  // 2-byte aligned
                    addr_out = {8'd0, addr_in[7:0], 16'd0};
                else                              // 3-byte aligned
                    addr_out = {16'd0, addr_in[7:0], 8'd0};

            default:
                addr_out = addr_in;
            endcase
    end
endmodule