module ImmGen(
    input        [31:0] Instruction,
    input        [2:0]  ImmSel,

    output logic [31:0] imm
);
    always_comb begin
        unique case (ImmSel)	
            3'b000: imm = 32'd0;                                 																	 //Rtype 
            3'b001: imm = {{20{Instruction[31]}}, Instruction[31:20]};  															 //Itype
            3'b010: imm = {{20{Instruction[31]}}, {Instruction[31:25],Instruction[11:7]}};											 //Stype
            3'b011: imm = {{19{Instruction[31]}}, {Instruction[31], Instruction[7], Instruction[30:25], Instruction[11:8]}, 1'b0};	 //Btype
            3'b100: imm = { Instruction[31:12], 12'd0};																			     //Utype
            3'b101: imm = {{11{Instruction[31]}}, {Instruction[31], Instruction[19:12], Instruction[20], Instruction[30:21]}, 1'd0}; //Jtype
            3'b110: imm = {27'd0,Instruction[19:15]}; 																				 //CSR
            default: imm = 32'd0;
        endcase
    end
endmodule