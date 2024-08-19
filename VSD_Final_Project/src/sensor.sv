module sensor( 
	input clk,
	input rst,
	input [7:0] sensor_in_0,
	input [7:0] sensor_in_1,
	input [7:0] sensor_in_2,
	input [7:0] sensor_in_3,
	input sensor_en,
	output logic [7:0] sensor_out_0,
	output logic [7:0] sensor_out_1,
	output logic [7:0] sensor_out_2,
	output logic [7:0] sensor_out_3
);
	// logic [8:0] sensor_counter;
	// logic [31:0] sensor_mem [0:511];
	// logic [9:0] data_counter;
	
	logic [7:0] sensor_in_0_t;
	logic [7:0] sensor_in_1_t;
	logic [7:0] sensor_in_2_t;
	logic [7:0] sensor_in_3_t;
	logic sensor_en_t;
	
	// maybe need to hold for a period
	always_ff@(posedge clk) begin
		if (rst) begin
			sensor_out_0 <= 8'b0;
			sensor_out_1 <= 8'b0;
			sensor_out_2 <= 8'b0;
			sensor_out_3 <= 8'b0;
			sensor_in_0_t <= 8'b0;
			sensor_in_1_t <= 8'b0;
			sensor_in_2_t <= 8'b0;
			sensor_in_3_t <= 8'b0;
			sensor_en_t  <= 1'b0;
			sensor_ready <= 1'b0;
		end
		else begin
			if (sensor_en) begin
				sensor_in_0_t <= sensor_in_0;
				sensor_in_1_t <= sensor_in_1;
				sensor_in_2_t <= sensor_in_2;
				sensor_in_3_t <= sensor_in_3;
				sensor_out_0 <= 8'b0;
				sensor_out_1 <= 8'b0;
				sensor_out_2 <= 8'b0;
				sensor_out_3 <= 8'b0;
				sensor_en_t <= sensor_en;
				sensor_ready <= 1'b0;
			end
			else if (sensor_en_t) begin
				sensor_out_0 <= sensor_in_0_t;
				sensor_out_1 <= sensor_in_1_t;
				sensor_out_2 <= sensor_in_2_t;
				sensor_out_3 <= sensor_in_3_t;
				sensor_in_0_t <= sensor_in_0_t;
				sensor_in_1_t <= sensor_in_1_t;
				sensor_in_2_t <= sensor_in_2_t;
				sensor_in_3_t <= sensor_in_3_t;
				sensor_en_t  <= sensor_en;
				sensor_ready <= 1'b1;
			end
			else begin
				sensor_out_0 <= 8'b0;
				sensor_out_1 <= 8'b0;
				sensor_out_2 <= 8'b0;
				sensor_out_3 <= 8'b0;
				sensor_in_0_t <= 8'b0;
				sensor_in_1_t <= 8'b0;
				sensor_in_2_t <= 8'b0;
				sensor_in_3_t <= 8'b0;
				sensor_en_t  <= 1'b0;
				sensor_ready <= 1'b0;
			end
		end
	end
	// 
endmodule