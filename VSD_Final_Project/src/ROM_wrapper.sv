module ROM_wrapper(
	input ACLK,
	input ARESETn,
	
	//READ ADDRESS
	input [7:0] ARID_S,
	input [31:0] ARADDR_S,
	input [3:0] ARLEN_S,
	input [2:0] ARSIZE_S,
	input [1:0] ARBURST_S,
	input ARVALID_S,
	output logic ARREADY_S,
	
	//READ DATA
	output logic [7:0] RID_S,
	output logic [31:0] RDATA_S,
	output logic [1:0] RRESP_S,
	output logic RLAST_S,
	output logic RVALID_S,
	input RREADY_S,
	
	input [31:0] DO,
	output logic OE,
	output logic CS,
	output logic [11:0] A
);


logic [31:0] read_address_reg;
logic [7:0] read_ID;
logic [3:0] len_reg;

assign CS=1'd1;

parameter ROM_IDLE=1'd0;
parameter ROM_read_data=1'd1;

logic ROM_curr_state,ROM_next_state;

always_ff@(posedge ACLK ) begin
	if(~ARESETn) ROM_curr_state<=ROM_IDLE;
	else ROM_curr_state<=ROM_next_state;
end

always_comb begin //next state logic for ROM read
	unique case (ROM_curr_state)
		ROM_IDLE: begin
				if(ARVALID_S==1'd1) ROM_next_state=ROM_read_data;
				else ROM_next_state=ROM_IDLE;
		end
		ROM_read_data:begin
			unique if(RREADY_S==1'd1 && len_reg==4'd0) ROM_next_state=ROM_IDLE;
			else ROM_next_state=ROM_read_data;
		end
	endcase
end

	
always_ff@(posedge ACLK ) begin
	if(~ARESETn) read_address_reg<=32'd0;
	else if(ROM_curr_state==ROM_IDLE) read_address_reg<=ARADDR_S;
	else read_address_reg<=read_address_reg;
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) read_ID<=8'd0;
	else if(ROM_curr_state==ROM_IDLE) read_ID<=ARID_S;
	else read_ID<=read_ID;
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) len_reg<=4'd0;
	else if(ROM_next_state==ROM_IDLE) len_reg<=ARLEN_S;
	else if(ROM_next_state==ROM_read_data && len_reg!=4'd0) len_reg<=len_reg-4'd1;
	else if(len_reg==4'd0) len_reg<=4'd0;
	else len_reg<=len_reg;
end
	
always_comb begin//output logic for ROM_read
	unique case (ROM_curr_state)
		ROM_IDLE: begin
			ARREADY_S=1'd1;
			RID_S=8'd0;
			RDATA_S=32'd0;
			RRESP_S=2'd0;
			RLAST_S=1'd0;
			RVALID_S=1'd0;
			OE=1'd0;
		end
		ROM_read_data: begin
			ARREADY_S=1'd0;
			RID_S=read_ID;
			RDATA_S=DO;
			RRESP_S=2'd0;
			RLAST_S=(len_reg==4'd0)?1'd1:1'd0;
			RVALID_S=1'd1;
			OE=1'd1;
		end	
	endcase
end
	
always_comb begin
	if(ROM_curr_state==ROM_IDLE || ROM_curr_state==ROM_read_data) begin
		case(len_reg) 
			4'd4: A=read_address_reg[13:2];
			4'd3: A=read_address_reg[13:2]+12'd1;
			4'd2: A=read_address_reg[13:2]+12'd2;
			4'd1: A=read_address_reg[13:2]+12'd3;
			default :A=12'd0;
		endcase
	end
	else A=12'd0;

end

endmodule