module IF_ID(
    clk,
    rst,
    PC_in,
    stall,
    PC_out,
    flush,
    instruction_in,
    instruction_out,
	waiting,
	WFI,
	MRET,
	p
);

input clk,rst,stall,flush,waiting,WFI,MRET,p;
input [31:0] PC_in,instruction_in;
output logic [31:0] PC_out,instruction_out;

always_ff @( posedge clk ) begin //write
    if(rst) begin
        PC_out<=32'd0;
        instruction_out<=32'd0;
    end	
    else if(stall!=1'b0 || waiting==1'd1) begin
        PC_out<=PC_out;
		instruction_out<=instruction_out;
    end
    else if(flush!=1'b0 || WFI!=1'd0 ||MRET==1'd1 ||p==1'd1) begin
        PC_out<=32'd0;
        instruction_out<=32'd0;
    end  
    else begin
        PC_out<=PC_in;
		instruction_out<=instruction_in;
    end
end

endmodule
