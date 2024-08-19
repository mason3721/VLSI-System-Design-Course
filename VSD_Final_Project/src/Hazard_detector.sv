module Hazard_detector(
    clk,
    rst,
    EX_Mread,
    EX_rd,
    ID_rs1,
    ID_rs2,
    M_Mread,
    M_rd,
    EX_regwrite,
    B_type_JALR,
    stall
);

input clk,rst,EX_Mread,M_Mread,EX_regwrite,B_type_JALR;
input [4:0] EX_rd,ID_rs1,ID_rs2,M_rd;
output logic stall;
logic  [2:0] counter;
logic c_stall;

assign stall=(c_stall||(counter!=3'd6));

always_ff @(posedge clk ) begin
	if(rst) counter<=3'd0;
	else begin
		if(counter==3'd6) counter<=3'd6;
		else counter<=counter+3'd1;
	end
end
always_comb begin
    if((EX_Mread!=1'b0)&&((EX_rd==ID_rs1)||(EX_rd==ID_rs2)))
        c_stall=1'b1;
    else if((EX_regwrite!=1'b0)&&(B_type_JALR!=1'b0)&&((EX_rd==ID_rs1)||(EX_rd==ID_rs2)))
        c_stall=1'b1;
    else if((M_Mread!=1'b0)&&(B_type_JALR!=1'b0)&&((M_rd==ID_rs1)||(M_rd==ID_rs2)))
        c_stall=1'b1;
    else
        c_stall=1'b0;
end

endmodule
