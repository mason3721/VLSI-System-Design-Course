`include "pwm.sv"
module PWM_wrapper(
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
	
	output logic pwm_o_0,
	output logic pwm_o_1,
	output logic pwm_o_2,
	output logic pwm_o_3
);

logic [31:0] DI;

parameter PWM_IDLE=2'd0;
parameter PWM_write_data=2'd1;
parameter PWM_write_resp=2'd2;

logic [1:0] PWM_curr_state,PWM_next_state;

always_ff@(posedge ACLK ) begin
	if(~ARESETn) PWM_curr_state<=PWM_IDLE;
	else PWM_curr_state<=PWM_next_state;
end

always_comb begin //next state logic for PWM read
	unique case (PWM_curr_state)
		PWM_IDLE: begin
			if(AWVALID_S==1'd1) PWM_next_state=PWM_write_data;
			else PWM_next_state=PWM_IDLE;
		end
		PWM_write_data: begin
			if(WLAST_S & WVALID_S) PWM_next_state=PWM_write_resp;
			else PWM_next_state=PWM_write_data;
		end
		PWM_write_resp: begin
			if(BREADY_S!=1'd1) PWM_next_state=PWM_write_resp;
			else PWM_next_state=PWM_IDLE;
		end
		default: PWM_next_state=PWM_IDLE;
	endcase
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) DI<=32'd0;
	else if(PWM_next_state==PWM_write_data) DI<=WDATA_S;
	else DI<=DI;
end
	
always_comb begin//output logic for PWM_write
	unique case (PWM_curr_state)
		PWM_IDLE: begin
			AWREADY_S=1'd1;
			WREADY_S=1'd0;
			BID_S=8'd0;
          	BRESP_S=2'd0;
			BVALID_S=1'd0;
		end
		PWM_write_data: begin
			AWREADY_S=1'd0;
			WREADY_S=1'd1;
			BID_S=8'd0;
           	BRESP_S=2'd0;
			BVALID_S=1'd0;
		end	
		PWM_write_resp: begin
			AWREADY_S=1'd0;
			WREADY_S=1'd0;
			BID_S=8'd0;
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

pwm pwm0(
	.clk(ACLK),
	.rst(ARESETn),
	.num(DI),
	.pwm_o_0(pwm_o_0),
	.pwm_o_1(pwm_o_1),
	.pwm_o_2(pwm_o_2),
	.pwm_o_3(pwm_o_3)
);


endmodule
