//================================================
// Auther:      Chen Yun-Ru (May)
// Filename:    L1C_data.sv
// Description: L1 Cache for data
// Version:     0.1
//================================================
`include "def.svh"
`include "data_array_wrapper.sv"
`include "tag_array_wrapper.sv"

module L1C_data (
    input                               clk,
    input                               rst,
    // Core to CPU wrapper
    input        [`DATA_BITS-1:0]       core_addr,
    input                               core_req,
    input                               core_write,
    input        [`DATA_BITS-1:0]       core_in,
    input        [`CACHE_TYPE_BITS-1:0] core_type,
    // Mem to CPU wrapper
    input        [`DATA_BITS-1:0]       D_out,
    input                               D_wait,
    // CPU wrapper to core
    output logic [`DATA_BITS-1:0]       core_out,
    output logic                        core_wait,
    // CPU wrapper to Mem
    output logic                        D_req,
    output logic [`DATA_BITS-1:0]       D_addr,
    output logic                        D_write,
    output logic [`DATA_BITS-1:0]       D_in,
    output logic [`CACHE_TYPE_BITS-1:0] D_type
);
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

    logic [31:0]                  count_Hit;
    logic [31:0]                  count_Miss;

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
    enum logic [2:0] {IDLE, Read, Read_miss, Read_Data, Write, Write_hit, Sensor_Control} current_state, next_state;

    logic [31:0] data_reg;
    logic [31:0] core_out_tmp;
    logic [1:0]  miss_count_for_4_data;
    logic [15:0] DA_type;
    assign index = core_addr[9:4];

    logic cacheable;   //for sensor_ctrl
    assign cacheable = (core_addr[31:16] != 16'h1000);

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
        priority if(rst) begin
            data_reg <= 32'd0;
            valid <= 64'd0;
            miss_count_for_4_data <= 2'd0;
            count_Hit <= 32'd0;
            count_Miss <= 32'd0;
        end else begin
            data_reg <= (DA_read) ? core_out_tmp : data_reg;
            valid <= valid;
            unique if (current_state == Read_miss) begin
                valid[index] <= (cacheable) ? 1'b1 : 1'b0;
                unique if(~D_wait)begin
                    miss_count_for_4_data <= miss_count_for_4_data + 2'd1;
                end else begin
                    miss_count_for_4_data <= miss_count_for_4_data;
                end
            end else begin
                miss_count_for_4_data <= 2'd0;
            end
            unique if (((current_state == Read) | (current_state == Write)) & ~D_wait) begin //hit rate and miss rate
                unique if (valid[index] && (TA_out == core_addr[31:10])) begin
                    count_Hit <= count_Hit + 32'd1;
                end else begin
                    count_Miss <= count_Miss + 32'd1;
                end
            end else begin
                count_Hit <= count_Hit;
                count_Miss <= count_Miss;
            end
        end
    end
    //next_state: Combinational Circuit
    always_comb begin
        unique case (current_state)
            IDLE: 
            begin
                unique if (core_req) begin
                    unique if (core_write) begin
                        next_state = Write;
                    end else begin
                        next_state = (cacheable) ? Read : Sensor_Control;
                    end
                end else begin
                    next_state = IDLE;
                end
            end
            Read: 
            begin
                unique if (valid[index] && (TA_out == core_addr[31:10])) begin //Hit
                    next_state = IDLE;
                end else begin //Miss
                    next_state = Read_miss;
                end
            end
            Read_miss: 
            begin  
                unique if((~D_wait) && miss_count_for_4_data == 2'd3) begin
                    next_state = Read_Data;
                end else begin
                    next_state = Read_miss;
                end
            end
            Read_Data: 
            begin
                next_state = IDLE;
            end
            Write: 
            begin
                unique if(~D_wait) begin
                    unique if (valid[index] && (TA_out == core_addr[31:10])) begin //Hit
                        next_state = Write_hit;
                    end else begin //Miss
                        next_state = IDLE;
                    end
                end else begin 
                    next_state = Write;
                end
            end
            Write_hit: 
            begin
                next_state = IDLE; 
            end
            Sensor_Control: 
            begin
                next_state = (D_wait) ? Sensor_Control : IDLE;
            end
            default: 
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

    //DA_type for Write: Combinational Circuit
    always_comb begin
            unique if (core_type == `CACHE_BYTE) begin //byte
                case(core_addr[1:0])
                    2'b00: DA_type = 16'heeee;
                    2'b01: DA_type = 16'hdddd;
                    2'b10: DA_type = 16'hbbbb;
                    2'b11: DA_type = 16'h7777;
                endcase
            end else if (core_type == `CACHE_HWORD) begin //half word
                case(core_addr[1])
                    1'b0: DA_type = 16'hcccc;
                    1'b1: DA_type = 16'h3333;
                endcase
            end else if (core_type == `CACHE_WORD) //word
                DA_type = 16'h0000;
            else begin
                DA_type = 16'hffff;
            end
    end

    //output: Combinational Circuit
    always_comb begin
        unique case (current_state)
            IDLE: 
            begin
                TA_read = 1'b0;
                TA_write = 1'b1;
                TA_in = core_addr[31:10];
                DA_read = 1'b0;
                DA_write = 16'hffff;
                DA_in = 128'd0;
                core_out = data_reg;
                core_wait = core_req;
                D_req = 1'b0;
                D_addr = (core_req && core_write) ? core_addr : 32'd0;
                D_write = 1'b0;
                D_in = (core_req && core_write) ? core_in : 32'd0;
                D_type = core_type;    
            end
            Read: 
            begin
                TA_read = 1'b1;
                unique if(valid[index] && (TA_out == core_addr[31:10]) ) begin
                    TA_write = 1'b1;
                    TA_in = 22'd0;
                    DA_read = 1'b1;
                    DA_write = 16'hffff;
                    DA_in = 128'd0;
                    core_wait = 1'b0;
                    core_out = core_out_tmp;
                    D_req = 1'b0;
                    D_addr = 32'd0;
                    D_write = 1'd0;
                    D_in = 32'd0;
                    D_type = core_type;   
                end else begin 
                    TA_write = 1'b1;
                    TA_in = 22'd0;
                    DA_read = 1'b0;
                    DA_write = 16'hffff;
                    DA_in = 128'd0;

                    core_wait = 1'b1;
                    core_out = 32'd0;
                    D_req = 1'b0;
                    D_addr = core_addr;
                    D_write = 1'b0;
                    D_in = 32'd0;
                    D_type = 3'b010; 
                end
            end
            Read_miss: 
            begin
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
                DA_in = {(4){D_out}};
                core_wait = 1'b1;
                core_out = data_reg;
                D_req = 1'b1;
                D_addr = {core_addr[31:4], miss_count_for_4_data, 2'd0};
                D_write = 1'b0;
                D_in = 32'd0;
                D_type = `CACHE_WORD;  //word
            end
            Read_Data: 
            begin
                TA_read = 1'b0;
                TA_write = 1'b1;
                TA_in = 22'd0;
                DA_read = 1'b1;
                DA_write = 16'hffff;   
                DA_in = 128'd0;
                core_wait = 1'b0;
                core_out = core_out_tmp; 
                D_req = 1'b0;
                D_addr = 32'd0;
                D_write = 1'b0;
                D_in = 32'd0;
                D_type = core_type;  
            end
            Write: 
            begin
                core_wait = (valid[index] && (TA_out == core_addr[31:10]) || D_wait) ? 1'b1 : 1'b0;
                core_out = 32'd0;
                D_req = 1'b1;
                D_addr = core_addr;
                D_write = 1'b1;
                D_in = core_in;
                D_type = core_type;
                TA_read = 1'b1;
                TA_write = 1'b1;
                TA_in = 22'd0;
                DA_read = 1'b0;
                DA_write = 16'hffff;   
                DA_in = 128'd0;
            end
            Write_hit: 
            begin
                core_wait = 1'b0;
                core_out = 32'd0;
                D_req = 1'b0;
                D_addr = 32'd0;
                D_write = 1'b0;
                D_in = 32'd0;
                D_type = core_type;
                TA_read = 1'b0;
                TA_write = 1'b0;
                TA_in = core_addr[31:10];
                DA_read = 1'b0;
                DA_in = {4{core_in}};
                case (core_addr[3:2])
                    2'b00: DA_write = 16'hfff0 | DA_type;
                    2'b01: DA_write = 16'hff0f | DA_type;
                    2'b10: DA_write = 16'hf0ff | DA_type;
                    2'b11: DA_write = 16'h0fff | DA_type;
                endcase
            end
            Sensor_Control: 
            begin
                TA_read = 1'b0;
                TA_write = 1'b1;
                TA_in = 22'd0;  
                DA_read = 1'b0;
                DA_write = 16'hffff;
                DA_in = 128'd0;
                core_out = D_out;
                core_wait = D_wait;  
                D_req = 1'b1;
                D_addr = core_addr;
                D_write = 1'b0;
                D_in = 32'd0;
                D_type = 3'b010;  
            end
            default: begin
                core_wait = 1'b0;
                core_out = 32'd0;
                D_req = 1'b0;
                D_addr = 32'd0;
                D_write = 1'b0;
                D_in = 32'd0;
                D_type = 3'd0;
                TA_read = 1'b0;
                TA_write = 1'b1;
                TA_in = 22'd0;
                DA_read = 1'b0;
                DA_write = 16'hffff;   
                DA_in = 128'd0;
            end
        endcase
    end 
endmodule