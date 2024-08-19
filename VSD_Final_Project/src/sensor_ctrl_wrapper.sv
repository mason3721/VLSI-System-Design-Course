`include "sensor_ctrl.sv"


module sensor_ctrl_wrapper(
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
	
	output sctrl_interrupt,
	input sensor_ready,
	input [31:0] sensor_out_0,
	input [31:0] sensor_out_1,
	input [31:0] sensor_out_2,
	    input  [31:0] sensor_out_3,
  input  [31:0] sensor_out_4,
  input [31:0] sensor_out_5,
  input  [31:0] sensor_out_6,
  input  [31:0] sensor_out_7,
	output sensor_en

);


logic sctrl_en,sctrl_clear;
logic [31:0] DO;
logic [31:0] A;

logic [31:0] read_address_reg;
//logic [7:0] read_ID;
logic [31:0] write_address_reg;
//logic [7:0] write_ID;

parameter idle=2'd0;
parameter read_data=2'd1;
parameter write_data=2'd2;
parameter write_resp=2'd3;
logic [1:0] cs,ns;


always_ff@(posedge ACLK) begin
	if(~ARESETn) cs<=idle;
	else cs<=ns;
end

always_comb begin //next state logic for SRAM read
	unique case (cs)
		idle: begin
				if(ARVALID_S==1'd1 && ARLEN_S==4'd0) ns=read_data;
				else if(AWVALID_S==1'd1) ns=write_data;
				else ns=idle;
		end
		read_data:begin
			unique if(RREADY_S!=1'd1) ns=read_data;
			else ns=idle;
		end
		write_data: begin
			unique if(WLAST_S & WVALID_S) ns=write_resp;
			else ns=write_data;
		end
		write_resp: begin
			unique if(BREADY_S!=1'd1) ns=write_resp;
			else ns=idle;
		end
	endcase
end
	
always_ff@(posedge ACLK ) begin
	if(~ARESETn) read_address_reg<=32'd0;
	else if(cs==idle) read_address_reg<=ARADDR_S;
	else read_address_reg<=read_address_reg;
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) write_address_reg<=32'd0;
	else if(cs==idle) write_address_reg<=AWADDR_S;
	else write_address_reg<=write_address_reg;
end

always_comb begin
	if(cs==idle || cs==read_data) begin
		A=read_address_reg;
	end
	else if(cs==write_data || cs==write_resp) begin
		A=write_address_reg;
	end
	else begin
		A=32'd0;
	end
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) sctrl_en<=1'd0;
	else if(WDATA_S != 0 && A==32'h10000100) sctrl_en<=1'd1;
	else sctrl_en<=sctrl_en;
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) sctrl_clear<=1'd0;
	else if(WDATA_S != 0 && A==32'h10000200) sctrl_clear<=1'd1;
	else sctrl_clear<=1'd0;
end
			
always_comb begin
	unique case (cs)
		idle: begin
			//read通道
			//read_ID=8'd0;
			ARREADY_S=1'd1;
			RID_S= 8'd0;
			RDATA_S=32'd0;
			RRESP_S=2'd0;
			RLAST_S=1'd0;
			RVALID_S=1'd0;
			//write通道
			//write_ID=AWID_S;
			AWREADY_S=1'd1;
			WREADY_S=1'd0;
			BID_S=8'd0;
          	BRESP_S=2'd0;
			BVALID_S=1'd0;
		end	
		read_data: begin
			//read通道
			//read_ID=read_ID;
			ARREADY_S=1'd0;
			RID_S= 8'd0;
			RDATA_S=DO;
			RRESP_S=2'd0;
			RLAST_S=1'd1;
			RVALID_S=1'd1;
			//write通道
			//write_ID=AWID_S;
			AWREADY_S=1'd0;
			WREADY_S=1'd0;
			BID_S=8'd0;
          	BRESP_S=2'd0;
			BVALID_S=1'd0;
		end	
		write_data: begin
			//read通道
			//read_ID=8'd0;
			ARREADY_S=1'd0;
			RID_S= 8'd0;
			RDATA_S=32'd0;
			RRESP_S=2'd0;
			RLAST_S=1'd0;
			RVALID_S=1'd0;
			//write通道
			//write_ID=write_ID;
			AWREADY_S=1'd0;
			WREADY_S=1'd1;
			BID_S=8'd0;
           	BRESP_S=2'd0;
			BVALID_S=1'd0;
		end	
		write_resp: begin
			//read通道
			//read_ID=8'd0;
			ARREADY_S=1'd0;
			RID_S= 8'd0;
			RDATA_S=32'd0;
			RRESP_S=2'd0;
			RLAST_S=1'd0;
			RVALID_S=1'd0;
			//write通道
			//write_ID=write_ID;
			AWREADY_S=1'd0;
			WREADY_S=1'd0;
			BID_S=8'd0;
            BRESP_S=2'd0;
			BVALID_S=1'd1;
		end
	endcase
end		

  
sensor_ctrl sensor_ctrl(
  .clk(ACLK),
  .rst(~ARESETn),
  .sctrl_en(sctrl_en),
  .sctrl_clear(sctrl_clear),
  .sctrl_addr(A[7:2]),
  .sensor_ready(sensor_ready),
  .sensor_out_0(sensor_out_0),
  .sensor_out_1(sensor_out_1),
  .sensor_out_2(sensor_out_2),
  .sensor_out_3	(sensor_out_3),
 .sensor_out_4	(sensor_out_4),	
 .sensor_out_5	(sensor_out_5),
	.sensor_out_6	(sensor_out_6),
	.sensor_out_7	(sensor_out_7),	
  .sctrl_interrupt(sctrl_interrupt),
  .sctrl_out(DO),
  .sensor_en(sensor_en)
);

endmodule