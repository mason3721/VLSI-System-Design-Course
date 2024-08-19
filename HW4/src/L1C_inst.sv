//================================================
// Auther:      Chen Yun-Ru (May)
// Filename:    L1C_inst.sv
// Description: L1 Cache for instruction
// Version:     0.1
//================================================
`include "def.svh"
`include "data_array_wrapper.sv"
`include "tag_array_wrapper.sv"

module L1C_inst(
    input                               clk,
    input                               rst,
    // Core to CPU wrapper
    input        [`DATA_BITS-1:0]       core_addr,
    input                               core_req,
    input                               core_write,
    input        [`DATA_BITS-1:0]       core_in,
    input        [`CACHE_TYPE_BITS-1:0] core_type,
    // Mem to CPU wrapper
    input        [`DATA_BITS-1:0]       I_out,
    input                               I_wait,
    // CPU wrapper to core
    output logic [`DATA_BITS-1:0]       core_out,
    output logic                        core_wait,
    // CPU wrapper to Mem
    output logic                        I_req,
    output logic [`DATA_BITS-1:0]       I_addr
);
    logic                         I_write;
    logic [`DATA_BITS-1:0]        I_in;
    logic [`CACHE_TYPE_BITS-1:0]  I_type;

    logic [`CACHE_INDEX_BITS-1:0] index;
    logic [`CACHE_DATA_BITS-1:0]  DA_out;
    logic [`CACHE_DATA_BITS-1:0]  DA_in;
    logic [`CACHE_WRITE_BITS-1:0] DA_write;
    logic                         DA_read;
    logic [`CACHE_TAG_BITS-1:0]   TA_out;
    logic [`CACHE_TAG_BITS-1:0]   TA_in;
    logic                         TA_write;
    logic                         TA_read;
    logic [`CACHE_LINES-1:0]      valid;

    logic [31:0] count_Hit;
    logic [31:0] count_Miss;
    //--------------- complete this part by yourself -----------------//

    data_array_wrapper DA (
        .A(index),
        .DO(DA_out),
        .DI(DA_in),
        .CK(clk),
        .WEB(DA_write),
        .OE(DA_read),
        .CS(1'b1)
    );
    
    tag_array_wrapper TA (
        .A(index),
        .DO(TA_out),
        .DI(TA_in),
        .CK(clk),
        .WEB(TA_write),
        .OE(TA_read),
        .CS(1'b1)
    );

    //state
    enum logic [1:0] {IDLE, Read, Read_miss, Read_Data} current_state, next_state;

    logic [31:0] data_reg;
    logic [31:0] core_out_tmp;
    logic [1:0]  miss_count_for_4_data;

    assign index = core_addr[9:4];

    //state: Sequential Circuit
	always_ff @(posedge clk) begin
		priority if (rst) begin
			current_state <= IDLE;
		end else begin
			current_state <= next_state;
		end
	end

    //Sequential Circuit
    always_ff @(posedge clk) begin
        priority if (rst) begin
            data_reg <= 32'd0;
            valid <= 64'd0;
            miss_count_for_4_data <= 2'd0;
            count_Hit <= 32'd0;
            count_Miss <= 32'd0;
        end else begin
            data_reg <= (DA_read) ? core_out_tmp : data_reg;
            valid <= valid;
            unique if (current_state == Read_miss) begin
                valid[index] <= 1'b1;
                unique if (~I_wait) begin
                    miss_count_for_4_data <= miss_count_for_4_data + 2'd1;
                end else begin
                    miss_count_for_4_data <= miss_count_for_4_data;
                end
            end else begin
                miss_count_for_4_data <= 2'd0;
            end
            if (current_state == Read) begin  //hit rate and miss rate
                unique if (valid[index] && (TA_out == core_addr[31:10])) begin
                    count_Hit <= count_Hit + 32'd1;   	
                end else begin
                    count_Miss <= count_Miss + 32'd1;
                end
            end
        end
    end

    //next_state: Combinational Circuit
    always_comb begin
        case (current_state)
            IDLE: 
            begin
                unique if(core_req)begin
                    next_state = Read;
                end else begin
                    next_state = IDLE;
                end
            end
            Read: 
            begin
                unique if(valid[index] && (TA_out == core_addr[31:10])) begin
                    next_state = IDLE;
                end else begin
                    next_state = Read_miss;
                end
            end
            Read_miss: 
            begin  
                unique if((~I_wait) && miss_count_for_4_data == 2'd3)
                    next_state = Read_Data;
                else begin
                    next_state = Read_miss;
                end
            end
            Read_Data: 
            begin
                next_state = IDLE;
            end
        endcase
    end  

    //Read Hit or Miss: Combinational Circuit
    always_comb begin
        unique if (DA_read) begin
            case(core_addr[3:2])
                2'b00: core_out_tmp = DA_out[31:0]; 
                2'b01: core_out_tmp = DA_out[63:32];
                2'b10: core_out_tmp = DA_out[95:64]; 
                2'b11: core_out_tmp = DA_out[127:96];
            endcase
        end else begin
            core_out_tmp = data_reg;
        end
    end

    //output: Combinational Circuit
    always_comb begin
        case (current_state)
            IDLE: 
            begin
                core_out = data_reg;
                core_wait = (core_req) ? 1'b1 : 1'b0;
                I_req = (core_req && core_write) ? 1'b1 : 1'b0;
                I_addr = (core_req && core_write) ? core_addr : 32'd0;
                I_write = 1'b0;
                I_in = (core_req && core_write) ? core_in : 32'd0;
                I_type = core_type; 
                TA_read = 1'b0;
                TA_write = 1'b1;
                TA_in = 22'd0;
                DA_read = 1'b0;
                DA_write = 16'hffff;
                DA_in = 128'd0;
            end
            Read:
            begin
                TA_read = 1'b1;
                unique if(valid[index] && (TA_out == core_addr[31:10]) ) begin //Hit
                    core_wait = 1'b0;
                    core_out = core_out_tmp;
                    I_req = 1'b0;
                    I_addr = 32'd0;
                    I_write = 1'd0;
                    I_in = 32'd0;
                    I_type = core_type; 
                    TA_write = 1'b1;
                    TA_in = 22'd0;
                    DA_read = 1'b1;
                    DA_write = 16'hffff;
                    DA_in = 128'd0;
                end else begin   //Miss
                    core_wait = 1'b1;
                    core_out = 32'd0;
                    I_req = 1'b0;
                    I_addr = core_addr;
                    I_write = 1'b0;
                    I_in = 32'd0;
                    I_type = 3'b010;
                    TA_write = 1'b1;
                    TA_in = 22'd0;
                    DA_read = 1'b0;
                    DA_write = 16'hffff;
                    DA_in = 128'd0;
                end
            end
            Read_miss: 
            begin
                core_wait = 1'b1;
                core_out = data_reg;
                I_req = 1'b1;
                I_addr = {core_addr[31:4], miss_count_for_4_data, 2'd0};
                I_write = 1'b0;
                I_in = 32'd0;
                I_type = 3'b010; 
                TA_read = 1'b0;
                TA_write = 1'b0;
                TA_in = core_addr[31:10];
                DA_read = 1'b0;
                case (miss_count_for_4_data)
                    2'd0: DA_write = 16'hfff0;
                    2'd1: DA_write = 16'hff0f;
                    2'd2: DA_write = 16'hf0ff;
                    2'd3: DA_write = 16'h0fff;
                endcase
                DA_in = {(4){I_out}};
            end
            Read_Data: 
            begin
                core_wait = 1'b0;
                core_out = core_out_tmp;
                I_req = 1'b0;
                I_addr = 32'd0;
                I_write = 1'b0;
                I_in = 32'd0;
                I_type = core_type;  
                TA_read = 1'b0;
                TA_write = 1'b1;
                TA_in = 22'd0;
                DA_read = 1'b1;
                DA_write = 16'hffff;   
                DA_in = 128'd0;
            end
        endcase
    end 
endmodule