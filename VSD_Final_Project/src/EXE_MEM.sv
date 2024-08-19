module EXE_MEM(
    clk,
    rst,
    WE_in,
    WE_out,
    M_in_read,
    M_out_read,
    ALU_in,
    ALU_out,
    /*sr2_data_in,
    sr2_data_out,*/
    forward_rd_in,
    forward_rd_out,
	waiting
);

input clk,rst,waiting;
input [4:0] WE_in;
input M_in_read;
input [31:0] ALU_in; //,sr2_data_in
input [4:0] forward_rd_in;
output logic [4:0] WE_out,forward_rd_out;
output logic M_out_read;
output logic [31:0] ALU_out;
//logic [31:0] sr2_data_out_temp;


always_ff @( posedge clk  ) begin 
    if(rst) begin
        WE_out<=5'd0;
        M_out_read<=1'd0;
        forward_rd_out<=5'd0;
        ALU_out<=32'd0;
        //sr2_data_out_temp<=32'd0;
    end
	else if(waiting==1'd1) begin
		WE_out<=WE_out;
        M_out_read<=M_out_read;
        forward_rd_out<=forward_rd_out;
        ALU_out<=ALU_out;
	end
    else begin
        WE_out<=WE_in;
        M_out_read<=M_in_read;
        forward_rd_out<=forward_rd_in;
        ALU_out<=ALU_in;
        //sr2_data_out_temp<=sr2_data_in;
    end
end

/*always_comb begin
	unique case(ALU_out[1:0])
		2'b00: begin
			M_out=M_out_temp;
			sr2_data_out=sr2_data_out_temp;
		end
		2'b01: begin
			M_out[4:0]={M_out_temp[4],M_out_temp[2],M_out_temp[1],M_out_temp[0],M_out_temp[3]};
			sr2_data_out={sr2_data_out_temp[23:0],8'd0};
		end
		2'b10: begin
			M_out[4:0]={M_out_temp[4],M_out_temp[1],M_out_temp[0],M_out_temp[3],M_out_temp[2]};
			sr2_data_out={sr2_data_out_temp[15:0],16'd0};
		end
		2'b11: begin
			M_out[4:0]={M_out_temp[4],M_out_temp[0],M_out_temp[3],M_out_temp[2],M_out_temp[1]};
			sr2_data_out={sr2_data_out_temp[7:0],24'd0};
		end
	endcase
end*/
endmodule
