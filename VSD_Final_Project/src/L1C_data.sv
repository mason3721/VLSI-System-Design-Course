//================================================
// Auther:      Chen Yun-Ru (May)
// Filename:    L1C_data.sv
// Description: L1 Cache for data
// Version:     0.1
//================================================
//Read Write data length
/*`define WRITE_LEN_BITS 2
`define BYTE `WRITE_LEN_BITS'b00
`define HWORD `WRITE_LEN_BITS'b01
`define WORD `WRITE_LEN_BITS'b10*/

/*`include "def.svh"
`include "data_array_wrapper.sv"
`include "tag_array_wrapper.sv"*/
module L1C_data(
  input clk,
  input rst,
  // Core to CPU wrapper
  input [32-1:0] core_addr,
  input core_read_req,          //DM_raddr(CPU)
  //input core_write,
  input [32-1:0] core_in,		//write data
  input [4-1:0] core_write_req, //DM_wen(CPU)
  // Mem to CPU wrapper
  input [32-1:0] D_out,         //RDATA_M1(CPU_wrapper)
  input D_wait,					//waiting_DM(CPU_wrapper)
  // CPU wrapper to core
  output logic [32-1:0] core_out,  //類似DM_read_data_reg
  output logic core_wait,                //類似waiting_DM
  // CPU wrapper to Mem
  output logic D_req,
  output logic [32-1:0] D_addr,
  //output D_write,
  output logic [32-1:0] D_in,
  output logic [4-1:0]  D_write_type, //DM_wen(CPU)
  input [2:0]  L1I_curr_state,
  output [3:0] L1D_state,
  input read_data_valid
);

  logic [6-1:0] index;
  logic [128-1:0] DA_out;
  logic [128-1:0] DA_in;
  logic [16-1:0] DA_write;
  logic DA_read;
  logic [22-1:0] TA_out;
  logic [22-1:0] TA_in;
  logic TA_write;
  logic TA_read;
  logic [64-1:0] valid;

  //--------------- complete this part by yourself -----------------//

parameter IDLE=4'd0;
parameter read_hit_miss=4'd1; //read Tag compare hit or miss
parameter write_hit_miss=4'd2; //write Tag compare hit or miss
parameter read_hit=4'd3;
parameter read_mem_miss=4'd4; //read miss
parameter write_hit=4'd5;
parameter write_miss=4'd6;
parameter sensor_read=4'd7;
parameter sensor_write=4'd8;
parameter wait_state=4'd9;

logic counter;
logic [31:0] cache_hit;
logic [31:0] cache_miss;
logic [2:0] read_counter;
logic [3:0] L1D_curr_state,L1D_next_state,strb_reg;
logic[1:0] offset;
logic [5:0] index_block;
logic [31:0] read_mem_addr,addr_reg,write_data_reg;

assign L1D_state=L1D_curr_state;
assign offset=addr_reg[3:2]; //避開LH、LB且address不是4的倍數，之後再做
assign index_block=addr_reg[9:4];

always_ff@(posedge clk ) begin
	if(rst) core_out<=32'd0;
	else begin
		unique if(L1D_curr_state==read_hit) core_out<=DA_out[offset*32+:32];
		else if(L1D_curr_state==sensor_read & L1D_next_state!=IDLE) core_out<=D_out;
		else core_out<=core_out;
	end
end

always_ff@(posedge clk) begin
	if(rst) L1D_curr_state<=IDLE;
	else L1D_curr_state<=L1D_next_state;
end

always_ff@(posedge clk) begin
	if(rst) begin
		cache_hit<=32'd0;
		cache_miss<=32'd0;
	end
	else begin
		if((L1D_curr_state==read_hit_miss && L1D_next_state==read_hit) || (L1D_curr_state==write_hit_miss && L1D_next_state==write_hit)) begin
			cache_hit<=cache_hit+32'd1;
			cache_miss<=cache_miss;
		end
		else if((L1D_curr_state==read_hit_miss && L1D_next_state==read_mem_miss) || (L1D_curr_state==write_hit_miss && L1D_next_state==write_miss)) begin
			cache_hit<=cache_hit;
			cache_miss<=cache_miss+32'd1;
		end
		else begin
			cache_hit<=cache_hit;
			cache_miss<=cache_miss;
		end
	end
