//================================================
// Auther:      Chen Yun-Ru (May)
// Filename:    L1C_inst.sv
// Description: L1 Cache for instruction
// Version:     0.1
//================================================

/*`include "def.svh"
`include "data_array_wrapper.sv"
`include "tag_array_wrapper.sv"*/
module L1C_inst(
  input clk,
  input rst,
  // Core to CPU wrapper
  input [32-1:0] core_addr, //IM_raddr(CPU)
  input core_req,		    //IM_ren(CPU)
  //input core_write,	 		
  //input [32-1:0] core_in,   
  //input [3-1:0] core_type,//read always read a word，LH、LB do later at LH_LB_shift
  // Mem to CPU wrapper
  input [32-1:0] I_out,     //RDATA_M0(CPU_wrapper)
  input I_wait,				//waiting_IM(CPU_wrapper)
  // CPU wrapper to core
  output logic [32-1:0] core_out, //類似IM_read_data_reg
  output logic core_wait,               //類似waiting_IM
  // CPU wrapper to Mem
  output logic I_req,       //類似IM_ren
  output logic [32-1:0] I_addr, //IM_raddr
  //output I_write,
  //output [32-1:0] I_in,
  //output [3-1:0] I_type
  input [3:0]  L1D_curr_state,
  output [2:0] L1I_state,
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

parameter IDLE=3'd0;
parameter hit_miss=3'd1; //Tag compare hit or miss
parameter read_hit=3'd2;
parameter read_mem_miss=3'd3; //read miss

logic counter;
logic [31:0] cache_hit;
logic [31:0] cache_miss;
logic [2:0] read_counter;
logic [2:0] L1I_curr_state,L1I_next_state;
logic[1:0] offset;
logic [5:0] index_block;
logic [31:0] read_mem_addr,addr_reg;

assign L1I_state=L1I_curr_state;
assign offset=addr_reg[3:2]; //避開LH、LB且address不是4的倍數，之後再做
assign index_block=addr_reg[9:4];

always_ff@(posedge clk ) begin
	if(rst) core_out<=32'd0;
	else begin
		unique if(L1I_curr_state==read_hit) core_out<=DA_out[offset*32+:32];
		else core_out<=core_out;
	end
end

always_ff@(posedge clk) begin
	if(rst) begin
		L1I_curr_state<=IDLE;
	end
	else begin
		L1I_curr_state<=L1I_next_state;
	end
end

always_ff@(posedge clk) begin
	if(rst) begin
		cache_hit<=32'd0;
		cache_miss<=32'd0;
	end
	else begin
		if(L1I_curr_state==hit_miss && L1I_next_state==read_hit) begin
			cache_hit<=cache_hit+32'd1;
			cache_miss<=cache_miss;
		end
		else if(L1I_curr_state==hit_miss && L1I_next_state==read_mem_miss) begin
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
	unique case (L1I_curr_state)
		IDLE: begin
			if(L1D_curr_state==4'd0 && core_req==1'd1) L1I_next_state=hit_miss;
			else L1I_next_state=IDLE;
		end
		hit_miss: begin
			if(valid[index_block]==1'd1) begin
				if(addr_reg[31:10]==TA_out) L1I_next_state=read_hit;
				else L1I_next_state=read_mem_miss;
			end
			else L1I_next_state=read_mem_miss;
		end
		read_hit: begin
			L1I_next_state=IDLE;
		end
		read_mem_miss: begin
			if(read_counter==3'd4) L1I_next_state=read_hit;
			else L1I_next_state=read_mem_miss;
		end
		default: L1I_next_state=IDLE;
	endcase
end

always_ff@(posedge clk) begin
	if(rst) counter<=1'd0;
	else if(L1I_curr_state==read_mem_miss) counter<=1'd1;
	else counter<=1'd0;
end

always_ff@(posedge clk) begin
	if(rst) addr_reg<=32'd0;
	else if(L1I_curr_state==IDLE && (core_req==1'd1)) addr_reg<=core_addr;
	else addr_reg<=addr_reg;
end

always_ff@(posedge clk) begin
	if(rst) valid<=64'd0;
	else if(L1I_curr_state==read_mem_miss) valid[index_block]<=1'd1;
	else valid<=valid;
end

always_ff@(posedge clk) begin
	if(rst) read_counter<=3'd0;
	else if( read_data_valid==1'd1) read_counter<=read_counter+3'd1;
	else if(read_counter==3'd4) read_counter<=3'd0;
	else read_counter<=read_counter;
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
	if(L1I_next_state==read_mem_miss) I_addr=read_mem_addr;
	else I_addr=32'd0;
end

always_comb begin//output logic
	unique case (L1I_curr_state)
		IDLE: begin 
			//core_out=32'd0;
			core_wait=1'd0;
			I_req=1'd0;
			
			index=core_addr[9:4];
			DA_in=128'd0;
			DA_write=16'b1111111111111111;
			DA_read=1'd0;
			TA_in=22'd0;
			TA_write=1'd1;
			TA_read=1'd0;
		end
		hit_miss: begin //read out Tag
			//core_out=32'd0;
			core_wait=1'd1;
			I_req=1'd0;
			//I_addr=32'd0;
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
			I_req=1'd0;
			//I_addr=32'd0;
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
			I_req=(read_counter==3'd3 || read_counter==3'd4)?1'd0:1'd1;
			index=addr_reg[9:4];
			case(read_counter) 
				3'd0: begin
					DA_write={12'b111111111111,4'b0000};
					DA_in={96'd0,I_out};
				end
				3'd1: begin
					DA_write={8'b11111111,4'b0000,4'b1111};
					DA_in={64'd0,I_out,32'd0};
				end
				3'd2: begin
					DA_write={4'b1111,4'b0000,8'b11111111};
					DA_in={32'd0,I_out,64'd0};
				end
				3'd3: begin
					DA_write={4'b0000,12'b111111111111};
					DA_in={I_out,96'd0};
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
		default :begin
			//core_out=32'd0;
			core_wait=1'd0;
			I_req=1'd0;
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
    .A(index),      
    .DO(DA_out),	//read data
    .DI(DA_in),     //write data
    .CK(clk),
    .WEB(DA_write),
    .OE(DA_read),
    .CS(1'b1)
  );
   
  tag_array_wrapper  TA(
    .A(index),
    .DO(TA_out),     //read tag
    .DI(TA_in),		 //write tag
    .CK(clk),
    .WEB(TA_write),
    .OE(TA_read),
    .CS(1'b1)
  );

endmodule

