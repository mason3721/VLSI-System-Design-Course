module CSR(
    clk,
    rst,
    stall,
    branch_take,
    CSR_sel,
    out,
	waiting,
	imm,
	rs1,
	WTO,
	sctrl_interrupt,
	PC_out,
	MEIP_MTIP,
	MTVEC,
	MEPC,
	q,
	WFI
);

input [11:0] imm;
input clk,rst,stall,branch_take,waiting,WTO,sctrl_interrupt,q,WFI;
input [9:0] CSR_sel;
input [31:0] rs1,PC_out;
output logic [31:0] out,MTVEC,MEPC;
output logic MEIP_MTIP;
logic [63:0] cycle,instruction;

logic [31:0] CSR_reg[8:0];

logic counter;

assign MEIP_MTIP=(CSR_reg[4][11]||CSR_reg[4][7]);
assign MEPC=CSR_reg[3];
//assign MTVEC=CSR_reg[2]; //interrupt address=100000

always_ff@( posedge clk ) begin 
    if(rst) begin
        MTVEC<=CSR_reg[2];
    end
    else begin
        if(sctrl_interrupt==1'd1) begin
			if(stall!=1'b1 || waiting==1'b0) MTVEC<=MTVEC;
			else MTVEC<=MTVEC+32'd4;
        end
        else begin
            MTVEC<=CSR_reg[2];
        end
    end
end

always_ff @( posedge clk ) begin 
    if(rst) begin
        cycle<=64'd0;
        instruction<=64'hfffffffffffffffd;
		counter<=1'd0;
    end
    else begin
        cycle<=cycle+64'd1;
        if(stall!=1'b1&&branch_take!=1'b1&&waiting!=1'b1) begin
            instruction<=instruction+64'd1;
			counter<=1'd1;
        end
        else begin
            instruction<=instruction;
			counter<=1'd0;
        end
    end
end

always_comb begin
	if(sctrl_interrupt==1'd1 & CSR_reg[1][11]==1'd1) CSR_reg[4]={20'd0,1'd1,3'd0,1'd0,7'd0};
	else if(WTO==1'd1 & CSR_reg[1][7]==1'd1) CSR_reg[4]={20'd0,1'd0,3'd0,1'd1,7'd0};
	else CSR_reg[4]=32'd0;
end

always_ff @( posedge clk ) begin 
    if(rst) begin
		CSR_reg[0]<=32'd1;
		CSR_reg[1]<=32'd0;
		CSR_reg[2]<=32'h00010000;
		CSR_reg[3]<=32'd0;
		CSR_reg[5]<=32'd0;
		CSR_reg[6]<=32'd0;
		CSR_reg[7]<=32'd0;
		CSR_reg[8]<=32'd0;
	end
	else if(q==1'd1)begin
		CSR_reg[0][7]<=CSR_reg[0][3];
		CSR_reg[0][3]<=1'd0;
		CSR_reg[0][12:11]<=2'b11;
		//CSR_reg[3]<=PC_out-32'd4;
	end
	else if(WFI==1'd1)begin
		CSR_reg[3]<=PC_out-32'd4;
	end
	else if(CSR_sel[4:2]!=3'd0) begin
		if(CSR_sel[4:2]==3'b001) begin
			case(imm) 
			12'h300: begin
				CSR_reg[0]<=(waiting==1'd0)?{19'd0,rs1[12:11],3'd0,rs1[7],3'd0,rs1[3],3'd0}:CSR_reg[0];
			end
			12'h304: begin
				CSR_reg[1]<=(waiting==1'd0)?{20'd0,rs1[11],3'd0,rs1[7],7'd0}:CSR_reg[1];
			end
			12'h305: begin
				CSR_reg[2]<=(waiting==1'd0)?32'h00010000:CSR_reg[2];
			end
			12'h341: begin
				CSR_reg[3]<=(waiting==1'd0)?rs1:CSR_reg[3];
			end
			default: begin
				CSR_reg[0]<=CSR_reg[0];
				CSR_reg[1]<=CSR_reg[1];
				CSR_reg[2]<=CSR_reg[2];
				CSR_reg[3]<=CSR_reg[3];
			end
			endcase
		end
		else if(CSR_sel[4:2]==3'b010) begin
			case(imm) 
			12'h300: begin
				CSR_reg[0]<=(rs1!=32'd0 && waiting==1'd0)? {19'd0,CSR_reg[0][12:11]|rs1[12:11],3'd0,CSR_reg[0][7]|rs1[7],3'd0,CSR_reg[0][3]|rs1[3],3'd0}:CSR_reg[0];
			end
			12'h304: begin
				CSR_reg[1]<=(rs1!=32'd0 && waiting==1'd0)?{20'd0,CSR_reg[1][11],3'd0,CSR_reg[1][7],7'd0} | {20'd0,rs1[11],3'd0,rs1[7],7'd0}:CSR_reg[1];
			end
			12'h305: begin
				CSR_reg[2]<=(rs1!=32'd0 && waiting==1'd0)?32'h00010000:CSR_reg[2];
			end
			12'h341: begin
				CSR_reg[3]<=(rs1!=32'd0 && waiting==1'd0)?CSR_reg[3] | rs1:CSR_reg[3];
			end
			12'hc00:begin
				CSR_reg[5]<=cycle[31:0];
			end
			12'hc02: begin
				CSR_reg[6]<=instruction[31:0];
			end
			12'hc80: begin
				CSR_reg[7]<=cycle[63:32];
			end
			12'hc82: begin
				CSR_reg[8]<=instruction[63:32];
			end
			default: begin
				CSR_reg[0]<=CSR_reg[0];
				CSR_reg[1]<=CSR_reg[1];
				CSR_reg[2]<=CSR_reg[2];
				CSR_reg[3]<=CSR_reg[3];
				CSR_reg[5]<=CSR_reg[5];
				CSR_reg[6]<=CSR_reg[6];
				CSR_reg[7]<=CSR_reg[7];
				CSR_reg[8]<=CSR_reg[8];
			end
			endcase
		end
		else if(CSR_sel[4:2]==3'b011) begin
			case(imm) 
			12'h300: begin
				CSR_reg[0]<=(rs1!=32'd0 && waiting==1'd0)?{19'd0,CSR_reg[0][12:11]&(~rs1[12:11]),3'd0,CSR_reg[0][7]&(~rs1[7]),3'd0,CSR_reg[0][3]&(~rs1[3]),3'd0}:CSR_reg[0];
			end
			12'h304: begin
				CSR_reg[1]<=(rs1!=32'd0 && waiting==1'd0)?{20'd0,CSR_reg[1][11],3'd0,CSR_reg[1][7],7'd0} & {20'd0,~(rs1[11]),3'd0,~(rs1[7]),7'd0}:CSR_reg[1];
			end
			12'h305: begin
				CSR_reg[2]<=(rs1!=32'd0 && waiting==1'd0)?32'h00010000:CSR_reg[2];
			end
			12'h341: begin
				CSR_reg[3]<=(rs1!=32'd0 && waiting==1'd0)?CSR_reg[3] & (~rs1):CSR_reg[3];
			end
			default: begin
				CSR_reg[0]<=CSR_reg[0];
				CSR_reg[1]<=CSR_reg[1];
				CSR_reg[2]<=CSR_reg[2];
				CSR_reg[3]<=CSR_reg[3];
			end
			endcase
		end
		else if(CSR_sel[4:2]==3'b101) begin
			case(imm) 
			12'h300: begin
				CSR_reg[0]<=(waiting==1'd0)?{28'd0,CSR_sel[8],3'd0}:CSR_reg[0];
			end
			12'h304: begin
				CSR_reg[1]<=(waiting==1'd0)?32'd0:CSR_reg[1];
			end
			12'h305: begin
				CSR_reg[2]<=(waiting==1'd0)?32'h00010000:CSR_reg[2];
			end
			12'h341: begin
				CSR_reg[3]<=(waiting==1'd0)?{27'd0,CSR_sel[9:5]}:CSR_reg[3];
			end
			default: begin
				CSR_reg[0]<=CSR_reg[0];
				CSR_reg[1]<=CSR_reg[1];
				CSR_reg[2]<=CSR_reg[2];
				CSR_reg[3]<=CSR_reg[3];
			end
			endcase
		end
		else if(CSR_sel[4:2]==3'b110) begin
			case(imm) 
			12'h300: begin
				CSR_reg[0]<=(CSR_sel[9:5]!=5'd0 && waiting==1'd0)?{28'd0,CSR_reg[0][3],3'd0} | {28'd0,CSR_sel[8],3'd0}:CSR_reg[0];
			end
			12'h304: begin
				CSR_reg[1]<=(CSR_sel[9:5]!=5'd0 && waiting==1'd0)?32'd0:CSR_reg[1];
			end
			12'h305: begin
				CSR_reg[2]<=(CSR_sel[9:5]!=5'd0 && waiting==1'd0)?32'h00010000:CSR_reg[2];
			end
			12'h341: begin
				CSR_reg[3]<=(CSR_sel[9:5]!=5'd0 && waiting==1'd0)?CSR_reg[3] | {27'd0,CSR_sel[9:5]}:CSR_reg[3];
			end
			default: begin
				CSR_reg[0]<=CSR_reg[0];
				CSR_reg[1]<=CSR_reg[1];
				CSR_reg[2]<=CSR_reg[2];
				CSR_reg[3]<=CSR_reg[3];
			end
			endcase
		end
		else if(CSR_sel[4:2]==3'b111) begin
			case(imm) 
			12'h300: begin
				CSR_reg[0]<=(CSR_sel[9:5]!=5'd0 && waiting==1'd0)?{19'd0,CSR_reg[0][12:11]&(~2'b00),3'd0,CSR_reg[0][7]&(~1'b0),3'd0,CSR_reg[0][3]&(~CSR_sel[8]),3'd0}:CSR_reg[0];
			end
			12'h304: begin
				CSR_reg[1]<=(CSR_sel[9:5]!=5'd0 && waiting==1'd0)?32'd0:CSR_reg[1];
			end
			12'h305: begin
				CSR_reg[2]<=(CSR_sel[9:5]!=5'd0 && waiting==1'd0)?32'h00010000:CSR_reg[2];
			end
			12'h341: begin
				CSR_reg[3]<=(CSR_sel[9:5]!=5'd0 && waiting==1'd0)?CSR_reg[3] & (~{27'd0,CSR_sel[9:5]}):CSR_reg[3];
			end
			default: begin
				CSR_reg[0]<=CSR_reg[0];
				CSR_reg[1]<=CSR_reg[1];
				CSR_reg[2]<=CSR_reg[2];
				CSR_reg[3]<=CSR_reg[3];
			end
			endcase
		end
	else begin
		CSR_reg[0][7]<=1'd1;
		CSR_reg[0][3]<=CSR_reg[0][7];
		CSR_reg[0][12:11]<=2'b11;
	end
		
	end
end
	
	
	
always_comb begin
    unique if(CSR_sel[4:2]==3'b001) begin
			case(imm) 
			12'h300: begin
				out=CSR_reg[0];
			end
			12'h304: begin
				out=CSR_reg[1];
			end
			12'h305: begin
				out=CSR_reg[2];
			end
			12'h341: begin
				out=CSR_reg[3];
			end
			12'h344: begin
				out=CSR_reg[4];
			end
			default: begin
				out=32'd0;
			end
		endcase
	end
	else if(CSR_sel[4:2]==3'b010) begin
			case(imm) 
			12'h300: begin
				out=CSR_reg[0];
			end
			12'h304: begin
				out=CSR_reg[1];
			end
			12'h305: begin
				out=CSR_reg[2];
			end
			12'h341: begin
				out=CSR_reg[3];
			end
			12'h344: begin
				out=CSR_reg[4];
			end
			12'hc00:begin
				out=CSR_reg[5];
			end
			12'hc02: begin
				out=CSR_reg[6];
			end
			12'hc80: begin
				out=CSR_reg[7];
			end
			12'hc82: begin
				out=CSR_reg[8];
			end
			default: begin
				out=32'd0;
			end
		endcase
	end
	else if(CSR_sel[4:2]==3'b011) begin
			case(imm) 
			12'h300: begin
				out=CSR_reg[0];
			end
			12'h304: begin
				out=CSR_reg[1];
			end
			12'h305: begin
				out=CSR_reg[2];
			end
			12'h341: begin
				out=CSR_reg[3];
			end
			12'h344: begin
				out=CSR_reg[4];
			end
			default: begin
				out=32'd0;
			end
		endcase
	end
	else if(CSR_sel[4:2]==3'b101) begin
			case(imm) 
			12'h300: begin
				out=CSR_reg[0];
			end
			12'h304: begin
				out=CSR_reg[1];
			end
			12'h305: begin
				out=CSR_reg[2];
			end
			12'h341: begin
				out=CSR_reg[3];
			end
			12'h344: begin
				out=CSR_reg[4];
			end
			default: begin
				out=32'd0;
			end
		endcase
	end
	else if(CSR_sel[4:2]==3'b110) begin
			case(imm) 
			12'h300: begin
				out=CSR_reg[0];
			end
			12'h304: begin
				out=CSR_reg[1];
			end
			12'h305: begin
				out=CSR_reg[2];
			end
			12'h341: begin
				out=CSR_reg[3];
			end
			12'h344: begin
				out=CSR_reg[4];
			end

			default: begin
				out=32'd0;
			end
		endcase
	end
	else if(CSR_sel[4:2]==3'b111) begin
			case(imm) 
			12'h300: begin
				out=CSR_reg[0];
			end
			12'h304: begin
				out=CSR_reg[1];
			end
			12'h305: begin
				out=CSR_reg[2];
			end
			12'h341: begin
				out=CSR_reg[3];
			end
			12'h344: begin
				out=CSR_reg[4];
			end
			default: begin
				out=32'd0;
			end
		endcase
	end
	else out=32'd0;
end


endmodule
