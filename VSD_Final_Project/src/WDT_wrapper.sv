`include "WDT.sv"

module WDT_wrapper(
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
	
	output logic WTO
);


logic WDEN,WDLIVE;
logic [31:0] WTOCNT;
logic [31:0] A;

logic [31:0] write_address_reg;
//logic [7:0] write_ID;

parameter idle=2'd0;
parameter write_data=2'd1;
parameter write_resp=2'd2;
logic [1:0] cs,ns;

always_ff@(posedge ACLK) begin
	if(~ARESETn) cs<=idle;
	else cs<=ns;
end

always_comb begin
	unique case (cs)
		idle: begin
			if(AWVALID_S==1'd1) ns=write_data;
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
		default : ns=idle;
	endcase
end

always_ff@(posedge ACLK) begin
	if(~ARESETn) write_address_reg<=32'd0;
	else if(cs==idle) write_address_reg<=AWADDR_S;
	else write_address_reg<=write_address_reg;
end

always_comb begin
	if(cs==write_data || cs==write_resp) begin
		A=write_address_reg;
	end
	else begin
		A=32'd0;
	end
end

always_ff@(posedge ACLK) begin
	if(~ARESETn) WDEN<=1'd0;
	else if(WDATA_S != 0 && A==32'h10010100) WDEN<=1'd1;
	else if(WDATA_S != 0 && A==32'h10010200) WDEN<=1'd0;
	else WDEN<=WDEN;
end

always_ff@(posedge ACLK) begin
	if(~ARESETn) WDLIVE<=1'd0;
	else if(WDATA_S != 0 && A==32'h10010200) WDLIVE<=1'd1;
	else if(WDATA_S != 0 && A==32'h10010100) WDLIVE<=1'd0;
	else WDLIVE<=WDLIVE;
end

always_ff@(posedge ACLK) begin
	if(~ARESETn) WTOCNT<=32'd0;
	else if(WDATA_S != 0 && A==32'h10010300) WTOCNT<=WDATA_S;
	else WTOCNT<=WTOCNT;
end
			
always_comb begin
	unique case (cs)
		idle: begin
			//write_ID=AWID_S;
			AWREADY_S=1'd1;
			WREADY_S=1'd0;
			BID_S=8'd0;
          	BRESP_S=2'd0;
			BVALID_S=1'd0;
		end	
		write_data: begin
			//write_ID=write_ID;
			AWREADY_S=1'd0;
			WREADY_S=1'd1;
			BID_S=8'd0;
           	BRESP_S=2'd0;
			BVALID_S=1'd0;
		end	
		write_resp: begin
			//write_ID=write_ID;
			AWREADY_S=1'd0;
			WREADY_S=1'd0;
			BID_S=8'd0;
            BRESP_S=2'd0;
			BVALID_S=1'd1;
		end
		default: begin
			//write_ID=AWID_S;
			AWREADY_S=1'd0;
			WREADY_S=1'd0;
			BID_S=8'd0;
          	BRESP_S=2'd0;
			BVALID_S=1'd0;
		end	
	endcase
end		


WDT WDT(
	.clk(ACLK),
	.rst(ARESETn),
	.clk2(ACLK),
	.rst2(ARESETn),
	.WDEN(WDEN),
	.WDLIVE(WDLIVE),
	.WTOCNT(WTOCNT),
	.WTO(WTO)
);

endmodule