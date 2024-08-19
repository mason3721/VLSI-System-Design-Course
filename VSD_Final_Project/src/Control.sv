module Control(
	clk,
	rst,
    instruction,
    brantch_take,
    EX,
    M,
    WE,
    B_type_JALR_hazard_PC,
    JALR_mux,
	WFI_reg,
	MRET,
	sctrl_interrupt
);

input [31:0] instruction;
input brantch_take,sctrl_interrupt,clk,rst;
output logic [17:0] EX;
output logic [4:0] WE;
output logic [4:0] M;
output logic [1:0] B_type_JALR_hazard_PC;
output logic JALR_mux; 
output logic WFI_reg,MRET;


logic [3:0] ALUop; //[signed_bit,Multiple,...]
logic [1:0] rs1,rs2;
logic Mread,WFI;
logic [3:0] Mwrite;
logic Regsign,Regsel;
logic [2:0] Regwrite;
logic [9:0] CSR_sel;


assign EX={CSR_sel,rs1,rs2,ALUop};
assign M={Mread,Mwrite};
assign WE={Regsign,Regwrite,Regsel};

always_ff@(posedge clk) begin
    if (rst) WFI_reg<=1'd0;
	else if(sctrl_interrupt==1'd1) WFI_reg<=1'd0;
	else if(WFI==1'd1)WFI_reg<=1'd1;
	else WFI_reg<=WFI_reg;
end
	
	
	
always_comb begin
    unique case (instruction[6:0])
        7'b0110011: begin //R_type
            if (instruction[25]) begin
                 unique case (instruction[14:12]) 
                    3'b000: ALUop=4'b1100; //MUL
                    3'b001: ALUop=4'b1101; //MULH
                    3'b010: ALUop=4'b1110; //MULHSU
                    3'b011: ALUop=4'b1111; //MULHU
					default: ALUop=4'd0;
                 endcase
            end
            else begin  
                unique case (instruction[14:12])
                    3'b000: begin
                        unique if(instruction[30])
                            ALUop=4'b0001; //SUB
                        else    
                            ALUop=4'b0000; //ADD
                    end
                    3'b001: ALUop=4'b0010; //SLL
                    3'b010: ALUop=4'b1011; //SLT
                    3'b011: ALUop=4'b0011; //SLTU
                    3'b100: ALUop=4'b0100; //XOR
                    3'b101: begin
                        unique if(instruction[30])
                            ALUop=4'b1010; //SRA 
                        else    
                            ALUop=4'b0101; //SRL
                    end    
                    3'b110: ALUop=4'b0110; //OR
                    3'b111: ALUop=4'b0111; //AND
                endcase
            end
            rs1=2'b00;
            rs2=2'b00;
            Mwrite=4'b1111;     
            Mread=1'b0;
            Regwrite=3'b111;
            Regsign=1'b0;
            Regsel=1'b1;
            B_type_JALR_hazard_PC=2'b00;
            JALR_mux=1'b0;
            CSR_sel=10'd0;
			WFI=1'd0;
			MRET=1'd0;
        end
        7'b0010011: begin //I_type   
            unique case (instruction[14:12])
                3'b000: ALUop=4'b0000; //ADDI
                3'b010: ALUop=4'b1011; //SLTI
                3'b011: ALUop=4'b0011; //SLTIU
                3'b100: ALUop=4'b0100; //XORI
                3'b110: ALUop=4'b0110; //ORI
                3'b111: ALUop=4'b0111; //ANDI
                3'b001: ALUop=4'b0010; //SLLI
                3'b101: begin
                    unique if (instruction[30])
                        ALUop=4'b1010; //SRAI
                    else
                        ALUop=4'b0101; //SRLI
                end
            endcase
            rs1=2'b00;
            rs2=2'b01;
            Mwrite=4'b1111;     
            Mread=1'b0;
            Regwrite=3'b111;
            Regsign=1'b0;
            Regsel=1'b1;
            B_type_JALR_hazard_PC=2'b00;
            JALR_mux=1'b0;
            CSR_sel=10'd0;
			WFI=1'd0;
			MRET=1'd0;
        end
        7'b1100111: begin //JALR
            ALUop=4'b0000;
            rs1=2'b01;
            rs2=2'b11;
            Mwrite=4'b1111;     
            Mread=1'b0;
            Regwrite=3'b111;
            Regsign=1'b0;
            Regsel=1'b1;
            B_type_JALR_hazard_PC=2'b11;
            JALR_mux=1'b1;
            CSR_sel=10'd0;
			WFI=1'd0;
			MRET=1'd0;
        end
        7'b0000011: begin //LOAD
            unique case (instruction[14:12])
                3'b010: begin //LW
                    Regsign=1'b0;
                    Regwrite=3'b111;
                end
                3'b000: begin //LB
                    Regsign=1'b1;
                    Regwrite=3'b001;
                end
                3'b001: begin //LH
                    Regsign=1'b1;
                    Regwrite=3'b011;
                end
                3'b101: begin //LHU
                    Regsign=1'b0; 
                    Regwrite=3'b011;
                end
                3'b100: begin //LBU
                    Regsign=1'b0;
                    Regwrite=3'b001;
                end
				default: begin //LBU
                    Regsign=1'b0;
                    Regwrite=3'b000;
                end
            endcase
            ALUop=4'b0000;
            rs1=2'b00;
            rs2=2'b01;
            Mwrite=4'b1111;
            Mread=1'b1;
            Regsel=1'b0;
            B_type_JALR_hazard_PC=2'b00;
            JALR_mux=1'b0;
            CSR_sel=10'd0;
			WFI=1'd0;
			MRET=1'd0;
        end
        7'b0100011: begin //S_type
            unique case (instruction[14:12])
                3'b010: Mwrite=4'b0000; //SW
                3'b000: Mwrite=4'b1110; //SB
                3'b001: Mwrite=4'b1100; //SH
				default: Mwrite=4'b1111;
            endcase
            ALUop=4'b0000;
            rs1=2'b00;
            rs2=2'b01;
            Mread=1'b0;
            Regwrite=3'b000;
            Regsign=1'b0;
            Regsel=1'b1;
            B_type_JALR_hazard_PC=2'b00;
            JALR_mux=1'b0;
            CSR_sel=10'd0;
			WFI=1'd0;
			MRET=1'd0;
        end
        7'b1100011: begin //B_type
            ALUop=4'b0000;
            rs1=2'b00;
            rs2=2'b00;
            Mwrite=4'b1111;
            Mread=1'b0; 
            Regwrite=3'b000;
            Regsign=1'b0;
            Regsel=1'b1;
            unique if(brantch_take==1'b1)
                B_type_JALR_hazard_PC=2'b11;
            else
                B_type_JALR_hazard_PC=2'b10;
            JALR_mux=1'b0;
            CSR_sel=10'd0;
			WFI=1'd0;
			MRET=1'd0;
        end
        7'b0010111: begin //AUIPC
            ALUop=4'b0000;
            rs1=2'b01;
            rs2=2'b01;
            Mwrite=4'b1111;
            Mread=1'b0; 
            Regwrite=3'b111;
            Regsign=1'b0;
            Regsel=1'b1;
            B_type_JALR_hazard_PC=2'b00;
            JALR_mux=1'b0;
            CSR_sel=10'd0;
			WFI=1'd0;
			MRET=1'd0;
        end
        7'b0110111: begin //LUI
            ALUop=4'b0000;
            rs1=2'b11;
            rs2=2'b01;
            Mwrite=4'b1111;
            Mread=1'b0; 
            Regwrite=3'b111;
            Regsign=1'b0;
            Regsel=1'b1;
            B_type_JALR_hazard_PC=2'b00;
            JALR_mux=1'b0;
            CSR_sel=10'b00;
			WFI=1'd0;
			MRET=1'd0;
        end
        7'b1101111: begin //J_type
            ALUop=4'b0000;
            rs1=2'b01;
            rs2=2'b11;
            Mwrite=4'b1111;
            Mread=1'b0; 
            Regwrite=3'b111;
            Regsign=1'b0;
            Regsel=1'b1;
            B_type_JALR_hazard_PC=2'b01;
            JALR_mux=1'b0;
            CSR_sel=10'd0;
			WFI=1'd0;
			MRET=1'd0;
        end
        7'b1110011: begin //CSR
            ALUop=4'b0000;
            rs1=2'b10;
            rs2=2'b10;
            Mwrite=4'b1111;
            Mread=1'b0; 
            Regwrite=3'b111;
            Regsign=1'b0;
            Regsel=1'b1;
            B_type_JALR_hazard_PC=2'b00;
            JALR_mux=1'b0;
            CSR_sel={instruction[19:12],instruction[27],instruction[21]};
			if(instruction[14:12]==3'd0 && instruction[20]==1'd1) begin
				WFI=1'd1;
				MRET=1'd0;
			end
			else if(instruction[14:12]==3'd0 && instruction[20]==1'd0) begin
				WFI=1'd0;
				MRET=1'd1;
			end
			else begin
				WFI=1'd0;
				MRET=1'd0;
			end
        end
		default: begin
			ALUop=4'b0000;
            rs1=2'b00;
            rs2=2'b00;
            Mwrite=4'b1111;
            Mread=1'b0; 
            Regwrite=3'b000;
            Regsign=1'b0;
            Regsel=1'b0;
            B_type_JALR_hazard_PC=2'b00;
            JALR_mux=1'b0;
            CSR_sel=10'd0;
			WFI=1'd0;
			MRET=1'd0;
		end
    endcase
    
end
endmodule
