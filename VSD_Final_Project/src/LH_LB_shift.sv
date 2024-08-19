module LH_LB_shift(
    Regsign,
    Regwrite,
    write_data,
	addr_10,
	write_data_out,
	write_reg
);

input Regsign;
input [1:0] addr_10;
input [2:0] Regwrite;
input [4:0] write_reg;
input [31:0] write_data;
output logic [31:0] write_data_out;


always_comb begin
	unique case(Regwrite)
        3'b111: begin //R_type、JALR、LW、AUIPC、LUI、J_type、CSR
            write_data_out=(write_reg==5'd0)?32'd0:write_data;
        end
        3'b001: begin 
            if(Regsign) begin //LB
				case(addr_10)
					2'b00: write_data_out=(write_reg==5'd0)?32'd0:{{24{write_data[7]}},write_data[7:0]};
					2'b01: write_data_out=(write_reg==5'd0)?32'd0:{{24{write_data[15]}},write_data[15:8]};
					2'b10: write_data_out=(write_reg==5'd0)?32'd0:{{24{write_data[23]}},write_data[23:16]};
					2'b11: write_data_out=(write_reg==5'd0)?32'd0:{{24{write_data[31]}},write_data[31:24]};
				endcase
			end
			else begin //LBU
				case(addr_10)
					2'b00: write_data_out=(write_reg==5'd0)?32'd0:{24'd0,write_data[7:0]};
					2'b01: write_data_out=(write_reg==5'd0)?32'd0:{24'd0,write_data[15:8]};
					2'b10: write_data_out=(write_reg==5'd0)?32'd0:{24'd0,write_data[23:16]};
					2'b11: write_data_out=(write_reg==5'd0)?32'd0:{24'd0,write_data[31:24]};
				endcase
			end
        end
        3'b011: begin //LH
            if(Regsign) begin
				case(addr_10)
					2'b00: write_data_out=(write_reg==5'd0)?32'd0:{{16{write_data[15]}},write_data[15:0]};
					2'b10: write_data_out=(write_reg==5'd0)?32'd0:{{16{write_data[31]}},write_data[31:16]};
					default :write_data_out=32'd0;
				endcase
			end
			else begin //LHU
				case(addr_10)
					2'b00: write_data_out=(write_reg==5'd0)?32'd0:{16'd0,write_data[15:0]};
					2'b10: write_data_out=(write_reg==5'd0)?32'd0:{16'd0,write_data[31:16]};
					default :write_data_out=32'd0;
				endcase
			end
        end
        3'b000: begin //S_type
             write_data_out=32'd0;
        end
		default: write_data_out=32'd0;
    endcase
end
endmodule
