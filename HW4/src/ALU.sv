module ALU (
    input        [31:0] ALU_in1,
    input        [31:0] ALU_in2,
    input        [4:0]  ALU_sel,

    output logic [31:0] ALU_result,
    output logic        Branch_flag
);
	logic [63:0] multiplexer;
	logic        equal;
	assign equal = &(ALU_in1 ~^ ALU_in2);

	always_comb begin
		unique case(ALU_sel)
			5'b00000:
			begin
				ALU_result = ALU_in1 + ALU_in2;	//ADD,LW,ADDI,LB,LH,LHU,LBU,SW,SB,SH,AUIPC,JALR,LUI,JAL
				Branch_flag = 1'b0;
				multiplexer = 64'd0;
			end
			5'b00001:
			begin
				ALU_result = ALU_in1 - ALU_in2;	//SUB
				Branch_flag = 1'b0;
				multiplexer = 64'd0;
			end
			5'b00010:
			begin
				ALU_result = ALU_in1 << ALU_in2[4:0];	//SLL,SLLI
				Branch_flag = 1'b0;
				multiplexer = 64'd0;
			end
			5'b00011:
			begin
				ALU_result = ($signed(ALU_in1) < $signed(ALU_in2))?32'd1:32'd0;	//SLT,SLTI
				Branch_flag = 1'b0;
				multiplexer = 64'd0;
			end
			5'b00100:
			begin
				ALU_result = (ALU_in1 < ALU_in2)?32'd1:32'd0;	//SLTU,SLTIU
				Branch_flag = 1'b0;
				multiplexer = 64'd0;
			end
			5'b00101:
			begin
				ALU_result = ALU_in1 ^ ALU_in2;	//XOR,XORI
				Branch_flag = 1'b0;
				multiplexer = 64'd0;
			end
			5'b00110:begin
				ALU_result = ALU_in1 >> ALU_in2[4:0];	//SRL,SRLI
				Branch_flag = 1'b0;
				multiplexer = 64'd0;
			end
			5'b00111:
			begin
				ALU_result = $signed(ALU_in1) >>> ALU_in2[4:0];	//SRA,SRAI
				Branch_flag = 1'b0;
				multiplexer = 64'd0;
			end
			5'b01000:
			begin
				ALU_result = ALU_in1 | ALU_in2;	//OR,ORI
				Branch_flag = 1'b0;
				multiplexer = 64'd0;
			end
			5'b01001:
			begin
				ALU_result = ALU_in1 & ALU_in2;	//AND,ANDI
				Branch_flag = 1'b0;
				multiplexer = 64'd0;
			end
			5'b01010:
			begin
				ALU_result = 32'd0;	//BEQ
				Branch_flag = (equal) ? 1'b1 : 1'b0;
				multiplexer = 64'd0;
			end
			5'b01011:
			begin
				ALU_result = 32'd0;	//BNE
				Branch_flag = (~equal) ? 1'b1 : 1'b0;
				multiplexer = 64'd0;
			end
			5'b01100:
			begin
				ALU_result = 32'd0;	//BLT
				Branch_flag = ($signed(ALU_in1) < $signed(ALU_in2))?1'b1:1'b0;
				multiplexer = 64'd0;
			end
			5'b01101:
			begin
				ALU_result = 32'd0;	//BGE
				Branch_flag = ($signed(ALU_in1) >= $signed(ALU_in2))?1'b1:1'b0;
				multiplexer = 64'd0;
			end
			5'b01110:
			begin
				ALU_result = 32'd0;	//BLTU
				Branch_flag = (ALU_in1 < ALU_in2)?1'b1:1'b0;
				multiplexer = 64'd0;
			end
			5'b01111:
			begin
				ALU_result = 32'd0;	//BGEU
				Branch_flag = (ALU_in1 >= ALU_in2)?1'b1:1'b0;
				multiplexer = 64'd0;
			end
			5'b10000:
			begin
				multiplexer = 64'd0;
				multiplexer = ALU_in1 * ALU_in2;
				ALU_result = multiplexer[31:0];
				Branch_flag = 1'd0;
			end
			5'b10001:
			begin
				multiplexer = $signed(ALU_in1) * $signed(ALU_in2)  ;
				ALU_result = multiplexer[63:32];
				Branch_flag = 1'd0;
			end
			5'b10010:
			begin
				multiplexer = $signed( {32'hffffffff, ALU_in1 } ) * ALU_in2 ;
				multiplexer = multiplexer;
				ALU_result = multiplexer[63:32];
				Branch_flag = 1'd0;
			end
			5'b10100:
			begin
				multiplexer = ALU_in1 * ALU_in2;
				ALU_result = multiplexer[63:32];
				Branch_flag = 1'd0;
			end
			default:begin
				multiplexer = 64'd0;
				ALU_result = 32'd0;
				Branch_flag = 1'd0;
			end
		endcase
	end
endmodule
