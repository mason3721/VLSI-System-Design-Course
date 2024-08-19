module Comparator(
    in_1,
    in_2,
	funct3,
    branch_take
);
    
input [31:0] in_1,in_2;
input [2:0] funct3;
output logic branch_take;

always_comb begin
	unique case(funct3)
		3'b000: begin
			unique if(in_1==in_2)
				branch_take=1'b1;
			else
				branch_take=1'b0;
		end
		3'b001: begin
			unique if(in_1!=in_2)
				branch_take=1'b1;
			else 
				branch_take=1'b0;
		end
		3'b100: begin
			unique if(in_1[31]>in_2[31]) branch_take=1'b1;
            else if(in_1[31]<in_2[31]) branch_take=1'b0;
            else branch_take=(in_1<in_2)? 1'b1:1'b0;
        end
		3'b101: begin
			unique if(in_1[31]<in_2[31]) branch_take=1'b1;
            else if(in_1[31]>in_2[31]) branch_take=1'b0;
            else branch_take=(in_1>=in_2)? 1'b1:1'b0;
        end
		3'b110: begin
			unique if(in_1<in_2)
				branch_take=1'b1;
			else 
			    branch_take=1'b0;
		end
		3'b111: begin
			unique if(in_1>=in_2)
				branch_take=1'b1;
			else
				branch_take=1'b0;
		end
		default: branch_take=1'b0;
	endcase
end

endmodule
