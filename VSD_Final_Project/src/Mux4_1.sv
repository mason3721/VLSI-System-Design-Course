module Mux4_1(
    I0,
    I1,
    I2,
    I3,
    sel,
    out
);

input [31:0] I0,I1,I2,I3;
input [1:0] sel;
output logic [31:0] out;

always_comb begin
    unique case(sel)
        2'b00: out=I0;
        2'b01: out=I1;
        2'b10: out=I2;
        2'b11: out=I3;
    endcase
end

endmodule
