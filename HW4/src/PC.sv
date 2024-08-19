module PC (
    input               clk,
    input               rst,
    input               stall,
    input        [31:0] PC_in,
	input               Interrupt_Confirm_Timer,
	
    output logic [31:0] PC_out
);
always_ff @(posedge clk) begin
	priority if (rst) begin
		PC_out <= 32'd0;
	end else if (Interrupt_Confirm_Timer) begin
		PC_out <= 32'd0;
	end else if (~stall) begin
		PC_out <= PC_in;
	end else begin
		PC_out <= PC_out;
	end
end
endmodule
