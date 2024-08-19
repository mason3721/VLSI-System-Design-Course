module WDT(
	input clk,
	input rst,
	input clk2,
	input rst2,
	input WDEN,
	input WDLIVE,
	input [31:0] WTOCNT,
	output logic WTO
);

logic [31:0] maxcount;
logic WDEN_syn0,WDEN_syn1;
logic WDLIVE_syn0,WDLIVE_syn1;
logic WTO_syn0,WTO_syn1;

logic [31:0] counter;
logic [1:0] cs,ns;
parameter idle=2'd0;
parameter count=2'd1;
parameter interrupt=2'd2;
parameter waiting=2'd3;

always_ff@(posedge clk2) begin
	if(~rst2) cs<=idle;
	else cs<=ns;
end

always_comb
begin
	case(cs)
		idle:begin
			if(WDEN_syn1) ns=count;
			else ns=idle;
		end
		count:begin
			if(counter==maxcount) ns=interrupt;
			else ns=count;
		end
		interrupt:begin
			ns=waiting;
		end
		waiting:begin
			if(WDLIVE_syn1) ns=idle;
			else ns=waiting;
		end
	endcase
end

always_ff@(posedge clk2)
begin
	if(~rst2)WTO_syn0<=1'd0;
	else if(cs==interrupt)WTO_syn0<=1'd1;
	else WTO_syn0<=1'd0;
end

always_ff@(posedge clk)
begin
	if(~rst)WTO_syn1<=1'd0;
	else WTO_syn1<=WTO_syn0;
end

always_ff@(posedge clk) begin
	if(~rst) WTO<=1'd0;
	else WTO<=WTO_syn1;
end


always_ff@(posedge clk2)
begin
	if(~rst2) maxcount<=32'd0;
	else if(cs==idle) maxcount<=WTOCNT;
	else maxcount<=maxcount;
end

always_ff@(posedge clk2)
begin
	if(~rst2 || (cs==idle)) counter<=32'd0;
	else if(cs==count) counter <= counter+32'd1;
	else counter <= counter;
end

always_ff@(posedge clk2)
begin
	if(~rst2) WDEN_syn0<=1'd0;
	else if(cs==idle) WDEN_syn0<=WDEN;
	else WDEN_syn0<=1'd0;
end

always_ff@(posedge clk2)
begin
	if(~rst2) WDEN_syn1<=1'd0;
	else WDEN_syn1<=WDEN_syn0;
end

always_ff@(posedge clk2)
begin
	if(~rst2) WDLIVE_syn0<=1'd0;
	else if(cs==waiting) WDLIVE_syn0<=WDLIVE;
	else WDLIVE_syn0<=1'd0;
end

always_ff@(posedge clk2)
begin
	if(~rst2) WDLIVE_syn1<=1'd0;
	else WDLIVE_syn1<=WDLIVE_syn0;
end


endmodule