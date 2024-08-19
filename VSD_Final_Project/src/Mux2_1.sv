module Mux2_1(
    I0,
    I1,
    sel,
    out
);

input [31:0] I0,I1;
input sel;
output logic [31:0] out;

always_comb begin
    unique case(sel)
        1'b0: out=I0;
        1'b1: out=I1;
    endcase
end

endmodule
