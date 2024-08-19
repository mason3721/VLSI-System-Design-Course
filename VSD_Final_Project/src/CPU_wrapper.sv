`include "CPU.sv"
`include "L1C_data.sv"
`include "L1C_inst.sv"

module CPU_wrapper(
	input ACLK,
	input ARESETn,
	
	//WRITE ADDRESS1
	output logic [3:0] AWID_M1,
	output logic [31:0] AWADDR_M1,
	output logic [3:0] AWLEN_M1,
	output logic [2:0] AWSIZE_M1,
	output logic [1:0] AWBURST_M1,
	output logic AWVALID_M1,
	input AWREADY_M1,
	
	//WRITE DATA1
	output logic [31:0] WDATA_M1,
	output logic [3:0] WSTRB_M1,
	output logic WLAST_M1,
	output logic WVALID_M1,
	input WREADY_M1,
	
	//WRITE RESPONSE1
	input [3:0] BID_M1,
	input [1:0] BRESP_M1,
	input BVALID_M1,
	output logic BREADY_M1,
	
	//READ ADDRESS0
	output logic [3:0] ARID_M0,
	output logic [31:0] ARADDR_M0,
	output logic [3:0] ARLEN_M0,
	output logic [2:0] ARSIZE_M0,
	output logic [1:0] ARBURST_M0,
	output logic ARVALID_M0,
	input ARREADY_M0,
	
	//READ DATA0
	input [3:0] RID_M0,
	input [31:0] RDATA_M0,
	input [1:0] RRESP_M0,
	input RLAST_M0,
	input RVALID_M0,
	output logic RREADY_M0,
	
	//READ ADDRESS1
	output logic [3:0] ARID_M1,
	output logic [31:0] ARADDR_M1,
	output logic [3:0] ARLEN_M1,
	output logic [2:0] ARSIZE_M1,
	output logic [1:0] ARBURST_M1,
	output logic ARVALID_M1,
	input ARREADY_M1,
	
	//READ DATA1
	input [3:0] RID_M1,
	input [31:0] RDATA_M1,
	input [1:0] RRESP_M1,
	input RLAST_M1,
	input RVALID_M1,
	output logic RREADY_M1,
	input WTO,
	input sctrl_interrupt
);

logic [31:0] DMwdata,IMdata,DMdata,IMaddr,DMaddr,IM_raddr,DM_raddr,DM_wdata,IM_address_reg,DM_address_reg,DM_write_data_reg,IM_read_data_reg,DM_read_data_reg;
logic IM_ren,DM_ren,DMren,IMren;
logic [3:0] DM_wen,DM_strb_reg,DMwen,L1D_curr_state;
logic waiting;
logic waiting_IM,waiting_DM,IMwait,DMwait,waiting_c,RVALID_M0_reg,RVALID_M1_reg;
logic [2:0] L1I_curr_state;
	
L1C_inst L1C_inst1(
	.clk(ACLK),
    .rst(~ARESETn),
	.core_addr(IMaddr),
	.core_req(IMren),
	.I_out(RDATA_M0),
	.I_wait(waiting),
	.core_out(IMdata),
	.core_wait(IMwait),
	.I_req(IM_ren),
	.I_addr(IM_raddr),
	.L1D_curr_state(L1D_curr_state),
	.L1I_state(L1I_curr_state),
	.read_data_valid(RVALID_M0)
);
L1C_data L1C_data1(
	.clk(ACLK),
    .rst(~ARESETn),
	.core_addr(DMaddr),
	.core_read_req(DMren),
	.core_in(DMwdata),		
	.core_write_req(DMwen),
	.D_out(RDATA_M1),
	.D_wait(waiting),
	.core_out(DMdata),
	.core_wait(DMwait),
	.D_req(DM_ren),
	.D_addr(DM_raddr),
	.D_in(DM_wdata),
	.D_write_type(DM_wen),
	.L1I_curr_state(L1I_curr_state),
	.L1D_state(L1D_curr_state),
	.read_data_valid(RVALID_M1)
);

CPU CPU2(
	.clk(ACLK),
	.rst(~ARESETn),
	.IM_raddr(IMaddr),
	.IM_rdata(IMdata),
	.IM_ren(IMren),
	.DM_addr(DMaddr),
	.DM_wdata(DMwdata),
	.DM_wen(DMwen),
	.DM_rdata(DMdata),
	.DM_ren(DMren),
	.waiting(waiting_c),
	.WTO(WTO),
	.sctrl_interrupt(sctrl_interrupt)
);


assign waiting_c=IMwait || DMwait;
assign waiting=waiting_IM || waiting_DM;

parameter M0_IDLE=2'd0;
parameter M0_read_addr=2'd1;
parameter M0_read_data=2'd2;

parameter M1_IDLE=3'd0;
parameter M1_read_addr=3'd1;
parameter M1_read_data=3'd2;
parameter M1_write_addr=3'd3;
parameter M1_write_data=3'd4;
parameter M1_write_resp=3'd5;


logic [1:0] M0_curr_state,M0_next_state;
logic [2:0] M1_curr_state,M1_next_state;


always_ff@(posedge ACLK ) begin
	if(~ARESETn) begin
		M0_curr_state<=M0_IDLE;
	end
	else begin
		M0_curr_state<=M0_next_state;
	end
end

always_ff@(posedge ACLK) begin
	if(~ARESETn) begin
		M1_curr_state<=M1_IDLE;
	end
	else begin
		M1_curr_state<=M1_next_state;
	end
end


always_ff@(posedge ACLK ) begin
	if(~ARESETn) IM_read_data_reg<=32'd0;
	else begin
		unique if(M0_curr_state==M0_read_data) IM_read_data_reg<=RDATA_M0;
		else IM_read_data_reg<=IM_read_data_reg;
	end
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn)  DM_read_data_reg<=32'd0;
	else begin
		unique if(M1_curr_state==M1_read_data) DM_read_data_reg<=RDATA_M1;
		else DM_read_data_reg<=DM_read_data_reg;
	end
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn)  begin
		RVALID_M0_reg<=1'd0;
		RVALID_M1_reg<=1'd0;
	end
	else begin
		RVALID_M0_reg<=RVALID_M0;
		RVALID_M1_reg<=RVALID_M1;
	end
end

always_comb begin //next state logic for M0
	M0_next_state=M0_curr_state;
	unique case (M0_curr_state)
		M0_IDLE: begin
			unique if(M1_curr_state==M1_IDLE && IM_ren==1'd1) M0_next_state=M0_read_addr;
			else M0_next_state=M0_IDLE;
		end
		M0_read_addr: begin
			unique if(ARREADY_M0==1'd1) M0_next_state=M0_read_data;
			else M0_next_state=M0_read_addr;
		end
		M0_read_data:begin
			unique if(RLAST_M0==1'd1) M0_next_state=M0_IDLE;
			else M0_next_state=M0_read_data;
		end
		default: M0_next_state=M0_IDLE;
	endcase
end

always_comb begin //next state logic for M1
	M1_next_state=M1_curr_state;
	unique case (M1_curr_state)
		M1_IDLE: begin
			unique if(M0_curr_state==M0_IDLE) begin 
				unique if(DM_ren==1'd1) M1_next_state=M1_read_addr; //cpu wrapper不用排，到AXI再排。
				else if(DM_wen!=4'b1111) M1_next_state=M1_write_addr;
				else M1_next_state=M1_IDLE;
			end
			else M1_next_state=M1_IDLE;
		end
		M1_read_addr: begin
			unique if(ARREADY_M1==1'd1) M1_next_state=M1_read_data;
			else M1_next_state=M1_read_addr;
		end
		M1_read_data:begin
			unique if(RLAST_M1==1'd1) M1_next_state=M1_IDLE;
			else M1_next_state=M1_read_data;
		end
		M1_write_addr: begin
			unique if(AWREADY_M1==1'd1) M1_next_state=M1_write_data;
			else M1_next_state=M1_write_addr;
		end
		M1_write_data: begin
			unique if(WREADY_M1==1'd1) M1_next_state=M1_write_resp;
			else M1_next_state=M1_write_data;
		end
		M1_write_resp: begin
			unique if(BVALID_M1==1'd1 && BRESP_M1==2'd0) M1_next_state=M1_IDLE;
			else M1_next_state=M1_write_resp;
		end
		default: M1_next_state=M1_IDLE;
	endcase
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) IM_address_reg<=32'd0;
	else if(M0_curr_state==M0_IDLE && M1_curr_state==M1_IDLE && IM_ren==1'd1) IM_address_reg<=IM_raddr;
	else IM_address_reg<=IM_address_reg;
end

always_comb begin//output logic for M0
	unique case (M0_curr_state)
		M0_IDLE: begin
			ARID_M0=4'd0;
			ARADDR_M0=32'd0;
			ARLEN_M0=4'd4;
			ARSIZE_M0=3'd2;
			ARBURST_M0=2'd1;
			ARVALID_M0=1'd0;
			RREADY_M0=1'd0;
			waiting_IM=1'd0;
		end
		M0_read_addr: begin	
			ARID_M0=4'd0;
			ARADDR_M0=IM_address_reg;
			ARLEN_M0=4'd4;
			ARSIZE_M0=3'd2;
			ARBURST_M0=2'd1;
			ARVALID_M0=1'd1;
			RREADY_M0=1'd0;
			waiting_IM=1'd1;
		end
		M0_read_data:begin
			ARID_M0=4'd0;
			ARADDR_M0=IM_address_reg;
			ARLEN_M0=4'd4;
			ARSIZE_M0=3'd2;
			ARBURST_M0=2'd1;
			ARVALID_M0=1'd0;
			RREADY_M0=1'd1;
			waiting_IM=1'd1;
		end
		default: begin
			ARID_M0=4'd0;
			ARADDR_M0=32'd0;
			ARLEN_M0=4'd4;
			ARSIZE_M0=3'd2;
			ARBURST_M0=2'd1;
			ARVALID_M0=1'd0;
			RREADY_M0=1'd0;
			waiting_IM=1'd0;
		end
	endcase
end

always_ff@(posedge ACLK) begin
	if(~ARESETn) begin
		DM_address_reg<=32'd0;
		DM_write_data_reg<=32'd0;
		DM_strb_reg<=4'b1111;
	end
	else if(M0_curr_state==M0_IDLE && M1_curr_state==M1_IDLE && (DM_ren==1'd1|| DM_wen!=4'b1111)) begin
		DM_address_reg<=DM_raddr;
		DM_write_data_reg<=DM_wdata;
		DM_strb_reg<=DM_wen;
	end
	else begin
		DM_address_reg<=DM_address_reg;
		DM_write_data_reg<=DM_write_data_reg;
		DM_strb_reg<=DM_strb_reg;
	end
end

always_comb begin//output logic for M1
	unique case (M1_curr_state)
		M1_IDLE: begin
			ARID_M1=4'd0;
			ARADDR_M1=32'd0;
			ARLEN_M1=4'd4;
			ARSIZE_M1=3'd2;
			ARBURST_M1=2'd1;
			ARVALID_M1=1'd0;
			RREADY_M1=1'd0;
			AWID_M1=4'd0;
			AWADDR_M1=32'd0;
			AWLEN_M1=4'd0;
			AWSIZE_M1=3'd2;
			AWBURST_M1=2'd1;
			AWVALID_M1=1'd0;
			WDATA_M1=32'd0;
			WSTRB_M1=4'b1111;
			WLAST_M1=1'd0;
			WVALID_M1=1'd0;
			BREADY_M1=1'd1;
			waiting_DM=1'd0;
			//if((DM_ren==1'd1||(DM_wen!=4'b1111))) DM_address_reg=DM_raddr;
			//else DM_address_reg=32'd0;
		end
		M1_read_addr: begin	
			ARID_M1=4'd0;
			ARADDR_M1=DM_address_reg;
			ARLEN_M1=(DM_address_reg<=32'h100003FF && DM_address_reg>=32'h10000000)?4'd0:4'd4;
			ARSIZE_M1=3'd2;
			ARBURST_M1=2'd1;
			ARVALID_M1=1'd1;
			RREADY_M1=1'd0;
			AWID_M1=4'd0;
			AWADDR_M1=32'd0;
			AWLEN_M1=4'd0;
			AWSIZE_M1=3'd2;
			AWBURST_M1=2'd1;
			AWVALID_M1=1'd0;
			WDATA_M1=32'd0;
			WSTRB_M1=4'b1111;
			WLAST_M1=1'd0;
			WVALID_M1=1'd0;
			BREADY_M1=1'd0;
			waiting_DM=1'd1;
		end
		M1_read_data: begin
			ARID_M1=4'd0;
			ARADDR_M1=DM_address_reg;
			ARLEN_M1=(DM_address_reg<=32'h100003FF && DM_address_reg>=32'h10000000)?4'd0:4'd4;
			ARSIZE_M1=3'd2;
			ARBURST_M1=2'd1;
			ARVALID_M1=1'd0;
			RREADY_M1=1'd1;
			AWID_M1=4'd0;
			AWADDR_M1=32'd0;
			AWLEN_M1=4'd0;
			AWSIZE_M1=3'd2;
			AWBURST_M1=2'd1;
			AWVALID_M1=1'd0;
			WDATA_M1=32'd0;
			WSTRB_M1=4'b1111;
			WLAST_M1=1'd0;
			WVALID_M1=1'd0;
			BREADY_M1=1'd0;
			waiting_DM=1'd1;
		end
		M1_write_addr: begin
			ARID_M1=4'd0;
			ARADDR_M1=32'd0;
			ARLEN_M1=4'd0;
			ARSIZE_M1=3'd2;
			ARBURST_M1=2'd1;
			ARVALID_M1=1'd0;
			RREADY_M1=1'd0;
			AWID_M1=4'd0;
			AWADDR_M1=DM_address_reg;
			AWLEN_M1=4'd0;
			AWSIZE_M1=3'd2;
			AWBURST_M1=2'd1;
			AWVALID_M1=1'd1;
			WDATA_M1=DM_write_data_reg;
			WSTRB_M1=DM_strb_reg;
			WLAST_M1=1'd0;
			WVALID_M1=1'd0;
			BREADY_M1=1'd0;
			waiting_DM=1'd1;
		end
		M1_write_data: begin
			ARID_M1=4'd0;
			ARADDR_M1=32'd0;
			ARLEN_M1=4'd0;
			ARSIZE_M1=3'd2;
			ARBURST_M1=2'd1;
			ARVALID_M1=1'd0;
			RREADY_M1=1'd0;
			AWID_M1=4'd0;
			AWADDR_M1=DM_address_reg;
			AWLEN_M1=4'd0;
			AWSIZE_M1=3'd2;
			AWBURST_M1=2'd1;
			AWVALID_M1=1'd0;
			WDATA_M1=DM_write_data_reg;
			WSTRB_M1=DM_strb_reg;
			WLAST_M1=1'd1;
			WVALID_M1=1'd1;
			BREADY_M1=1'd1;
			waiting_DM=1'd1;
		end
		M1_write_resp: begin
			ARID_M1=4'd0;
			ARADDR_M1=32'd0;
			ARLEN_M1=4'd0;
			ARSIZE_M1=3'd2;
			ARBURST_M1=2'd1;
			ARVALID_M1=1'd0;
			RREADY_M1=1'd0;
			AWID_M1=4'd0;
			AWADDR_M1=DM_address_reg;
			AWLEN_M1=4'd0;
			AWSIZE_M1=3'd2;
			AWBURST_M1=2'd1;
			AWVALID_M1=1'd0;
			WDATA_M1=DM_write_data_reg;
			WSTRB_M1=DM_strb_reg;
			WLAST_M1=1'd0;
			WVALID_M1=1'd0;
			BREADY_M1=1'd0;
			waiting_DM=1'd1;
		end
		default: begin
			ARID_M1=4'd0;
			ARADDR_M1=32'd0;
			ARLEN_M1=4'd0;
			ARSIZE_M1=3'd2;
			ARBURST_M1=2'd1;
			ARVALID_M1=1'd0;
			RREADY_M1=1'd0;
			AWID_M1=4'd0;
			AWADDR_M1=32'd0;
			AWLEN_M1=4'd0;
			AWSIZE_M1=3'd2;
			AWBURST_M1=2'd1;
			AWVALID_M1=1'd0;
			WDATA_M1=32'd0;
			WSTRB_M1=4'b1111;
			WLAST_M1=1'd0;
			WVALID_M1=1'd0;
			BREADY_M1=1'd0;
			waiting_DM=1'd0;
		end
	endcase
end

endmodule

