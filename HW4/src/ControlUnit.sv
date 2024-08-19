module ControlUnit(
    input        [6:0]  Opcode,
    input        [2:0]  funct3,
    input        [6:0]  funct7,          ///****
    input        [11:0] csr_imm,
    input               stall,

    output logic [1:0]  ALU_src1,
    output logic [1:0]  ALU_src2, 
    output logic [2:0]  ImmSel,
    output logic [4:0]  ALU_op,
    output logic        MemToReg,
    output logic        RegWrite, 
    output logic [3:0]  MemRead,
    output logic [2:0]  MemWrite,
    output logic        WbSel,
    output logic        Jump,
    output logic        Jalr,
    output logic        Branch,
	
    //for CSR
    output logic        WFI,
    output logic        MRET,
    output logic        ALUSrc_CSR,
    output logic [1:0]  ALU_op_CSR,
    output logic        RegWrite_CSR
);
	localparam RTYPE = 7'b0110011;
	localparam ITYPE = 7'b0010011;
	localparam ITYPE_L = 7'b0000011;
	localparam ITYPE_JALR = 7'b1100111;
	localparam STYPE = 7'b0100011;
	localparam BTYPE = 7'b1100011;
	localparam UTYPE = 7'b0110111;
	localparam AUIPC = 7'b0010111;
	localparam JTYPE = 7'b1101111;
	localparam CSR =  7'b1110011;
	localparam Op_Rw_CSR = 2'b00;
	localparam Op_Rs_CSR = 2'b01;
	localparam Op_Rc_CSR = 2'b10;

