module store_data_shift(
	ALU_out_10,
	EXE_M_wen,
	rs2_temp,
	rs2_temp_out,
	EXE_M_wen_out
);

input [1:0] ALU_out_10;
input [3:0] EXE_M_wen;
input [31:0] rs2_temp;
output logic [31:0] rs2_temp_out;
output logic [3:0] EXE_M_wen_out;

always_comb begin
	unique case(ALU_out_10[1:0])
		2'b00: begin
			EXE_M_wen_out=EXE_M_wen;
			rs2_temp_out=rs2_temp;
		end
		2'b01: begin
			EXE_M_wen_out[3:0]={EXE_M_wen[2],EXE_M_wen[1],EXE_M_wen[0],EXE_M_wen[3]};
			rs2_temp_out={rs2_temp[23:0],8'd0};
		end
		2'b10: begin
			EXE_M_wen_out[3:0]={EXE_M_wen[1],EXE_M_wen[0],EXE_M_wen[3],EXE_M_wen[2]};
			rs2_temp_out={rs2_temp[15:0],16'd0};
		end
		2'b11: begin
			EXE_M_wen_out[3:0]={EXE_M_wen[0],EXE_M_wen[3],EXE_M_wen[2],EXE_M_wen[1]};
			rs2_temp_out={rs2_temp[7:0],24'd0};
		end
	endcase
end

endmodule