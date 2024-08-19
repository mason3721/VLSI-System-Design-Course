module ID_EXE(
    clk,
    rst,
    EX_in,
    EX_out,
    M_in,
    M_out,
    WE_in,
    WE_out,
    PC_in,
    PC_out,
    indata1,
    outdata1,
    indata2,
    outdata2,
    imm_in,
    imm_out,
    forward_EX_rs1_in,
    forward_EX_rs1_out,
    forward_EX_rs2_in,
    forward_EX_rs2_out,
    forward_rd_in,
    forward_rd_out,
    flush,
	waiting,
	WFI
);

input clk,rst,flush,waiting,WFI;
input [17:0] EX_in;
input [4:0] M_in;
input [4:0] WE_in;
input [31:0] PC_in,indata1,indata2,imm_in;
input [4:0] forward_EX_rs1_in,forward_EX_rs2_in,forward_rd_in;
output logic [17:0] EX_out;
output logic [4:0] M_out;
output logic [4:0] WE_out;
output logic [31:0] PC_out,outdata1,outdata2,imm_out;
output logic [4:0] forward_EX_rs1_out,forward_EX_rs2_out,forward_rd_out;

always_ff @( posedge clk ) begin 
    if(rst) begin
        EX_out<=18'd0;
        M_out<=5'b01111;
        WE_out<=5'd0;
        PC_out<=32'd0;
        outdata1<=32'd0;
        outdata2<=32'd0;
        imm_out<=32'd0;
        forward_EX_rs1_out<=5'd0;
        forward_EX_rs2_out<=5'd0;
        forward_rd_out<=5'd0;
    end
	else if(waiting==1'd1) begin
		EX_out<=EX_out;
        M_out<=M_out;
        WE_out<=WE_out;
        PC_out<=PC_out;
        outdata1<=outdata1;
        outdata2<=outdata2;
        imm_out<=imm_out;
        forward_EX_rs1_out<=forward_EX_rs1_out;
        forward_EX_rs2_out<=forward_EX_rs2_out;
        forward_rd_out<=forward_rd_out;
	end
    else if(flush!=1'b0 || WFI==1'd1) begin
        EX_out<=18'd0;
        M_out<=5'b01111;
        WE_out<=5'd0;
        PC_out<=32'd0;
        outdata1<=32'd0;
        outdata2<=32'd0;
        imm_out<=32'd0;
        forward_EX_rs1_out<=5'd0;
        forward_EX_rs2_out<=5'd0;
        forward_rd_out<=5'd0;
    end
    else begin
        EX_out<=EX_in;
        M_out<=M_in;
        WE_out<=WE_in;
        PC_out<=PC_in;
        outdata1<=indata1;
        outdata2<=indata2;
        imm_out<=imm_in;
        forward_EX_rs1_out<=forward_EX_rs1_in;
        forward_EX_rs2_out<=forward_EX_rs2_in;
        forward_rd_out<=forward_rd_in;
    end
end
endmodule