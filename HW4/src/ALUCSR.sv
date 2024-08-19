module ALUCSR (
    input        [31:0] src1_CSR,
    input        [31:0] src2_CSR,
    input        [1:0]  ALUop_CSR,
    input        [11:0] address_CSR,

    output logic [31:0] ALU_result_CSR
);
	localparam Op_Rw = 2'b00;
	localparam Op_Rs = 2'b01;
	localparam Op_Rc = 2'b10;

    localparam mstatus_addr   = 12'h300;
    localparam mie_addr       = 12'h304;
    localparam mtvec_addr     = 12'h305;
    localparam mepc_addr      = 12'h341;
    localparam mip_addr       = 12'h344;
    localparam mcycle_addr    = 12'hC00;
    localparam minstret_addr  = 12'hC02;
    localparam mcycleh_addr   = 12'hC80;
    localparam minstreth_addr = 12'hC82;

	logic [31:0] CSR_temp;

	always_comb begin
		unique case (ALUop_CSR)
			Op_Rw: CSR_temp = src2_CSR;               //RW_CSR
			Op_Rs: CSR_temp = src1_CSR | src2_CSR;    //RS_CSR
			Op_Rc: CSR_temp = src1_CSR & (~src2_CSR); //RC_CSR
			default:CSR_temp = 32'd0;
		endcase
	end
	always_comb begin
		unique case(address_CSR)
			mstatus_addr: ALU_result_CSR = {19'd0, CSR_temp[12:11], 3'd0, CSR_temp[7], 3'd0, CSR_temp[3], 3'd0};
			mtvec_addr: ALU_result_CSR = 32'h0001_0000; 
			mip_addr: ALU_result_CSR = src1_CSR;  //***
			mie_addr: ALU_result_CSR = {20'd0, CSR_temp[11], 3'd0, CSR_temp[7], 7'd0};
			mepc_addr: ALU_result_CSR = CSR_temp;
			mcycle_addr: ALU_result_CSR = CSR_temp;
			minstret_addr: ALU_result_CSR = CSR_temp;
			mcycleh_addr: ALU_result_CSR = CSR_temp;
			minstreth_addr: ALU_result_CSR = CSR_temp;
			default : ALU_result_CSR = CSR_temp;
		endcase
	end   
endmodule