always_comb begin
    ALU_src1 = 2'b00;
    ALU_src2 = 2'b00;
    ImmSel = 3'b000;
    ALU_op = 5'b0000;
    MemToReg = 1'b0;
    RegWrite = 1'b0;
    MemRead = 4'b0000;
    MemWrite = 3'b000;
    WbSel = 1'b0;
    Jump = 1'b0;
    Jalr = 1'b0;
    Branch = 1'b0;

    WFI = 1'b0;
    MRET = 1'b0;
    ALUSrc_CSR = 1'b0;
    ALU_op_CSR = 2'b00;
    RegWrite_CSR = 1'b0;

    case (Opcode)
        RTYPE:
		begin
			ALU_src1 = 2'b00;
			ALU_src2 = 2'b00;
			ImmSel = 3'b000;
			ALU_op = 5'b0000;
			MemToReg = 1'b0;
            RegWrite = 1'b1;
			MemRead = 4'b0000;
			MemWrite = 3'b000;
			WbSel = 1'b0;
			Jump = 1'b0;
			Jalr = 1'b0;
			Branch = 1'b0;
			WFI = 1'b0;
			MRET = 1'b0;
			ALUSrc_CSR = 1'b0;
			ALU_op_CSR = 2'b00;
			RegWrite_CSR = 1'b0;
            case (funct7)
                7'b0000000:
				begin
                    case (funct3)
						3'b000: ALU_op = 5'b00000; //ADD
						3'b001: ALU_op = 5'b00010; //SLL
						3'b010: ALU_op = 5'b00011; //SLT
						3'b011: ALU_op = 5'b00100; //SLTU
						3'b100: ALU_op = 5'b00101; //XOR
						3'b101: ALU_op = 5'b00110; //SRL
						3'b110: ALU_op = 5'b01000; //OR
						3'b111: ALU_op = 5'b01001; //AND;
                    endcase
                end
                7'b0100000:
				begin
                    case (funct3)
						3'b000: ALU_op = 5'b00001; //SUB
						3'b101: ALU_op = 5'b00111; //SRA	
						default: ALU_op = 5'b01111;
                    endcase
                end
				7'b0000001:
				begin
					case (funct3)
						3'b000: ALU_op = 5'b10000;
						3'b001: ALU_op = 5'b10001;
						3'b010: ALU_op = 5'b10010;
						3'b011: ALU_op = 5'b10100;
					    default: ALU_op = 5'b00000;
				    endcase
                end
            endcase
        end
        ITYPE:
		begin
		    RegWrite = 1'b1;
		    ALU_src1 = 2'b00;
			ALU_op = 5'b0000;
			MemToReg = 1'b0;
			MemRead = 4'b0000;
			MemWrite = 3'b000;
			WbSel = 1'b0;
			Jump = 1'b0;
			Jalr = 1'b0;
			Branch = 1'b0;
			WFI = 1'b0;
			MRET = 1'b0;
			ALUSrc_CSR = 1'b0;
			ALU_op_CSR = 2'b00;
			RegWrite_CSR = 1'b0;
            ALU_src2 = 2'b01;
            ImmSel = 3'b001;
			case(funct3)
				3'b000: ALU_op = 5'b00000; //ADDI
				3'b001: ALU_op = 5'b00010; //SLLI
				3'b010: ALU_op = 5'b00011; //SLTI
				3'b011: ALU_op = 5'b00100; //SLTIU
				3'b100: ALU_op = 5'b00101; //XORI
				3'b110: ALU_op = 5'b01000; //ORI
				3'b111: ALU_op = 5'b01001; //ANDI
				3'b101:
				begin
					unique case(funct7)
						7'b0000000: ALU_op = 5'b00110; //SRLI
						7'b0100000: ALU_op = 5'b00111; //SRAI
						default: ALU_op = 5'b00000;
					endcase
				end
			endcase
        end
        ITYPE_L:
		begin
            ALU_src2 = 2'b01;
            ImmSel = 3'b001;
            MemToReg = 1'b1;
            RegWrite = 1'b1;
			ALU_src1 = 2'b00;
			ALU_op = 5'b0000;
			MemRead = 4'b0000;
			MemWrite = 3'b000;
			WbSel = 1'b0;
			Jump = 1'b0;
			Jalr = 1'b0;
			Branch = 1'b0;
			WFI = 1'b0;
			MRET = 1'b0;
			ALUSrc_CSR = 1'b0;
			ALU_op_CSR = 2'b00;
			RegWrite_CSR = 1'b0;
            unique case (funct3)
                3'b010: MemRead = 4'b0001;//LW 
                3'b001: MemRead = 4'b0010;//LH
                3'b000: MemRead = 4'b0100;//LB
                3'b101: MemRead = 4'b1010;//LHU
                3'b100: MemRead = 4'b1100;//LBU
                default: MemRead = 4'b0001;
            endcase
        end
        ITYPE_JALR:
		begin
		    ALU_src1 = 2'b00;
			ALU_op = 5'b00000;  //JALR
			MemToReg = 1'b0;
			MemRead = 4'b0000;
			MemWrite = 3'b000;
			Jump = 1'b0;
			Branch = 1'b0;
			WFI = 1'b0;
			MRET = 1'b0;
			ALUSrc_CSR = 1'b0;
			ALU_op_CSR = 2'b00;
			RegWrite_CSR = 1'b0;
            ALU_src2 = 2'b01;
            ImmSel = 3'b001;
            RegWrite = 1'b1;
            WbSel = 1'b1;
            Jalr = 1'b1;
        end
        STYPE:
		begin
            ALU_src2 = 2'b01;
            ImmSel = 3'b010;
			
			ALU_src1 = 2'b00;
			ALU_op = 5'b00000;  //JALR
			MemToReg = 1'b0;
			RegWrite = 1'b0;
			MemRead = 4'b0000;
			MemWrite = 3'b000;
			WbSel = 1'b0;
			Jump = 1'b0;
			Jalr = 1'b0;
			Branch = 1'b0;
			WFI = 1'b0;
			MRET = 1'b0;
			ALUSrc_CSR = 1'b0;
			ALU_op_CSR = 2'b00;
			RegWrite_CSR = 1'b0;
            unique case (funct3)
                3'b010: MemWrite = 3'b001;
                3'b001: MemWrite = 3'b010;
                3'b000: MemWrite = 3'b100;
                default: MemWrite = 3'b001;
            endcase
        end
        BTYPE:
		begin
            ImmSel = 3'b011;
			ALU_src1 = 2'b00;
			ALU_src2 = 2'b00;
			ALU_op = 5'b0000;
			MemToReg = 1'b0;
			RegWrite = 1'b0;
			MemRead = 4'b0000;
			MemWrite = 3'b000;
			WbSel = 1'b0;
			Jump = 1'b0;
			Jalr = 1'b0;
			Branch = 1'b1;
			WFI = 1'b0;
			MRET = 1'b0;
			ALUSrc_CSR = 1'b0;
			ALU_op_CSR = 2'b00;
			RegWrite_CSR = 1'b0;
			unique case(funct3)
				3'b000:ALU_op = 5'b01010;	//BEQ
				3'b001:ALU_op = 5'b01011;	//BNE
				3'b100:ALU_op = 5'b01100;	//BLT
				3'b101:ALU_op = 5'b01101;	//BGE
				3'b110:ALU_op = 5'b01110;	//BLTU
				3'b111:ALU_op = 5'b01111;	//BGEU
				default:ALU_op = 5'b01111;
			endcase        
        end

        AUIPC:
		begin
			ALU_op = 5'b00000; //AUIPC
			MemToReg = 1'b0;
			MemRead = 4'b0000;
			MemWrite = 3'b000;
			WbSel = 1'b0;
			Jump = 1'b0;
			Jalr = 1'b0;
			Branch = 1'b0;
			WFI = 1'b0;
			MRET = 1'b0;
			ALUSrc_CSR = 1'b0;
			ALU_op_CSR = 2'b00;
			RegWrite_CSR = 1'b0;
            ALU_src1 = 2'b01;    //pc
            ALU_src2 = 2'b01;
            ImmSel = 3'b100;
            RegWrite = 1'b1;
        end
        UTYPE:
		begin
            ALU_src1 = 2'b10;    //0
            ALU_src2 = 2'b01;
            ImmSel = 3'b100;
            RegWrite = 1'b1;			   
			ALU_op = 5'b00000; //LUI
			MemToReg = 1'b0;
			MemRead = 4'b0000;
			MemWrite = 3'b000;
			WbSel = 1'b0;
			Jump = 1'b0;
			Jalr = 1'b0;
			Branch = 1'b0;
			WFI = 1'b0;
			MRET = 1'b0;
			ALUSrc_CSR = 1'b0;
			ALU_op_CSR = 2'b00;
			RegWrite_CSR = 1'b0;
        end
        JTYPE:
		begin
            ALU_src1 = 2'b01;    //pc
            ALU_src2 = 2'b01;
            ImmSel = 3'b101;
            RegWrite = 1'b1;
            WbSel = 1'b1;
            Jump = 1'b1;	   
			ALU_op = 5'b00000; //LUI
			MemToReg = 1'b0; 
			MemRead = 4'b0000;
			MemWrite = 3'b000;
			Jalr = 1'b0;
			Branch = 1'b0;
			WFI = 1'b0;
			MRET = 1'b0;
			ALUSrc_CSR = 1'b0;
			ALU_op_CSR = 2'b00;
			RegWrite_CSR = 1'b0;
        end
        CSR:
		begin
            unique if (csr_imm == 12'b0011_0000_0010) begin    //MRET
                MRET = 1'b1;
            end else if (csr_imm == 12'b0001_0000_0101) begin   //WFI
                WFI = 1'b1;
            end else begin  //csr
                ImmSel = 3'b110;    //uimm
                ALU_src1 = 2'b10;    // 0
                ALU_src2 = 2'b10;
                RegWrite = 1'b1;
                RegWrite_CSR = 1'b1;
                case (funct3)
                    3'b001: ALU_op_CSR = Op_Rw_CSR;
                    3'b010: ALU_op_CSR = Op_Rs_CSR;
                    3'b011: ALU_op_CSR = Op_Rc_CSR;
                    3'b101:
					begin
                        ALUSrc_CSR = 1'b1;
                        ALU_op_CSR = Op_Rw_CSR;
                    end
                    3'b110:
					begin
                        ALUSrc_CSR = 1'b1;
                        ALU_op_CSR = Op_Rs_CSR;
                    end
                    3'b111:
					begin
                        ALUSrc_CSR = 1'b1;
                        ALU_op_CSR = Op_Rc_CSR;
                    end
                endcase
            end
        end
    endcase

    if (stall == 1'b1) begin
        ALU_src1 = 2'b00;
        ALU_src2 = 2'b00;
        ImmSel = 3'b000;
        ALU_op = 5'b0000;
        MemToReg = 1'b0;
        RegWrite = 1'b0;
        MemRead = 4'b0000;
        MemWrite = 3'b000;
        Jump = 1'b0;
        Jalr = 1'b0;
        Branch = 1'b0;
        WFI = 1'b0;
        MRET = 1'b0;
        ALUSrc_CSR = 1'b0;
        ALU_op_CSR = 2'b00;
        RegWrite_CSR = 1'b0;
    end
end  
endmodule