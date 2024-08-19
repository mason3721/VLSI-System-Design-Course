module PC_delay(
    clk,
    rst,
    in,
    out,
	waiting
);

input clk,rst,waiting;
input [31:0] in;
output logic [31:0] out;

always_ff @(posedge clk ) begin 
    if(rst) begin
        out<=32'd0;
    end
	else if(waiting==1'd1) out<=out;
    else begin
        out<=in;
    end
end

endmodule
