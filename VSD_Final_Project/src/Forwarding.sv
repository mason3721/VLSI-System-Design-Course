module Forwarding(
	ID_rs1,
	ID_rs2,
	EX_rs1,
	EX_rs2,
	M_rd,
	WE_rd,
	M_regwrite,
	WE_regwrite,
	forward_EX_rs1,
	forward_EX_rs2,
	forward_ID_comp_rs1,
	forward_ID_comp_rs2,
	forward_ID_JALR
);

input [4:0] ID_rs1,ID_rs2,EX_rs1,EX_rs2,M_rd,WE_rd;
input M_regwrite,WE_regwrite; //take regwrite's last bit[0]
output logic [1:0] forward_EX_rs1,forward_EX_rs2;
output logic forward_ID_comp_rs1,forward_ID_comp_rs2,forward_ID_JALR;
/*always_comb begin
	if((M_regwrite!=1'b0)&&(M_rd!=5'd0)&&(M_rd==EX_rs1)) begin //EXE-EXE
		forward_EX_rs1=2'b01;
	end
	else if((WE_regwrite!=1'b0)&&(WE_rd!=5'd0)&&(WE_rd==EX_rs1)) begin //MEM-EXE
		forward_EX_rs1=2'b10;
	end
	else begin
		forward_EX_rs1=2'b00;
	end
	if((M_regwrite!=1'b0)&&(M_rd!=5'd0)&&(M_rd==EX_rs2)) begin //EXE-EXE
		forward_EX_rs2=2'b01;
	end
	else if((WE_regwrite!=1'b0)&&(WE_rd!=5'd0)&&(WE_rd==EX_rs2)) begin //MEM-EXE
		forward_EX_rs2=2'b10;
	end
	else begin
		forward_EX_rs2=2'b00;
	end
	if((M_regwrite!=1'b0)&&(M_rd!=5'd0)&&(M_rd==ID_rs1)) begin //EXE-ID-comparator、JALR
		forward_ID_comp_rs1=1'b1;
		forward_ID_JALR=1'b1;
	end
	else begin
		forward_ID_comp_rs1=1'b0;
		forward_ID_JALR=1'b0;
	end
	if((M_regwrite!=1'b0)&&(M_rd!=5'd0)&&(M_rd==ID_rs2)) begin //EXE-ID-comparator
		forward_ID_comp_rs2=1'b1;
	end
	else begin
		forward_ID_comp_rs2=1'b0;
	end

end*/
/*
always_comb begin
	if((M_regwrite!=1'b0)&&(M_rd!=5'd0)) begin //EXE-EXE
		if(M_rd==EX_rs1) forward_EX_rs1=2'b01;
		else forward_EX_rs1=2'b00;
		if(M_rd==EX_rs2) forward_EX_rs2=2'b01;
		else forward_EX_rs2=2'b00;
		if(M_rd==ID_rs1) begin //EXE-ID-comparator、JALR
			forward_ID_comp_rs1=1'b1;
			forward_ID_JALR=1'b1;
		end
		else begin
			forward_ID_comp_rs1=1'b0;
			forward_ID_JALR=1'b0;
		end
		if(M_rd==ID_rs2) forward_ID_comp_rs2=1'b1;
		else forward_ID_comp_rs2=1'b0;
	end
	else if((WE_regwrite!=1'b0)&&(WE_rd!=5'd0)) begin //MEM-EXE
		if(WE_rd==EX_rs1) forward_EX_rs1=2'b10;
		else forward_EX_rs1=2'b00;
		if(WE_rd==EX_rs2) forward_EX_rs2=2'b10;
	        else forward_EX_rs2=2'b00;
	end
	else begin
		forward_EX_rs1=2'b00;
		forward_EX_rs2=2'b00;
		forward_ID_comp_rs1=1'b0;
		forward_ID_JALR=1'b0;
		forward_ID_comp_rs2=1'b0;
	end
end*/
always_comb begin
	if((M_regwrite!=1'b0)&&(M_rd!=5'd0)) begin //EXE-EXE
		if(M_rd==EX_rs1) forward_EX_rs1[0]=1'b1;
		else forward_EX_rs1[0]=1'b0;
		if(M_rd==EX_rs2) forward_EX_rs2[0]=1'b1;
		else forward_EX_rs2[0]=1'b0;
		if(M_rd==ID_rs1) begin //EXE-ID-comparator、JALR
			forward_ID_comp_rs1=1'b1;
			forward_ID_JALR=1'b1;
		end
		else begin
			forward_ID_comp_rs1=1'b0;
			forward_ID_JALR=1'b0;
		end
		if(M_rd==ID_rs2) forward_ID_comp_rs2=1'b1;
		else forward_ID_comp_rs2=1'b0;
	end
	else begin
		forward_EX_rs1[0]=1'b0;
		forward_EX_rs2[0]=1'b0;
		forward_ID_comp_rs1=1'b0;
		forward_ID_JALR=1'b0;
		forward_ID_comp_rs2=1'b0;
	end
	if((WE_regwrite!=1'b0)&&(WE_rd!=5'd0)) begin //MEM-EXE
		if(WE_rd==EX_rs1) forward_EX_rs1[1]=1'b1;
		else forward_EX_rs1[1]=1'b0;
		if(WE_rd==EX_rs2) forward_EX_rs2[1]=1'b1;
	        else forward_EX_rs2[1]=1'b0;
	end
	else begin
		forward_EX_rs1[1]=1'b0;
		forward_EX_rs2[1]=1'b0;
	end
end
endmodule