end

always_comb begin //next state logic
	unique case (L1D_curr_state)
		IDLE: begin
			if(L1I_curr_state==3'd0) begin
				if(core_read_req==1'd1 && core_addr[31:16]!=16'h1000) L1D_next_state=read_hit_miss;
				else if(core_write_req!=4'b1111 && core_addr[31:16]!=16'h1000)  L1D_next_state=write_hit_miss;
				else if(core_read_req==1'd1 && core_addr[31:16]==16'h1000) L1D_next_state=sensor_read;
				else if(core_write_req!=4'b1111 && core_addr[31:16]==16'h1000) L1D_next_state=wait_state;
				else L1D_next_state=IDLE;
			end
			else L1D_next_state=IDLE;
		end
		read_hit_miss: begin
			if(valid[index_block]==1'd1) begin
				if(addr_reg[31:10]==TA_out) L1D_next_state=read_hit;
				else L1D_next_state=read_mem_miss;
			end
			else L1D_next_state=read_mem_miss;
		end
		write_hit_miss: begin
			if(valid[index_block]==1'd1) begin
				if(addr_reg[31:10]==TA_out) L1D_next_state=write_hit;
				else L1D_next_state=write_miss;
			end
			else L1D_next_state=write_miss;
		end
		read_hit: begin
			L1D_next_state=IDLE;
		end
		read_mem_miss: begin
			if(counter==1'd1) begin
				if(D_wait==1'd0) L1D_next_state=read_hit;
				else L1D_next_state=read_mem_miss;
			end
			else L1D_next_state=read_mem_miss;
		end
		write_hit: begin
			if(counter==1'd1) begin
				if(D_wait==1'd0) L1D_next_state=IDLE;
				else L1D_next_state=write_hit;
			end
			else L1D_next_state=write_hit;
		end
		write_miss: begin
			if(counter==1'd1) begin
				if(D_wait==1'd0) L1D_next_state=IDLE;
				else L1D_next_state=write_miss;
			end
			else L1D_next_state=write_miss;
		end
		sensor_read: begin
			if(counter==1'd1) begin
				if(D_wait==1'd0) L1D_next_state=IDLE;
				else L1D_next_state=sensor_read;
			end
			else L1D_next_state=sensor_read;
		end
		sensor_write: begin
			if(counter==1'd1) begin
				if(D_wait==1'd0) L1D_next_state=IDLE;
				else L1D_next_state=sensor_write;
			end
			else L1D_next_state=sensor_write;
		end
		wait_state: begin
			L1D_next_state=sensor_write;
		end
		default: L1D_next_state=IDLE;
	endcase
end

always_ff@(posedge clk) begin
	if(rst) counter<=1'd0;
	else if(L1D_curr_state==read_mem_miss || L1D_curr_state==write_hit || L1D_curr_state==write_miss || L1D_curr_state==sensor_write || L1D_curr_state==sensor_read) counter<=1'd1;
	else counter<=1'd0;
end

always_ff@(posedge clk) begin
	if(rst) begin
		addr_reg<=32'd0;
		write_data_reg<=32'd0;
		strb_reg<=4'b1111;
	end
	else if(L1D_curr_state==IDLE && (core_read_req==1'd1 || core_write_req!=4'b1111)) begin
		addr_reg<=core_addr;
		write_data_reg<=core_in;
		strb_reg<=core_write_req;
	end
	else begin
		addr_reg<=addr_reg;
		write_data_reg<=write_data_reg;
		strb_reg<=strb_reg;
	end
end

always_ff@(posedge clk) begin
	if(rst) read_counter<=3'd0;
	else if(L1D_curr_state==read_mem_miss && read_data_valid==1'd1) read_counter<=read_counter+3'd1;
	else if(read_counter==3'd4) read_counter<=3'd0;
	else read_counter<=read_counter;
end

always_ff@(posedge clk) begin
	if(rst) valid<=64'd0;
	else if(L1D_curr_state==read_mem_miss) valid[index_block]<=1'd1;
	else valid<=valid;
end


always_comb begin
	case(addr_reg[3:2])
		2'd0: begin
			read_mem_addr={addr_reg[31:2],2'b00};
		end
		2'd1: begin
			read_mem_addr={addr_reg[31:3],3'b000};
		end
		2'd2: begin
			read_mem_addr={addr_reg[31:4],4'b0000};
		end
		2'd3: begin
			read_mem_addr={addr_reg[31:4],4'b0000};
		end
	endcase
end

always_comb begin
	if(L1D_next_state==read_mem_miss) D_addr=read_mem_addr;
	else if(L1D_curr_state==write_hit || L1D_curr_state==write_miss || L1D_curr_state==sensor_write || L1D_curr_state==sensor_read) D_addr=addr_reg;
	else D_addr=32'd0;
end

always_comb begin//output logic
	unique case (L1D_curr_state)
		IDLE: begin //read out data
			//core_out=32'd0;
			core_wait=1'd0;
			D_req=1'd0;
			//D_addr=32'd0;
			D_in=32'd0;
			D_write_type=4'b1111;
			index=core_addr[9:4];
			DA_in=128'd0;
			DA_write=16'b1111111111111111;
			DA_read=1'd0;
			TA_in=22'd0;
			TA_write=1'd1;
			TA_read=1'd0;
		end
		read_hit_miss: begin //read out Tag
			//core_out=DA_out[offset*32+:32];
			core_wait=1'd1;
			D_req=1'd0;
			//D_addr=32'd0;
			D_in=32'd0;
			D_write_type=4'b1111;
			index=addr_reg[9:4];
			DA_in=128'd0;
			DA_write=16'b1111111111111111;
			DA_read=1'd0;
			TA_in=22'd0;
			TA_write=1'd1;
			TA_read=(valid[index_block]==1'd1)?1'd1:1'd0;
		end
		write_hit_miss: begin //read out Tag
			//core_out=DA_out[offset*32+:32];
			core_wait=1'd1;
			D_req=1'd0;
			//D_addr=32'd0;
			D_in=32'd0;
			D_write_type=4'b1111;
			index=addr_reg[9:4];
			DA_in=128'd0;
			DA_write=16'b1111111111111111;
			DA_read=1'd0;
			TA_in=22'd0;
			TA_write=1'd1;
			TA_read=(valid[index_block]==1'd1)?1'd1:1'd0;
		end
		read_hit: begin //read out data
			//core_out=DA_out[offset*32+:32];
			core_wait=1'd1;
			D_req=1'd0;
			//D_addr=32'd0;
			D_in=32'd0;
			D_write_type=4'b1111;
			index=addr_reg[9:4];
			DA_in=128'd0;
			DA_write=16'b1111111111111111;
			DA_read=1'd1;
			TA_in=22'd0;
			TA_write=1'd1;
			TA_read=1'd0;
		end
		read_mem_miss: begin
			//core_out=32'd0;
			core_wait=1'd1;
			D_req=(L1D_next_state==read_hit)?1'd0:1'd1;
			//D_addr=read_mem0_addr;
			D_in=32'd0;
			D_write_type=4'b1111;
			index=addr_reg[9:4];
			case(read_counter) 
				3'd0: begin
					DA_write={12'b111111111111,4'b0000};
					DA_in={96'd0,D_out};
				end
				3'd1: begin
					DA_write={8'b11111111,4'b0000,4'b1111};
					DA_in={64'd0,D_out,32'd0};
				end
				3'd2: begin
					DA_write={4'b1111,4'b0000,8'b11111111};
					DA_in={32'd0,D_out,64'd0};
				end
				3'd3: begin
					DA_write={4'b0000,12'b111111111111};
					DA_in={D_out,96'd0};
				end
				default: begin
					DA_in=128'd0;
					DA_write=16'b1111111111111111;
				end
			endcase
			DA_read=1'd0;
			TA_in=addr_reg[31:10];
			TA_write=1'd0;
			TA_read=1'd0;
		end
		write_hit: begin
			//core_out=32'd0;
			core_wait=1'd1;
			D_req=1'd0;
			//D_addr=addr_reg;
			D_in=write_data_reg;
			D_write_type=(L1D_next_state==IDLE)?4'b1111:strb_reg;
			index=addr_reg[9:4];
			case(offset)
				2'd0: begin	
					DA_write={12'b111111111111,strb_reg};
					DA_in={96'd0,write_data_reg};
				end
				2'd1: begin
					DA_write={8'b11111111,strb_reg,4'b1111};
					DA_in={64'd0,write_data_reg,32'd0};
				end
				2'd2: begin
					DA_write={4'b1111,strb_reg,8'b11111111};
					DA_in={32'd0,write_data_reg,64'd0};
				end
				2'd3: begin
					DA_write={strb_reg,12'b111111111111};
					DA_in={write_data_reg,96'd0};
				end
			endcase
			DA_read=1'd0;
			TA_in=22'd0;
			TA_write=1'd1;
			TA_read=1'd0;
		end
		write_miss: begin
			//core_out=32'd0;
			core_wait=1'd1;
			D_req=1'd0;
			//D_addr=addr_reg;
			D_in=write_data_reg;
			D_write_type=(L1D_next_state==IDLE)?4'b1111:strb_reg;
			index=6'd0;
			DA_in=128'd0;
			DA_write=16'b1111111111111111;
			DA_read=1'd0;
			TA_in=22'd0;
			TA_write=1'd1;
			TA_read=1'd0;
		end
		sensor_read: begin
			//core_out=32'd0;
			core_wait=1'd1;
			D_req=(L1D_next_state==IDLE)?1'd0:1'd1;
			//D_addr=read_mem3_addr;
			D_in=32'd0;
			D_write_type=4'b1111;
			index=6'd0;
			DA_in=128'd0;
			DA_write=16'b1111111111111111;
			DA_read=1'd0;
			TA_in=22'd0;
			TA_write=1'd1;
			TA_read=1'd0;
		end
		sensor_write: begin
			//core_out=32'd0;
			core_wait=1'd1;
			D_req=1'd0;
			//D_addr=read_mem3_addr;
			D_in=write_data_reg;
			D_write_type=(L1D_next_state==IDLE)?4'b1111:strb_reg;
			index=6'd0;
			DA_in=128'd0;
			DA_write=16'b1111111111111111;
			DA_read=1'd0;
			TA_in=22'd0;
			TA_write=1'd1;
			TA_read=1'd0;
		end
		wait_state: begin
			//core_out=32'd0;
			core_wait=1'd1;
			D_req=1'd0;
			//D_addr=read_mem3_addr;
			D_in=32'd0;
			D_write_type=4'b1111;
			index=6'd0;
			DA_in=128'd0;
			DA_write=16'b1111111111111111;
			DA_read=1'd0;
			TA_in=22'd0;
			TA_write=1'd1;
			TA_read=1'd0;
		end
		default :begin
			//core_out=32'd0;
			core_wait=1'd0;
			D_req=1'd0;
			//D_addr=read_mem3_addr;
			D_in=32'd0;
			D_write_type=4'b1111;
			index=6'd0;
			DA_in=128'd0;
			DA_write=16'b1111111111111111;
			DA_read=1'd0;
			TA_in=22'd0;
			TA_write=1'd1;
			TA_read=1'd0;
		end
	endcase
end
  
  data_array_wrapper DA(
    .A(index), //6bit
    .DO(DA_out), //128bit
    .DI(DA_in), //128bit
    .CK(clk),
    .WEB(DA_write), //16bit
    .OE(DA_read), //1bit
    .CS(1'b1)
  );
   
  tag_array_wrapper  TA(
    .A(index), //6bit
    .DO(TA_out), //22bit
    .DI(TA_in), //22bit
    .CK(clk),
    .WEB(TA_write), //1bit
    .OE(TA_read), //1bit
    .CS(1'b1)
  );

endmodule

