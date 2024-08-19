
module FIFO_B(
	input [9:0] wdata,
	input valid_i, //wen、wput
	output logic valid_o, //rrdy
	input wrst_n,
	input wclk,
	output logic [9:0] rdata,
	input ready_i, //ren、rget
	output logic ready_o, //wrdy
	input rrst_n,
	input rclk
);

logic wptr, we, wq2_rptr;
logic rptr, rq2_wptr;


assign we = ready_o & valid_i;
assign ready_o = ~(wq2_rptr ^ wptr);
always_ff @(posedge wclk) begin
	if (wrst_n) wptr <=1'd0;
	else wptr <= wptr ^ we;
end

logic rinc;
/*typedef enum {xxx, VALID} status_e;
status_e status;
assign status = status_e'(rrdy);*/
assign rinc = valid_o & ready_i;
assign valid_o = (rq2_wptr ^ rptr);
always_ff @(posedge rclk) begin
	if (rrst_n) rptr <=1'd0;
	else rptr <= rptr ^ rinc;
end

logic q1; // 1st stage ff output
always_ff @(posedge rclk) begin
	if (rrst_n) {rq2_wptr,q1} <=2'd0;
	else {rq2_wptr,q1} <= {q1,wptr};
end

logic q2; // 1st stage ff output
always_ff @(posedge wclk) begin
	if (wrst_n) {wq2_rptr,q2} <=2'd0;
	else {wq2_rptr,q2} <= {q2,rptr};
end

logic [9:0] mem [1:0];
always_ff @(posedge wclk) begin
	if(wrst_n) begin
		mem[0]<=10'd0;
		mem[1]<=10'd0;
	end
	else if (we) mem[wptr] <= wdata;
end
assign rdata = mem[rptr];

	
endmodule
	
	


	