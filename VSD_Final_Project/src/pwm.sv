module pwm(
	input [31:0] num,  ///wrapper 來的pwm count num
	input clk,
	input rst,
	output logic pwm_o_0,  //pwm output to motor(relay)
	output logic pwm_o_1,
	output logic pwm_o_2,
	output logic pwm_o_3
);

logic unsigned [7:0] counter; //pwm count 
logic unsigned [31:0] num_local; //if count = 0 ,num local = num

always_ff@(posedge clk) begin
	if(~rst) begin
		counter  <= 8'd0;
		num_local<= 32'd0;
		pwm_o_0  <= 1'd1;
		pwm_o_1  <= 1'd1;
		pwm_o_2  <= 1'd1;
		pwm_o_3  <= 1'd1;
	end
	else begin
		counter   <= counter+8'd1;
		num_local <= (counter == 8'd0)? num : num_local;
		pwm_o_0   <= (counter < num_local[7:0])?1'd1:1'd0;
		pwm_o_1   <= (counter < num_local[15:8])?1'd1:1'd0;
		pwm_o_2   <= (counter < num_local[23:16])?1'd1:1'd0;
		pwm_o_3   <= (counter < num_local[31:24])?1'd1:1'd0;
	end
end

endmodule