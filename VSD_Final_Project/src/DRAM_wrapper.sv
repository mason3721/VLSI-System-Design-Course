module DRAM_wrapper(
	input ACLK,
	input ARESETn,
	//WRITE ADDRESS
	input [7:0] AWID_S,
	input [31:0] AWADDR_S,
	input [3:0] AWLEN_S,
	input [2:0] AWSIZE_S,
	input [1:0] AWBURST_S,
	input AWVALID_S,
	output logic AWREADY_S,
	
	//WRITE DATA
	input [31:0] WDATA_S,
	input [3:0] WSTRB_S,
	input WLAST_S,
	input WVALID_S,
	output logic WREADY_S,
	
	//WRITE RESPONSE
	output logic [7:0] BID_S,
	output logic [1:0] BRESP_S,
	output logic BVALID_S,
	input BREADY_S,
	

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
	
	
	input [31:0] Q,
	input VALID,
	output logic CSn,
	output logic [3:0] WEn,
	output logic RASn,
	output logic CASn,
	output logic [10:0] A,
	output logic [31:0] D
);

logic [10:0] row_address_reg;
logic [7:0] read_ID;
logic [3:0] len_reg;

logic [9:0] col_address_reg;
logic [7:0] write_ID;

logic [31:0] wdata_reg,read_data_reg;
logic [3:0] wen_reg;
logic [2:0] counter;
logic set,act_or_not,CASn_set;

assign CSn=1'd0;

parameter DRAM_IDLE=3'd0;
parameter DRAM_act=3'd1; //addr
parameter DRAM_read_addr=3'd2;
parameter DRAM_read_data=3'd3;
parameter DRAM_write_addr=3'd4;
parameter DRAM_write_data=3'd5;
parameter DRAM_write_resp=3'd6;
parameter DRAM_precharge=3'd7;

logic [2:0] DRAM_curr_state,DRAM_next_state;

always_ff@(posedge ACLK ) begin
	if(~ARESETn) begin
		DRAM_curr_state<=DRAM_IDLE;
		counter<=3'd0;
		set<=1'd1;
		act_or_not<=1'd0;
	end
	else begin
		DRAM_curr_state<=DRAM_next_state;
		if(counter==3'd4) counter<=3'd0;
		else if(DRAM_curr_state==DRAM_act || DRAM_curr_state==DRAM_precharge || DRAM_next_state==DRAM_read_data) counter<=counter+3'd1;
		else counter<=3'd0;
		set<=(DRAM_curr_state==DRAM_read_data || DRAM_curr_state==DRAM_write_data)?  set: 1'd0;
		if(DRAM_curr_state==DRAM_IDLE) act_or_not<=1'd0;
		else if(DRAM_curr_state==DRAM_act) act_or_not<=1'd1;
		else act_or_not<=act_or_not;
	end
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) row_address_reg<=11'd0;
	else if(DRAM_next_state==DRAM_act) begin
		if(ARVALID_S==1'd1) row_address_reg<=ARADDR_S[22:12];
		else row_address_reg<=AWADDR_S[22:12];
	end
	else row_address_reg<=row_address_reg;
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) write_ID<=8'd0;
	else if(DRAM_curr_state==DRAM_IDLE || DRAM_curr_state==DRAM_read_data) write_ID<=AWID_S;
	else write_ID<=write_ID;
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) len_reg<=4'd0;
	else if(DRAM_curr_state==DRAM_IDLE) len_reg<=ARLEN_S;
	else if(DRAM_curr_state==DRAM_read_data && len_reg!=4'd0 && counter==3'd4) len_reg<=len_reg-4'd1;
	else if(len_reg==4'd0) len_reg<=4'd0;
	else len_reg<=len_reg;
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) read_data_reg<=32'd0;
	else if(VALID==1'd1) read_data_reg<=Q;
	else read_data_reg<=read_data_reg;
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) begin
		col_address_reg<=10'd0;
		read_ID<=8'd0;
	end
	else if(DRAM_next_state==DRAM_read_addr) begin
		col_address_reg<=ARADDR_S[11:2];
		read_ID<=ARID_S;
	end
	else if(DRAM_next_state==DRAM_write_addr) begin
		col_address_reg<=AWADDR_S[11:2];
		read_ID<=read_ID;
	end
	else begin
		col_address_reg<=col_address_reg;
		read_ID<=read_ID;
	end
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) CASn_set<=1'd0;
	else if(DRAM_curr_state==DRAM_read_data && CASn==1'd0 && len_reg==4'd1) CASn_set<=1'd1;
	else if(DRAM_curr_state==DRAM_IDLE) CASn_set<=1'd0;
	else CASn_set<=CASn_set;
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) begin
		wdata_reg<=32'd0;
		wen_reg<=4'd0;
	end
	else if(DRAM_next_state==DRAM_write_data) begin
		wdata_reg<=WDATA_S;
		wen_reg<=WSTRB_S;
	end
	else begin
		wdata_reg<=wdata_reg;
		wen_reg<=wen_reg;
	end
