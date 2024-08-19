module FIFO_R(
	input [41:0] wdata,
	input valid_i, //wen
	output logic valid_o,
	input wrst_n,
	input wclk,
	output logic [41:0] rdata,
	input ready_i,
	output logic ready_o,
	input rrst_n,
	input rclk
);

logic [2:0] waddr;
logic [2:0] raddr;
logic [2:0] wptr;
logic [2:0] sync_w2r;
logic [2:0] rq2_wptr;
logic [2:0] rptr;
logic [2:0] sync_r2w;
logic [2:0] wq2_rptr;
logic [2:0] waddr_next;
logic [2:0] wptr_next;
logic [2:0] raddr_next;
logic [2:0] rptr_next;
logic full;
logic empty;
logic wfull;
logic rempty;
logic [41:0] mem [3:0];


assign waddr_next = waddr+{2'd0,(valid_i & !wfull)};
assign wptr_next = (waddr_next>>1)^waddr_next;
//assign wen = (valid_i&(~ready_i));
assign full = (wptr_next == {~wq2_rptr[2:1],wq2_rptr[0]});

assign raddr_next = raddr+{2'd0,(ready_i & !rempty)};
assign rptr_next = (raddr_next >>1)^raddr_next;
//assign ren = (ready_i&valid_i);
assign empty = (rq2_wptr == rptr_next);

assign valid_o = ~rempty;
assign ready_o = ~wfull;

always_ff@(posedge wclk)
begin
	if(wrst_n) begin
		waddr<= 3'd0;
		wptr<= 3'd0;
	end
	else begin
		waddr<=waddr_next;
		wptr<=wptr_next;
	end
end

always_ff@(posedge wclk)
begin
	if(wrst_n) wfull<= 1'd0;
	else wfull<=full;
end

always_ff@(posedge rclk)
begin
	if(rrst_n) begin
		raddr<= 3'd0;
		rptr<= 3'd0;
	end
	else begin
		raddr<=raddr_next;
		rptr<=rptr_next;
	end
end

always_ff@(posedge rclk)
begin
	if(rrst_n) rempty<=1'd1;
	else rempty<=empty;
end

always_ff@(posedge wclk)
begin
	if(wrst_n) begin
		mem[0]<=42'd0;
		mem[1]<=42'd0;
		mem[2]<=42'd0;
		mem[3]<=42'd0;
	end
	else if(valid_i) mem[waddr[1:0]]<=wdata; //拿waddr[1:0]定址，waddr[2]只是判斷full用
end

assign rdata=mem[raddr[1:0]];

always_ff@(posedge wclk)
begin
	if(wrst_n) begin
		sync_r2w<= 3'd0;
		wq2_rptr<= 3'd0;
	end
	else begin
		sync_r2w<=rptr;
		wq2_rptr<=sync_r2w;
	end
end

always_ff@(posedge rclk)
begin
	if(rrst_n) begin
		sync_w2r<= 3'd0;
		rq2_wptr<= 3'd0;
	end
	else begin
		sync_w2r<=wptr;
		rq2_wptr<=sync_w2r;
	end
end

endmodule