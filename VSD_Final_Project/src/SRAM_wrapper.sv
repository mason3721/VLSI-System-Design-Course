module SRAM_wrapper(
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
	input RREADY_S

);


logic CS,OE;
logic [3:0] WEB;
logic [13:0] A;
logic [31:0] DI;
logic [31:0] DO;

logic [31:0] read_address_reg;
logic [7:0] read_ID;

logic [31:0] write_address_reg;
logic [7:0] write_ID;
logic [3:0] len_reg;


assign DI=WDATA_S;

assign CS=1'd1;

parameter SRAM_IDLE=2'd0;
parameter SRAM_read_data=2'd1;
parameter SRAM_write_data=2'd2;
parameter SRAM_write_resp=2'd3;


logic [1:0] SRAM_curr_state,SRAM_next_state;


always_ff@(posedge ACLK ) begin
	if(~ARESETn) SRAM_curr_state<=SRAM_IDLE;
	else SRAM_curr_state<=SRAM_next_state;
end

always_comb begin //next state logic for SRAM read
	unique case (SRAM_curr_state)
		SRAM_IDLE: begin
				if(ARVALID_S==1'd1) SRAM_next_state=SRAM_read_data;
				else if(AWVALID_S==1'd1) SRAM_next_state=SRAM_write_data;
				else SRAM_next_state=SRAM_IDLE;
		end
		SRAM_read_data:begin
			if(RREADY_S==1'd1 && len_reg==4'd0) SRAM_next_state=SRAM_IDLE;
			else SRAM_next_state=SRAM_read_data;
		end
		SRAM_write_data: begin
			if(WLAST_S & WVALID_S) SRAM_next_state=SRAM_write_resp;
			else SRAM_next_state=SRAM_write_data;
		end
		SRAM_write_resp: begin
			if(BREADY_S!=1'd1) SRAM_next_state=SRAM_write_resp;
			else SRAM_next_state=SRAM_IDLE;
		end
	endcase
end

	
always_ff@(posedge ACLK ) begin
	if(~ARESETn) read_address_reg<=32'd0;
	else if(SRAM_curr_state==SRAM_IDLE) read_address_reg<=ARADDR_S;
	else read_address_reg<=read_address_reg;
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) read_ID<=8'd0;
	else if(SRAM_curr_state==SRAM_IDLE) read_ID<=ARID_S;
	else read_ID<=read_ID;
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) len_reg<=4'd0;
	else if(SRAM_next_state==SRAM_IDLE) len_reg<=ARLEN_S;
	else if(SRAM_next_state==SRAM_read_data && len_reg!=4'd0) len_reg<=len_reg-4'd1;
	else if(len_reg==4'd0) len_reg<=4'd0;
	else len_reg<=len_reg;
end
	
always_comb begin//output logic for SRAM_read
	unique case (SRAM_curr_state)
		SRAM_IDLE: begin
			ARREADY_S=1'd1;
			RID_S=8'd0;
			RDATA_S=32'd0;
			RRESP_S=2'd0;
			RLAST_S=1'd0;
			RVALID_S=1'd0;
			OE=1'd0;
		end
		SRAM_read_data: begin
			ARREADY_S=1'd0;
			RID_S=read_ID;
			RDATA_S=DO;
			RRESP_S=2'd0;
			RLAST_S=(len_reg==4'd0)?1'd1:1'd0;
			RVALID_S=1'd1;
			OE=1'd1;
		end	
		default : begin
			ARREADY_S=1'd0;
			RID_S= 8'd0;
			RDATA_S=32'd0;
			RRESP_S=2'd0;
			RLAST_S=1'd0;
			RVALID_S=1'd0;
			OE=1'd0;
		end	
	endcase
end		

always_ff@(posedge ACLK ) begin
	if(~ARESETn) write_address_reg<=32'd0;
	else if(SRAM_curr_state==SRAM_IDLE) write_address_reg<=AWADDR_S;
	else write_address_reg<=write_address_reg;
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) write_ID<=8'd0;
	else if(SRAM_curr_state==SRAM_IDLE || SRAM_curr_state==SRAM_read_data) write_ID<=AWID_S;
	else write_ID<=write_ID;
end
	
always_comb begin//output logic for SRAM_write
	unique case (SRAM_curr_state)
		SRAM_IDLE: begin
			AWREADY_S=1'd1;
			WREADY_S=1'd0;
			BID_S=8'd0;
          	BRESP_S=2'd0;
			BVALID_S=1'd0;
		end
		SRAM_write_data: begin
			AWREADY_S=1'd0;
			WREADY_S=1'd1;
			BID_S=8'd0;
           	BRESP_S=2'd0;
			BVALID_S=1'd0;
		end	
		SRAM_write_resp: begin
			AWREADY_S=1'd0;
			WREADY_S=1'd0;
			BID_S=write_ID;
            BRESP_S=2'd0;
			BVALID_S=1'd1;
		end
		default : begin	
			AWREADY_S=1'd0;
			WREADY_S=1'd0;
			BID_S=8'd0;
          	BRESP_S=2'd0;
			BVALID_S=1'd0;
		end
	endcase
end		

always_comb begin
	if(SRAM_curr_state==SRAM_IDLE || SRAM_curr_state==SRAM_read_data) begin
		case(len_reg) 
			4'd4: A=read_address_reg[15:2];
			4'd3: A=read_address_reg[15:2]+14'd1;
			4'd2: A=read_address_reg[15:2]+14'd2;
			4'd1: A=read_address_reg[15:2]+14'd3;
			default :A=14'd0;
		endcase
	end
	else if(SRAM_curr_state==SRAM_write_data || SRAM_curr_state==SRAM_write_resp) begin
		A=write_address_reg[15:2];
	end
	else begin
		A=14'd0;
	end
end
	
always_comb begin
	if(SRAM_curr_state==SRAM_write_data || SRAM_curr_state==SRAM_write_data) WEB=WSTRB_S;
	else WEB=4'b1111;
end	

SRAM i_SRAM (
    .A0   (A[0]  ),
    .A1   (A[1]  ),
    .A2   (A[2]  ),
    .A3   (A[3]  ),
    .A4   (A[4]  ),
    .A5   (A[5]  ),
    .A6   (A[6]  ),
    .A7   (A[7]  ),
    .A8   (A[8]  ),
    .A9   (A[9]  ),
    .A10  (A[10] ),
    .A11  (A[11] ),
    .A12  (A[12] ),
    .A13  (A[13] ),
    .DO0  (DO[0] ),
    .DO1  (DO[1] ),
    .DO2  (DO[2] ),
    .DO3  (DO[3] ),
    .DO4  (DO[4] ),
    .DO5  (DO[5] ),
    .DO6  (DO[6] ),
    .DO7  (DO[7] ),
    .DO8  (DO[8] ),
    .DO9  (DO[9] ),
    .DO10 (DO[10]),
    .DO11 (DO[11]),
    .DO12 (DO[12]),
    .DO13 (DO[13]),
    .DO14 (DO[14]),
    .DO15 (DO[15]),
    .DO16 (DO[16]),
    .DO17 (DO[17]),
    .DO18 (DO[18]),
    .DO19 (DO[19]),
    .DO20 (DO[20]),
    .DO21 (DO[21]),
    .DO22 (DO[22]),
    .DO23 (DO[23]),
    .DO24 (DO[24]),
    .DO25 (DO[25]),
    .DO26 (DO[26]),
    .DO27 (DO[27]),
    .DO28 (DO[28]),
    .DO29 (DO[29]),
    .DO30 (DO[30]),
    .DO31 (DO[31]),
    .DI0  (DI[0] ),
    .DI1  (DI[1] ),
    .DI2  (DI[2] ),
    .DI3  (DI[3] ),
    .DI4  (DI[4] ),
    .DI5  (DI[5] ),
    .DI6  (DI[6] ),
    .DI7  (DI[7] ),
    .DI8  (DI[8] ),
    .DI9  (DI[9] ),
    .DI10 (DI[10]),
    .DI11 (DI[11]),
    .DI12 (DI[12]),
    .DI13 (DI[13]),
    .DI14 (DI[14]),
    .DI15 (DI[15]),
    .DI16 (DI[16]),
    .DI17 (DI[17]),
    .DI18 (DI[18]),
    .DI19 (DI[19]),
    .DI20 (DI[20]),
    .DI21 (DI[21]),
    .DI22 (DI[22]),
    .DI23 (DI[23]),
    .DI24 (DI[24]),
    .DI25 (DI[25]),
    .DI26 (DI[26]),
    .DI27 (DI[27]),
    .DI28 (DI[28]),
    .DI29 (DI[29]),
    .DI30 (DI[30]),
    .DI31 (DI[31]),
    .CK   (ACLK    ),
    .WEB0 (WEB[0]),
    .WEB1 (WEB[1]),
    .WEB2 (WEB[2]),
    .WEB3 (WEB[3]),
    .OE   (OE    ),
    .CS   (CS    )
  );

endmodule
