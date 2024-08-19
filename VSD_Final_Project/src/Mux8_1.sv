module Mux8_1(
    I0,
    I1,
    I2,
    I3,
	I4,
	I5,
	I6,
	I7,
    sel,
    out
);

input [31:0] I0,I1,I2,I3,I4,I5,I6,I7;
input [2:0] sel;
output logic [31:0] out;

always_comb begin
    unique case(sel)
        3'b000: out=I0;
        3'b001: out=I1;
        3'b010: out=I2;
        3'b011: out=I3;
		3'b100: out=I4;
        3'b101: out=I5;
        3'b110: out=I6;
        3'b111: out=I7;
    endcase
end

endmodule
