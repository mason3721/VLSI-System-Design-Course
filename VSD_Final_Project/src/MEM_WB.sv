module MEM_WB(
    clk,
    rst,
    WE_in,
    WE_out,
    ALU_in,
    ALU_out,
    forward_rd_in,
    forward_rd_out,
	DM_data_out,
	DM_data_in,
	waiting
);

input [31:0] DM_data_in;
input clk,rst,waiting;
input [4:0] WE_in;
input [31:0] ALU_in;
input [4:0] forward_rd_in;
output logic [31:0] ALU_out,DM_data_out;//
output logic [4:0] WE_out;
output logic [4:0] forward_rd_out;

always_ff @( posedge clk ) begin 
    if(rst) begin
        WE_out<=5'd0;
        ALU_out<=32'd0;
        forward_rd_out<=5'd0;
		DM_data_out<=32'd0;
    end
	else if(waiting==1'd1) begin
		WE_out<=WE_out;
        ALU_out<=ALU_out;
        forward_rd_out<=forward_rd_out;
		DM_data_out<=DM_data_out;
	end
    else begin
        WE_out<=WE_in;
        ALU_out<=ALU_in;
        forward_rd_out<=forward_rd_in;
		DM_data_out<=DM_data_in;
    end
end

endmodule