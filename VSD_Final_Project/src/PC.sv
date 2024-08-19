module PC(
    clk,
    rst,
    stall,
    in,
    out,
	waiting,
	WFI,
	sen_pulse
);

input clk,rst,stall,waiting,WFI,sen_pulse;
input [31:0] in;
output logic [31:0] out;

always_ff @(posedge clk) begin 
    if(rst) begin
        out<=32'd0;
    end
    else if(stall!=1'b0 || waiting==1'd1) begin
		out<=out;
    end
	else if(WFI==1'd1 ) begin
		if(sen_pulse==1'd1) out<=in;
        else out<=out;
    end
    else begin
        out<=in;
    end
end

endmodule