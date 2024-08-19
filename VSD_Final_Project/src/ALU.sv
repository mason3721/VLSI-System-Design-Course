module ALU(
    rs1,
    rs2,
    ALUop,
    result
);
input [31:0] rs1,rs2;
input [3:0] ALUop;
output logic [31:0] result;

logic [63:0] m_result;
logic signed [32:0] temp1,temp2;

always_comb begin
    unique casez (ALUop)
        4'b0000: begin
	     result=rs1+rs2; //ADD、ADDI
	     m_result=64'd0;
	     temp1=33'd0;
	     temp2=33'd0;
	end
        4'b0001: begin
	     result=rs1-rs2; //SUB
	     m_result=64'd0;
	     temp1=33'd0;
	     temp2=33'd0;
	end
        4'b0010: begin
     	     result=rs1<<rs2[4:0]; //SLL、SLLI
	     m_result=64'd0;
	     temp1=33'd0;
	     temp2=33'd0;
	end
        4'b0011: begin
	     result=(rs1<rs2)? 32'd1:32'd0; //SLTU、SLTIU
	     m_result=64'd0;
	     temp1=33'd0;
	     temp2=33'd0;
	end
        4'b1011: begin //SLT、SLTI
            /*unique if(rs1[31]>rs2[31]) begin
		result=32'd1;
		m_result=64'd0;
	    end
            else if(rs1[31]<rs2[31]) begin
		result=32'd0;
		m_result=64'd0;
	    end
            else begin*/
		result=($signed(rs1)<$signed(rs2))? 32'd1:32'd0;
		m_result=64'd0;
		temp1=33'd0;
	        temp2=33'd0;
        end
        4'b0100: begin
	    result=rs1^rs2; //XOR、XORI
	    m_result=64'd0;
	    temp1=33'd0;
	    temp2=33'd0;
	end
        4'b0101: begin
	    result=rs1>>rs2[4:0]; //SRL、SRLI
	    m_result=64'd0;
	    temp1=33'd0;
	    temp2=33'd0;
	end
        4'b1010: begin //SRA、SRAI
	    result=$signed(rs1)>>>rs2[4:0];
            /*unique if(rs1[31]==1'b0) result=rs1>>rs2[4:0];
            else result=({{32{1'b1}}, rs1[31:0]}) >> rs2[4:0];*/
	    m_result=64'd0;
	    temp1=33'd0;
	    temp2=33'd0;
        end
        4'b0110: begin
	    result=rs1|rs2; //OR、ORI
	    m_result=64'd0;
	    temp1=33'd0;
	    temp2=33'd0;
	end
        4'b0111: begin
	    result=rs1&rs2; //AND、ANDI
	    m_result=64'd0;
	    temp1=33'd0;
	    temp2=33'd0;
	end
        4'b11zz: begin //MUL
	    if(ALUop[1:0]==2'd0) begin
		temp1={1'b0,rs1};
		temp2={1'b0,rs2};
	    end
	    else if(ALUop[1:0]==2'b01) begin
		temp1={rs1[31],rs1};
		temp2={rs2[31],rs2};
	    end
	    else if(ALUop[1:0]==2'b10) begin
		temp1={rs1[31],rs1};
		temp2={1'b0,rs2};
	    end
	    else if(ALUop[1:0]==2'b11) begin
		temp1={1'b0,rs1};
		temp2={1'b0,rs2};
	    end
	    else begin
		temp1=33'd0;
	        temp2=33'd0;
	    end
            m_result=temp1*temp2;
            result=(ALUop[1:0]==2'b00)?m_result[31:0]:m_result[63:32];
        end
        /*4'b1101: begin //MULH
            //m_result={{32{rs1[31]}},rs1}*{{32{rs2[31]}},rs2};
	    m_result=$signed(rs1)*$signed(rs2);
            result=m_result[63:32];
        end
        4'b1110: begin //MULHSU
            m_result=$signed(rs1)*$signed({1'd0,rs2});
            result=m_result[63:32];
        end
        4'b1111: begin //MULHU
            m_result=rs1*rs2;
            result=m_result[63:32];
        end*/
	default: begin
            m_result=64'd0;
	    result=32'd0;
	    temp1=33'd0;
	    temp2=33'd0;
	end
    endcase 
end

endmodule
