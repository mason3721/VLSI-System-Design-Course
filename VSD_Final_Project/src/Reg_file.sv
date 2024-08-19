module Reg_file(
    clk,
    rst,
    read_reg1,
    outdata1,
    read_reg2,
    outdata2,
    write_reg,
    write_data,
    waiting,
	Regwrite
);

input clk,rst,waiting;
input [2:0] Regwrite;
input [4:0] read_reg1,read_reg2,write_reg;
input [31:0] write_data;
output logic [31:0] outdata1,outdata2;

logic [31:0] register [31:0];
logic counter;
logic [31:0] write_temp;

always_ff @(posedge clk) begin
	if(rst) counter<=1'd0;
	else begin
		if(counter==1'd1) counter<=1'd1;
		else counter<=counter+1'd1;
	end
end

always_comb begin
	if(counter==1'd1) begin
		outdata1=((read_reg1==write_reg)&&(write_reg!=5'd0))?write_temp:register[read_reg1]; //read1
		outdata2=((read_reg2==write_reg)&&(write_reg!=5'd0))?write_temp:register[read_reg2];  //read2
	end
	else begin
		outdata1=32'd0;
		outdata2=32'd0;
	end
end

always_comb begin
	unique case(Regwrite)
        3'b111: begin //R_type、JALR、LW、AUIPC、LUI、J_type、CSR
            write_temp=(write_reg==5'd0)?32'd0:write_data;
        end
        3'b001: begin //LB、LBU
            write_temp=(write_reg==5'd0)?32'd0:write_data;	
        end
        3'b011: begin //LH、LHU
            write_temp=(write_reg==5'd0)?32'd0:write_data;
        end
        3'b000: begin //S_type
            if(write_reg==5'd0) write_temp=32'd0;
			else write_temp=register[write_reg];
        end
		default: write_temp=32'd0;
    endcase
end

always_ff @( posedge clk ) begin //write
    if(rst) begin
        register[0]<=32'b0;
        register[1]<=32'b0;
        register[2]<=32'b0;
        register[3]<=32'b0;
        register[4]<=32'b0;
        register[5]<=32'b0;
        register[6]<=32'b0;
        register[7]<=32'b0;
        register[8]<=32'b0;
        register[9]<=32'b0;
        register[10]<=32'b0;
        register[11]<=32'b0;
        register[12]<=32'b0;
        register[13]<=32'b0;
        register[14]<=32'b0;
        register[15]<=32'b0;
        register[16]<=32'b0;
        register[17]<=32'b0;
        register[18]<=32'b0;
        register[19]<=32'b0;
        register[20]<=32'b0;
        register[21]<=32'b0;
        register[22]<=32'b0;
        register[23]<=32'b0;
        register[24]<=32'b0;
        register[25]<=32'b0;
        register[26]<=32'b0;
        register[27]<=32'b0;
        register[28]<=32'b0;
        register[29]<=32'b0;
        register[30]<=32'b0;
        register[31]<=32'b0;
    end
    else begin
	//if(waiting==1'd1) register[write_reg]<=register[write_reg];
		register[write_reg]<=(write_reg!=5'd0)?write_temp:32'd0;
        /*unique case(Regwrite)
        3'b111: begin //R_type、JALR、LW、AUIPC、LUI、J_type、CSR
            register[write_reg]<=(write_reg==5'd0)?32'd0:write_data;
        end
        3'b001: begin //LB、LBU
            if(write_reg==5'd0) register[write_reg]<=32'd0;
	    else register[write_reg]<=(Regsign)?{{24{write_data[7]}},write_data[7:0]}:{24'd0,write_data[7:0]};
        end
        3'b011: begin //LH、LHU
            if(write_reg==5'd0) register[write_reg]<=32'd0;
	    else register[write_reg]<=(Regsign)?{{16{write_data[15]}},write_data[15:0]}:{16'd0,write_data[15:0]};
        end
        3'b000: begin //S_type
            if(write_reg==5'd0) register[write_reg]<=32'd0;
	    else register[write_reg]<=register[write_reg];
        end
		default: register[write_reg]<=32'd0;
    endcase*/
    end
end

endmodule