end

always_comb begin //next state logic for DRAM wrapper
	unique case (DRAM_curr_state)
		DRAM_IDLE: begin
			if(ARVALID_S==1'd1) begin
				if(ARADDR_S[22:12]==row_address_reg || set) DRAM_next_state=DRAM_read_addr;
				else DRAM_next_state=DRAM_precharge;
			end
			else if(AWVALID_S==1'd1) begin
				if(AWADDR_S[22:12]==row_address_reg || set) DRAM_next_state=DRAM_write_addr;
				else DRAM_next_state=DRAM_precharge;
			end
			else DRAM_next_state=DRAM_IDLE;
		end
		DRAM_act: begin
			if(counter==3'd3 && ARVALID_S==1'd1) DRAM_next_state=DRAM_read_addr;
			else if(counter==3'd3 && AWVALID_S==1'd1) DRAM_next_state=DRAM_write_addr;
			else  DRAM_next_state=DRAM_act;
		end
		DRAM_read_addr:begin
			DRAM_next_state=DRAM_read_data;
		end
		DRAM_read_data:begin
			if(RREADY_S==1'd1 && len_reg==4'd0 && VALID==1'd1) DRAM_next_state=DRAM_IDLE;
			else DRAM_next_state=DRAM_read_data;
		end
		DRAM_write_addr: begin
			unique if(WVALID_S==1'd1) DRAM_next_state=DRAM_write_data;
			else DRAM_next_state=DRAM_write_addr;
		end
		DRAM_write_data: begin
			unique if(WLAST_S & WVALID_S) DRAM_next_state=DRAM_write_resp;
			else DRAM_next_state=DRAM_write_data;
		end
		DRAM_write_resp: begin
			unique if(BREADY_S!=1'd1) DRAM_next_state=DRAM_write_resp;
			else DRAM_next_state=DRAM_IDLE;
		end
		DRAM_precharge:begin
			if(counter==3'd4) begin
				DRAM_next_state=DRAM_act;
			end
			else DRAM_next_state=DRAM_precharge;
		end
	endcase
end
	
always_comb begin//output logic for DRAM_read
	unique case (DRAM_curr_state)
		DRAM_IDLE: begin
			ARREADY_S=1'd0;
			RID_S=8'd0;
			RDATA_S=32'd0;
			RRESP_S=2'd0;
			RLAST_S=1'd0;
			RVALID_S=1'd0;
			
			AWREADY_S=1'd0;
			WREADY_S=1'd0;
			BID_S=8'd0;
          	BRESP_S=2'd0;
			BVALID_S=1'd0;
			
			RASn=1'd1;
			CASn=1'd1;
			WEn=4'hf;
			D=wdata_reg;
			A=row_address_reg;
		end
		DRAM_act: begin
			ARREADY_S=1'd0;
			RID_S=8'd0;
			RDATA_S=32'd0;
			RRESP_S=2'd0;
			RLAST_S=1'd0;
			RVALID_S=1'd0;
			
			AWREADY_S=1'd0;
			WREADY_S=1'd0;
			BID_S=8'd0;
            BRESP_S=2'd0;
			BVALID_S=1'd0;
			
			RASn=(counter==3'd0)?1'd0:1'd1;
			CASn=1'd1;
			WEn=4'hf;
			D=32'd0;
			A=row_address_reg;
		end	
		DRAM_read_addr:begin
			ARREADY_S=1'd1;
			RID_S=8'd0;
			RDATA_S=32'd0;
			RRESP_S=2'd0;
			RLAST_S=1'd0;
			RVALID_S=1'd0;
			
			AWREADY_S=1'd0;
			WREADY_S=1'd0;
			BID_S=8'd0;
            BRESP_S=2'd0;
			BVALID_S=1'd0;
			
			RASn=1'd1;
			CASn=1'd1;
			WEn=4'hf;
			D=32'd0;
			A=row_address_reg;
		end
		DRAM_read_data: begin
			ARREADY_S=1'd0;
			RID_S=read_ID;
			RDATA_S=Q;
			RRESP_S=2'd0;
			RLAST_S=(len_reg==4'd0 && VALID==1'd1)?1'd1:1'd0;
			RVALID_S=(VALID==1'd1)?1'd1:1'd0;
			
			AWREADY_S=1'd0;
			WREADY_S=1'd0;
			BID_S=8'd0;
          	BRESP_S=2'd0;
			BVALID_S=1'd0;
			
			RASn=1'd1;
			if(act_or_not==1'd0) CASn=(counter==3'd1 && CASn_set==1'd0)?1'd0:1'd1;
			else  CASn=(counter==3'd0 && CASn_set==1'd0)?1'd0:1'd1;
			WEn=4'hf;
			D=32'd0;
			case(len_reg) 
				4'd4: A={1'd0,col_address_reg};
				4'd3: A={1'd0,col_address_reg}+11'd1;
				4'd2: A={1'd0,col_address_reg}+11'd2;
				4'd1: A={1'd0,col_address_reg}+11'd3;
				default: A=11'd0;
				endcase
		end	
		DRAM_write_addr:begin
			ARREADY_S=1'd0;
			RID_S=8'd0;
			RDATA_S=32'd0;
			RRESP_S=2'd0;
			RLAST_S=1'd0;
			RVALID_S=1'd0;
			
			AWREADY_S=1'd1;
			WREADY_S=1'd0;
			BID_S=8'd0;
            BRESP_S=2'd0;
			BVALID_S=1'd0;
			
			RASn=1'd1;
			CASn=1'd1;
			WEn=4'hf;
			D=32'd0;
			A={1'd0,col_address_reg};
		end
		DRAM_write_data: begin
			ARREADY_S=1'd0;
			RID_S=8'd0;
			RDATA_S=32'd0;
			RRESP_S=2'd0;
			RLAST_S=1'd0;
			RVALID_S=1'd0;
			
			AWREADY_S=1'd0;
			WREADY_S=1'd1;
			BID_S=8'd0;
           	BRESP_S=2'd0;
			BVALID_S=1'd0;
			
			RASn=1'd1;
			CASn=1'd0;
			WEn=wen_reg;
			D=wdata_reg;
			A={1'd0,col_address_reg};
		end	
		DRAM_write_resp: begin
			ARREADY_S=1'd0;
			RID_S=8'd0;
			RDATA_S=32'd0;
			RRESP_S=2'd0;
			RLAST_S=1'd0;
			RVALID_S=1'd0;
			
			AWREADY_S=1'd0;
			WREADY_S=1'd0;
			BID_S=write_ID;
            BRESP_S=2'd0;
			BVALID_S=1'd1;
			
			RASn=1'd1;
			CASn=1'd1;
			WEn=4'hf;
			D=wdata_reg;
			A=11'd0;
		end
		DRAM_precharge: begin
			ARREADY_S=1'd0;
			RID_S=8'd0;
			RDATA_S=32'd0;
			RRESP_S=2'd0;
			RLAST_S=1'd0;
			RVALID_S=1'd0;
			
			AWREADY_S=1'd0;
			WREADY_S=1'd0;
			BID_S=8'd0;
          	BRESP_S=2'd0;
			BVALID_S=1'd0;
			
			RASn=(counter==3'd0)?1'd0:1'd1;
			CASn=1'd1;
			WEn=(counter==3'd0)?4'h0:4'hf;
			D=32'd0;
			A=row_address_reg;
		end	
	endcase
end			


endmodule

