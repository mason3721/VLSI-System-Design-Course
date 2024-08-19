`include "../../include/AXI_define.svh"
`include "../FIFO_AR.sv"
`include "../FIFO_AW.sv"
`include "../FIFO_B.sv"
`include "../FIFO_R.sv"
`include "../FIFO_W.sv"
module AXI(

	input CPU_CLK_i,      
	input ACLK,        
	input ROM_CLK_i,      
	input DRAM_CLK_i,
	input SRAM_CLK_i,
	input PWM_CLK_i,
	input CPU_RST_i,      
	input ARESETn,        
	input ROM_RST_i,      
	input DRAM_RST_i,
	input SRAM_RST_i,   
	input PWM_RST_i, 
	//SLAVE INTERFACE FOR MASTERS
	
	//WRITE ADDRESS
	input [`AXI_ID_BITS-1:0] AWID_M1_F,
	input [`AXI_ADDR_BITS-1:0] AWADDR_M1_F,
	input [`AXI_LEN_BITS-1:0] AWLEN_M1_F,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_M1_F,
	input [1:0] AWBURST_M1_F,
	input AWVALID_M1_F,
	output logic AWREADY_M1_F,
	
	//WRITE DATA
	input [`AXI_DATA_BITS-1:0] WDATA_M1_F,
	input [`AXI_STRB_BITS-1:0] WSTRB_M1_F,
	input WLAST_M1_F,
	input WVALID_M1_F,
	output logic WREADY_M1_F,
	
	//WRITE RESPONSE
	output logic [`AXI_ID_BITS-1:0] BID_M1_F,
	output logic [1:0] BRESP_M1_F,
	output logic BVALID_M1_F,
	input BREADY_M1_F,

	//READ ADDRESS0
	input [`AXI_ID_BITS-1:0] ARID_M0_F,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M0_F,
	input [`AXI_LEN_BITS-1:0] ARLEN_M0_F,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M0_F,
	input [1:0] ARBURST_M0_F,
	input ARVALID_M0_F,
	output logic ARREADY_M0_F,
	
	//READ DATA0
	output logic [`AXI_ID_BITS-1:0] RID_M0_F,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M0_F,
	output logic [1:0] RRESP_M0_F,
	output logic RLAST_M0_F,
	output logic RVALID_M0_F,
	input RREADY_M0_F,
	
	//READ ADDRESS1
	input [`AXI_ID_BITS-1:0] ARID_M1_F,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M1_F,
	input [`AXI_LEN_BITS-1:0] ARLEN_M1_F,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M1_F,
	input [1:0] ARBURST_M1_F,
	input ARVALID_M1_F,
	output logic ARREADY_M1_F,
	
	//READ DATA1
	output logic [`AXI_ID_BITS-1:0] RID_M1_F,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M1_F,
	output logic [1:0] RRESP_M1_F,
	output logic RLAST_M1_F,
	output logic RVALID_M1_F,
	input RREADY_M1_F,




	//MASTER INTERFACE FOR SLAVES

	//READ ADDRESS0   ROM
	output logic [`AXI_IDS_BITS-1:0] ARID_S0_F,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S0_F,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S0_F,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0_F,
	output logic [1:0] ARBURST_S0_F,
	output logic ARVALID_S0_F,
	input ARREADY_S0_F,
	
	//READ DATA0
	input [`AXI_IDS_BITS-1:0] RID_S0_F,
	input [`AXI_DATA_BITS-1:0] RDATA_S0_F,
	input [1:0] RRESP_S0_F,
	input RLAST_S0_F,
	input RVALID_S0_F,
	output logic RREADY_S0_F,
	
	//WRITE ADDRESS1	IM
	output logic [`AXI_IDS_BITS-1:0] AWID_S1_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S1_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S1_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1_F,
	output logic [1:0] AWBURST_S1_F,
	output logic AWVALID_S1_F,
	input AWREADY_S1_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S1_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S1_F,
	output logic WLAST_S1_F,
	output logic WVALID_S1_F,
	input WREADY_S1_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S1_F,
	input [1:0] BRESP_S1_F,
	input BVALID_S1_F,
	output logic BREADY_S1_F,
	
	//READ ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] ARID_S1_F,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S1_F,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S1_F,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1_F,
	output logic [1:0] ARBURST_S1_F,
	output logic ARVALID_S1_F,
	input ARREADY_S1_F,
	
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S1_F,
	input [`AXI_DATA_BITS-1:0] RDATA_S1_F,
	input [1:0] RRESP_S1_F,
	input RLAST_S1_F,
	input RVALID_S1_F,
	output logic RREADY_S1_F,
	
	//WRITE ADDRESS1	DM
	output logic [`AXI_IDS_BITS-1:0] AWID_S2_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S2_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S2_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S2_F,
	output logic [1:0] AWBURST_S2_F,
	output logic AWVALID_S2_F,
	input AWREADY_S2_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S2_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S2_F,
	output logic WLAST_S2_F,
	output logic WVALID_S2_F,
	input WREADY_S2_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S2_F,
	input [1:0] BRESP_S2_F,
	input BVALID_S2_F,
	output logic BREADY_S2_F,
	
	//READ ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] ARID_S2_F,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S2_F,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S2_F,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S2_F,
	output logic [1:0] ARBURST_S2_F,
	output logic ARVALID_S2_F,
	input ARREADY_S2_F,
	
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S2_F,
	input [`AXI_DATA_BITS-1:0] RDATA_S2_F,
	input [1:0] RRESP_S2_F,
	input RLAST_S2_F,
	input RVALID_S2_F,
	output logic RREADY_S2_F,
	
	//WRITE ADDRESS1	sensor_ctrl
	output logic [`AXI_IDS_BITS-1:0] AWID_S3_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S3_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S3_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S3_F,
	output logic [1:0] AWBURST_S3_F,
	output logic AWVALID_S3_F,
	input AWREADY_S3_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S3_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S3_F,
	output logic WLAST_S3_F,
	output logic WVALID_S3_F,
	input WREADY_S3_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S3_F,
	input [1:0] BRESP_S3_F,
	input BVALID_S3_F,
	output logic BREADY_S3_F,
	
	//READ ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] ARID_S3_F,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S3_F,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S3_F,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S3_F,
	output logic [1:0] ARBURST_S3_F,
	output logic ARVALID_S3_F,
	input ARREADY_S3_F,
	
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S3_F,
	input [`AXI_DATA_BITS-1:0] RDATA_S3_F,
	input [1:0] RRESP_S3_F,
	input RLAST_S3_F,
	input RVALID_S3_F,
	output logic RREADY_S3_F,
	
	//WRITE ADDRESS1	WDT
	output logic [`AXI_IDS_BITS-1:0] AWID_S4_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S4_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S4_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S4_F,
	output logic [1:0] AWBURST_S4_F,
	output logic AWVALID_S4_F,
	input AWREADY_S4_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S4_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S4_F,
	output logic WLAST_S4_F,
	output logic WVALID_S4_F,
	input WREADY_S4_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S4_F,
	input [1:0] BRESP_S4_F,
	input BVALID_S4_F,
	output logic BREADY_S4_F,
	
	
	//WRITE ADDRESS1	DRAM
	output logic [`AXI_IDS_BITS-1:0] AWID_S5_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S5_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S5_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S5_F,
	output logic [1:0] AWBURST_S5_F,
	output logic AWVALID_S5_F,
	input AWREADY_S5_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S5_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S5_F,
	output logic WLAST_S5_F,
	output logic WVALID_S5_F,
	input WREADY_S5_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S5_F,
	input [1:0] BRESP_S5_F,
	input BVALID_S5_F,
	output logic BREADY_S5_F,
	
	//READ ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] ARID_S5_F,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S5_F,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S5_F,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S5_F,
	output logic [1:0] ARBURST_S5_F,
	output logic ARVALID_S5_F,
	input ARREADY_S5_F,
	
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S5_F,
	input [`AXI_DATA_BITS-1:0] RDATA_S5_F,
	input [1:0] RRESP_S5_F,
	input RLAST_S5_F,
	input RVALID_S5_F,
	output logic RREADY_S5_F,
	
	//WRITE ADDRESS1	PWM
	output logic [`AXI_IDS_BITS-1:0] AWID_S6_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S6_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S6_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S6_F,
	output logic [1:0] AWBURST_S6_F,
	output logic AWVALID_S6_F,
	input AWREADY_S6_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S6_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S6_F,
	output logic WLAST_S6_F,
	output logic WVALID_S6_F,
	input WREADY_S6_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S6_F,
	input [1:0] BRESP_S6_F,
	input BVALID_S6_F,
	output logic BREADY_S6_F
);
    //---------- you should put your design here ----------//

//state machine
parameter read_IDLE=4'd0;
parameter M0_read_S0=4'd1; //ROM
parameter M0_read_S1=4'd2; //IM
parameter M0_read_S2=4'd3; //DM
parameter M0_read_S3=4'd4; //sensor_ctrl
parameter M0_read_S5=4'd6; //DRAM

parameter M1_read_S0=4'd7; //ROM
parameter M1_read_S1=4'd8; //IM
parameter M1_read_S2=4'd9; //DM
parameter M1_read_S3=4'd10; //sensor_ctrl
parameter M1_read_S5=4'd12; //DRAM


parameter write_IDLE=3'd0;
parameter M1_write_S1=3'd1; //IM
parameter M1_write_S2=3'd2; //DM
parameter M1_write_S3=3'd3; //sensor_ctrl
parameter M1_write_S4=3'd4; //WDT
parameter M1_write_S5=3'd5; //DRAM
parameter M1_write_S6=3'd6; //PWM

logic [3:0] read_curr_state,read_next_state;
logic [2:0] write_curr_state,write_next_state;

//SLAVE INTERFACE FOR MASTERS
	
	//WRITE ADDRESS
logic [`AXI_ID_BITS-1:0] AWID_M1;
logic [`AXI_ADDR_BITS-1:0] AWADDR_M1;
logic [`AXI_LEN_BITS-1:0] AWLEN_M1;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_M1;
logic [1:0] AWBURST_M1;
logic AWVALID_M1;
logic AWREADY_M1;
	
//WRITE DATA
logic [`AXI_DATA_BITS-1:0] WDATA_M1;
logic [`AXI_STRB_BITS-1:0] WSTRB_M1;
logic WLAST_M1;
logic WVALID_M1;
logic WREADY_M1;

//WRITE RESPONSE
logic [`AXI_ID_BITS-1:0] BID_M1;
logic [1:0] BRESP_M1;
logic BVALID_M1;
logic BREADY_M1;

//READ ADDRESS0
logic [`AXI_ID_BITS-1:0] ARID_M0;
logic [`AXI_ADDR_BITS-1:0] ARADDR_M0;
logic [`AXI_LEN_BITS-1:0] ARLEN_M0;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_M0;
logic [1:0] ARBURST_M0;
logic ARVALID_M0;
logic ARREADY_M0;

//READ DATA0
logic [`AXI_ID_BITS-1:0] RID_M0;
logic [`AXI_DATA_BITS-1:0] RDATA_M0;
logic [1:0] RRESP_M0;
logic RLAST_M0;
logic RVALID_M0;
logic RREADY_M0;

//READ ADDRESS1
logic [`AXI_ID_BITS-1:0] ARID_M1;
logic [`AXI_ADDR_BITS-1:0] ARADDR_M1;
logic [`AXI_LEN_BITS-1:0] ARLEN_M1;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_M1;
logic [1:0] ARBURST_M1;
logic ARVALID_M1;
logic ARREADY_M1;

//READ DATA1
logic [`AXI_ID_BITS-1:0] RID_M1;
logic [`AXI_DATA_BITS-1:0] RDATA_M1;
logic [1:0] RRESP_M1;
logic RLAST_M1;
logic RVALID_M1;
logic RREADY_M1;




//MASTER INTERFACE FOR SLAVES

//READ ADDRESS0   ROM
logic [`AXI_IDS_BITS-1:0] ARID_S0;
logic [`AXI_ADDR_BITS-1:0] ARADDR_S0;
logic [`AXI_LEN_BITS-1:0] ARLEN_S0;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0;
logic [1:0] ARBURST_S0;
logic ARVALID_S0;
logic ARREADY_S0;

//READ DATA0
logic [`AXI_IDS_BITS-1:0] RID_S0;
logic [`AXI_DATA_BITS-1:0] RDATA_S0;
logic [1:0] RRESP_S0;
logic RLAST_S0;
logic RVALID_S0;
logic RREADY_S0;

//WRITE ADDRESS1	IM
logic [`AXI_IDS_BITS-1:0] AWID_S1;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S1;
logic [`AXI_LEN_BITS-1:0] AWLEN_S1;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1;
logic [1:0] AWBURST_S1;
logic AWVALID_S1;
logic AWREADY_S1;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S1;
logic [`AXI_STRB_BITS-1:0] WSTRB_S1;
logic WLAST_S1;
logic WVALID_S1;
logic WREADY_S1;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S1;
logic [1:0] BRESP_S1;
logic BVALID_S1;
logic BREADY_S1;

//READ ADDRESS1
logic [`AXI_IDS_BITS-1:0] ARID_S1;
logic [`AXI_ADDR_BITS-1:0] ARADDR_S1;
logic [`AXI_LEN_BITS-1:0] ARLEN_S1;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1;
logic [1:0] ARBURST_S1;
logic ARVALID_S1;
logic ARREADY_S1;

//READ DATA1
logic [`AXI_IDS_BITS-1:0] RID_S1;
logic [`AXI_DATA_BITS-1:0] RDATA_S1;
logic [1:0] RRESP_S1;
logic RLAST_S1;
logic RVALID_S1;
logic RREADY_S1;

//WRITE ADDRESS1	DM
logic [`AXI_IDS_BITS-1:0] AWID_S2;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S2;
logic [`AXI_LEN_BITS-1:0] AWLEN_S2;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S2;
logic [1:0] AWBURST_S2;
logic AWVALID_S2;
logic AWREADY_S2;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S2;
logic [`AXI_STRB_BITS-1:0] WSTRB_S2;
logic WLAST_S2;
logic WVALID_S2;
logic WREADY_S2;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S2;
logic [1:0] BRESP_S2;
logic BVALID_S2;
logic BREADY_S2;

//READ ADDRESS1
logic [`AXI_IDS_BITS-1:0] ARID_S2;
logic [`AXI_ADDR_BITS-1:0] ARADDR_S2;
logic [`AXI_LEN_BITS-1:0] ARLEN_S2;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_S2;
logic [1:0] ARBURST_S2;
logic ARVALID_S2;
logic ARREADY_S2;

//READ DATA1
logic [`AXI_IDS_BITS-1:0] RID_S2;
logic [`AXI_DATA_BITS-1:0] RDATA_S2;
logic [1:0] RRESP_S2;
logic RLAST_S2;
logic RVALID_S2;
logic RREADY_S2;

//WRITE ADDRESS1	sensor_ctrl
logic [`AXI_IDS_BITS-1:0] AWID_S3;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S3;
logic [`AXI_LEN_BITS-1:0] AWLEN_S3;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S3;
logic [1:0] AWBURST_S3;
logic AWVALID_S3;
logic AWREADY_S3;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S3;
logic [`AXI_STRB_BITS-1:0] WSTRB_S3;
logic WLAST_S3;
logic WVALID_S3;
logic WREADY_S3;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S3;
logic [1:0] BRESP_S3;
logic BVALID_S3;
logic BREADY_S3;

//READ ADDRESS1
logic [`AXI_IDS_BITS-1:0] ARID_S3;
logic [`AXI_ADDR_BITS-1:0] ARADDR_S3;
logic [`AXI_LEN_BITS-1:0] ARLEN_S3;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_S3;
logic [1:0] ARBURST_S3;
logic ARVALID_S3;
logic ARREADY_S3;

//READ DATA1
logic [`AXI_IDS_BITS-1:0] RID_S3;
logic [`AXI_DATA_BITS-1:0] RDATA_S3;
logic [1:0] RRESP_S3;
logic RLAST_S3;
logic RVALID_S3;
logic RREADY_S3;

//WRITE ADDRESS1	WDT
logic [`AXI_IDS_BITS-1:0] AWID_S4;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S4;
logic [`AXI_LEN_BITS-1:0] AWLEN_S4;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S4;
logic [1:0] AWBURST_S4;
logic AWVALID_S4;
logic AWREADY_S4;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S4;
logic [`AXI_STRB_BITS-1:0] WSTRB_S4;
logic WLAST_S4;
logic WVALID_S4;
logic WREADY_S4;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S4;
logic [1:0] BRESP_S4;
logic BVALID_S4;
logic BREADY_S4;


//WRITE ADDRESS1	DRAM
logic [`AXI_IDS_BITS-1:0] AWID_S5;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S5;
logic [`AXI_LEN_BITS-1:0] AWLEN_S5;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S5;
logic [1:0] AWBURST_S5;
logic AWVALID_S5;
logic AWREADY_S5;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S5;
logic [`AXI_STRB_BITS-1:0] WSTRB_S5;
logic WLAST_S5;
logic WVALID_S5;
logic WREADY_S5;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S5;
logic [1:0] BRESP_S5;
logic BVALID_S5;
logic BREADY_S5;

//READ ADDRESS1
logic [`AXI_IDS_BITS-1:0] ARID_S5;
logic [`AXI_ADDR_BITS-1:0] ARADDR_S5;
logic [`AXI_LEN_BITS-1:0] ARLEN_S5;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_S5;
logic [1:0] ARBURST_S5;
logic ARVALID_S5;
logic ARREADY_S5;

//READ DATA1
logic [`AXI_IDS_BITS-1:0] RID_S5;
logic [`AXI_DATA_BITS-1:0] RDATA_S5;
logic [1:0] RRESP_S5;
logic RLAST_S5;
logic RVALID_S5;
logic RREADY_S5;

//WRITE ADDRESS1	PWM
logic [`AXI_IDS_BITS-1:0] AWID_S6;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S6;
logic [`AXI_LEN_BITS-1:0] AWLEN_S6;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S6;
logic [1:0] AWBURST_S6;
logic AWVALID_S6;
logic AWREADY_S6;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S6;
logic [`AXI_STRB_BITS-1:0] WSTRB_S6;
logic WLAST_S6;
logic WVALID_S6;
logic WREADY_S6;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S6;
logic [1:0] BRESP_S6;
logic BVALID_S6;
logic BREADY_S6;


logic [48:0] aw_s1_wdata,aw_s1_rdata;
logic [48:0] aw_m1_wdata,aw_m1_rdata;
logic [48:0] aw_m2_wdata,aw_m2_rdata;
logic [48:0] aw_m3_wdata,aw_m3_rdata;
logic [48:0] aw_m4_wdata,aw_m4_rdata;
logic [48:0] aw_m5_wdata,aw_m5_rdata;
logic [48:0] aw_m6_wdata,aw_m6_rdata;

assign aw_s1_wdata={4'd0,AWID_M1_F,AWADDR_M1_F,AWLEN_M1_F,AWSIZE_M1_F,AWBURST_M1_F};
assign AWID_M1=aw_s1_rdata[44:41];
assign AWADDR_M1=aw_s1_rdata[40:9];
assign AWLEN_M1=aw_s1_rdata[8:5];
assign AWSIZE_M1=aw_s1_rdata[4:2];
assign AWBURST_M1=aw_s1_rdata[1:0];

assign aw_m1_wdata={AWID_S1,AWADDR_S1,AWLEN_S1,AWSIZE_S1,AWBURST_S1};
assign AWID_S1_F=aw_m1_rdata[48:41];
assign AWADDR_S1_F=aw_m1_rdata[40:9];
assign AWLEN_S1_F=aw_m1_rdata[8:5];
assign AWSIZE_S1_F=aw_m1_rdata[4:2];
assign AWBURST_S1_F=aw_m1_rdata[1:0];

assign aw_m2_wdata={AWID_S2,AWADDR_S2,AWLEN_S2,AWSIZE_S2,AWBURST_S2};
assign AWID_S2_F=aw_m2_rdata[48:41];
assign AWADDR_S2_F=aw_m2_rdata[40:9];
assign AWLEN_S2_F=aw_m2_rdata[8:5];
assign AWSIZE_S2_F=aw_m2_rdata[4:2];
assign AWBURST_S2_F=aw_m2_rdata[1:0];

assign aw_m3_wdata={AWID_S3,AWADDR_S3,AWLEN_S3,AWSIZE_S3,AWBURST_S3};
assign AWID_S3_F=aw_m3_rdata[48:41];
assign AWADDR_S3_F=aw_m3_rdata[40:9];
assign AWLEN_S3_F=aw_m3_rdata[8:5];
assign AWSIZE_S3_F=aw_m3_rdata[4:2];
assign AWBURST_S3_F=aw_m3_rdata[1:0];

assign aw_m4_wdata={AWID_S4,AWADDR_S4,AWLEN_S4,AWSIZE_S4,AWBURST_S4};
assign AWID_S4_F=aw_m4_rdata[48:41];
assign AWADDR_S4_F=aw_m4_rdata[40:9];
assign AWLEN_S4_F=aw_m4_rdata[8:5];
assign AWSIZE_S4_F=aw_m4_rdata[4:2];
assign AWBURST_S4_F=aw_m4_rdata[1:0];

assign aw_m5_wdata={AWID_S5,AWADDR_S5,AWLEN_S5,AWSIZE_S5,AWBURST_S5};
assign AWID_S5_F=aw_m5_rdata[48:41];
assign AWADDR_S5_F=aw_m5_rdata[40:9];
assign AWLEN_S5_F=aw_m5_rdata[8:5];
assign AWSIZE_S5_F=aw_m5_rdata[4:2];
assign AWBURST_S5_F=aw_m5_rdata[1:0];

assign aw_m6_wdata={AWID_S6,AWADDR_S6,AWLEN_S6,AWSIZE_S6,AWBURST_S6};
assign AWID_S6_F=aw_m6_rdata[48:41];
assign AWADDR_S6_F=aw_m6_rdata[40:9];
assign AWLEN_S6_F=aw_m6_rdata[8:5];
assign AWSIZE_S6_F=aw_m6_rdata[4:2];
assign AWBURST_S6_F=aw_m6_rdata[1:0];

//aw
FIFO_AW aw_s1(
	.wdata(aw_s1_wdata),
	.valid_i(AWVALID_M1_F),
	.valid_o(AWVALID_M1),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(aw_s1_rdata),
	.ready_i(AWREADY_M1),
	.ready_o(AWREADY_M1_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_AW aw_m1(
	.wdata(aw_m1_wdata),
	.valid_i(AWVALID_S1),
	.valid_o(AWVALID_S1_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m1_rdata),
	.ready_i(AWREADY_S1_F),
	.ready_o(AWREADY_S1),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);

FIFO_AW aw_m2(
	.wdata(aw_m2_wdata),
	.valid_i(AWVALID_S2),
	.valid_o(AWVALID_S2_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m2_rdata),
	.ready_i(AWREADY_S2_F),
	.ready_o(AWREADY_S2),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);
FIFO_AW aw_m3(
	.wdata(aw_m3_wdata),
	.valid_i(AWVALID_S3),
	.valid_o(AWVALID_S3_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m3_rdata),
	.ready_i(AWREADY_S3_F),
	.ready_o(AWREADY_S3),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_AW aw_m4(
	.wdata(aw_m4_wdata),
	.valid_i(AWVALID_S4),
	.valid_o(AWVALID_S4_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m4_rdata),
	.ready_i(AWREADY_S4_F),
	.ready_o(AWREADY_S4),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_AW aw_m5(
	.wdata(aw_m5_wdata),
	.valid_i(AWVALID_S5),
	.valid_o(AWVALID_S5_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m5_rdata),
	.ready_i(AWREADY_S5_F),
	.ready_o(AWREADY_S5),
	.rrst_n(~DRAM_RST_i),
	.rclk(DRAM_CLK_i)
);

FIFO_AW aw_m6(
	.wdata(aw_m6_wdata),
	.valid_i(AWVALID_S6),
	.valid_o(AWVALID_S6_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m6_rdata),
	.ready_i(AWREADY_S6_F),
	.ready_o(AWREADY_S6),
	.rrst_n(~PWM_RST_i),
	.rclk(PWM_CLK_i)
);

logic [36:0] w_s1_wdata,w_s1_rdata;
logic [36:0] w_m1_wdata,w_m1_rdata;
logic [36:0] w_m2_wdata,w_m2_rdata;
logic [36:0] w_m3_wdata,w_m3_rdata;
logic [36:0] w_m4_wdata,w_m4_rdata;
logic [36:0] w_m5_wdata,w_m5_rdata;
logic [36:0] w_m6_wdata,w_m6_rdata;

assign w_s1_wdata={WDATA_M1_F,WSTRB_M1_F,WLAST_M1_F};
assign WDATA_M1=w_s1_rdata[36:5];
assign WSTRB_M1=w_s1_rdata[4:1];
assign WLAST_M1=w_s1_rdata[0];

assign w_m1_wdata={WDATA_S1,WSTRB_S1,WLAST_S1};
assign WDATA_S1_F=w_m1_rdata[36:5];
assign WSTRB_S1_F=w_m1_rdata[4:1];
assign WLAST_S1_F=w_m1_rdata[0];

assign w_m2_wdata={WDATA_S2,WSTRB_S2,WLAST_S2};
assign WDATA_S2_F=w_m2_rdata[36:5];
assign WSTRB_S2_F=w_m2_rdata[4:1];
assign WLAST_S2_F=w_m2_rdata[0];

assign w_m3_wdata={WDATA_S3,WSTRB_S3,WLAST_S3};
assign WDATA_S3_F=w_m3_rdata[36:5];
assign WSTRB_S3_F=w_m3_rdata[4:1];
assign WLAST_S3_F=w_m3_rdata[0];

assign w_m4_wdata={WDATA_S4,WSTRB_S4,WLAST_S4};
assign WDATA_S4_F=w_m4_rdata[36:5];
assign WSTRB_S4_F=w_m4_rdata[4:1];
assign WLAST_S4_F=w_m4_rdata[0];

assign w_m5_wdata={WDATA_S5,WSTRB_S5,WLAST_S5};
assign WDATA_S5_F=w_m5_rdata[36:5];
assign WSTRB_S5_F=w_m5_rdata[4:1];
assign WLAST_S5_F=w_m5_rdata[0];

assign w_m6_wdata={WDATA_S6,WSTRB_S6,WLAST_S6};
assign WDATA_S6_F=w_m6_rdata[36:5];
assign WSTRB_S6_F=w_m6_rdata[4:1];
assign WLAST_S6_F=w_m6_rdata[0];

//w
FIFO_W w_s1(
	.wdata(w_s1_wdata),
	.valid_i(WVALID_M1_F),
	.valid_o(WVALID_M1),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(w_s1_rdata),
	.ready_i(WREADY_M1),
	.ready_o(WREADY_M1_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_W w_m1(
	.wdata(w_m1_wdata),
	.valid_i(WVALID_S1),
	.valid_o(WVALID_S1_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m1_rdata),
	.ready_i(WREADY_S1_F),
	.ready_o(WREADY_S1),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);

FIFO_W w_m2(
	.wdata(w_m2_wdata),
	.valid_i(WVALID_S2),
	.valid_o(WVALID_S2_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m2_rdata),
	.ready_i(WREADY_S2_F),
	.ready_o(WREADY_S2),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);

FIFO_W w_m3(
	.wdata(w_m3_wdata),
	.valid_i(WVALID_S3),
	.valid_o(WVALID_S3_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m3_rdata),
	.ready_i(WREADY_S3_F),
	.ready_o(WREADY_S3),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_W w_m4(
	.wdata(w_m4_wdata),
	.valid_i(WVALID_S4),
	.valid_o(WVALID_S4_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m4_rdata),
	.ready_i(WREADY_S4_F),
	.ready_o(WREADY_S4),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_W w_m5(
	.wdata(w_m5_wdata),
	.valid_i(WVALID_S5),
	.valid_o(WVALID_S5_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m5_rdata),
	.ready_i(WREADY_S5_F),
	.ready_o(WREADY_S5),
	.rrst_n(~DRAM_RST_i),
	.rclk(DRAM_CLK_i)
);

FIFO_W w_m6(
	.wdata(w_m6_wdata),
	.valid_i(WVALID_S6),
	.valid_o(WVALID_S6_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m6_rdata),
	.ready_i(WREADY_S6_F),
	.ready_o(WREADY_S6),
	.rrst_n(~PWM_RST_i),
	.rclk(PWM_CLK_i)
);

logic [9:0] b_s1_wdata,b_s1_rdata;
logic [9:0] b_m1_wdata,b_m1_rdata;
logic [9:0] b_m2_wdata,b_m2_rdata;
logic [9:0] b_m3_wdata,b_m3_rdata;
logic [9:0] b_m4_wdata,b_m4_rdata;
logic [9:0] b_m5_wdata,b_m5_rdata;
logic [9:0] b_m6_wdata,b_m6_rdata;

assign b_s1_wdata={4'd0,BID_M1,BRESP_M1};
assign BID_M1_F=b_s1_rdata[5:2];
assign BRESP_M1_F=b_s1_rdata[1:0];

assign b_m1_wdata={BID_S1_F,BRESP_S1_F};
assign BID_S1=b_m1_rdata[9:2];
assign BRESP_S1=b_m1_rdata[1:0];

assign b_m2_wdata={BID_S2_F,BRESP_S2_F};
assign BID_S2=b_m2_rdata[9:2];
assign BRESP_S2=b_m2_rdata[1:0];

assign b_m3_wdata={BID_S3_F,BRESP_S3_F};
assign BID_S3=b_m3_rdata[9:2];
assign BRESP_S3=b_m3_rdata[1:0];

assign b_m4_wdata={BID_S4_F,BRESP_S4_F};
assign BID_S4=b_m4_rdata[9:2];
assign BRESP_S4=b_m4_rdata[1:0];

assign b_m5_wdata={BID_S5_F,BRESP_S5_F};
assign BID_S5=b_m5_rdata[9:2];
assign BRESP_S5=b_m5_rdata[1:0];

assign b_m6_wdata={BID_S6_F,BRESP_S6_F};
assign BID_S6=b_m6_rdata[9:2];
assign BRESP_S6=b_m6_rdata[1:0];

//b
FIFO_B b_s1(
	.wdata(b_s1_wdata),
	.valid_i(BVALID_M1),
	.valid_o(BVALID_M1_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(b_s1_rdata),
	.ready_i(BREADY_M1_F),
	.ready_o(BREADY_M1),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_B b_m1(
	.wdata(b_m1_wdata),
	.valid_i(BVALID_S1_F),
	.valid_o(BVALID_S1),
	.wrst_n(~SRAM_RST_i),
	.wclk(SRAM_CLK_i),
	.rdata(b_m1_rdata),
	.ready_i(BREADY_S1),
	.ready_o(BREADY_S1_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_B b_m2(
	.wdata(b_m2_wdata),
	.valid_i(BVALID_S2_F),
	.valid_o(BVALID_S2),
	.wrst_n(~SRAM_RST_i),
	.wclk(SRAM_CLK_i),
	.rdata(b_m2_rdata),
	.ready_i(BREADY_S2),
	.ready_o(BREADY_S2_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_B b_m3(
	.wdata(b_m3_wdata),
	.valid_i(BVALID_S3_F),
	.valid_o(BVALID_S3),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(b_m3_rdata),
	.ready_i(BREADY_S3),
	.ready_o(BREADY_S3_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_B b_m4(
	.wdata(b_m4_wdata),
	.valid_i(BVALID_S4_F),
	.valid_o(BVALID_S4),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(b_m4_rdata),
	.ready_i(BREADY_S4),
	.ready_o(BREADY_S4_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_B b_m5(
	.wdata(b_m5_wdata),
	.valid_i(BVALID_S5_F),
	.valid_o(BVALID_S5),
	.wrst_n(~DRAM_RST_i),
	.wclk(DRAM_CLK_i),
	.rdata(b_m5_rdata),
	.ready_i(BREADY_S5),
	.ready_o(BREADY_S5_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_B b_m6(
	.wdata(b_m6_wdata),
	.valid_i(BVALID_S6_F),
	.valid_o(BVALID_S6),
	.wrst_n(~PWM_RST_i),
	.wclk(PWM_CLK_i),
	.rdata(b_m6_rdata),
	.ready_i(BREADY_S6),
	.ready_o(BREADY_S6_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

logic [48:0] ar_s0_wdata,ar_s0_rdata;						 
logic [48:0] ar_s1_wdata,ar_s1_rdata;
logic [48:0] ar_m0_wdata,ar_m0_rdata;
logic [48:0] ar_m1_wdata,ar_m1_rdata;
logic [48:0] ar_m2_wdata,ar_m2_rdata;
logic [48:0] ar_m3_wdata,ar_m3_rdata;
logic [48:0] ar_m5_wdata,ar_m5_rdata;

assign ar_s0_wdata={4'd0,ARID_M0_F,ARADDR_M0_F,ARLEN_M0_F,ARSIZE_M0_F,ARBURST_M0_F};
assign ARID_M0=ar_s0_rdata[44:41];
assign ARADDR_M0=ar_s0_rdata[40:9];
assign ARLEN_M0=ar_s0_rdata[8:5];
assign ARSIZE_M0=ar_s0_rdata[4:2];
assign ARBURST_M0=ar_s0_rdata[1:0];

assign ar_s1_wdata={4'd0,ARID_M1_F,ARADDR_M1_F,ARLEN_M1_F,ARSIZE_M1_F,ARBURST_M1_F};
assign ARID_M1=ar_s1_rdata[44:41];
assign ARADDR_M1=ar_s1_rdata[40:9];
assign ARLEN_M1=ar_s1_rdata[8:5];
assign ARSIZE_M1=ar_s1_rdata[4:2];
assign ARBURST_M1=ar_s1_rdata[1:0];

assign ar_m0_wdata={ARID_S0,ARADDR_S0,ARLEN_S0,ARSIZE_S0,ARBURST_S0};
assign ARID_S0_F=ar_m0_rdata[48:41];
assign ARADDR_S0_F=ar_m0_rdata[40:9];
assign ARLEN_S0_F=ar_m0_rdata[8:5];
assign ARSIZE_S0_F=ar_m0_rdata[4:2];
assign ARBURST_S0_F=ar_m0_rdata[1:0];

assign ar_m1_wdata={ARID_S1,ARADDR_S1,ARLEN_S1,ARSIZE_S1,ARBURST_S1};
assign ARID_S1_F=ar_m1_rdata[48:41];
assign ARADDR_S1_F=ar_m1_rdata[40:9];
assign ARLEN_S1_F=ar_m1_rdata[8:5];
assign ARSIZE_S1_F=ar_m1_rdata[4:2];
assign ARBURST_S1_F=ar_m1_rdata[1:0];

assign ar_m2_wdata={ARID_S2,ARADDR_S2,ARLEN_S2,ARSIZE_S2,ARBURST_S2};
assign ARID_S2_F=ar_m2_rdata[48:41];
assign ARADDR_S2_F=ar_m2_rdata[40:9];
assign ARLEN_S2_F=ar_m2_rdata[8:5];
assign ARSIZE_S2_F=ar_m2_rdata[4:2];
assign ARBURST_S2_F=ar_m2_rdata[1:0];

assign ar_m3_wdata={ARID_S3,ARADDR_S3,ARLEN_S3,ARSIZE_S3,ARBURST_S3};
assign ARID_S3_F=ar_m3_rdata[48:41];
assign ARADDR_S3_F=ar_m3_rdata[40:9];
assign ARLEN_S3_F=ar_m3_rdata[8:5];
assign ARSIZE_S3_F=ar_m3_rdata[4:2];
assign ARBURST_S3_F=ar_m3_rdata[1:0];

assign ar_m5_wdata={ARID_S5,ARADDR_S5,ARLEN_S5,ARSIZE_S5,ARBURST_S5};
assign ARID_S5_F=ar_m5_rdata[48:41];
assign ARADDR_S5_F=ar_m5_rdata[40:9];
assign ARLEN_S5_F=ar_m5_rdata[8:5];
assign ARSIZE_S5_F=ar_m5_rdata[4:2];
assign ARBURST_S5_F=ar_m5_rdata[1:0];

//ar
FIFO_AR ar_s0(
	.wdata(ar_s0_wdata),
	.valid_i(ARVALID_M0_F),
	.valid_o(ARVALID_M0),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(ar_s0_rdata),
	.ready_i(ARREADY_M0),
	.ready_o(ARREADY_M0_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_AR ar_s1(
	.wdata(ar_s1_wdata),
	.valid_i(ARVALID_M1_F),
	.valid_o(ARVALID_M1),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(ar_s1_rdata),
	.ready_i(ARREADY_M1),
	.ready_o(ARREADY_M1_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_AR ar_m0(
	.wdata(ar_m0_wdata),
	.valid_i(ARVALID_S0),
	.valid_o(ARVALID_S0_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(ar_m0_rdata),
	.ready_i(ARREADY_S0_F),
	.ready_o(ARREADY_S0),
	.rrst_n(~ROM_RST_i),
	.rclk(ROM_CLK_i)
);

FIFO_AR ar_m1(
	.wdata(ar_m1_wdata),
	.valid_i(ARVALID_S1),
	.valid_o(ARVALID_S1_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(ar_m1_rdata),
	.ready_i(ARREADY_S1_F),
	.ready_o(ARREADY_S1),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);

FIFO_AR ar_m2(
	.wdata(ar_m2_wdata),
	.valid_i(ARVALID_S2),
	.valid_o(ARVALID_S2_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(ar_m2_rdata),
	.ready_i(ARREADY_S2_F),
	.ready_o(ARREADY_S2),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);

FIFO_AR ar_m3(
	.wdata(ar_m3_wdata),
	.valid_i(ARVALID_S3),
	.valid_o(ARVALID_S3_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(ar_m3_rdata),
	.ready_i(ARREADY_S3_F),
	.ready_o(ARREADY_S3),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_AR ar_m5(
	.wdata(ar_m5_wdata),
	.valid_i(ARVALID_S5),
	.valid_o(ARVALID_S5_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(ar_m5_rdata),
	.ready_i(ARREADY_S5_F),
	.ready_o(ARREADY_S5),
	.rrst_n(~DRAM_RST_i),
	.rclk(DRAM_CLK_i)
);

logic [41:0] r_s0_wdata,r_s0_rdata;
logic [41:0] r_s1_wdata,r_s1_rdata;
logic [41:0] r_m0_wdata,r_m0_rdata;
logic [41:0] r_m1_wdata,r_m1_rdata;
logic [41:0] r_m2_wdata,r_m2_rdata;
logic [41:0] r_m3_wdata,r_m3_rdata;
logic [41:0] r_m5_wdata,r_m5_rdata;

assign r_s0_wdata={4'd0,RID_M0,RDATA_M0,RRESP_M0};
assign RID_M0_F=r_s0_rdata[37:34];
assign RDATA_M0_F=r_s0_rdata[33:2];
assign RRESP_M0_F=r_s0_rdata[1:0];

assign r_s1_wdata={4'd0,RID_M1,RDATA_M1,RRESP_M1};
assign RID_M1_F=r_s1_rdata[37:34];
assign RDATA_M1_F=r_s1_rdata[33:2];
assign RRESP_M1_F=r_s1_rdata[1:0];

assign r_m0_wdata={RID_S0_F,RDATA_S0_F,RRESP_S0_F};
assign RID_S0=r_m0_rdata[41:34];
assign RDATA_S0=r_m0_rdata[33:2];
assign RRESP_S0=r_m0_rdata[1:0];

assign r_m1_wdata={RID_S1_F,RDATA_S1_F,RRESP_S1_F};
assign RID_S1=r_m1_rdata[41:34];
assign RDATA_S1=r_m1_rdata[33:2];
assign RRESP_S1=r_m1_rdata[1:0];

assign r_m2_wdata={RID_S2_F,RDATA_S2_F,RRESP_S2_F};
assign RID_S2=r_m2_rdata[41:34];
assign RDATA_S2=r_m2_rdata[33:2];
assign RRESP_S2=r_m2_rdata[1:0];

assign r_m3_wdata={RID_S3_F,RDATA_S3_F,RRESP_S3_F};
assign RID_S3=r_m3_rdata[41:34];
assign RDATA_S3=r_m3_rdata[33:2];
assign RRESP_S3=r_m3_rdata[1:0];

assign r_m5_wdata={RID_S5_F,RDATA_S5_F,RRESP_S5_F};
assign RID_S5=r_m5_rdata[41:34];
assign RDATA_S5=r_m5_rdata[33:2];
assign RRESP_S5=r_m5_rdata[1:0];
//r
FIFO_R r_s0(
	.wdata(r_s0_wdata),
	.valid_i(RVALID_M0),
	.valid_o(RVALID_M0_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(r_s0_rdata),
	.ready_i(RREADY_M0_F),
	.ready_o(RREADY_M0),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_R r_s1(
	.wdata(r_s1_wdata),
	.valid_i(RVALID_M1),
	.valid_o(RVALID_M1_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(r_s1_rdata),
	.ready_i(RREADY_M1_F),
	.ready_o(RREADY_M1),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_R r_m0(
	.wdata(r_m0_wdata),
	.valid_i(RVALID_S0_F),
	.valid_o(RVALID_S0),
	.wrst_n(~ROM_RST_i),
	.wclk(ROM_CLK_i),
	.rdata(r_m0_rdata),
	.ready_i(RREADY_S0),
	.ready_o(RREADY_S0_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_R r_m1(
	.wdata(r_m1_wdata),
	.valid_i(RVALID_S1_F),
	.valid_o(RVALID_S1),
	.wrst_n(~SRAM_RST_i),
	.wclk(SRAM_CLK_i),
	.rdata(r_m1_rdata),
	.ready_i(RREADY_S1),
	.ready_o(RREADY_S1_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_R r_m2(
	.wdata(r_m2_wdata),
	.valid_i(RVALID_S2_F),
	.valid_o(RVALID_S2),
	.wrst_n(~SRAM_RST_i),
	.wclk(SRAM_CLK_i),
	.rdata(r_m2_rdata),
	.ready_i(RREADY_S2),
	.ready_o(RREADY_S2_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_R r_m3(
	.wdata(r_m3_wdata),
	.valid_i(RVALID_S3_F),
	.valid_o(RVALID_S3),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(r_m3_rdata),
	.ready_i(RREADY_S3),
	.ready_o(RREADY_S3_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_R r_m5(
	.wdata(r_m5_wdata),
	.valid_i(RVALID_S5_F),
	.valid_o(RVALID_S5),
	.wrst_n(~DRAM_RST_i),
	.wclk(DRAM_CLK_i),
	.rdata(r_m5_rdata),
	.ready_i(RREADY_S5),
	.ready_o(RREADY_S5_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

logic [2:0] counter_S0;
always_ff@(posedge CPU_CLK_i ) begin
	if(~CPU_RST_i) counter_S0<=3'd0;
	else if(RVALID_M0_F==1'd1) counter_S0<=counter_S0+3'd1;
	else if(counter_S0==3'd4) counter_S0<=3'd0;
	else counter_S0<=counter_S0;
end
assign RLAST_M0_F=(counter_S0==3'd3)?RVALID_M0_F:1'd0;

logic [2:0] counter_S1;
always_ff@(posedge CPU_CLK_i ) begin
	if(~CPU_RST_i) counter_S1<=3'd0;
	else if(RVALID_M1_F==1'd1) counter_S1<=counter_S1+3'd1;
	else if(counter_S1==3'd4) counter_S1<=3'd0;
	else counter_S1<=counter_S1;
end
//assign RLAST_M1_F=(counter_S1==3'd3)?RVALID_M1_F:1'd0;
logic [3:0] len_reg;
always_comb begin
	if(len_reg==4'd0) RLAST_M1_F=RVALID_M1_F;
	else if(counter_S1==3'd3) RLAST_M1_F=RVALID_M1_F;
	else RLAST_M1_F=1'd0;
end

always_ff@(posedge CPU_CLK_i) begin
	if(~CPU_RST_i) len_reg<=4'd1;
	else if(ARVALID_M1_F==1'd1) len_reg<=ARLEN_M1_F;
	else len_reg<=len_reg;
end

logic [2:0] counter_M0;
always_ff@(posedge ACLK ) begin
	if(~ARESETn) counter_M0<=3'd0;
	else if(RVALID_S0==1'd1) counter_M0<=counter_M0+3'd1;
	else if(counter_M0==3'd4) counter_M0<=3'd0;
	else counter_M0<=counter_M0;
end
assign RLAST_S0=(counter_M0==3'd3)?RVALID_S0:1'd0;

logic [2:0] counter_M1;
always_ff@(posedge ACLK ) begin
	if(~ARESETn) counter_M1<=3'd0;
	else if(RVALID_S1==1'd1) counter_M1<=counter_M1+3'd1;
	else if(counter_M1==3'd4) counter_M1<=3'd0;
	else counter_M1<=counter_M1;
end
assign RLAST_S1=(counter_M1==3'd3)?RVALID_S1:1'd0;

logic [2:0] counter_M2;
always_ff@(posedge ACLK ) begin
	if(~ARESETn) counter_M2<=3'd0;
	else if(RVALID_S2==1'd1) counter_M2<=counter_M2+3'd1;
	else if(counter_M2==3'd4) counter_M2<=3'd0;
	else counter_M2<=counter_M2;
end
assign RLAST_S2=(counter_M2==3'd3)?RVALID_S2:1'd0;


assign RLAST_S3=RVALID_S3;

logic [2:0] counter_M5;
always_ff@(posedge ACLK ) begin
	if(~ARESETn) counter_M5<=3'd0;
	else if(RVALID_S5==1'd1) counter_M5<=counter_M5+3'd1;
	else if(counter_M5==3'd4) counter_M5<=3'd0;
	else counter_M5<=counter_M5;
end
assign RLAST_S5=(counter_M5==3'd3)?RVALID_S5:1'd0;

always_ff@(posedge ACLK ) begin
	if(~ARESETn) read_curr_state<=read_IDLE;
	else read_curr_state<=read_next_state;
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) write_curr_state<=write_IDLE;
	else write_curr_state<=write_next_state;
end

always_comb begin //next state logic for read
	unique case (read_curr_state)
		read_IDLE: begin
			if(ARVALID_M0==1'd1)  begin
				unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
				else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
				else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
				else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
				else  read_next_state=M0_read_S5; //DRAM
			end
			else if(ARVALID_M1==1'd1)  begin
				unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
				else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
				else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
				else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
				else  read_next_state=M1_read_S5; //DRAM
			end
			else read_next_state=read_IDLE;
		end
		M0_read_S0: begin //M0 read ROM
			unique if(RVALID_S0==1'd1 && RREADY_M0==1'd1 && RLAST_S0) begin
				unique if(ARVALID_M1==1'd1) begin
					unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
					else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
					else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
					else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
					else  read_next_state=M1_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M0_read_S0;
		end
		M0_read_S1: begin  //M0 read IM
			unique if(RVALID_S1==1'd1 && RREADY_M0==1'd1 && RLAST_S1) begin
				unique if(ARVALID_M1==1'd1) begin
					unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
					else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
					else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
					else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
					else  read_next_state=M1_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M0_read_S1;
		end
		M0_read_S2: begin //M0 read DM
			unique if(RVALID_S2==1'd1 && RREADY_M0==1'd1 && RLAST_S2) begin
				unique if(ARVALID_M1==1'd1) begin
					unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
					else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
					else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
					else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
					else  read_next_state=M1_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M0_read_S2;
		end
		M0_read_S3: begin //M0 read sensor_ctrl
			unique if(RVALID_S3==1'd1 && RREADY_M0==1'd1 && RLAST_S3) begin
				unique if(ARVALID_M1==1'd1) begin
					unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
					else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
					else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
					else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
					else  read_next_state=M1_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M0_read_S3;
		end
		M0_read_S5: begin //M0 read DRAM
			unique if(RVALID_S5==1'd1 && RREADY_M0==1'd1 && RLAST_S5) begin
				unique if(ARVALID_M1==1'd1) begin
					unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
					else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
					else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
					else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
					else  read_next_state=M1_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M0_read_S5;
		end
		M1_read_S0: begin  //M1 read ROM
			unique if(RVALID_S0==1'd1 && RREADY_M1==1'd1 && RLAST_S0) begin
				unique if(ARVALID_M0==1'd1) begin
					unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
					else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
					else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
					else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
					else  read_next_state=M0_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M1_read_S0;
		end
		M1_read_S1: begin //M1 read IM
			unique if(RVALID_S1==1'd1 && RREADY_M1==1'd1 && RLAST_S1) begin
				unique if(ARVALID_M0==1'd1) begin
					unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
					else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
					else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
					else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
					else  read_next_state=M0_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M1_read_S1;
		end
		M1_read_S2: begin //M1 read DM
			unique if(RVALID_S2==1'd1 && RREADY_M1==1'd1 && RLAST_S2) begin
				unique if(ARVALID_M0==1'd1) begin
					unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
					else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
					else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
					else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
					else  read_next_state=M0_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M1_read_S2;
		end
		M1_read_S3: begin //M1 read sensor_ctrl
			unique if(RVALID_S3==1'd1 && RREADY_M1==1'd1 && RLAST_S3) begin
				unique if(ARVALID_M0==1'd1) begin
					unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
					else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
					else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
					else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
					else  read_next_state=M0_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M1_read_S3;
		end
		M1_read_S5: begin //M1 read DRAM
			unique if(RVALID_S5==1'd1 && RREADY_M1==1'd1 && RLAST_S5) begin
				unique if(ARVALID_M0==1'd1) begin
					unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
					else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
					else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
					else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
					else  read_next_state=M0_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M1_read_S5;
		end
		default: begin
			read_next_state=read_IDLE;
		end
	endcase
end

always_comb begin //next state logic for write
	unique case (write_curr_state)
		write_IDLE: begin
			if(AWVALID_M1==1'd1)  begin
				unique if(AWADDR_M1<=32'h0001FFFF && AWADDR_M1>=32'h00010000) write_next_state=M1_write_S1; //IM
				else if(AWADDR_M1<=32'h0002FFFF && AWADDR_M1>=32'h00020000) write_next_state=M1_write_S2; //DM
				else if(AWADDR_M1<=32'h100003FF && AWADDR_M1>=32'h10000000) write_next_state=M1_write_S3; //sensor_ctrl
				else if(AWADDR_M1<=32'h100103FF && AWADDR_M1>=32'h10010000) write_next_state=M1_write_S4; //WDT
				else if(AWADDR_M1<=32'h201FFFFF && AWADDR_M1>=32'h20000000) write_next_state=M1_write_S5; //DRAM
				else write_next_state=M1_write_S6; //PWM
			end
			else write_next_state=write_IDLE;
		end
		M1_write_S1: begin
			unique if(BREADY_M1==1'd1 && BVALID_S1==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S1;
		end
		M1_write_S2: begin
			unique if(BREADY_M1==1'd1 && BVALID_S2==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S2;
		end
		M1_write_S3: begin
			unique if(BREADY_M1==1'd1 && BVALID_S3==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S3;
		end
		M1_write_S4: begin
			unique if(BREADY_M1==1'd1 && BVALID_S4==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S4;
		end
		M1_write_S5: begin
			unique if(BREADY_M1==1'd1 && BVALID_S5==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S5;
		end
		M1_write_S6: begin
			unique if(BREADY_M1==1'd1 && BVALID_S6==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S6;
		end
		default: begin
			write_next_state=write_IDLE;
		end
	endcase
end

always_comb begin
	unique case (read_curr_state)
		read_IDLE: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
			
		end
		M0_read_S0: begin
			ARID_S0={4'd0,ARID_M0};//MASTER interface READ ADDRESS0
			ARADDR_S0=ARADDR_M0;
			ARLEN_S0=ARLEN_M0;
			ARSIZE_S0=ARSIZE_M0;
			ARBURST_S0=ARBURST_M0;
			ARVALID_S0=ARVALID_M0;
			
			RREADY_S0=RREADY_M0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			ARREADY_M0=ARREADY_S0; //SLAVE interface READ ADDRESS0
			
			RID_M0=RID_S0[3:0]; //SLAVE interface READ DATA0
			RDATA_M0=RDATA_S0;
			RRESP_M0=RRESP_S0;
			RLAST_M0=RLAST_S0;
			RVALID_M0=RVALID_S0;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
			
		end
		M0_read_S1: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1={4'd0,ARID_M0}; //MASTER interface READ ADDRESS1
			ARADDR_S1=ARADDR_M0;
			ARLEN_S1=ARLEN_M0;
			ARSIZE_S1=ARSIZE_M0;
			ARBURST_S1=ARBURST_M0;
			ARVALID_S1=ARVALID_M0;
					
			RREADY_S1=RREADY_M0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			ARREADY_M0=ARREADY_S1; //SLAVE interface READ ADDRESS0
			
			RID_M0=RID_S1[3:0]; //SLAVE interface READ DATA0
			RDATA_M0=RDATA_S1;
			RRESP_M0=RRESP_S1;
			RLAST_M0=RLAST_S1;
			RVALID_M0=RVALID_S1;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
			
		end
		M0_read_S2: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2={4'd0,ARID_M0}; //MASTER interface READ ADDRESS2
			ARADDR_S2=ARADDR_M0;
			ARLEN_S2=ARLEN_M0;
			ARSIZE_S2=ARSIZE_M0;
			ARBURST_S2=ARBURST_M0;
			ARVALID_S2=ARVALID_M0;
					
			RREADY_S2=RREADY_M0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=ARREADY_S2; //SLAVE interface READ ADDRESS0
			
			RID_M0=RID_S2[3:0]; //SLAVE interface READ DATA0
			RDATA_M0=RDATA_S2;
			RRESP_M0=RRESP_S2;
			RLAST_M0=RLAST_S2;
			RVALID_M0=RVALID_S2;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
			
		end
		M0_read_S3: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3={4'd0,ARID_M0}; //MASTER interface READ ADDRESS3
			ARADDR_S3=ARADDR_M0;
			ARLEN_S3=ARLEN_M0;
			ARSIZE_S3=ARSIZE_M0;
			ARBURST_S3=ARBURST_M0;
			ARVALID_S3=ARVALID_M0;
					
			RREADY_S3=RREADY_M0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=ARREADY_S3; //SLAVE interface READ ADDRESS0
			
			RID_M0=RID_S3[3:0]; //SLAVE interface READ DATA0
			RDATA_M0=RDATA_S3;
			RRESP_M0=RRESP_S3;
			RLAST_M0=RLAST_S3;
			RVALID_M0=RVALID_S3;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
		end
		M0_read_S5: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5={4'd0,ARID_M0}; //MASTER interface READ ADDRESS5
			ARADDR_S5=ARADDR_M0;
			ARLEN_S5=ARLEN_M0;
			ARSIZE_S5=ARSIZE_M0;
			ARBURST_S5=ARBURST_M0;
			ARVALID_S5=ARVALID_M0;
					
			RREADY_S5=RREADY_M0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=ARREADY_S5; //SLAVE interface READ ADDRESS0
			
			RID_M0=RID_S5[3:0]; //SLAVE interface READ DATA0
			RDATA_M0=RDATA_S5;
			RRESP_M0=RRESP_S5;
			RLAST_M0=RLAST_S5;
			RVALID_M0=RVALID_S5;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
		end
		M1_read_S0: begin
			ARID_S0={4'd0,ARID_M1};//MASTER interface READ ADDRESS0
			ARADDR_S0=ARADDR_M1;
			ARLEN_S0=ARLEN_M1;
			ARSIZE_S0=ARSIZE_M1;
			ARBURST_S0=ARBURST_M1;
			ARVALID_S0=ARVALID_M1;
			
			RREADY_S0=RREADY_M1; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=ARREADY_S0; //SLAVE interface READ ADDRESS1
			
			RID_M1=RID_S0[3:0]; //SLAVE interface READ DATA1
			RDATA_M1=RDATA_S0;
			RRESP_M1=RRESP_S0;
			RLAST_M1=RLAST_S0;
			RVALID_M1=RVALID_S0;
		end
		M1_read_S1: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1={4'd0,ARID_M1}; //MASTER interface READ ADDRESS1
			ARADDR_S1=ARADDR_M1;
			ARLEN_S1=ARLEN_M1;
			ARSIZE_S1=ARSIZE_M1;
			ARBURST_S1=ARBURST_M1;
			ARVALID_S1=ARVALID_M1;
					
			RREADY_S1=RREADY_M1; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=ARREADY_S1; //SLAVE interface READ ADDRESS1
			
			RID_M1=RID_S1[3:0]; //SLAVE interface READ DATA1
			RDATA_M1=RDATA_S1;
			RRESP_M1=RRESP_S1;
			RLAST_M1=RLAST_S1;
			RVALID_M1=RVALID_S1;
		end
		M1_read_S2: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2={4'd0,ARID_M1}; //MASTER interface READ ADDRESS2
			ARADDR_S2=ARADDR_M1;
			ARLEN_S2=ARLEN_M1;
			ARSIZE_S2=ARSIZE_M1;
			ARBURST_S2=ARBURST_M1;
			ARVALID_S2=ARVALID_M1;
					
			RREADY_S2=RREADY_M1; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=ARREADY_S2; //SLAVE interface READ ADDRESS1
			
			RID_M1=RID_S2[3:0]; //SLAVE interface READ DATA1
			RDATA_M1=RDATA_S2;
			RRESP_M1=RRESP_S2;
			RLAST_M1=RLAST_S2;
			RVALID_M1=RVALID_S2;
			
		end
		M1_read_S3: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3={4'd0,ARID_M1}; //MASTER interface READ ADDRESS3
			ARADDR_S3=ARADDR_M1;
			ARLEN_S3=ARLEN_M1;
			ARSIZE_S3=ARSIZE_M1;
			ARBURST_S3=ARBURST_M1;
			ARVALID_S3=ARVALID_M1;
					
			RREADY_S3=RREADY_M1; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=ARREADY_S3; //SLAVE interface READ ADDRESS1
			
			RID_M1=RID_S3[3:0]; //SLAVE interface READ DATA1
			RDATA_M1=RDATA_S3;
			RRESP_M1=RRESP_S3;
			RLAST_M1=RLAST_S3;
			RVALID_M1=RVALID_S3;
			
		end
		M1_read_S5: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0;; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5={4'd0,ARID_M1}; //MASTER interface READ ADDRESS5
			ARADDR_S5=ARADDR_M1;
			ARLEN_S5=ARLEN_M1;
			ARSIZE_S5=ARSIZE_M1;
			ARBURST_S5=ARBURST_M1;
			ARVALID_S5=ARVALID_M1;
					
			RREADY_S5=RREADY_M1; //MASTER interface READ DATA5
			
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=ARREADY_S5; //SLAVE interface READ ADDRESS1
			
			RID_M1=RID_S5[3:0]; //SLAVE interface READ DATA1
			RDATA_M1=RDATA_S5;
			RRESP_M1=RRESP_S5;
			RLAST_M1=RLAST_S5;
			RVALID_M1=RVALID_S5;
		end
		default: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
		end
	endcase
end

always_comb begin
	unique case (write_curr_state)
		write_IDLE: begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=1'd0; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=1'd0; //SLAVE interface WRITE DATA
			
			BID_M1=4'd0; //SLAVE interface WRITE RESPONSE
			BRESP_M1=2'd0;
			BVALID_M1=1'd0;
		end
		M1_write_S1: begin
			AWID_S1={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=AWADDR_M1;
			AWLEN_S1=AWLEN_M1;
			AWSIZE_S1=AWSIZE_M1;
			AWBURST_S1=AWBURST_M1;
			AWVALID_S1=AWVALID_M1;
					
			WDATA_S1=WDATA_M1; //MASTER interface WRITE DATA1
			WSTRB_S1=WSTRB_M1;
			WLAST_S1=WLAST_M1;
			WVALID_S1=WVALID_M1;
					
			BREADY_S1=BREADY_M1; //MASTER interface WRITE RESPONSE1
		
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S1; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S1; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S1[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S1;
			BVALID_M1=BVALID_S1;
		end
		M1_write_S2: begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=AWADDR_M1;
			AWLEN_S2=AWLEN_M1;
			AWSIZE_S2=AWSIZE_M1;
			AWBURST_S2=AWBURST_M1;
			AWVALID_S2=AWVALID_M1;
					
			WDATA_S2=WDATA_M1; //MASTER interface WRITE DATA2
			WSTRB_S2=WSTRB_M1;
			WLAST_S2=WLAST_M1;
			WVALID_S2=WVALID_M1;
					
			BREADY_S2=BREADY_M1; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S2; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S2; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S2[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S2;
			BVALID_M1=BVALID_S2;
		end
		M1_write_S3: begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=AWADDR_M1;
			AWLEN_S3=AWLEN_M1;
			AWSIZE_S3=AWSIZE_M1;
			AWBURST_S3=AWBURST_M1;
			AWVALID_S3=AWVALID_M1;
					
			WDATA_S3=WDATA_M1; //MASTER interface WRITE DATA3
			WSTRB_S3=WSTRB_M1;
			WLAST_S3=WLAST_M1;
			WVALID_S3=WVALID_M1;
					
			BREADY_S3=BREADY_M1; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S3; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S3; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S3[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S3;
			BVALID_M1=BVALID_S3;
		end
		M1_write_S4: begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=AWADDR_M1;
			AWLEN_S4=AWLEN_M1;
			AWSIZE_S4=AWSIZE_M1;
			AWBURST_S4=AWBURST_M1;
			AWVALID_S4=AWVALID_M1;
					
			WDATA_S4=WDATA_M1; //MASTER interface WRITE DATA4
			WSTRB_S4=WSTRB_M1;
			WLAST_S4=WLAST_M1;
			WVALID_S4=WVALID_M1;
					
			BREADY_S4=BREADY_M1; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S4; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S4; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S4[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S4;
			BVALID_M1=BVALID_S4;
		end
		M1_write_S5: begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=AWADDR_M1;
			AWLEN_S5=AWLEN_M1;
			AWSIZE_S5=AWSIZE_M1;
			AWBURST_S5=AWBURST_M1;
			AWVALID_S5=AWVALID_M1;
					
			WDATA_S5=WDATA_M1; //MASTER interface WRITE DATA5
			WSTRB_S5=WSTRB_M1;
			WLAST_S5=WLAST_M1;
			WVALID_S5=WVALID_M1;
					
			BREADY_S5=BREADY_M1; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S5; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S5; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S5[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S5;
			BVALID_M1=BVALID_S5;
		end
		M1_write_S6 :begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=AWADDR_M1;
			AWLEN_S6=AWLEN_M1;
			AWSIZE_S6=AWSIZE_M1;
			AWBURST_S6=AWBURST_M1;
			AWVALID_S6=AWVALID_M1;
					
			WDATA_S6=WDATA_M1; //MASTER interface WRITE DATA6
			WSTRB_S6=WSTRB_M1;
			WLAST_S6=WLAST_M1;
			WVALID_S6=WVALID_M1;
					
			BREADY_S6=BREADY_M1; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S6; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S6; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S6[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S6;
			BVALID_M1=BVALID_S6;
		end
		default :begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=1'd0; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=1'd0; //SLAVE interface WRITE DATA
			
			BID_M1=4'd0; //SLAVE interface WRITE RESPONSE
			BRESP_M1=2'd0;
			BVALID_M1=1'd0;
		end
	endcase
end

endmodule

/*
`include "../../include/AXI_define.svh"
`include "../FIFO_AR.sv"
`include "../FIFO_AW.sv"
`include "../FIFO_B.sv"
`include "../FIFO_R.sv"
`include "../FIFO_W.sv"
module AXI(

	input CPU_CLK_i,      
	input ACLK,        
	input ROM_CLK_i,      
	input DRAM_CLK_i,
	input SRAM_CLK_i,
	input PWM_CLK_i,
	input CPU_RST_i,      
	input ARESETn,        
	input ROM_RST_i,      
	input DRAM_RST_i,
	input SRAM_RST_i,   
	input PWM_RST_i, 
	//SLAVE INTERFACE FOR MASTERS
	
	//WRITE ADDRESS
	input [`AXI_ID_BITS-1:0] AWID_M1_F,
	input [`AXI_ADDR_BITS-1:0] AWADDR_M1_F,
	input [`AXI_LEN_BITS-1:0] AWLEN_M1_F,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_M1_F,
	input [1:0] AWBURST_M1_F,
	input AWVALID_M1_F,
	output logic AWREADY_M1_F,
	
	//WRITE DATA
	input [`AXI_DATA_BITS-1:0] WDATA_M1_F,
	input [`AXI_STRB_BITS-1:0] WSTRB_M1_F,
	input WLAST_M1_F,
	input WVALID_M1_F,
	output logic WREADY_M1_F,
	
	//WRITE RESPONSE
	output logic [`AXI_ID_BITS-1:0] BID_M1_F,
	output logic [1:0] BRESP_M1_F,
	output logic BVALID_M1_F,
	input BREADY_M1_F,

	//READ ADDRESS0
	input [`AXI_ID_BITS-1:0] ARID_M0_F,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M0_F,
	input [`AXI_LEN_BITS-1:0] ARLEN_M0_F,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M0_F,
	input [1:0] ARBURST_M0_F,
	input ARVALID_M0_F,
	output logic ARREADY_M0_F,
	
	//READ DATA0
	output logic [`AXI_ID_BITS-1:0] RID_M0_F,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M0_F,
	output logic [1:0] RRESP_M0_F,
	output logic RLAST_M0_F,
	output logic RVALID_M0_F,
	input RREADY_M0_F,
	
	//READ ADDRESS1
	input [`AXI_ID_BITS-1:0] ARID_M1_F,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M1_F,
	input [`AXI_LEN_BITS-1:0] ARLEN_M1_F,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M1_F,
	input [1:0] ARBURST_M1_F,
	input ARVALID_M1_F,
	output logic ARREADY_M1_F,
	
	//READ DATA1
	output logic [`AXI_ID_BITS-1:0] RID_M1_F,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M1_F,
	output logic [1:0] RRESP_M1_F,
	output logic RLAST_M1_F,
	output logic RVALID_M1_F,
	input RREADY_M1_F,




	//MASTER INTERFACE FOR SLAVES

	//READ ADDRESS0   ROM
	output logic [`AXI_IDS_BITS-1:0] ARID_S0_F,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S0_F,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S0_F,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0_F,
	output logic [1:0] ARBURST_S0_F,
	output logic ARVALID_S0_F,
	input ARREADY_S0_F,
	
	//READ DATA0
	input [`AXI_IDS_BITS-1:0] RID_S0_F,
	input [`AXI_DATA_BITS-1:0] RDATA_S0_F,
	input [1:0] RRESP_S0_F,
	input RLAST_S0_F,
	input RVALID_S0_F,
	output logic RREADY_S0_F,
	
	//WRITE ADDRESS1	IM
	output logic [`AXI_IDS_BITS-1:0] AWID_S1_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S1_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S1_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1_F,
	output logic [1:0] AWBURST_S1_F,
	output logic AWVALID_S1_F,
	input AWREADY_S1_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S1_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S1_F,
	output logic WLAST_S1_F,
	output logic WVALID_S1_F,
	input WREADY_S1_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S1_F,
	input [1:0] BRESP_S1_F,
	input BVALID_S1_F,
	output logic BREADY_S1_F,
	
	//READ ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] ARID_S1_F,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S1_F,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S1_F,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1_F,
	output logic [1:0] ARBURST_S1_F,
	output logic ARVALID_S1_F,
	input ARREADY_S1_F,
	
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S1_F,
	input [`AXI_DATA_BITS-1:0] RDATA_S1_F,
	input [1:0] RRESP_S1_F,
	input RLAST_S1_F,
	input RVALID_S1_F,
	output logic RREADY_S1_F,
	
	//WRITE ADDRESS1	DM
	output logic [`AXI_IDS_BITS-1:0] AWID_S2_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S2_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S2_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S2_F,
	output logic [1:0] AWBURST_S2_F,
	output logic AWVALID_S2_F,
	input AWREADY_S2_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S2_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S2_F,
	output logic WLAST_S2_F,
	output logic WVALID_S2_F,
	input WREADY_S2_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S2_F,
	input [1:0] BRESP_S2_F,
	input BVALID_S2_F,
	output logic BREADY_S2_F,
	
	//READ ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] ARID_S2_F,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S2_F,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S2_F,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S2_F,
	output logic [1:0] ARBURST_S2_F,
	output logic ARVALID_S2_F,
	input ARREADY_S2_F,
	
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S2_F,
	input [`AXI_DATA_BITS-1:0] RDATA_S2_F,
	input [1:0] RRESP_S2_F,
	input RLAST_S2_F,
	input RVALID_S2_F,
	output logic RREADY_S2_F,
	
	//WRITE ADDRESS1	sensor_ctrl
	output logic [`AXI_IDS_BITS-1:0] AWID_S3_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S3_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S3_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S3_F,
	output logic [1:0] AWBURST_S3_F,
	output logic AWVALID_S3_F,
	input AWREADY_S3_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S3_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S3_F,
	output logic WLAST_S3_F,
	output logic WVALID_S3_F,
	input WREADY_S3_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S3_F,
	input [1:0] BRESP_S3_F,
	input BVALID_S3_F,
	output logic BREADY_S3_F,
	
	//READ ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] ARID_S3_F,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S3_F,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S3_F,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S3_F,
	output logic [1:0] ARBURST_S3_F,
	output logic ARVALID_S3_F,
	input ARREADY_S3_F,
	
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S3_F,
	input [`AXI_DATA_BITS-1:0] RDATA_S3_F,
	input [1:0] RRESP_S3_F,
	input RLAST_S3_F,
	input RVALID_S3_F,
	output logic RREADY_S3_F,
	
	//WRITE ADDRESS1	WDT
	output logic [`AXI_IDS_BITS-1:0] AWID_S4_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S4_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S4_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S4_F,
	output logic [1:0] AWBURST_S4_F,
	output logic AWVALID_S4_F,
	input AWREADY_S4_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S4_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S4_F,
	output logic WLAST_S4_F,
	output logic WVALID_S4_F,
	input WREADY_S4_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S4_F,
	input [1:0] BRESP_S4_F,
	input BVALID_S4_F,
	output logic BREADY_S4_F,
	
	
	//WRITE ADDRESS1	DRAM
	output logic [`AXI_IDS_BITS-1:0] AWID_S5_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S5_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S5_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S5_F,
	output logic [1:0] AWBURST_S5_F,
	output logic AWVALID_S5_F,
	input AWREADY_S5_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S5_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S5_F,
	output logic WLAST_S5_F,
	output logic WVALID_S5_F,
	input WREADY_S5_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S5_F,
	input [1:0] BRESP_S5_F,
	input BVALID_S5_F,
	output logic BREADY_S5_F,
	
	//READ ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] ARID_S5_F,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S5_F,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S5_F,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S5_F,
	output logic [1:0] ARBURST_S5_F,
	output logic ARVALID_S5_F,
	input ARREADY_S5_F,
	
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S5_F,
	input [`AXI_DATA_BITS-1:0] RDATA_S5_F,
	input [1:0] RRESP_S5_F,
	input RLAST_S5_F,
	input RVALID_S5_F,
	output logic RREADY_S5_F,
	
	//WRITE ADDRESS1	PWM
	output logic [`AXI_IDS_BITS-1:0] AWID_S6_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S6_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S6_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S6_F,
	output logic [1:0] AWBURST_S6_F,
	output logic AWVALID_S6_F,
	input AWREADY_S6_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S6_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S6_F,
	output logic WLAST_S6_F,
	output logic WVALID_S6_F,
	input WREADY_S6_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S6_F,
	input [1:0] BRESP_S6_F,
	input BVALID_S6_F,
	output logic BREADY_S6_F
);
    //---------- you should put your design here ----------//

//state machine
parameter read_IDLE=4'd0;
parameter M0_read_S0=4'd1; //ROM
parameter M0_read_S1=4'd2; //IM
parameter M0_read_S2=4'd3; //DM
parameter M0_read_S3=4'd4; //sensor_ctrl
parameter M0_read_S5=4'd6; //DRAM

parameter M1_read_S0=4'd7; //ROM
parameter M1_read_S1=4'd8; //IM
parameter M1_read_S2=4'd9; //DM
parameter M1_read_S3=4'd10; //sensor_ctrl
parameter M1_read_S5=4'd12; //DRAM


parameter write_IDLE=3'd0;
parameter M1_write_S1=3'd1; //IM
parameter M1_write_S2=3'd2; //DM
parameter M1_write_S3=3'd3; //sensor_ctrl
parameter M1_write_S4=3'd4; //WDT
parameter M1_write_S5=3'd5; //DRAM
parameter M1_write_S6=3'd6; //PWM

logic [3:0] read_curr_state,read_next_state;
logic [2:0] write_curr_state,write_next_state;

//SLAVE INTERFACE FOR MASTERS
	
	//WRITE ADDRESS
logic [`AXI_ID_BITS-1:0] AWID_M1;
logic [`AXI_ADDR_BITS-1:0] AWADDR_M1;
logic [`AXI_LEN_BITS-1:0] AWLEN_M1;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_M1;
logic [1:0] AWBURST_M1;
logic AWVALID_M1;
logic AWREADY_M1;
	
//WRITE DATA
logic [`AXI_DATA_BITS-1:0] WDATA_M1;
logic [`AXI_STRB_BITS-1:0] WSTRB_M1;
logic WLAST_M1;
logic WVALID_M1;
logic WREADY_M1;

//WRITE RESPONSE
logic [`AXI_ID_BITS-1:0] BID_M1;
logic [1:0] BRESP_M1;
logic BVALID_M1;
logic BREADY_M1;

//READ ADDRESS0
logic [`AXI_ID_BITS-1:0] ARID_M0;
logic [`AXI_ADDR_BITS-1:0] ARADDR_M0;
logic [`AXI_LEN_BITS-1:0] ARLEN_M0;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_M0;
logic [1:0] ARBURST_M0;
logic ARVALID_M0;
logic ARREADY_M0;

//READ DATA0
logic [`AXI_ID_BITS-1:0] RID_M0;
logic [`AXI_DATA_BITS-1:0] RDATA_M0;
logic [1:0] RRESP_M0;
logic RLAST_M0;
logic RVALID_M0;
logic RREADY_M0;

//READ ADDRESS1
logic [`AXI_ID_BITS-1:0] ARID_M1;
logic [`AXI_ADDR_BITS-1:0] ARADDR_M1;
logic [`AXI_LEN_BITS-1:0] ARLEN_M1;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_M1;
logic [1:0] ARBURST_M1;
logic ARVALID_M1;
logic ARREADY_M1;

//READ DATA1
logic [`AXI_ID_BITS-1:0] RID_M1;
logic [`AXI_DATA_BITS-1:0] RDATA_M1;
logic [1:0] RRESP_M1;
logic RLAST_M1;
logic RVALID_M1;
logic RREADY_M1;




//MASTER INTERFACE FOR SLAVES

//READ ADDRESS0   ROM
logic [`AXI_IDS_BITS-1:0] ARID_S0;
logic [`AXI_ADDR_BITS-1:0] ARADDR_S0;
logic [`AXI_LEN_BITS-1:0] ARLEN_S0;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0;
logic [1:0] ARBURST_S0;
logic ARVALID_S0;
logic ARREADY_S0;

//READ DATA0
logic [`AXI_IDS_BITS-1:0] RID_S0;
logic [`AXI_DATA_BITS-1:0] RDATA_S0;
logic [1:0] RRESP_S0;
logic RLAST_S0;
logic RVALID_S0;
logic RREADY_S0;

//WRITE ADDRESS1	IM
logic [`AXI_IDS_BITS-1:0] AWID_S1;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S1;
logic [`AXI_LEN_BITS-1:0] AWLEN_S1;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1;
logic [1:0] AWBURST_S1;
logic AWVALID_S1;
logic AWREADY_S1;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S1;
logic [`AXI_STRB_BITS-1:0] WSTRB_S1;
logic WLAST_S1;
logic WVALID_S1;
logic WREADY_S1;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S1;
logic [1:0] BRESP_S1;
logic BVALID_S1;
logic BREADY_S1;

//READ ADDRESS1
logic [`AXI_IDS_BITS-1:0] ARID_S1;
logic [`AXI_ADDR_BITS-1:0] ARADDR_S1;
logic [`AXI_LEN_BITS-1:0] ARLEN_S1;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1;
logic [1:0] ARBURST_S1;
logic ARVALID_S1;
logic ARREADY_S1;

//READ DATA1
logic [`AXI_IDS_BITS-1:0] RID_S1;
logic [`AXI_DATA_BITS-1:0] RDATA_S1;
logic [1:0] RRESP_S1;
logic RLAST_S1;
logic RVALID_S1;
logic RREADY_S1;

//WRITE ADDRESS1	DM
logic [`AXI_IDS_BITS-1:0] AWID_S2;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S2;
logic [`AXI_LEN_BITS-1:0] AWLEN_S2;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S2;
logic [1:0] AWBURST_S2;
logic AWVALID_S2;
logic AWREADY_S2;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S2;
logic [`AXI_STRB_BITS-1:0] WSTRB_S2;
logic WLAST_S2;
logic WVALID_S2;
logic WREADY_S2;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S2;
logic [1:0] BRESP_S2;
logic BVALID_S2;
logic BREADY_S2;

//READ ADDRESS1
logic [`AXI_IDS_BITS-1:0] ARID_S2;
logic [`AXI_ADDR_BITS-1:0] ARADDR_S2;
logic [`AXI_LEN_BITS-1:0] ARLEN_S2;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_S2;
logic [1:0] ARBURST_S2;
logic ARVALID_S2;
logic ARREADY_S2;

//READ DATA1
logic [`AXI_IDS_BITS-1:0] RID_S2;
logic [`AXI_DATA_BITS-1:0] RDATA_S2;
logic [1:0] RRESP_S2;
logic RLAST_S2;
logic RVALID_S2;
logic RREADY_S2;

//WRITE ADDRESS1	sensor_ctrl
logic [`AXI_IDS_BITS-1:0] AWID_S3;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S3;
logic [`AXI_LEN_BITS-1:0] AWLEN_S3;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S3;
logic [1:0] AWBURST_S3;
logic AWVALID_S3;
logic AWREADY_S3;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S3;
logic [`AXI_STRB_BITS-1:0] WSTRB_S3;
logic WLAST_S3;
logic WVALID_S3;
logic WREADY_S3;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S3;
logic [1:0] BRESP_S3;
logic BVALID_S3;
logic BREADY_S3;

//READ ADDRESS1
logic [`AXI_IDS_BITS-1:0] ARID_S3;
logic [`AXI_ADDR_BITS-1:0] ARADDR_S3;
logic [`AXI_LEN_BITS-1:0] ARLEN_S3;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_S3;
logic [1:0] ARBURST_S3;
logic ARVALID_S3;
logic ARREADY_S3;

//READ DATA1
logic [`AXI_IDS_BITS-1:0] RID_S3;
logic [`AXI_DATA_BITS-1:0] RDATA_S3;
logic [1:0] RRESP_S3;
logic RLAST_S3;
logic RVALID_S3;
logic RREADY_S3;

//WRITE ADDRESS1	WDT
logic [`AXI_IDS_BITS-1:0] AWID_S4;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S4;
logic [`AXI_LEN_BITS-1:0] AWLEN_S4;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S4;
logic [1:0] AWBURST_S4;
logic AWVALID_S4;
logic AWREADY_S4;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S4;
logic [`AXI_STRB_BITS-1:0] WSTRB_S4;
logic WLAST_S4;
logic WVALID_S4;
logic WREADY_S4;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S4;
logic [1:0] BRESP_S4;
logic BVALID_S4;
logic BREADY_S4;


//WRITE ADDRESS1	DRAM
logic [`AXI_IDS_BITS-1:0] AWID_S5;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S5;
logic [`AXI_LEN_BITS-1:0] AWLEN_S5;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S5;
logic [1:0] AWBURST_S5;
logic AWVALID_S5;
logic AWREADY_S5;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S5;
logic [`AXI_STRB_BITS-1:0] WSTRB_S5;
logic WLAST_S5;
logic WVALID_S5;
logic WREADY_S5;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S5;
logic [1:0] BRESP_S5;
logic BVALID_S5;
logic BREADY_S5;

//READ ADDRESS1
logic [`AXI_IDS_BITS-1:0] ARID_S5;
logic [`AXI_ADDR_BITS-1:0] ARADDR_S5;
logic [`AXI_LEN_BITS-1:0] ARLEN_S5;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_S5;
logic [1:0] ARBURST_S5;
logic ARVALID_S5;
logic ARREADY_S5;

//READ DATA1
logic [`AXI_IDS_BITS-1:0] RID_S5;
logic [`AXI_DATA_BITS-1:0] RDATA_S5;
logic [1:0] RRESP_S5;
logic RLAST_S5;
logic RVALID_S5;
logic RREADY_S5;

//WRITE ADDRESS1	PWM
logic [`AXI_IDS_BITS-1:0] AWID_S6;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S6;
logic [`AXI_LEN_BITS-1:0] AWLEN_S6;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S6;
logic [1:0] AWBURST_S6;
logic AWVALID_S6;
logic AWREADY_S6;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S6;
logic [`AXI_STRB_BITS-1:0] WSTRB_S6;
logic WLAST_S6;
logic WVALID_S6;
logic WREADY_S6;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S6;
logic [1:0] BRESP_S6;
logic BVALID_S6;
logic BREADY_S6;


logic [48:0] aw_s1_wdata,aw_s1_rdata;
logic [48:0] aw_m1_wdata,aw_m1_rdata;
logic [48:0] aw_m2_wdata,aw_m2_rdata;
logic [48:0] aw_m3_wdata,aw_m3_rdata;
logic [48:0] aw_m4_wdata,aw_m4_rdata;
logic [48:0] aw_m5_wdata,aw_m5_rdata;
logic [48:0] aw_m6_wdata,aw_m6_rdata;

assign aw_s1_wdata={4'd0,AWID_M1_F,AWADDR_M1_F,AWLEN_M1_F,AWSIZE_M1_F,AWBURST_M1_F};
assign AWID_M1=aw_s1_rdata[44:41];
assign AWADDR_M1=aw_s1_rdata[40:9];
assign AWLEN_M1=aw_s1_rdata[8:5];
assign AWSIZE_M1=aw_s1_rdata[4:2];
assign AWBURST_M1=aw_s1_rdata[1:0];

assign aw_m1_wdata={AWID_S1,AWADDR_S1,AWLEN_S1,AWSIZE_S1,AWBURST_S1};
assign AWID_S1_F=aw_m1_rdata[48:41];
assign AWADDR_S1_F=aw_m1_rdata[40:9];
assign AWLEN_S1_F=aw_m1_rdata[8:5];
assign AWSIZE_S1_F=aw_m1_rdata[4:2];
assign AWBURST_S1_F=aw_m1_rdata[1:0];

assign aw_m2_wdata={AWID_S2,AWADDR_S2,AWLEN_S2,AWSIZE_S2,AWBURST_S2};
assign AWID_S2_F=aw_m2_rdata[48:41];
assign AWADDR_S2_F=aw_m2_rdata[40:9];
assign AWLEN_S2_F=aw_m2_rdata[8:5];
assign AWSIZE_S2_F=aw_m2_rdata[4:2];
assign AWBURST_S2_F=aw_m2_rdata[1:0];

assign aw_m3_wdata={AWID_S3,AWADDR_S3,AWLEN_S3,AWSIZE_S3,AWBURST_S3};
assign AWID_S3_F=aw_m3_rdata[48:41];
assign AWADDR_S3_F=aw_m3_rdata[40:9];
assign AWLEN_S3_F=aw_m3_rdata[8:5];
assign AWSIZE_S3_F=aw_m3_rdata[4:2];
assign AWBURST_S3_F=aw_m3_rdata[1:0];

assign aw_m4_wdata={AWID_S4,AWADDR_S4,AWLEN_S4,AWSIZE_S4,AWBURST_S4};
assign AWID_S4_F=aw_m4_rdata[48:41];
assign AWADDR_S4_F=aw_m4_rdata[40:9];
assign AWLEN_S4_F=aw_m4_rdata[8:5];
assign AWSIZE_S4_F=aw_m4_rdata[4:2];
assign AWBURST_S4_F=aw_m4_rdata[1:0];

assign aw_m5_wdata={AWID_S5,AWADDR_S5,AWLEN_S5,AWSIZE_S5,AWBURST_S5};
assign AWID_S5_F=aw_m5_rdata[48:41];
assign AWADDR_S5_F=aw_m5_rdata[40:9];
assign AWLEN_S5_F=aw_m5_rdata[8:5];
assign AWSIZE_S5_F=aw_m5_rdata[4:2];
assign AWBURST_S5_F=aw_m5_rdata[1:0];

assign aw_m6_wdata={AWID_S6,AWADDR_S6,AWLEN_S6,AWSIZE_S6,AWBURST_S6};
assign AWID_S6_F=aw_m6_rdata[48:41];
assign AWADDR_S6_F=aw_m6_rdata[40:9];
assign AWLEN_S6_F=aw_m6_rdata[8:5];
assign AWSIZE_S6_F=aw_m6_rdata[4:2];
assign AWBURST_S6_F=aw_m6_rdata[1:0];

//aw
FIFO_AW aw_s1(
	.wdata(aw_s1_wdata),
	.valid_i(AWVALID_M1_F),
	.valid_o(AWVALID_M1),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(aw_s1_rdata),
	.ready_i(AWREADY_M1),
	.ready_o(AWREADY_M1_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_AW aw_m1(
	.wdata(aw_m1_wdata),
	.valid_i(AWVALID_S1),
	.valid_o(AWVALID_S1_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m1_rdata),
	.ready_i(AWREADY_S1_F),
	.ready_o(AWREADY_S1),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);

FIFO_AW aw_m2(
	.wdata(aw_m2_wdata),
	.valid_i(AWVALID_S2),
	.valid_o(AWVALID_S2_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m2_rdata),
	.ready_i(AWREADY_S2_F),
	.ready_o(AWREADY_S2),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);
FIFO_AW aw_m3(
	.wdata(aw_m3_wdata),
	.valid_i(AWVALID_S3),
	.valid_o(AWVALID_S3_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m3_rdata),
	.ready_i(AWREADY_S3_F),
	.ready_o(AWREADY_S3),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_AW aw_m4(
	.wdata(aw_m4_wdata),
	.valid_i(AWVALID_S4),
	.valid_o(AWVALID_S4_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m4_rdata),
	.ready_i(AWREADY_S4_F),
	.ready_o(AWREADY_S4),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_AW aw_m5(
	.wdata(aw_m5_wdata),
	.valid_i(AWVALID_S5),
	.valid_o(AWVALID_S5_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m5_rdata),
	.ready_i(AWREADY_S5_F),
	.ready_o(AWREADY_S5),
	.rrst_n(~DRAM_RST_i),
	.rclk(DRAM_CLK_i)
);

FIFO_AW aw_m6(
	.wdata(aw_m6_wdata),
	.valid_i(AWVALID_S6),
	.valid_o(AWVALID_S6_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m6_rdata),
	.ready_i(AWREADY_S6_F),
	.ready_o(AWREADY_S6),
	.rrst_n(~PWM_RST_i),
	.rclk(PWM_CLK_i)
);

logic [36:0] w_s1_wdata,w_s1_rdata;
logic [36:0] w_m1_wdata,w_m1_rdata;
logic [36:0] w_m2_wdata,w_m2_rdata;
logic [36:0] w_m3_wdata,w_m3_rdata;
logic [36:0] w_m4_wdata,w_m4_rdata;
logic [36:0] w_m5_wdata,w_m5_rdata;
logic [36:0] w_m6_wdata,w_m6_rdata;

assign w_s1_wdata={WDATA_M1_F,WSTRB_M1_F,WLAST_M1_F};
assign WDATA_M1=w_s1_rdata[36:5];
assign WSTRB_M1=w_s1_rdata[4:1];
assign WLAST_M1=w_s1_rdata[0];

assign w_m1_wdata={WDATA_S1,WSTRB_S1,WLAST_S1};
assign WDATA_S1_F=w_m1_rdata[36:5];
assign WSTRB_S1_F=w_m1_rdata[4:1];
assign WLAST_S1_F=w_m1_rdata[0];

assign w_m2_wdata={WDATA_S2,WSTRB_S2,WLAST_S2};
assign WDATA_S2_F=w_m2_rdata[36:5];
assign WSTRB_S2_F=w_m2_rdata[4:1];
assign WLAST_S2_F=w_m2_rdata[0];

assign w_m3_wdata={WDATA_S3,WSTRB_S3,WLAST_S3};
assign WDATA_S3_F=w_m3_rdata[36:5];
assign WSTRB_S3_F=w_m3_rdata[4:1];
assign WLAST_S3_F=w_m3_rdata[0];

assign w_m4_wdata={WDATA_S4,WSTRB_S4,WLAST_S4};
assign WDATA_S4_F=w_m4_rdata[36:5];
assign WSTRB_S4_F=w_m4_rdata[4:1];
assign WLAST_S4_F=w_m4_rdata[0];

assign w_m5_wdata={WDATA_S5,WSTRB_S5,WLAST_S5};
assign WDATA_S5_F=w_m5_rdata[36:5];
assign WSTRB_S5_F=w_m5_rdata[4:1];
assign WLAST_S5_F=w_m5_rdata[0];

assign w_m6_wdata={WDATA_S6,WSTRB_S6,WLAST_S6};
assign WDATA_S6_F=w_m6_rdata[36:5];
assign WSTRB_S6_F=w_m6_rdata[4:1];
assign WLAST_S6_F=w_m6_rdata[0];

//w
FIFO_W w_s1(
	.wdata(w_s1_wdata),
	.valid_i(WVALID_M1_F),
	.valid_o(WVALID_M1),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(w_s1_rdata),
	.ready_i(WREADY_M1),
	.ready_o(WREADY_M1_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_W w_m1(
	.wdata(w_m1_wdata),
	.valid_i(WVALID_S1),
	.valid_o(WVALID_S1_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m1_rdata),
	.ready_i(WREADY_S1_F),
	.ready_o(WREADY_S1),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);

FIFO_W w_m2(
	.wdata(w_m2_wdata),
	.valid_i(WVALID_S2),
	.valid_o(WVALID_S2_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m2_rdata),
	.ready_i(WREADY_S2_F),
	.ready_o(WREADY_S2),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);

FIFO_W w_m3(
	.wdata(w_m3_wdata),
	.valid_i(WVALID_S3),
	.valid_o(WVALID_S3_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m3_rdata),
	.ready_i(WREADY_S3_F),
	.ready_o(WREADY_S3),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_W w_m4(
	.wdata(w_m4_wdata),
	.valid_i(WVALID_S4),
	.valid_o(WVALID_S4_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m4_rdata),
	.ready_i(WREADY_S4_F),
	.ready_o(WREADY_S4),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_W w_m5(
	.wdata(w_m5_wdata),
	.valid_i(WVALID_S5),
	.valid_o(WVALID_S5_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m5_rdata),
	.ready_i(WREADY_S5_F),
	.ready_o(WREADY_S5),
	.rrst_n(~DRAM_RST_i),
	.rclk(DRAM_CLK_i)
);

FIFO_W w_m6(
	.wdata(w_m6_wdata),
	.valid_i(WVALID_S6),
	.valid_o(WVALID_S6_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m6_rdata),
	.ready_i(WREADY_S6_F),
	.ready_o(WREADY_S6),
	.rrst_n(~PWM_RST_i),
	.rclk(PWM_CLK_i)
);

logic [9:0] b_s1_wdata,b_s1_rdata;
logic [9:0] b_m1_wdata,b_m1_rdata;
logic [9:0] b_m2_wdata,b_m2_rdata;
logic [9:0] b_m3_wdata,b_m3_rdata;
logic [9:0] b_m4_wdata,b_m4_rdata;
logic [9:0] b_m5_wdata,b_m5_rdata;
logic [9:0] b_m6_wdata,b_m6_rdata;

assign b_s1_wdata={4'd0,BID_M1,BRESP_M1};
assign BID_M1_F=b_s1_rdata[5:2];
assign BRESP_M1_F=b_s1_rdata[1:0];

assign b_m1_wdata={BID_S1_F,BRESP_S1_F};
assign BID_S1=b_m1_rdata[9:2];
assign BRESP_S1=b_m1_rdata[1:0];

assign b_m2_wdata={BID_S2_F,BRESP_S2_F};
assign BID_S2=b_m2_rdata[9:2];
assign BRESP_S2=b_m2_rdata[1:0];

assign b_m3_wdata={BID_S3_F,BRESP_S3_F};
assign BID_S3=b_m3_rdata[9:2];
assign BRESP_S3=b_m3_rdata[1:0];

assign b_m4_wdata={BID_S4_F,BRESP_S4_F};
assign BID_S4=b_m4_rdata[9:2];
assign BRESP_S4=b_m4_rdata[1:0];

assign b_m5_wdata={BID_S5_F,BRESP_S5_F};
assign BID_S5=b_m5_rdata[9:2];
assign BRESP_S5=b_m5_rdata[1:0];

assign b_m6_wdata={BID_S6_F,BRESP_S6_F};
assign BID_S6=b_m6_rdata[9:2];
assign BRESP_S6=b_m6_rdata[1:0];

//b
FIFO_B b_s1(
	.wdata(b_s1_wdata),
	.valid_i(BVALID_M1),
	.valid_o(BVALID_M1_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(b_s1_rdata),
	.ready_i(BREADY_M1_F),
	.ready_o(BREADY_M1),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_B b_m1(
	.wdata(b_m1_wdata),
	.valid_i(BVALID_S1_F),
	.valid_o(BVALID_S1),
	.wrst_n(~SRAM_RST_i),
	.wclk(SRAM_CLK_i),
	.rdata(b_m1_rdata),
	.ready_i(BREADY_S1),
	.ready_o(BREADY_S1_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_B b_m2(
	.wdata(b_m2_wdata),
	.valid_i(BVALID_S2_F),
	.valid_o(BVALID_S2),
	.wrst_n(~SRAM_RST_i),
	.wclk(SRAM_CLK_i),
	.rdata(b_m2_rdata),
	.ready_i(BREADY_S2),
	.ready_o(BREADY_S2_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_B b_m3(
	.wdata(b_m3_wdata),
	.valid_i(BVALID_S3_F),
	.valid_o(BVALID_S3),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(b_m3_rdata),
	.ready_i(BREADY_S3),
	.ready_o(BREADY_S3_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_B b_m4(
	.wdata(b_m4_wdata),
	.valid_i(BVALID_S4_F),
	.valid_o(BVALID_S4),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(b_m4_rdata),
	.ready_i(BREADY_S4),
	.ready_o(BREADY_S4_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_B b_m5(
	.wdata(b_m5_wdata),
	.valid_i(BVALID_S5_F),
	.valid_o(BVALID_S5),
	.wrst_n(~DRAM_RST_i),
	.wclk(DRAM_CLK_i),
	.rdata(b_m5_rdata),
	.ready_i(BREADY_S5),
	.ready_o(BREADY_S5_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_B b_m6(
	.wdata(b_m6_wdata),
	.valid_i(BVALID_S6_F),
	.valid_o(BVALID_S6),
	.wrst_n(~PWM_RST_i),
	.wclk(PWM_CLK_i),
	.rdata(b_m6_rdata),
	.ready_i(BREADY_S6),
	.ready_o(BREADY_S6_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

logic [48:0] ar_s0_wdata,ar_s0_rdata;						 
logic [48:0] ar_s1_wdata,ar_s1_rdata;
logic [48:0] ar_m0_wdata,ar_m0_rdata;
logic [48:0] ar_m1_wdata,ar_m1_rdata;
logic [48:0] ar_m2_wdata,ar_m2_rdata;
logic [48:0] ar_m3_wdata,ar_m3_rdata;
logic [48:0] ar_m5_wdata,ar_m5_rdata;

assign ar_s0_wdata={4'd0,ARID_M0_F,ARADDR_M0_F,ARLEN_M0_F,ARSIZE_M0_F,ARBURST_M0_F};
assign ARID_M0=ar_s0_rdata[44:41];
assign ARADDR_M0=ar_s0_rdata[40:9];
assign ARLEN_M0=ar_s0_rdata[8:5];
assign ARSIZE_M0=ar_s0_rdata[4:2];
assign ARBURST_M0=ar_s0_rdata[1:0];

assign ar_s1_wdata={4'd0,ARID_M1_F,ARADDR_M1_F,ARLEN_M1_F,ARSIZE_M1_F,ARBURST_M1_F};
assign ARID_M1=ar_s1_rdata[44:41];
assign ARADDR_M1=ar_s1_rdata[40:9];
assign ARLEN_M1=ar_s1_rdata[8:5];
assign ARSIZE_M1=ar_s1_rdata[4:2];
assign ARBURST_M1=ar_s1_rdata[1:0];

assign ar_m0_wdata={ARID_S0,ARADDR_S0,ARLEN_S0,ARSIZE_S0,ARBURST_S0};
assign ARID_S0_F=ar_m0_rdata[48:41];
assign ARADDR_S0_F=ar_m0_rdata[40:9];
assign ARLEN_S0_F=ar_m0_rdata[8:5];
assign ARSIZE_S0_F=ar_m0_rdata[4:2];
assign ARBURST_S0_F=ar_m0_rdata[1:0];

assign ar_m1_wdata={ARID_S1,ARADDR_S1,ARLEN_S1,ARSIZE_S1,ARBURST_S1};
assign ARID_S1_F=ar_m1_rdata[48:41];
assign ARADDR_S1_F=ar_m1_rdata[40:9];
assign ARLEN_S1_F=ar_m1_rdata[8:5];
assign ARSIZE_S1_F=ar_m1_rdata[4:2];
assign ARBURST_S1_F=ar_m1_rdata[1:0];

assign ar_m2_wdata={ARID_S2,ARADDR_S2,ARLEN_S2,ARSIZE_S2,ARBURST_S2};
assign ARID_S2_F=ar_m2_rdata[48:41];
assign ARADDR_S2_F=ar_m2_rdata[40:9];
assign ARLEN_S2_F=ar_m2_rdata[8:5];
assign ARSIZE_S2_F=ar_m2_rdata[4:2];
assign ARBURST_S2_F=ar_m2_rdata[1:0];

assign ar_m3_wdata={ARID_S3,ARADDR_S3,ARLEN_S3,ARSIZE_S3,ARBURST_S3};
assign ARID_S3_F=ar_m3_rdata[48:41];
assign ARADDR_S3_F=ar_m3_rdata[40:9];
assign ARLEN_S3_F=ar_m3_rdata[8:5];
assign ARSIZE_S3_F=ar_m3_rdata[4:2];
assign ARBURST_S3_F=ar_m3_rdata[1:0];

assign ar_m5_wdata={ARID_S5,ARADDR_S5,ARLEN_S5,ARSIZE_S5,ARBURST_S5};
assign ARID_S5_F=ar_m5_rdata[48:41];
assign ARADDR_S5_F=ar_m5_rdata[40:9];
assign ARLEN_S5_F=ar_m5_rdata[8:5];
assign ARSIZE_S5_F=ar_m5_rdata[4:2];
assign ARBURST_S5_F=ar_m5_rdata[1:0];

//ar
FIFO_AR ar_s0(
	.wdata(ar_s0_wdata),
	.valid_i(ARVALID_M0_F),
	.valid_o(ARVALID_M0),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(ar_s0_rdata),
	.ready_i(ARREADY_M0),
	.ready_o(ARREADY_M0_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_AR ar_s1(
	.wdata(ar_s1_wdata),
	.valid_i(ARVALID_M1_F),
	.valid_o(ARVALID_M1),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(ar_s1_rdata),
	.ready_i(ARREADY_M1),
	.ready_o(ARREADY_M1_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_AR ar_m0(
	.wdata(ar_m0_wdata),
	.valid_i(ARVALID_S0),
	.valid_o(ARVALID_S0_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(ar_m0_rdata),
	.ready_i(ARREADY_S0_F),
	.ready_o(ARREADY_S0),
	.rrst_n(~ROM_RST_i),
	.rclk(ROM_CLK_i)
);

FIFO_AR ar_m1(
	.wdata(ar_m1_wdata),
	.valid_i(ARVALID_S1),
	.valid_o(ARVALID_S1_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(ar_m1_rdata),
	.ready_i(ARREADY_S1_F),
	.ready_o(ARREADY_S1),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);

FIFO_AR ar_m2(
	.wdata(ar_m2_wdata),
	.valid_i(ARVALID_S2),
	.valid_o(ARVALID_S2_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(ar_m2_rdata),
	.ready_i(ARREADY_S2_F),
	.ready_o(ARREADY_S2),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);

FIFO_AR ar_m3(
	.wdata(ar_m3_wdata),
	.valid_i(ARVALID_S3),
	.valid_o(ARVALID_S3_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(ar_m3_rdata),
	.ready_i(ARREADY_S3_F),
	.ready_o(ARREADY_S3),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_AR ar_m5(
	.wdata(ar_m5_wdata),
	.valid_i(ARVALID_S5),
	.valid_o(ARVALID_S5_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(ar_m5_rdata),
	.ready_i(ARREADY_S5_F),
	.ready_o(ARREADY_S5),
	.rrst_n(~DRAM_RST_i),
	.rclk(DRAM_CLK_i)
);

logic [41:0] r_s0_wdata,r_s0_rdata;
logic [41:0] r_s1_wdata,r_s1_rdata;
logic [41:0] r_m0_wdata,r_m0_rdata;
logic [41:0] r_m1_wdata,r_m1_rdata;
logic [41:0] r_m2_wdata,r_m2_rdata;
logic [41:0] r_m3_wdata,r_m3_rdata;
logic [41:0] r_m5_wdata,r_m5_rdata;

assign r_s0_wdata={4'd0,RID_M0,RDATA_M0,RRESP_M0};
assign RID_M0_F=r_s0_rdata[37:34];
assign RDATA_M0_F=r_s0_rdata[33:2];
assign RRESP_M0_F=r_s0_rdata[1:0];

assign r_s1_wdata={4'd0,RID_M1,RDATA_M1,RRESP_M1};
assign RID_M1_F=r_s1_rdata[37:34];
assign RDATA_M1_F=r_s1_rdata[33:2];
assign RRESP_M1_F=r_s1_rdata[1:0];

assign r_m0_wdata={RID_S0_F,RDATA_S0_F,RRESP_S0_F};
assign RID_S0=r_m0_rdata[41:34];
assign RDATA_S0=r_m0_rdata[33:2];
assign RRESP_S0=r_m0_rdata[1:0];

assign r_m1_wdata={RID_S1_F,RDATA_S1_F,RRESP_S1_F};
assign RID_S1=r_m1_rdata[41:34];
assign RDATA_S1=r_m1_rdata[33:2];
assign RRESP_S1=r_m1_rdata[1:0];

assign r_m2_wdata={RID_S2_F,RDATA_S2_F,RRESP_S2_F};
assign RID_S2=r_m2_rdata[41:34];
assign RDATA_S2=r_m2_rdata[33:2];
assign RRESP_S2=r_m2_rdata[1:0];

assign r_m3_wdata={RID_S3_F,RDATA_S3_F,RRESP_S3_F};
assign RID_S3=r_m3_rdata[41:34];
assign RDATA_S3=r_m3_rdata[33:2];
assign RRESP_S3=r_m3_rdata[1:0];

assign r_m5_wdata={RID_S5_F,RDATA_S5_F,RRESP_S5_F};
assign RID_S5=r_m5_rdata[41:34];
assign RDATA_S5=r_m5_rdata[33:2];
assign RRESP_S5=r_m5_rdata[1:0];
//r
FIFO_R r_s0(
	.wdata(r_s0_wdata),
	.valid_i(RVALID_M0),
	.valid_o(RVALID_M0_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(r_s0_rdata),
	.ready_i(RREADY_M0_F),
	.ready_o(RREADY_M0),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_R r_s1(
	.wdata(r_s1_wdata),
	.valid_i(RVALID_M1),
	.valid_o(RVALID_M1_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(r_s1_rdata),
	.ready_i(RREADY_M1_F),
	.ready_o(RREADY_M1),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_R r_m0(
	.wdata(r_m0_wdata),
	.valid_i(RVALID_S0_F),
	.valid_o(RVALID_S0),
	.wrst_n(~ROM_RST_i),
	.wclk(ROM_CLK_i),
	.rdata(r_m0_rdata),
	.ready_i(RREADY_S0),
	.ready_o(RREADY_S0_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_R r_m1(
	.wdata(r_m1_wdata),
	.valid_i(RVALID_S1_F),
	.valid_o(RVALID_S1),
	.wrst_n(~SRAM_RST_i),
	.wclk(SRAM_CLK_i),
	.rdata(r_m1_rdata),
	.ready_i(RREADY_S1),
	.ready_o(RREADY_S1_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_R r_m2(
	.wdata(r_m2_wdata),
	.valid_i(RVALID_S2_F),
	.valid_o(RVALID_S2),
	.wrst_n(~SRAM_RST_i),
	.wclk(SRAM_CLK_i),
	.rdata(r_m2_rdata),
	.ready_i(RREADY_S2),
	.ready_o(RREADY_S2_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_R r_m3(
	.wdata(r_m3_wdata),
	.valid_i(RVALID_S3_F),
	.valid_o(RVALID_S3),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(r_m3_rdata),
	.ready_i(RREADY_S3),
	.ready_o(RREADY_S3_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_R r_m5(
	.wdata(r_m5_wdata),
	.valid_i(RVALID_S5_F),
	.valid_o(RVALID_S5),
	.wrst_n(~DRAM_RST_i),
	.wclk(DRAM_CLK_i),
	.rdata(r_m5_rdata),
	.ready_i(RREADY_S5),
	.ready_o(RREADY_S5_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

logic [2:0] counter_S0;
always_ff@(posedge CPU_CLK_i ) begin
	if(~CPU_RST_i) counter_S0<=3'd0;
	else if(RVALID_M0_F==1'd1) counter_S0<=counter_S0+3'd1;
	else if(counter_S0==3'd4) counter_S0<=3'd0;
	else counter_S0<=counter_S0;
end
assign RLAST_M0_F=(counter_S0==3'd3)?RVALID_M0_F:1'd0;

logic [2:0] counter_S1;
always_ff@(posedge CPU_CLK_i ) begin
	if(~CPU_RST_i) counter_S1<=3'd0;
	else if(RVALID_M1_F==1'd1) counter_S1<=counter_S1+3'd1;
	else if(counter_S1==3'd4) counter_S1<=3'd0;
	else counter_S1<=counter_S1;
end
//assign RLAST_M1_F=(counter_S1==3'd3)?RVALID_M1_F:1'd0;
logic [3:0] len_reg;
always_comb begin
	if(len_reg==4'd0) RLAST_M1_F=RVALID_M1_F;
	else if(counter_S1==3'd3) RLAST_M1_F=RVALID_M1_F;
	else RLAST_M1_F=1'd0;
end

always_ff@(posedge CPU_CLK_i) begin
	if(~CPU_RST_i) len_reg<=4'd1;
	else if(ARVALID_M1_F==1'd1) len_reg<=ARLEN_M1_F;
	else len_reg<=len_reg;
end

logic [2:0] counter_M0;
always_ff@(posedge ACLK ) begin
	if(~ARESETn) counter_M0<=3'd0;
	else if(RVALID_S0==1'd1) counter_M0<=counter_M0+3'd1;
	else if(counter_M0==3'd4) counter_M0<=3'd0;
	else counter_M0<=counter_M0;
end
assign RLAST_S0=(counter_M0==3'd3)?RVALID_S0:1'd0;

logic [2:0] counter_M1;
always_ff@(posedge ACLK ) begin
	if(~ARESETn) counter_M1<=3'd0;
	else if(RVALID_S1==1'd1) counter_M1<=counter_M1+3'd1;
	else if(counter_M1==3'd4) counter_M1<=3'd0;
	else counter_M1<=counter_M1;
end
assign RLAST_S1=(counter_M1==3'd3)?RVALID_S1:1'd0;

logic [2:0] counter_M2;
always_ff@(posedge ACLK ) begin
	if(~ARESETn) counter_M2<=3'd0;
	else if(RVALID_S2==1'd1) counter_M2<=counter_M2+3'd1;
	else if(counter_M2==3'd4) counter_M2<=3'd0;
	else counter_M2<=counter_M2;
end
assign RLAST_S2=(counter_M2==3'd3)?RVALID_S2:1'd0;


assign RLAST_S3=RVALID_S3;

logic [2:0] counter_M5;
always_ff@(posedge ACLK ) begin
	if(~ARESETn) counter_M5<=3'd0;
	else if(RVALID_S5==1'd1) counter_M5<=counter_M5+3'd1;
	else if(counter_M5==3'd4) counter_M5<=3'd0;
	else counter_M5<=counter_M5;
end
assign RLAST_S5=(counter_M5==3'd3)?RVALID_S5:1'd0;

always_ff@(posedge ACLK ) begin
	if(~ARESETn) read_curr_state<=read_IDLE;
	else read_curr_state<=read_next_state;
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) write_curr_state<=write_IDLE;
	else write_curr_state<=write_next_state;
end

always_comb begin //next state logic for read
	unique case (read_curr_state)
		read_IDLE: begin
			if(ARVALID_M0==1'd1)  begin
				unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
				else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
				else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
				else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
				else  read_next_state=M0_read_S5; //DRAM
			end
			else if(ARVALID_M1==1'd1)  begin
				unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
				else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
				else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
				else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
				else  read_next_state=M1_read_S5; //DRAM
			end
			else read_next_state=read_IDLE;
		end
		M0_read_S0: begin //M0 read ROM
			unique if(RVALID_S0==1'd1 && RREADY_M0==1'd1 && RLAST_S0) begin
				unique if(ARVALID_M1==1'd1) begin
					unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
					else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
					else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
					else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
					else  read_next_state=M1_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M0_read_S0;
		end
		M0_read_S1: begin  //M0 read IM
			unique if(RVALID_S1==1'd1 && RREADY_M0==1'd1 && RLAST_S1) begin
				unique if(ARVALID_M1==1'd1) begin
					unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
					else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
					else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
					else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
					else  read_next_state=M1_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M0_read_S1;
		end
		M0_read_S2: begin //M0 read DM
			unique if(RVALID_S2==1'd1 && RREADY_M0==1'd1 && RLAST_S2) begin
				unique if(ARVALID_M1==1'd1) begin
					unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
					else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
					else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
					else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
					else  read_next_state=M1_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M0_read_S2;
		end
		M0_read_S3: begin //M0 read sensor_ctrl
			unique if(RVALID_S3==1'd1 && RREADY_M0==1'd1 && RLAST_S3) begin
				unique if(ARVALID_M1==1'd1) begin
					unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
					else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
					else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
					else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
					else  read_next_state=M1_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M0_read_S3;
		end
		M0_read_S5: begin //M0 read DRAM
			unique if(RVALID_S5==1'd1 && RREADY_M0==1'd1 && RLAST_S5) begin
				unique if(ARVALID_M1==1'd1) begin
					unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
					else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
					else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
					else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
					else  read_next_state=M1_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M0_read_S5;
		end
		M1_read_S0: begin  //M1 read ROM
			unique if(RVALID_S0==1'd1 && RREADY_M1==1'd1 && RLAST_S0) begin
				unique if(ARVALID_M0==1'd1) begin
					unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
					else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
					else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
					else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
					else  read_next_state=M0_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M1_read_S0;
		end
		M1_read_S1: begin //M1 read IM
			unique if(RVALID_S1==1'd1 && RREADY_M1==1'd1 && RLAST_S1) begin
				unique if(ARVALID_M0==1'd1) begin
					unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
					else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
					else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
					else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
					else  read_next_state=M0_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M1_read_S1;
		end
		M1_read_S2: begin //M1 read DM
			unique if(RVALID_S2==1'd1 && RREADY_M1==1'd1 && RLAST_S2) begin
				unique if(ARVALID_M0==1'd1) begin
					unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
					else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
					else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
					else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
					else  read_next_state=M0_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M1_read_S2;
		end
		M1_read_S3: begin //M1 read sensor_ctrl
			unique if(RVALID_S3==1'd1 && RREADY_M1==1'd1 && RLAST_S3) begin
				unique if(ARVALID_M0==1'd1) begin
					unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
					else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
					else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
					else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
					else  read_next_state=M0_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M1_read_S3;
		end
		M1_read_S5: begin //M1 read DRAM
			unique if(RVALID_S5==1'd1 && RREADY_M1==1'd1 && RLAST_S5) begin
				unique if(ARVALID_M0==1'd1) begin
					unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
					else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
					else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
					else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
					else  read_next_state=M0_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M1_read_S5;
		end
		default: begin
			read_next_state=read_IDLE;
		end
	endcase
end

always_comb begin //next state logic for write
	unique case (write_curr_state)
		write_IDLE: begin
			if(AWVALID_M1==1'd1)  begin
				unique if(AWADDR_M1<=32'h0001FFFF && AWADDR_M1>=32'h00010000) write_next_state=M1_write_S1; //IM
				else if(AWADDR_M1<=32'h0002FFFF && AWADDR_M1>=32'h00020000) write_next_state=M1_write_S2; //DM
				else if(AWADDR_M1<=32'h100003FF && AWADDR_M1>=32'h10000000) write_next_state=M1_write_S3; //sensor_ctrl
				else if(AWADDR_M1<=32'h100103FF && AWADDR_M1>=32'h10010000) write_next_state=M1_write_S4; //WDT
				else if(AWADDR_M1<=32'h201FFFFF && AWADDR_M1>=32'h20000000) write_next_state=M1_write_S5; //DRAM
				else write_next_state=M1_write_S6; //PWM
			end
			else write_next_state=write_IDLE;
		end
		M1_write_S1: begin
			unique if(BREADY_M1==1'd1 && BVALID_S1==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S1;
		end
		M1_write_S2: begin
			unique if(BREADY_M1==1'd1 && BVALID_S2==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S2;
		end
		M1_write_S3: begin
			unique if(BREADY_M1==1'd1 && BVALID_S3==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S3;
		end
		M1_write_S4: begin
			unique if(BREADY_M1==1'd1 && BVALID_S4==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S4;
		end
		M1_write_S5: begin
			unique if(BREADY_M1==1'd1 && BVALID_S5==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S5;
		end
		M1_write_S6: begin
			unique if(BREADY_M1==1'd1 && BVALID_S6==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S6;
		end
		default: begin
			write_next_state=write_IDLE;
		end
	endcase
end

always_comb begin
	unique case (read_curr_state)
		read_IDLE: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
			
		end
		M0_read_S0: begin
			ARID_S0={4'd0,ARID_M0};//MASTER interface READ ADDRESS0
			ARADDR_S0=ARADDR_M0;
			ARLEN_S0=ARLEN_M0;
			ARSIZE_S0=ARSIZE_M0;
			ARBURST_S0=ARBURST_M0;
			ARVALID_S0=ARVALID_M0;
			
			RREADY_S0=RREADY_M0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			ARREADY_M0=ARREADY_S0; //SLAVE interface READ ADDRESS0
			
			RID_M0=RID_S0[3:0]; //SLAVE interface READ DATA0
			RDATA_M0=RDATA_S0;
			RRESP_M0=RRESP_S0;
			RLAST_M0=RLAST_S0;
			RVALID_M0=RVALID_S0;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
			
		end
		M0_read_S1: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1={4'd0,ARID_M0}; //MASTER interface READ ADDRESS1
			ARADDR_S1=ARADDR_M0;
			ARLEN_S1=ARLEN_M0;
			ARSIZE_S1=ARSIZE_M0;
			ARBURST_S1=ARBURST_M0;
			ARVALID_S1=ARVALID_M0;
					
			RREADY_S1=RREADY_M0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			ARREADY_M0=ARREADY_S1; //SLAVE interface READ ADDRESS0
			
			RID_M0=RID_S1[3:0]; //SLAVE interface READ DATA0
			RDATA_M0=RDATA_S1;
			RRESP_M0=RRESP_S1;
			RLAST_M0=RLAST_S1;
			RVALID_M0=RVALID_S1;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
			
		end
		M0_read_S2: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2={4'd0,ARID_M0}; //MASTER interface READ ADDRESS2
			ARADDR_S2=ARADDR_M0;
			ARLEN_S2=ARLEN_M0;
			ARSIZE_S2=ARSIZE_M0;
			ARBURST_S2=ARBURST_M0;
			ARVALID_S2=ARVALID_M0;
					
			RREADY_S2=RREADY_M0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=ARREADY_S2; //SLAVE interface READ ADDRESS0
			
			RID_M0=RID_S2[3:0]; //SLAVE interface READ DATA0
			RDATA_M0=RDATA_S2;
			RRESP_M0=RRESP_S2;
			RLAST_M0=RLAST_S2;
			RVALID_M0=RVALID_S2;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
			
		end
		M0_read_S3: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3={4'd0,ARID_M0}; //MASTER interface READ ADDRESS3
			ARADDR_S3=ARADDR_M0;
			ARLEN_S3=ARLEN_M0;
			ARSIZE_S3=ARSIZE_M0;
			ARBURST_S3=ARBURST_M0;
			ARVALID_S3=ARVALID_M0;
					
			RREADY_S3=RREADY_M0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=ARREADY_S3; //SLAVE interface READ ADDRESS0
			
			RID_M0=RID_S3[3:0]; //SLAVE interface READ DATA0
			RDATA_M0=RDATA_S3;
			RRESP_M0=RRESP_S3;
			RLAST_M0=RLAST_S3;
			RVALID_M0=RVALID_S3;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
		end
		M0_read_S5: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5={4'd0,ARID_M0}; //MASTER interface READ ADDRESS5
			ARADDR_S5=ARADDR_M0;
			ARLEN_S5=ARLEN_M0;
			ARSIZE_S5=ARSIZE_M0;
			ARBURST_S5=ARBURST_M0;
			ARVALID_S5=ARVALID_M0;
					
			RREADY_S5=RREADY_M0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=ARREADY_S5; //SLAVE interface READ ADDRESS0
			
			RID_M0=RID_S5[3:0]; //SLAVE interface READ DATA0
			RDATA_M0=RDATA_S5;
			RRESP_M0=RRESP_S5;
			RLAST_M0=RLAST_S5;
			RVALID_M0=RVALID_S5;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
		end
		M1_read_S0: begin
			ARID_S0={4'd0,ARID_M1};//MASTER interface READ ADDRESS0
			ARADDR_S0=ARADDR_M1;
			ARLEN_S0=ARLEN_M1;
			ARSIZE_S0=ARSIZE_M1;
			ARBURST_S0=ARBURST_M1;
			ARVALID_S0=ARVALID_M1;
			
			RREADY_S0=RREADY_M1; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=ARREADY_S0; //SLAVE interface READ ADDRESS1
			
			RID_M1=RID_S0[3:0]; //SLAVE interface READ DATA1
			RDATA_M1=RDATA_S0;
			RRESP_M1=RRESP_S0;
			RLAST_M1=RLAST_S0;
			RVALID_M1=RVALID_S0;
		end
		M1_read_S1: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1={4'd0,ARID_M1}; //MASTER interface READ ADDRESS1
			ARADDR_S1=ARADDR_M1;
			ARLEN_S1=ARLEN_M1;
			ARSIZE_S1=ARSIZE_M1;
			ARBURST_S1=ARBURST_M1;
			ARVALID_S1=ARVALID_M1;
					
			RREADY_S1=RREADY_M1; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=ARREADY_S1; //SLAVE interface READ ADDRESS1
			
			RID_M1=RID_S1[3:0]; //SLAVE interface READ DATA1
			RDATA_M1=RDATA_S1;
			RRESP_M1=RRESP_S1;
			RLAST_M1=RLAST_S1;
			RVALID_M1=RVALID_S1;
		end
		M1_read_S2: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2={4'd0,ARID_M1}; //MASTER interface READ ADDRESS2
			ARADDR_S2=ARADDR_M1;
			ARLEN_S2=ARLEN_M1;
			ARSIZE_S2=ARSIZE_M1;
			ARBURST_S2=ARBURST_M1;
			ARVALID_S2=ARVALID_M1;
					
			RREADY_S2=RREADY_M1; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=ARREADY_S2; //SLAVE interface READ ADDRESS1
			
			RID_M1=RID_S2[3:0]; //SLAVE interface READ DATA1
			RDATA_M1=RDATA_S2;
			RRESP_M1=RRESP_S2;
			RLAST_M1=RLAST_S2;
			RVALID_M1=RVALID_S2;
			
		end
		M1_read_S3: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3={4'd0,ARID_M1}; //MASTER interface READ ADDRESS3
			ARADDR_S3=ARADDR_M1;
			ARLEN_S3=ARLEN_M1;
			ARSIZE_S3=ARSIZE_M1;
			ARBURST_S3=ARBURST_M1;
			ARVALID_S3=ARVALID_M1;
					
			RREADY_S3=RREADY_M1; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=ARREADY_S3; //SLAVE interface READ ADDRESS1
			
			RID_M1=RID_S3[3:0]; //SLAVE interface READ DATA1
			RDATA_M1=RDATA_S3;
			RRESP_M1=RRESP_S3;
			RLAST_M1=RLAST_S3;
			RVALID_M1=RVALID_S3;
			
		end
		M1_read_S5: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0;; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5={4'd0,ARID_M1}; //MASTER interface READ ADDRESS5
			ARADDR_S5=ARADDR_M1;
			ARLEN_S5=ARLEN_M1;
			ARSIZE_S5=ARSIZE_M1;
			ARBURST_S5=ARBURST_M1;
			ARVALID_S5=ARVALID_M1;
					
			RREADY_S5=RREADY_M1; //MASTER interface READ DATA5
			
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=ARREADY_S5; //SLAVE interface READ ADDRESS1
			
			RID_M1=RID_S5[3:0]; //SLAVE interface READ DATA1
			RDATA_M1=RDATA_S5;
			RRESP_M1=RRESP_S5;
			RLAST_M1=RLAST_S5;
			RVALID_M1=RVALID_S5;
		end
		default: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
		end
	endcase
end

always_comb begin
	unique case (write_curr_state)
		write_IDLE: begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=1'd0; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=1'd0; //SLAVE interface WRITE DATA
			
			BID_M1=4'd0; //SLAVE interface WRITE RESPONSE
			BRESP_M1=2'd0;
			BVALID_M1=1'd0;
		end
		M1_write_S1: begin
			AWID_S1={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=AWADDR_M1;
			AWLEN_S1=AWLEN_M1;
			AWSIZE_S1=AWSIZE_M1;
			AWBURST_S1=AWBURST_M1;
			AWVALID_S1=AWVALID_M1;
					
			WDATA_S1=WDATA_M1; //MASTER interface WRITE DATA1
			WSTRB_S1=WSTRB_M1;
			WLAST_S1=WLAST_M1;
			WVALID_S1=WVALID_M1;
					
			BREADY_S1=BREADY_M1; //MASTER interface WRITE RESPONSE1
		
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S1; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S1; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S1[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S1;
			BVALID_M1=BVALID_S1;
		end
		M1_write_S2: begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=AWADDR_M1;
			AWLEN_S2=AWLEN_M1;
			AWSIZE_S2=AWSIZE_M1;
			AWBURST_S2=AWBURST_M1;
			AWVALID_S2=AWVALID_M1;
					
			WDATA_S2=WDATA_M1; //MASTER interface WRITE DATA2
			WSTRB_S2=WSTRB_M1;
			WLAST_S2=WLAST_M1;
			WVALID_S2=WVALID_M1;
					
			BREADY_S2=BREADY_M1; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S2; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S2; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S2[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S2;
			BVALID_M1=BVALID_S2;
		end
		M1_write_S3: begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=AWADDR_M1;
			AWLEN_S3=AWLEN_M1;
			AWSIZE_S3=AWSIZE_M1;
			AWBURST_S3=AWBURST_M1;
			AWVALID_S3=AWVALID_M1;
					
			WDATA_S3=WDATA_M1; //MASTER interface WRITE DATA3
			WSTRB_S3=WSTRB_M1;
			WLAST_S3=WLAST_M1;
			WVALID_S3=WVALID_M1;
					
			BREADY_S3=BREADY_M1; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S3; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S3; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S3[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S3;
			BVALID_M1=BVALID_S3;
		end
		M1_write_S4: begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=AWADDR_M1;
			AWLEN_S4=AWLEN_M1;
			AWSIZE_S4=AWSIZE_M1;
			AWBURST_S4=AWBURST_M1;
			AWVALID_S4=AWVALID_M1;
					
			WDATA_S4=WDATA_M1; //MASTER interface WRITE DATA4
			WSTRB_S4=WSTRB_M1;
			WLAST_S4=WLAST_M1;
			WVALID_S4=WVALID_M1;
					
			BREADY_S4=BREADY_M1; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S4; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S4; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S4[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S4;
			BVALID_M1=BVALID_S4;
		end
		M1_write_S5: begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=AWADDR_M1;
			AWLEN_S5=AWLEN_M1;
			AWSIZE_S5=AWSIZE_M1;
			AWBURST_S5=AWBURST_M1;
			AWVALID_S5=AWVALID_M1;
					
			WDATA_S5=WDATA_M1; //MASTER interface WRITE DATA5
			WSTRB_S5=WSTRB_M1;
			WLAST_S5=WLAST_M1;
			WVALID_S5=WVALID_M1;
					
			BREADY_S5=BREADY_M1; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S5; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S5; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S5[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S5;
			BVALID_M1=BVALID_S5;
		end
		M1_write_S6 :begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=AWADDR_M1;
			AWLEN_S6=AWLEN_M1;
			AWSIZE_S6=AWSIZE_M1;
			AWBURST_S6=AWBURST_M1;
			AWVALID_S6=AWVALID_M1;
					
			WDATA_S6=WDATA_M1; //MASTER interface WRITE DATA6
			WSTRB_S6=WSTRB_M1;
			WLAST_S6=WLAST_M1;
			WVALID_S6=WVALID_M1;
					
			BREADY_S6=BREADY_M1; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S6; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S6; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S6[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S6;
			BVALID_M1=BVALID_S6;
		end
		default :begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=1'd0; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=1'd0; //SLAVE interface WRITE DATA
			
			BID_M1=4'd0; //SLAVE interface WRITE RESPONSE
			BRESP_M1=2'd0;
			BVALID_M1=1'd0;
		end
	endcase
end

endmodule
`include "../../include/AXI_define.svh"
`include "../FIFO_AR.sv"
`include "../FIFO_AW.sv"
`include "../FIFO_B.sv"
`include "../FIFO_R.sv"
`include "../FIFO_W.sv"
module AXI(

	input CPU_CLK_i,      
	input ACLK,        
	input ROM_CLK_i,      
	input DRAM_CLK_i,
	input SRAM_CLK_i,
	input PWM_CLK_i,
	input CPU_RST_i,      
	input ARESETn,        
	input ROM_RST_i,      
	input DRAM_RST_i,
	input SRAM_RST_i,   
	input PWM_RST_i, 
	//SLAVE INTERFACE FOR MASTERS
	
	//WRITE ADDRESS
	input [`AXI_ID_BITS-1:0] AWID_M1_F,
	input [`AXI_ADDR_BITS-1:0] AWADDR_M1_F,
	input [`AXI_LEN_BITS-1:0] AWLEN_M1_F,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_M1_F,
	input [1:0] AWBURST_M1_F,
	input AWVALID_M1_F,
	output logic AWREADY_M1_F,
	
	//WRITE DATA
	input [`AXI_DATA_BITS-1:0] WDATA_M1_F,
	input [`AXI_STRB_BITS-1:0] WSTRB_M1_F,
	input WLAST_M1_F,
	input WVALID_M1_F,
	output logic WREADY_M1_F,
	
	//WRITE RESPONSE
	output logic [`AXI_ID_BITS-1:0] BID_M1_F,
	output logic [1:0] BRESP_M1_F,
	output logic BVALID_M1_F,
	input BREADY_M1_F,

	//READ ADDRESS0
	input [`AXI_ID_BITS-1:0] ARID_M0_F,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M0_F,
	input [`AXI_LEN_BITS-1:0] ARLEN_M0_F,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M0_F,
	input [1:0] ARBURST_M0_F,
	input ARVALID_M0_F,
	output logic ARREADY_M0_F,
	
	//READ DATA0
	output logic [`AXI_ID_BITS-1:0] RID_M0_F,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M0_F,
	output logic [1:0] RRESP_M0_F,
	output logic RLAST_M0_F,
	output logic RVALID_M0_F,
	input RREADY_M0_F,
	
	//READ ADDRESS1
	input [`AXI_ID_BITS-1:0] ARID_M1_F,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M1_F,
	input [`AXI_LEN_BITS-1:0] ARLEN_M1_F,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M1_F,
	input [1:0] ARBURST_M1_F,
	input ARVALID_M1_F,
	output logic ARREADY_M1_F,
	
	//READ DATA1
	output logic [`AXI_ID_BITS-1:0] RID_M1_F,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M1_F,
	output logic [1:0] RRESP_M1_F,
	output logic RLAST_M1_F,
	output logic RVALID_M1_F,
	input RREADY_M1_F,




	//MASTER INTERFACE FOR SLAVES

	//READ ADDRESS0   ROM
	output logic [`AXI_IDS_BITS-1:0] ARID_S0_F,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S0_F,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S0_F,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0_F,
	output logic [1:0] ARBURST_S0_F,
	output logic ARVALID_S0_F,
	input ARREADY_S0_F,
	
	//READ DATA0
	input [`AXI_IDS_BITS-1:0] RID_S0_F,
	input [`AXI_DATA_BITS-1:0] RDATA_S0_F,
	input [1:0] RRESP_S0_F,
	input RLAST_S0_F,
	input RVALID_S0_F,
	output logic RREADY_S0_F,
	
	//WRITE ADDRESS1	IM
	output logic [`AXI_IDS_BITS-1:0] AWID_S1_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S1_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S1_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1_F,
	output logic [1:0] AWBURST_S1_F,
	output logic AWVALID_S1_F,
	input AWREADY_S1_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S1_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S1_F,
	output logic WLAST_S1_F,
	output logic WVALID_S1_F,
	input WREADY_S1_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S1_F,
	input [1:0] BRESP_S1_F,
	input BVALID_S1_F,
	output logic BREADY_S1_F,
	
	//READ ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] ARID_S1_F,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S1_F,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S1_F,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1_F,
	output logic [1:0] ARBURST_S1_F,
	output logic ARVALID_S1_F,
	input ARREADY_S1_F,
	
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S1_F,
	input [`AXI_DATA_BITS-1:0] RDATA_S1_F,
	input [1:0] RRESP_S1_F,
	input RLAST_S1_F,
	input RVALID_S1_F,
	output logic RREADY_S1_F,
	
	//WRITE ADDRESS1	DM
	output logic [`AXI_IDS_BITS-1:0] AWID_S2_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S2_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S2_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S2_F,
	output logic [1:0] AWBURST_S2_F,
	output logic AWVALID_S2_F,
	input AWREADY_S2_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S2_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S2_F,
	output logic WLAST_S2_F,
	output logic WVALID_S2_F,
	input WREADY_S2_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S2_F,
	input [1:0] BRESP_S2_F,
	input BVALID_S2_F,
	output logic BREADY_S2_F,
	
	//READ ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] ARID_S2_F,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S2_F,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S2_F,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S2_F,
	output logic [1:0] ARBURST_S2_F,
	output logic ARVALID_S2_F,
	input ARREADY_S2_F,
	
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S2_F,
	input [`AXI_DATA_BITS-1:0] RDATA_S2_F,
	input [1:0] RRESP_S2_F,
	input RLAST_S2_F,
	input RVALID_S2_F,
	output logic RREADY_S2_F,
	
	//WRITE ADDRESS1	sensor_ctrl
	output logic [`AXI_IDS_BITS-1:0] AWID_S3_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S3_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S3_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S3_F,
	output logic [1:0] AWBURST_S3_F,
	output logic AWVALID_S3_F,
	input AWREADY_S3_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S3_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S3_F,
	output logic WLAST_S3_F,
	output logic WVALID_S3_F,
	input WREADY_S3_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S3_F,
	input [1:0] BRESP_S3_F,
	input BVALID_S3_F,
	output logic BREADY_S3_F,
	
	//READ ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] ARID_S3_F,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S3_F,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S3_F,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S3_F,
	output logic [1:0] ARBURST_S3_F,
	output logic ARVALID_S3_F,
	input ARREADY_S3_F,
	
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S3_F,
	input [`AXI_DATA_BITS-1:0] RDATA_S3_F,
	input [1:0] RRESP_S3_F,
	input RLAST_S3_F,
	input RVALID_S3_F,
	output logic RREADY_S3_F,
	
	//WRITE ADDRESS1	WDT
	output logic [`AXI_IDS_BITS-1:0] AWID_S4_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S4_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S4_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S4_F,
	output logic [1:0] AWBURST_S4_F,
	output logic AWVALID_S4_F,
	input AWREADY_S4_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S4_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S4_F,
	output logic WLAST_S4_F,
	output logic WVALID_S4_F,
	input WREADY_S4_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S4_F,
	input [1:0] BRESP_S4_F,
	input BVALID_S4_F,
	output logic BREADY_S4_F,
	
	
	//WRITE ADDRESS1	DRAM
	output logic [`AXI_IDS_BITS-1:0] AWID_S5_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S5_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S5_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S5_F,
	output logic [1:0] AWBURST_S5_F,
	output logic AWVALID_S5_F,
	input AWREADY_S5_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S5_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S5_F,
	output logic WLAST_S5_F,
	output logic WVALID_S5_F,
	input WREADY_S5_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S5_F,
	input [1:0] BRESP_S5_F,
	input BVALID_S5_F,
	output logic BREADY_S5_F,
	
	//READ ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] ARID_S5_F,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S5_F,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S5_F,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S5_F,
	output logic [1:0] ARBURST_S5_F,
	output logic ARVALID_S5_F,
	input ARREADY_S5_F,
	
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S5_F,
	input [`AXI_DATA_BITS-1:0] RDATA_S5_F,
	input [1:0] RRESP_S5_F,
	input RLAST_S5_F,
	input RVALID_S5_F,
	output logic RREADY_S5_F,
	
	//WRITE ADDRESS1	PWM
	output logic [`AXI_IDS_BITS-1:0] AWID_S6_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S6_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S6_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S6_F,
	output logic [1:0] AWBURST_S6_F,
	output logic AWVALID_S6_F,
	input AWREADY_S6_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S6_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S6_F,
	output logic WLAST_S6_F,
	output logic WVALID_S6_F,
	input WREADY_S6_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S6_F,
	input [1:0] BRESP_S6_F,
	input BVALID_S6_F,
	output logic BREADY_S6_F
);
    //---------- you should put your design here ----------//

//state machine
parameter read_IDLE=4'd0;
parameter M0_read_S0=4'd1; //ROM
parameter M0_read_S1=4'd2; //IM
parameter M0_read_S2=4'd3; //DM
parameter M0_read_S3=4'd4; //sensor_ctrl
parameter M0_read_S5=4'd6; //DRAM

parameter M1_read_S0=4'd7; //ROM
parameter M1_read_S1=4'd8; //IM
parameter M1_read_S2=4'd9; //DM
parameter M1_read_S3=4'd10; //sensor_ctrl
parameter M1_read_S5=4'd12; //DRAM


parameter write_IDLE=3'd0;
parameter M1_write_S1=3'd1; //IM
parameter M1_write_S2=3'd2; //DM
parameter M1_write_S3=3'd3; //sensor_ctrl
parameter M1_write_S4=3'd4; //WDT
parameter M1_write_S5=3'd5; //DRAM
parameter M1_write_S6=3'd6; //PWM

logic [3:0] read_curr_state,read_next_state;
logic [2:0] write_curr_state,write_next_state;

//SLAVE INTERFACE FOR MASTERS
	
	//WRITE ADDRESS
logic [`AXI_ID_BITS-1:0] AWID_M1;
logic [`AXI_ADDR_BITS-1:0] AWADDR_M1;
logic [`AXI_LEN_BITS-1:0] AWLEN_M1;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_M1;
logic [1:0] AWBURST_M1;
logic AWVALID_M1;
logic AWREADY_M1;
	
//WRITE DATA
logic [`AXI_DATA_BITS-1:0] WDATA_M1;
logic [`AXI_STRB_BITS-1:0] WSTRB_M1;
logic WLAST_M1;
logic WVALID_M1;
logic WREADY_M1;

//WRITE RESPONSE
logic [`AXI_ID_BITS-1:0] BID_M1;
logic [1:0] BRESP_M1;
logic BVALID_M1;
logic BREADY_M1;

//READ ADDRESS0
logic [`AXI_ID_BITS-1:0] ARID_M0;
logic [`AXI_ADDR_BITS-1:0] ARADDR_M0;
logic [`AXI_LEN_BITS-1:0] ARLEN_M0;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_M0;
logic [1:0] ARBURST_M0;
logic ARVALID_M0;
logic ARREADY_M0;

//READ DATA0
logic [`AXI_ID_BITS-1:0] RID_M0;
logic [`AXI_DATA_BITS-1:0] RDATA_M0;
logic [1:0] RRESP_M0;
logic RLAST_M0;
logic RVALID_M0;
logic RREADY_M0;

//READ ADDRESS1
logic [`AXI_ID_BITS-1:0] ARID_M1;
logic [`AXI_ADDR_BITS-1:0] ARADDR_M1;
logic [`AXI_LEN_BITS-1:0] ARLEN_M1;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_M1;
logic [1:0] ARBURST_M1;
logic ARVALID_M1;
logic ARREADY_M1;

//READ DATA1
logic [`AXI_ID_BITS-1:0] RID_M1;
logic [`AXI_DATA_BITS-1:0] RDATA_M1;
logic [1:0] RRESP_M1;
logic RLAST_M1;
logic RVALID_M1;
logic RREADY_M1;




//MASTER INTERFACE FOR SLAVES

//READ ADDRESS0   ROM
logic [`AXI_IDS_BITS-1:0] ARID_S0;
logic [`AXI_ADDR_BITS-1:0] ARADDR_S0;
logic [`AXI_LEN_BITS-1:0] ARLEN_S0;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0;
logic [1:0] ARBURST_S0;
logic ARVALID_S0;
logic ARREADY_S0;

//READ DATA0
logic [`AXI_IDS_BITS-1:0] RID_S0;
logic [`AXI_DATA_BITS-1:0] RDATA_S0;
logic [1:0] RRESP_S0;
logic RLAST_S0;
logic RVALID_S0;
logic RREADY_S0;

//WRITE ADDRESS1	IM
logic [`AXI_IDS_BITS-1:0] AWID_S1;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S1;
logic [`AXI_LEN_BITS-1:0] AWLEN_S1;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1;
logic [1:0] AWBURST_S1;
logic AWVALID_S1;
logic AWREADY_S1;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S1;
logic [`AXI_STRB_BITS-1:0] WSTRB_S1;
logic WLAST_S1;
logic WVALID_S1;
logic WREADY_S1;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S1;
logic [1:0] BRESP_S1;
logic BVALID_S1;
logic BREADY_S1;

//READ ADDRESS1
logic [`AXI_IDS_BITS-1:0] ARID_S1;
logic [`AXI_ADDR_BITS-1:0] ARADDR_S1;
logic [`AXI_LEN_BITS-1:0] ARLEN_S1;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1;
logic [1:0] ARBURST_S1;
logic ARVALID_S1;
logic ARREADY_S1;

//READ DATA1
logic [`AXI_IDS_BITS-1:0] RID_S1;
logic [`AXI_DATA_BITS-1:0] RDATA_S1;
logic [1:0] RRESP_S1;
logic RLAST_S1;
logic RVALID_S1;
logic RREADY_S1;

//WRITE ADDRESS1	DM
logic [`AXI_IDS_BITS-1:0] AWID_S2;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S2;
logic [`AXI_LEN_BITS-1:0] AWLEN_S2;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S2;
logic [1:0] AWBURST_S2;
logic AWVALID_S2;
logic AWREADY_S2;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S2;
logic [`AXI_STRB_BITS-1:0] WSTRB_S2;
logic WLAST_S2;
logic WVALID_S2;
logic WREADY_S2;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S2;
logic [1:0] BRESP_S2;
logic BVALID_S2;
logic BREADY_S2;

//READ ADDRESS1
logic [`AXI_IDS_BITS-1:0] ARID_S2;
logic [`AXI_ADDR_BITS-1:0] ARADDR_S2;
logic [`AXI_LEN_BITS-1:0] ARLEN_S2;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_S2;
logic [1:0] ARBURST_S2;
logic ARVALID_S2;
logic ARREADY_S2;

//READ DATA1
logic [`AXI_IDS_BITS-1:0] RID_S2;
logic [`AXI_DATA_BITS-1:0] RDATA_S2;
logic [1:0] RRESP_S2;
logic RLAST_S2;
logic RVALID_S2;
logic RREADY_S2;

//WRITE ADDRESS1	sensor_ctrl
logic [`AXI_IDS_BITS-1:0] AWID_S3;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S3;
logic [`AXI_LEN_BITS-1:0] AWLEN_S3;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S3;
logic [1:0] AWBURST_S3;
logic AWVALID_S3;
logic AWREADY_S3;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S3;
logic [`AXI_STRB_BITS-1:0] WSTRB_S3;
logic WLAST_S3;
logic WVALID_S3;
logic WREADY_S3;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S3;
logic [1:0] BRESP_S3;
logic BVALID_S3;
logic BREADY_S3;

//READ ADDRESS1
logic [`AXI_IDS_BITS-1:0] ARID_S3;
logic [`AXI_ADDR_BITS-1:0] ARADDR_S3;
logic [`AXI_LEN_BITS-1:0] ARLEN_S3;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_S3;
logic [1:0] ARBURST_S3;
logic ARVALID_S3;
logic ARREADY_S3;

//READ DATA1
logic [`AXI_IDS_BITS-1:0] RID_S3;
logic [`AXI_DATA_BITS-1:0] RDATA_S3;
logic [1:0] RRESP_S3;
logic RLAST_S3;
logic RVALID_S3;
logic RREADY_S3;

//WRITE ADDRESS1	WDT
logic [`AXI_IDS_BITS-1:0] AWID_S4;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S4;
logic [`AXI_LEN_BITS-1:0] AWLEN_S4;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S4;
logic [1:0] AWBURST_S4;
logic AWVALID_S4;
logic AWREADY_S4;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S4;
logic [`AXI_STRB_BITS-1:0] WSTRB_S4;
logic WLAST_S4;
logic WVALID_S4;
logic WREADY_S4;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S4;
logic [1:0] BRESP_S4;
logic BVALID_S4;
logic BREADY_S4;


//WRITE ADDRESS1	DRAM
logic [`AXI_IDS_BITS-1:0] AWID_S5;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S5;
logic [`AXI_LEN_BITS-1:0] AWLEN_S5;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S5;
logic [1:0] AWBURST_S5;
logic AWVALID_S5;
logic AWREADY_S5;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S5;
logic [`AXI_STRB_BITS-1:0] WSTRB_S5;
logic WLAST_S5;
logic WVALID_S5;
logic WREADY_S5;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S5;
logic [1:0] BRESP_S5;
logic BVALID_S5;
logic BREADY_S5;

//READ ADDRESS1
logic [`AXI_IDS_BITS-1:0] ARID_S5;
logic [`AXI_ADDR_BITS-1:0] ARADDR_S5;
logic [`AXI_LEN_BITS-1:0] ARLEN_S5;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_S5;
logic [1:0] ARBURST_S5;
logic ARVALID_S5;
logic ARREADY_S5;

//READ DATA1
logic [`AXI_IDS_BITS-1:0] RID_S5;
logic [`AXI_DATA_BITS-1:0] RDATA_S5;
logic [1:0] RRESP_S5;
logic RLAST_S5;
logic RVALID_S5;
logic RREADY_S5;

//WRITE ADDRESS1	PWM
logic [`AXI_IDS_BITS-1:0] AWID_S6;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S6;
logic [`AXI_LEN_BITS-1:0] AWLEN_S6;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S6;
logic [1:0] AWBURST_S6;
logic AWVALID_S6;
logic AWREADY_S6;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S6;
logic [`AXI_STRB_BITS-1:0] WSTRB_S6;
logic WLAST_S6;
logic WVALID_S6;
logic WREADY_S6;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S6;
logic [1:0] BRESP_S6;
logic BVALID_S6;
logic BREADY_S6;


logic [48:0] aw_s1_wdata,aw_s1_rdata;
logic [48:0] aw_m1_wdata,aw_m1_rdata;
logic [48:0] aw_m2_wdata,aw_m2_rdata;
logic [48:0] aw_m3_wdata,aw_m3_rdata;
logic [48:0] aw_m4_wdata,aw_m4_rdata;
logic [48:0] aw_m5_wdata,aw_m5_rdata;
logic [48:0] aw_m6_wdata,aw_m6_rdata;

assign aw_s1_wdata={4'd0,AWID_M1_F,AWADDR_M1_F,AWLEN_M1_F,AWSIZE_M1_F,AWBURST_M1_F};
assign AWID_M1=aw_s1_rdata[44:41];
assign AWADDR_M1=aw_s1_rdata[40:9];
assign AWLEN_M1=aw_s1_rdata[8:5];
assign AWSIZE_M1=aw_s1_rdata[4:2];
assign AWBURST_M1=aw_s1_rdata[1:0];

assign aw_m1_wdata={AWID_S1,AWADDR_S1,AWLEN_S1,AWSIZE_S1,AWBURST_S1};
assign AWID_S1_F=aw_m1_rdata[48:41];
assign AWADDR_S1_F=aw_m1_rdata[40:9];
assign AWLEN_S1_F=aw_m1_rdata[8:5];
assign AWSIZE_S1_F=aw_m1_rdata[4:2];
assign AWBURST_S1_F=aw_m1_rdata[1:0];

assign aw_m2_wdata={AWID_S2,AWADDR_S2,AWLEN_S2,AWSIZE_S2,AWBURST_S2};
assign AWID_S2_F=aw_m2_rdata[48:41];
assign AWADDR_S2_F=aw_m2_rdata[40:9];
assign AWLEN_S2_F=aw_m2_rdata[8:5];
assign AWSIZE_S2_F=aw_m2_rdata[4:2];
assign AWBURST_S2_F=aw_m2_rdata[1:0];

assign aw_m3_wdata={AWID_S3,AWADDR_S3,AWLEN_S3,AWSIZE_S3,AWBURST_S3};
assign AWID_S3_F=aw_m3_rdata[48:41];
assign AWADDR_S3_F=aw_m3_rdata[40:9];
assign AWLEN_S3_F=aw_m3_rdata[8:5];
assign AWSIZE_S3_F=aw_m3_rdata[4:2];
assign AWBURST_S3_F=aw_m3_rdata[1:0];

assign aw_m4_wdata={AWID_S4,AWADDR_S4,AWLEN_S4,AWSIZE_S4,AWBURST_S4};
assign AWID_S4_F=aw_m4_rdata[48:41];
assign AWADDR_S4_F=aw_m4_rdata[40:9];
assign AWLEN_S4_F=aw_m4_rdata[8:5];
assign AWSIZE_S4_F=aw_m4_rdata[4:2];
assign AWBURST_S4_F=aw_m4_rdata[1:0];

assign aw_m5_wdata={AWID_S5,AWADDR_S5,AWLEN_S5,AWSIZE_S5,AWBURST_S5};
assign AWID_S5_F=aw_m5_rdata[48:41];
assign AWADDR_S5_F=aw_m5_rdata[40:9];
assign AWLEN_S5_F=aw_m5_rdata[8:5];
assign AWSIZE_S5_F=aw_m5_rdata[4:2];
assign AWBURST_S5_F=aw_m5_rdata[1:0];

assign aw_m6_wdata={AWID_S6,AWADDR_S6,AWLEN_S6,AWSIZE_S6,AWBURST_S6};
assign AWID_S6_F=aw_m6_rdata[48:41];
assign AWADDR_S6_F=aw_m6_rdata[40:9];
assign AWLEN_S6_F=aw_m6_rdata[8:5];
assign AWSIZE_S6_F=aw_m6_rdata[4:2];
assign AWBURST_S6_F=aw_m6_rdata[1:0];

//aw
FIFO_AW aw_s1(
	.wdata(aw_s1_wdata),
	.valid_i(AWVALID_M1_F),
	.valid_o(AWVALID_M1),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(aw_s1_rdata),
	.ready_i(AWREADY_M1),
	.ready_o(AWREADY_M1_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_AW aw_m1(
	.wdata(aw_m1_wdata),
	.valid_i(AWVALID_S1),
	.valid_o(AWVALID_S1_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m1_rdata),
	.ready_i(AWREADY_S1_F),
	.ready_o(AWREADY_S1),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);

FIFO_AW aw_m2(
	.wdata(aw_m2_wdata),
	.valid_i(AWVALID_S2),
	.valid_o(AWVALID_S2_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m2_rdata),
	.ready_i(AWREADY_S2_F),
	.ready_o(AWREADY_S2),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);
FIFO_AW aw_m3(
	.wdata(aw_m3_wdata),
	.valid_i(AWVALID_S3),
	.valid_o(AWVALID_S3_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m3_rdata),
	.ready_i(AWREADY_S3_F),
	.ready_o(AWREADY_S3),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_AW aw_m4(
	.wdata(aw_m4_wdata),
	.valid_i(AWVALID_S4),
	.valid_o(AWVALID_S4_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m4_rdata),
	.ready_i(AWREADY_S4_F),
	.ready_o(AWREADY_S4),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_AW aw_m5(
	.wdata(aw_m5_wdata),
	.valid_i(AWVALID_S5),
	.valid_o(AWVALID_S5_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m5_rdata),
	.ready_i(AWREADY_S5_F),
	.ready_o(AWREADY_S5),
	.rrst_n(~DRAM_RST_i),
	.rclk(DRAM_CLK_i)
);

FIFO_AW aw_m6(
	.wdata(aw_m6_wdata),
	.valid_i(AWVALID_S6),
	.valid_o(AWVALID_S6_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m6_rdata),
	.ready_i(AWREADY_S6_F),
	.ready_o(AWREADY_S6),
	.rrst_n(~PWM_RST_i),
	.rclk(PWM_CLK_i)
);

logic [36:0] w_s1_wdata,w_s1_rdata;
logic [36:0] w_m1_wdata,w_m1_rdata;
logic [36:0] w_m2_wdata,w_m2_rdata;
logic [36:0] w_m3_wdata,w_m3_rdata;
logic [36:0] w_m4_wdata,w_m4_rdata;
logic [36:0] w_m5_wdata,w_m5_rdata;
logic [36:0] w_m6_wdata,w_m6_rdata;

assign w_s1_wdata={WDATA_M1_F,WSTRB_M1_F,WLAST_M1_F};
assign WDATA_M1=w_s1_rdata[36:5];
assign WSTRB_M1=w_s1_rdata[4:1];
assign WLAST_M1=w_s1_rdata[0];

assign w_m1_wdata={WDATA_S1,WSTRB_S1,WLAST_S1};
assign WDATA_S1_F=w_m1_rdata[36:5];
assign WSTRB_S1_F=w_m1_rdata[4:1];
assign WLAST_S1_F=w_m1_rdata[0];

assign w_m2_wdata={WDATA_S2,WSTRB_S2,WLAST_S2};
assign WDATA_S2_F=w_m2_rdata[36:5];
assign WSTRB_S2_F=w_m2_rdata[4:1];
assign WLAST_S2_F=w_m2_rdata[0];

assign w_m3_wdata={WDATA_S3,WSTRB_S3,WLAST_S3};
assign WDATA_S3_F=w_m3_rdata[36:5];
assign WSTRB_S3_F=w_m3_rdata[4:1];
assign WLAST_S3_F=w_m3_rdata[0];

assign w_m4_wdata={WDATA_S4,WSTRB_S4,WLAST_S4};
assign WDATA_S4_F=w_m4_rdata[36:5];
assign WSTRB_S4_F=w_m4_rdata[4:1];
assign WLAST_S4_F=w_m4_rdata[0];

assign w_m5_wdata={WDATA_S5,WSTRB_S5,WLAST_S5};
assign WDATA_S5_F=w_m5_rdata[36:5];
assign WSTRB_S5_F=w_m5_rdata[4:1];
assign WLAST_S5_F=w_m5_rdata[0];

assign w_m6_wdata={WDATA_S6,WSTRB_S6,WLAST_S6};
assign WDATA_S6_F=w_m6_rdata[36:5];
assign WSTRB_S6_F=w_m6_rdata[4:1];
assign WLAST_S6_F=w_m6_rdata[0];

//w
FIFO_W w_s1(
	.wdata(w_s1_wdata),
	.valid_i(WVALID_M1_F),
	.valid_o(WVALID_M1),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(w_s1_rdata),
	.ready_i(WREADY_M1),
	.ready_o(WREADY_M1_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_W w_m1(
	.wdata(w_m1_wdata),
	.valid_i(WVALID_S1),
	.valid_o(WVALID_S1_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m1_rdata),
	.ready_i(WREADY_S1_F),
	.ready_o(WREADY_S1),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);

FIFO_W w_m2(
	.wdata(w_m2_wdata),
	.valid_i(WVALID_S2),
	.valid_o(WVALID_S2_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m2_rdata),
	.ready_i(WREADY_S2_F),
	.ready_o(WREADY_S2),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);

FIFO_W w_m3(
	.wdata(w_m3_wdata),
	.valid_i(WVALID_S3),
	.valid_o(WVALID_S3_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m3_rdata),
	.ready_i(WREADY_S3_F),
	.ready_o(WREADY_S3),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_W w_m4(
	.wdata(w_m4_wdata),
	.valid_i(WVALID_S4),
	.valid_o(WVALID_S4_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m4_rdata),
	.ready_i(WREADY_S4_F),
	.ready_o(WREADY_S4),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_W w_m5(
	.wdata(w_m5_wdata),
	.valid_i(WVALID_S5),
	.valid_o(WVALID_S5_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m5_rdata),
	.ready_i(WREADY_S5_F),
	.ready_o(WREADY_S5),
	.rrst_n(~DRAM_RST_i),
	.rclk(DRAM_CLK_i)
);

FIFO_W w_m6(
	.wdata(w_m6_wdata),
	.valid_i(WVALID_S6),
	.valid_o(WVALID_S6_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m6_rdata),
	.ready_i(WREADY_S6_F),
	.ready_o(WREADY_S6),
	.rrst_n(~PWM_RST_i),
	.rclk(PWM_CLK_i)
);

logic [9:0] b_s1_wdata,b_s1_rdata;
logic [9:0] b_m1_wdata,b_m1_rdata;
logic [9:0] b_m2_wdata,b_m2_rdata;
logic [9:0] b_m3_wdata,b_m3_rdata;
logic [9:0] b_m4_wdata,b_m4_rdata;
logic [9:0] b_m5_wdata,b_m5_rdata;
logic [9:0] b_m6_wdata,b_m6_rdata;

assign b_s1_wdata={4'd0,BID_M1,BRESP_M1};
assign BID_M1_F=b_s1_rdata[5:2];
assign BRESP_M1_F=b_s1_rdata[1:0];

assign b_m1_wdata={BID_S1_F,BRESP_S1_F};
assign BID_S1=b_m1_rdata[9:2];
assign BRESP_S1=b_m1_rdata[1:0];

assign b_m2_wdata={BID_S2_F,BRESP_S2_F};
assign BID_S2=b_m2_rdata[9:2];
assign BRESP_S2=b_m2_rdata[1:0];

assign b_m3_wdata={BID_S3_F,BRESP_S3_F};
assign BID_S3=b_m3_rdata[9:2];
assign BRESP_S3=b_m3_rdata[1:0];

assign b_m4_wdata={BID_S4_F,BRESP_S4_F};
assign BID_S4=b_m4_rdata[9:2];
assign BRESP_S4=b_m4_rdata[1:0];

assign b_m5_wdata={BID_S5_F,BRESP_S5_F};
assign BID_S5=b_m5_rdata[9:2];
assign BRESP_S5=b_m5_rdata[1:0];

assign b_m6_wdata={BID_S6_F,BRESP_S6_F};
assign BID_S6=b_m6_rdata[9:2];
assign BRESP_S6=b_m6_rdata[1:0];

//b
FIFO_B b_s1(
	.wdata(b_s1_wdata),
	.valid_i(BVALID_M1),
	.valid_o(BVALID_M1_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(b_s1_rdata),
	.ready_i(BREADY_M1_F),
	.ready_o(BREADY_M1),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_B b_m1(
	.wdata(b_m1_wdata),
	.valid_i(BVALID_S1_F),
	.valid_o(BVALID_S1),
	.wrst_n(~SRAM_RST_i),
	.wclk(SRAM_CLK_i),
	.rdata(b_m1_rdata),
	.ready_i(BREADY_S1),
	.ready_o(BREADY_S1_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_B b_m2(
	.wdata(b_m2_wdata),
	.valid_i(BVALID_S2_F),
	.valid_o(BVALID_S2),
	.wrst_n(~SRAM_RST_i),
	.wclk(SRAM_CLK_i),
	.rdata(b_m2_rdata),
	.ready_i(BREADY_S2),
	.ready_o(BREADY_S2_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_B b_m3(
	.wdata(b_m3_wdata),
	.valid_i(BVALID_S3_F),
	.valid_o(BVALID_S3),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(b_m3_rdata),
	.ready_i(BREADY_S3),
	.ready_o(BREADY_S3_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_B b_m4(
	.wdata(b_m4_wdata),
	.valid_i(BVALID_S4_F),
	.valid_o(BVALID_S4),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(b_m4_rdata),
	.ready_i(BREADY_S4),
	.ready_o(BREADY_S4_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_B b_m5(
	.wdata(b_m5_wdata),
	.valid_i(BVALID_S5_F),
	.valid_o(BVALID_S5),
	.wrst_n(~DRAM_RST_i),
	.wclk(DRAM_CLK_i),
	.rdata(b_m5_rdata),
	.ready_i(BREADY_S5),
	.ready_o(BREADY_S5_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_B b_m6(
	.wdata(b_m6_wdata),
	.valid_i(BVALID_S6_F),
	.valid_o(BVALID_S6),
	.wrst_n(~PWM_RST_i),
	.wclk(PWM_CLK_i),
	.rdata(b_m6_rdata),
	.ready_i(BREADY_S6),
	.ready_o(BREADY_S6_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

logic [48:0] ar_s0_wdata,ar_s0_rdata;						 
logic [48:0] ar_s1_wdata,ar_s1_rdata;
logic [48:0] ar_m0_wdata,ar_m0_rdata;
logic [48:0] ar_m1_wdata,ar_m1_rdata;
logic [48:0] ar_m2_wdata,ar_m2_rdata;
logic [48:0] ar_m3_wdata,ar_m3_rdata;
logic [48:0] ar_m5_wdata,ar_m5_rdata;

assign ar_s0_wdata={4'd0,ARID_M0_F,ARADDR_M0_F,ARLEN_M0_F,ARSIZE_M0_F,ARBURST_M0_F};
assign ARID_M0=ar_s0_rdata[44:41];
assign ARADDR_M0=ar_s0_rdata[40:9];
assign ARLEN_M0=ar_s0_rdata[8:5];
assign ARSIZE_M0=ar_s0_rdata[4:2];
assign ARBURST_M0=ar_s0_rdata[1:0];

assign ar_s1_wdata={4'd0,ARID_M1_F,ARADDR_M1_F,ARLEN_M1_F,ARSIZE_M1_F,ARBURST_M1_F};
assign ARID_M1=ar_s1_rdata[44:41];
assign ARADDR_M1=ar_s1_rdata[40:9];
assign ARLEN_M1=ar_s1_rdata[8:5];
assign ARSIZE_M1=ar_s1_rdata[4:2];
assign ARBURST_M1=ar_s1_rdata[1:0];

assign ar_m0_wdata={ARID_S0,ARADDR_S0,ARLEN_S0,ARSIZE_S0,ARBURST_S0};
assign ARID_S0_F=ar_m0_rdata[48:41];
assign ARADDR_S0_F=ar_m0_rdata[40:9];
assign ARLEN_S0_F=ar_m0_rdata[8:5];
assign ARSIZE_S0_F=ar_m0_rdata[4:2];
assign ARBURST_S0_F=ar_m0_rdata[1:0];

assign ar_m1_wdata={ARID_S1,ARADDR_S1,ARLEN_S1,ARSIZE_S1,ARBURST_S1};
assign ARID_S1_F=ar_m1_rdata[48:41];
assign ARADDR_S1_F=ar_m1_rdata[40:9];
assign ARLEN_S1_F=ar_m1_rdata[8:5];
assign ARSIZE_S1_F=ar_m1_rdata[4:2];
assign ARBURST_S1_F=ar_m1_rdata[1:0];

assign ar_m2_wdata={ARID_S2,ARADDR_S2,ARLEN_S2,ARSIZE_S2,ARBURST_S2};
assign ARID_S2_F=ar_m2_rdata[48:41];
assign ARADDR_S2_F=ar_m2_rdata[40:9];
assign ARLEN_S2_F=ar_m2_rdata[8:5];
assign ARSIZE_S2_F=ar_m2_rdata[4:2];
assign ARBURST_S2_F=ar_m2_rdata[1:0];

assign ar_m3_wdata={ARID_S3,ARADDR_S3,ARLEN_S3,ARSIZE_S3,ARBURST_S3};
assign ARID_S3_F=ar_m3_rdata[48:41];
assign ARADDR_S3_F=ar_m3_rdata[40:9];
assign ARLEN_S3_F=ar_m3_rdata[8:5];
assign ARSIZE_S3_F=ar_m3_rdata[4:2];
assign ARBURST_S3_F=ar_m3_rdata[1:0];

assign ar_m5_wdata={ARID_S5,ARADDR_S5,ARLEN_S5,ARSIZE_S5,ARBURST_S5};
assign ARID_S5_F=ar_m5_rdata[48:41];
assign ARADDR_S5_F=ar_m5_rdata[40:9];
assign ARLEN_S5_F=ar_m5_rdata[8:5];
assign ARSIZE_S5_F=ar_m5_rdata[4:2];
assign ARBURST_S5_F=ar_m5_rdata[1:0];

//ar
FIFO_AR ar_s0(
	.wdata(ar_s0_wdata),
	.valid_i(ARVALID_M0_F),
	.valid_o(ARVALID_M0),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(ar_s0_rdata),
	.ready_i(ARREADY_M0),
	.ready_o(ARREADY_M0_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_AR ar_s1(
	.wdata(ar_s1_wdata),
	.valid_i(ARVALID_M1_F),
	.valid_o(ARVALID_M1),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(ar_s1_rdata),
	.ready_i(ARREADY_M1),
	.ready_o(ARREADY_M1_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_AR ar_m0(
	.wdata(ar_m0_wdata),
	.valid_i(ARVALID_S0),
	.valid_o(ARVALID_S0_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(ar_m0_rdata),
	.ready_i(ARREADY_S0_F),
	.ready_o(ARREADY_S0),
	.rrst_n(~ROM_RST_i),
	.rclk(ROM_CLK_i)
);

FIFO_AR ar_m1(
	.wdata(ar_m1_wdata),
	.valid_i(ARVALID_S1),
	.valid_o(ARVALID_S1_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(ar_m1_rdata),
	.ready_i(ARREADY_S1_F),
	.ready_o(ARREADY_S1),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);

FIFO_AR ar_m2(
	.wdata(ar_m2_wdata),
	.valid_i(ARVALID_S2),
	.valid_o(ARVALID_S2_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(ar_m2_rdata),
	.ready_i(ARREADY_S2_F),
	.ready_o(ARREADY_S2),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);

FIFO_AR ar_m3(
	.wdata(ar_m3_wdata),
	.valid_i(ARVALID_S3),
	.valid_o(ARVALID_S3_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(ar_m3_rdata),
	.ready_i(ARREADY_S3_F),
	.ready_o(ARREADY_S3),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_AR ar_m5(
	.wdata(ar_m5_wdata),
	.valid_i(ARVALID_S5),
	.valid_o(ARVALID_S5_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(ar_m5_rdata),
	.ready_i(ARREADY_S5_F),
	.ready_o(ARREADY_S5),
	.rrst_n(~DRAM_RST_i),
	.rclk(DRAM_CLK_i)
);

logic [41:0] r_s0_wdata,r_s0_rdata;
logic [41:0] r_s1_wdata,r_s1_rdata;
logic [41:0] r_m0_wdata,r_m0_rdata;
logic [41:0] r_m1_wdata,r_m1_rdata;
logic [41:0] r_m2_wdata,r_m2_rdata;
logic [41:0] r_m3_wdata,r_m3_rdata;
logic [41:0] r_m5_wdata,r_m5_rdata;

assign r_s0_wdata={4'd0,RID_M0,RDATA_M0,RRESP_M0};
assign RID_M0_F=r_s0_rdata[37:34];
assign RDATA_M0_F=r_s0_rdata[33:2];
assign RRESP_M0_F=r_s0_rdata[1:0];

assign r_s1_wdata={4'd0,RID_M1,RDATA_M1,RRESP_M1};
assign RID_M1_F=r_s1_rdata[37:34];
assign RDATA_M1_F=r_s1_rdata[33:2];
assign RRESP_M1_F=r_s1_rdata[1:0];

assign r_m0_wdata={RID_S0_F,RDATA_S0_F,RRESP_S0_F};
assign RID_S0=r_m0_rdata[41:34];
assign RDATA_S0=r_m0_rdata[33:2];
assign RRESP_S0=r_m0_rdata[1:0];

assign r_m1_wdata={RID_S1_F,RDATA_S1_F,RRESP_S1_F};
assign RID_S1=r_m1_rdata[41:34];
assign RDATA_S1=r_m1_rdata[33:2];
assign RRESP_S1=r_m1_rdata[1:0];

assign r_m2_wdata={RID_S2_F,RDATA_S2_F,RRESP_S2_F};
assign RID_S2=r_m2_rdata[41:34];
assign RDATA_S2=r_m2_rdata[33:2];
assign RRESP_S2=r_m2_rdata[1:0];

assign r_m3_wdata={RID_S3_F,RDATA_S3_F,RRESP_S3_F};
assign RID_S3=r_m3_rdata[41:34];
assign RDATA_S3=r_m3_rdata[33:2];
assign RRESP_S3=r_m3_rdata[1:0];

assign r_m5_wdata={RID_S5_F,RDATA_S5_F,RRESP_S5_F};
assign RID_S5=r_m5_rdata[41:34];
assign RDATA_S5=r_m5_rdata[33:2];
assign RRESP_S5=r_m5_rdata[1:0];
//r
FIFO_R r_s0(
	.wdata(r_s0_wdata),
	.valid_i(RVALID_M0),
	.valid_o(RVALID_M0_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(r_s0_rdata),
	.ready_i(RREADY_M0_F),
	.ready_o(RREADY_M0),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_R r_s1(
	.wdata(r_s1_wdata),
	.valid_i(RVALID_M1),
	.valid_o(RVALID_M1_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(r_s1_rdata),
	.ready_i(RREADY_M1_F),
	.ready_o(RREADY_M1),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_R r_m0(
	.wdata(r_m0_wdata),
	.valid_i(RVALID_S0_F),
	.valid_o(RVALID_S0),
	.wrst_n(~ROM_RST_i),
	.wclk(ROM_CLK_i),
	.rdata(r_m0_rdata),
	.ready_i(RREADY_S0),
	.ready_o(RREADY_S0_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_R r_m1(
	.wdata(r_m1_wdata),
	.valid_i(RVALID_S1_F),
	.valid_o(RVALID_S1),
	.wrst_n(~SRAM_RST_i),
	.wclk(SRAM_CLK_i),
	.rdata(r_m1_rdata),
	.ready_i(RREADY_S1),
	.ready_o(RREADY_S1_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_R r_m2(
	.wdata(r_m2_wdata),
	.valid_i(RVALID_S2_F),
	.valid_o(RVALID_S2),
	.wrst_n(~SRAM_RST_i),
	.wclk(SRAM_CLK_i),
	.rdata(r_m2_rdata),
	.ready_i(RREADY_S2),
	.ready_o(RREADY_S2_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_R r_m3(
	.wdata(r_m3_wdata),
	.valid_i(RVALID_S3_F),
	.valid_o(RVALID_S3),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(r_m3_rdata),
	.ready_i(RREADY_S3),
	.ready_o(RREADY_S3_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_R r_m5(
	.wdata(r_m5_wdata),
	.valid_i(RVALID_S5_F),
	.valid_o(RVALID_S5),
	.wrst_n(~DRAM_RST_i),
	.wclk(DRAM_CLK_i),
	.rdata(r_m5_rdata),
	.ready_i(RREADY_S5),
	.ready_o(RREADY_S5_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

logic [2:0] counter_S0;
always_ff@(posedge CPU_CLK_i ) begin
	if(~CPU_RST_i) counter_S0<=3'd0;
	else if(RVALID_M0_F==1'd1) counter_S0<=counter_S0+3'd1;
	else if(counter_S0==3'd4) counter_S0<=3'd0;
	else counter_S0<=counter_S0;
end
assign RLAST_M0_F=(counter_S0==3'd3)?RVALID_M0_F:1'd0;

logic [2:0] counter_S1;
always_ff@(posedge CPU_CLK_i ) begin
	if(~CPU_RST_i) counter_S1<=3'd0;
	else if(RVALID_M1_F==1'd1) counter_S1<=counter_S1+3'd1;
	else if(counter_S1==3'd4) counter_S1<=3'd0;
	else counter_S1<=counter_S1;
end
//assign RLAST_M1_F=(counter_S1==3'd3)?RVALID_M1_F:1'd0;
logic [3:0] len_reg;
always_comb begin
	if(len_reg==4'd0) RLAST_M1_F=RVALID_M1_F;
	else if(counter_S1==3'd3) RLAST_M1_F=RVALID_M1_F;
	else RLAST_M1_F=1'd0;
end

always_ff@(posedge CPU_CLK_i) begin
	if(~CPU_RST_i) len_reg<=4'd1;
	else if(ARVALID_M1_F==1'd1) len_reg<=ARLEN_M1_F;
	else len_reg<=len_reg;
end

logic [2:0] counter_M0;
always_ff@(posedge ACLK ) begin
	if(~ARESETn) counter_M0<=3'd0;
	else if(RVALID_S0==1'd1) counter_M0<=counter_M0+3'd1;
	else if(counter_M0==3'd4) counter_M0<=3'd0;
	else counter_M0<=counter_M0;
end
assign RLAST_S0=(counter_M0==3'd3)?RVALID_S0:1'd0;

logic [2:0] counter_M1;
always_ff@(posedge ACLK ) begin
	if(~ARESETn) counter_M1<=3'd0;
	else if(RVALID_S1==1'd1) counter_M1<=counter_M1+3'd1;
	else if(counter_M1==3'd4) counter_M1<=3'd0;
	else counter_M1<=counter_M1;
end
assign RLAST_S1=(counter_M1==3'd3)?RVALID_S1:1'd0;

logic [2:0] counter_M2;
always_ff@(posedge ACLK ) begin
	if(~ARESETn) counter_M2<=3'd0;
	else if(RVALID_S2==1'd1) counter_M2<=counter_M2+3'd1;
	else if(counter_M2==3'd4) counter_M2<=3'd0;
	else counter_M2<=counter_M2;
end
assign RLAST_S2=(counter_M2==3'd3)?RVALID_S2:1'd0;


assign RLAST_S3=RVALID_S3;

logic [2:0] counter_M5;
always_ff@(posedge ACLK ) begin
	if(~ARESETn) counter_M5<=3'd0;
	else if(RVALID_S5==1'd1) counter_M5<=counter_M5+3'd1;
	else if(counter_M5==3'd4) counter_M5<=3'd0;
	else counter_M5<=counter_M5;
end
assign RLAST_S5=(counter_M5==3'd3)?RVALID_S5:1'd0;

always_ff@(posedge ACLK ) begin
	if(~ARESETn) read_curr_state<=read_IDLE;
	else read_curr_state<=read_next_state;
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) write_curr_state<=write_IDLE;
	else write_curr_state<=write_next_state;
end

always_comb begin //next state logic for read
	unique case (read_curr_state)
		read_IDLE: begin
			if(ARVALID_M0==1'd1)  begin
				unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
				else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
				else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
				else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
				else  read_next_state=M0_read_S5; //DRAM
			end
			else if(ARVALID_M1==1'd1)  begin
				unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
				else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
				else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
				else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
				else  read_next_state=M1_read_S5; //DRAM
			end
			else read_next_state=read_IDLE;
		end
		M0_read_S0: begin //M0 read ROM
			unique if(RVALID_S0==1'd1 && RREADY_M0==1'd1 && RLAST_S0) begin
				unique if(ARVALID_M1==1'd1) begin
					unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
					else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
					else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
					else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
					else  read_next_state=M1_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M0_read_S0;
		end
		M0_read_S1: begin  //M0 read IM
			unique if(RVALID_S1==1'd1 && RREADY_M0==1'd1 && RLAST_S1) begin
				unique if(ARVALID_M1==1'd1) begin
					unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
					else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
					else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
					else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
					else  read_next_state=M1_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M0_read_S1;
		end
		M0_read_S2: begin //M0 read DM
			unique if(RVALID_S2==1'd1 && RREADY_M0==1'd1 && RLAST_S2) begin
				unique if(ARVALID_M1==1'd1) begin
					unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
					else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
					else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
					else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
					else  read_next_state=M1_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M0_read_S2;
		end
		M0_read_S3: begin //M0 read sensor_ctrl
			unique if(RVALID_S3==1'd1 && RREADY_M0==1'd1 && RLAST_S3) begin
				unique if(ARVALID_M1==1'd1) begin
					unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
					else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
					else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
					else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
					else  read_next_state=M1_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M0_read_S3;
		end
		M0_read_S5: begin //M0 read DRAM
			unique if(RVALID_S5==1'd1 && RREADY_M0==1'd1 && RLAST_S5) begin
				unique if(ARVALID_M1==1'd1) begin
					unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
					else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
					else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
					else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
					else  read_next_state=M1_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M0_read_S5;
		end
		M1_read_S0: begin  //M1 read ROM
			unique if(RVALID_S0==1'd1 && RREADY_M1==1'd1 && RLAST_S0) begin
				unique if(ARVALID_M0==1'd1) begin
					unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
					else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
					else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
					else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
					else  read_next_state=M0_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M1_read_S0;
		end
		M1_read_S1: begin //M1 read IM
			unique if(RVALID_S1==1'd1 && RREADY_M1==1'd1 && RLAST_S1) begin
				unique if(ARVALID_M0==1'd1) begin
					unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
					else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
					else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
					else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
					else  read_next_state=M0_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M1_read_S1;
		end
		M1_read_S2: begin //M1 read DM
			unique if(RVALID_S2==1'd1 && RREADY_M1==1'd1 && RLAST_S2) begin
				unique if(ARVALID_M0==1'd1) begin
					unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
					else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
					else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
					else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
					else  read_next_state=M0_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M1_read_S2;
		end
		M1_read_S3: begin //M1 read sensor_ctrl
			unique if(RVALID_S3==1'd1 && RREADY_M1==1'd1 && RLAST_S3) begin
				unique if(ARVALID_M0==1'd1) begin
					unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
					else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
					else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
					else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
					else  read_next_state=M0_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M1_read_S3;
		end
		M1_read_S5: begin //M1 read DRAM
			unique if(RVALID_S5==1'd1 && RREADY_M1==1'd1 && RLAST_S5) begin
				unique if(ARVALID_M0==1'd1) begin
					unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
					else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
					else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
					else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
					else  read_next_state=M0_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M1_read_S5;
		end
		default: begin
			read_next_state=read_IDLE;
		end
	endcase
end

always_comb begin //next state logic for write
	unique case (write_curr_state)
		write_IDLE: begin
			if(AWVALID_M1==1'd1)  begin
				unique if(AWADDR_M1<=32'h0001FFFF && AWADDR_M1>=32'h00010000) write_next_state=M1_write_S1; //IM
				else if(AWADDR_M1<=32'h0002FFFF && AWADDR_M1>=32'h00020000) write_next_state=M1_write_S2; //DM
				else if(AWADDR_M1<=32'h100003FF && AWADDR_M1>=32'h10000000) write_next_state=M1_write_S3; //sensor_ctrl
				else if(AWADDR_M1<=32'h100103FF && AWADDR_M1>=32'h10010000) write_next_state=M1_write_S4; //WDT
				else if(AWADDR_M1<=32'h201FFFFF && AWADDR_M1>=32'h20000000) write_next_state=M1_write_S5; //DRAM
				else write_next_state=M1_write_S6; //PWM
			end
			else write_next_state=write_IDLE;
		end
		M1_write_S1: begin
			unique if(BREADY_M1==1'd1 && BVALID_S1==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S1;
		end
		M1_write_S2: begin
			unique if(BREADY_M1==1'd1 && BVALID_S2==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S2;
		end
		M1_write_S3: begin
			unique if(BREADY_M1==1'd1 && BVALID_S3==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S3;
		end
		M1_write_S4: begin
			unique if(BREADY_M1==1'd1 && BVALID_S4==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S4;
		end
		M1_write_S5: begin
			unique if(BREADY_M1==1'd1 && BVALID_S5==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S5;
		end
		M1_write_S6: begin
			unique if(BREADY_M1==1'd1 && BVALID_S6==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S6;
		end
		default: begin
			write_next_state=write_IDLE;
		end
	endcase
end

always_comb begin
	unique case (read_curr_state)
		read_IDLE: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
			
		end
		M0_read_S0: begin
			ARID_S0={4'd0,ARID_M0};//MASTER interface READ ADDRESS0
			ARADDR_S0=ARADDR_M0;
			ARLEN_S0=ARLEN_M0;
			ARSIZE_S0=ARSIZE_M0;
			ARBURST_S0=ARBURST_M0;
			ARVALID_S0=ARVALID_M0;
			
			RREADY_S0=RREADY_M0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			ARREADY_M0=ARREADY_S0; //SLAVE interface READ ADDRESS0
			
			RID_M0=RID_S0[3:0]; //SLAVE interface READ DATA0
			RDATA_M0=RDATA_S0;
			RRESP_M0=RRESP_S0;
			RLAST_M0=RLAST_S0;
			RVALID_M0=RVALID_S0;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
			
		end
		M0_read_S1: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1={4'd0,ARID_M0}; //MASTER interface READ ADDRESS1
			ARADDR_S1=ARADDR_M0;
			ARLEN_S1=ARLEN_M0;
			ARSIZE_S1=ARSIZE_M0;
			ARBURST_S1=ARBURST_M0;
			ARVALID_S1=ARVALID_M0;
					
			RREADY_S1=RREADY_M0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			ARREADY_M0=ARREADY_S1; //SLAVE interface READ ADDRESS0
			
			RID_M0=RID_S1[3:0]; //SLAVE interface READ DATA0
			RDATA_M0=RDATA_S1;
			RRESP_M0=RRESP_S1;
			RLAST_M0=RLAST_S1;
			RVALID_M0=RVALID_S1;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
			
		end
		M0_read_S2: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2={4'd0,ARID_M0}; //MASTER interface READ ADDRESS2
			ARADDR_S2=ARADDR_M0;
			ARLEN_S2=ARLEN_M0;
			ARSIZE_S2=ARSIZE_M0;
			ARBURST_S2=ARBURST_M0;
			ARVALID_S2=ARVALID_M0;
					
			RREADY_S2=RREADY_M0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=ARREADY_S2; //SLAVE interface READ ADDRESS0
			
			RID_M0=RID_S2[3:0]; //SLAVE interface READ DATA0
			RDATA_M0=RDATA_S2;
			RRESP_M0=RRESP_S2;
			RLAST_M0=RLAST_S2;
			RVALID_M0=RVALID_S2;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
			
		end
		M0_read_S3: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3={4'd0,ARID_M0}; //MASTER interface READ ADDRESS3
			ARADDR_S3=ARADDR_M0;
			ARLEN_S3=ARLEN_M0;
			ARSIZE_S3=ARSIZE_M0;
			ARBURST_S3=ARBURST_M0;
			ARVALID_S3=ARVALID_M0;
					
			RREADY_S3=RREADY_M0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=ARREADY_S3; //SLAVE interface READ ADDRESS0
			
			RID_M0=RID_S3[3:0]; //SLAVE interface READ DATA0
			RDATA_M0=RDATA_S3;
			RRESP_M0=RRESP_S3;
			RLAST_M0=RLAST_S3;
			RVALID_M0=RVALID_S3;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
		end
		M0_read_S5: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5={4'd0,ARID_M0}; //MASTER interface READ ADDRESS5
			ARADDR_S5=ARADDR_M0;
			ARLEN_S5=ARLEN_M0;
			ARSIZE_S5=ARSIZE_M0;
			ARBURST_S5=ARBURST_M0;
			ARVALID_S5=ARVALID_M0;
					
			RREADY_S5=RREADY_M0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=ARREADY_S5; //SLAVE interface READ ADDRESS0
			
			RID_M0=RID_S5[3:0]; //SLAVE interface READ DATA0
			RDATA_M0=RDATA_S5;
			RRESP_M0=RRESP_S5;
			RLAST_M0=RLAST_S5;
			RVALID_M0=RVALID_S5;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
		end
		M1_read_S0: begin
			ARID_S0={4'd0,ARID_M1};//MASTER interface READ ADDRESS0
			ARADDR_S0=ARADDR_M1;
			ARLEN_S0=ARLEN_M1;
			ARSIZE_S0=ARSIZE_M1;
			ARBURST_S0=ARBURST_M1;
			ARVALID_S0=ARVALID_M1;
			
			RREADY_S0=RREADY_M1; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=ARREADY_S0; //SLAVE interface READ ADDRESS1
			
			RID_M1=RID_S0[3:0]; //SLAVE interface READ DATA1
			RDATA_M1=RDATA_S0;
			RRESP_M1=RRESP_S0;
			RLAST_M1=RLAST_S0;
			RVALID_M1=RVALID_S0;
		end
		M1_read_S1: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1={4'd0,ARID_M1}; //MASTER interface READ ADDRESS1
			ARADDR_S1=ARADDR_M1;
			ARLEN_S1=ARLEN_M1;
			ARSIZE_S1=ARSIZE_M1;
			ARBURST_S1=ARBURST_M1;
			ARVALID_S1=ARVALID_M1;
					
			RREADY_S1=RREADY_M1; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=ARREADY_S1; //SLAVE interface READ ADDRESS1
			
			RID_M1=RID_S1[3:0]; //SLAVE interface READ DATA1
			RDATA_M1=RDATA_S1;
			RRESP_M1=RRESP_S1;
			RLAST_M1=RLAST_S1;
			RVALID_M1=RVALID_S1;
		end
		M1_read_S2: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2={4'd0,ARID_M1}; //MASTER interface READ ADDRESS2
			ARADDR_S2=ARADDR_M1;
			ARLEN_S2=ARLEN_M1;
			ARSIZE_S2=ARSIZE_M1;
			ARBURST_S2=ARBURST_M1;
			ARVALID_S2=ARVALID_M1;
					
			RREADY_S2=RREADY_M1; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=ARREADY_S2; //SLAVE interface READ ADDRESS1
			
			RID_M1=RID_S2[3:0]; //SLAVE interface READ DATA1
			RDATA_M1=RDATA_S2;
			RRESP_M1=RRESP_S2;
			RLAST_M1=RLAST_S2;
			RVALID_M1=RVALID_S2;
			
		end
		M1_read_S3: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3={4'd0,ARID_M1}; //MASTER interface READ ADDRESS3
			ARADDR_S3=ARADDR_M1;
			ARLEN_S3=ARLEN_M1;
			ARSIZE_S3=ARSIZE_M1;
			ARBURST_S3=ARBURST_M1;
			ARVALID_S3=ARVALID_M1;
					
			RREADY_S3=RREADY_M1; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=ARREADY_S3; //SLAVE interface READ ADDRESS1
			
			RID_M1=RID_S3[3:0]; //SLAVE interface READ DATA1
			RDATA_M1=RDATA_S3;
			RRESP_M1=RRESP_S3;
			RLAST_M1=RLAST_S3;
			RVALID_M1=RVALID_S3;
			
		end
		M1_read_S5: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0;; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5={4'd0,ARID_M1}; //MASTER interface READ ADDRESS5
			ARADDR_S5=ARADDR_M1;
			ARLEN_S5=ARLEN_M1;
			ARSIZE_S5=ARSIZE_M1;
			ARBURST_S5=ARBURST_M1;
			ARVALID_S5=ARVALID_M1;
					
			RREADY_S5=RREADY_M1; //MASTER interface READ DATA5
			
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=ARREADY_S5; //SLAVE interface READ ADDRESS1
			
			RID_M1=RID_S5[3:0]; //SLAVE interface READ DATA1
			RDATA_M1=RDATA_S5;
			RRESP_M1=RRESP_S5;
			RLAST_M1=RLAST_S5;
			RVALID_M1=RVALID_S5;
		end
		default: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
		end
	endcase
end

always_comb begin
	unique case (write_curr_state)
		write_IDLE: begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=1'd0; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=1'd0; //SLAVE interface WRITE DATA
			
			BID_M1=4'd0; //SLAVE interface WRITE RESPONSE
			BRESP_M1=2'd0;
			BVALID_M1=1'd0;
		end
		M1_write_S1: begin
			AWID_S1={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=AWADDR_M1;
			AWLEN_S1=AWLEN_M1;
			AWSIZE_S1=AWSIZE_M1;
			AWBURST_S1=AWBURST_M1;
			AWVALID_S1=AWVALID_M1;
					
			WDATA_S1=WDATA_M1; //MASTER interface WRITE DATA1
			WSTRB_S1=WSTRB_M1;
			WLAST_S1=WLAST_M1;
			WVALID_S1=WVALID_M1;
					
			BREADY_S1=BREADY_M1; //MASTER interface WRITE RESPONSE1
		
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S1; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S1; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S1[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S1;
			BVALID_M1=BVALID_S1;
		end
		M1_write_S2: begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=AWADDR_M1;
			AWLEN_S2=AWLEN_M1;
			AWSIZE_S2=AWSIZE_M1;
			AWBURST_S2=AWBURST_M1;
			AWVALID_S2=AWVALID_M1;
					
			WDATA_S2=WDATA_M1; //MASTER interface WRITE DATA2
			WSTRB_S2=WSTRB_M1;
			WLAST_S2=WLAST_M1;
			WVALID_S2=WVALID_M1;
					
			BREADY_S2=BREADY_M1; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S2; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S2; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S2[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S2;
			BVALID_M1=BVALID_S2;
		end
		M1_write_S3: begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=AWADDR_M1;
			AWLEN_S3=AWLEN_M1;
			AWSIZE_S3=AWSIZE_M1;
			AWBURST_S3=AWBURST_M1;
			AWVALID_S3=AWVALID_M1;
					
			WDATA_S3=WDATA_M1; //MASTER interface WRITE DATA3
			WSTRB_S3=WSTRB_M1;
			WLAST_S3=WLAST_M1;
			WVALID_S3=WVALID_M1;
					
			BREADY_S3=BREADY_M1; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S3; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S3; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S3[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S3;
			BVALID_M1=BVALID_S3;
		end
		M1_write_S4: begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=AWADDR_M1;
			AWLEN_S4=AWLEN_M1;
			AWSIZE_S4=AWSIZE_M1;
			AWBURST_S4=AWBURST_M1;
			AWVALID_S4=AWVALID_M1;
					
			WDATA_S4=WDATA_M1; //MASTER interface WRITE DATA4
			WSTRB_S4=WSTRB_M1;
			WLAST_S4=WLAST_M1;
			WVALID_S4=WVALID_M1;
					
			BREADY_S4=BREADY_M1; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S4; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S4; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S4[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S4;
			BVALID_M1=BVALID_S4;
		end
		M1_write_S5: begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=AWADDR_M1;
			AWLEN_S5=AWLEN_M1;
			AWSIZE_S5=AWSIZE_M1;
			AWBURST_S5=AWBURST_M1;
			AWVALID_S5=AWVALID_M1;
					
			WDATA_S5=WDATA_M1; //MASTER interface WRITE DATA5
			WSTRB_S5=WSTRB_M1;
			WLAST_S5=WLAST_M1;
			WVALID_S5=WVALID_M1;
					
			BREADY_S5=BREADY_M1; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S5; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S5; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S5[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S5;
			BVALID_M1=BVALID_S5;
		end
		M1_write_S6 :begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=AWADDR_M1;
			AWLEN_S6=AWLEN_M1;
			AWSIZE_S6=AWSIZE_M1;
			AWBURST_S6=AWBURST_M1;
			AWVALID_S6=AWVALID_M1;
					
			WDATA_S6=WDATA_M1; //MASTER interface WRITE DATA6
			WSTRB_S6=WSTRB_M1;
			WLAST_S6=WLAST_M1;
			WVALID_S6=WVALID_M1;
					
			BREADY_S6=BREADY_M1; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S6; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S6; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S6[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S6;
			BVALID_M1=BVALID_S6;
		end
		default :begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=1'd0; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=1'd0; //SLAVE interface WRITE DATA
			
			BID_M1=4'd0; //SLAVE interface WRITE RESPONSE
			BRESP_M1=2'd0;
			BVALID_M1=1'd0;
		end
	endcase
end

endmodule`include "../../include/AXI_define.svh"
`include "../FIFO_AR.sv"
`include "../FIFO_AW.sv"
`include "../FIFO_B.sv"
`include "../FIFO_R.sv"
`include "../FIFO_W.sv"
module AXI(

	input CPU_CLK_i,      
	input ACLK,        
	input ROM_CLK_i,      
	input DRAM_CLK_i,
	input SRAM_CLK_i,
	input PWM_CLK_i,
	input CPU_RST_i,      
	input ARESETn,        
	input ROM_RST_i,      
	input DRAM_RST_i,
	input SRAM_RST_i,   
	input PWM_RST_i, 
	//SLAVE INTERFACE FOR MASTERS
	
	//WRITE ADDRESS
	input [`AXI_ID_BITS-1:0] AWID_M1_F,
	input [`AXI_ADDR_BITS-1:0] AWADDR_M1_F,
	input [`AXI_LEN_BITS-1:0] AWLEN_M1_F,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_M1_F,
	input [1:0] AWBURST_M1_F,
	input AWVALID_M1_F,
	output logic AWREADY_M1_F,
	
	//WRITE DATA
	input [`AXI_DATA_BITS-1:0] WDATA_M1_F,
	input [`AXI_STRB_BITS-1:0] WSTRB_M1_F,
	input WLAST_M1_F,
	input WVALID_M1_F,
	output logic WREADY_M1_F,
	
	//WRITE RESPONSE
	output logic [`AXI_ID_BITS-1:0] BID_M1_F,
	output logic [1:0] BRESP_M1_F,
	output logic BVALID_M1_F,
	input BREADY_M1_F,

	//READ ADDRESS0
	input [`AXI_ID_BITS-1:0] ARID_M0_F,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M0_F,
	input [`AXI_LEN_BITS-1:0] ARLEN_M0_F,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M0_F,
	input [1:0] ARBURST_M0_F,
	input ARVALID_M0_F,
	output logic ARREADY_M0_F,
	
	//READ DATA0
	output logic [`AXI_ID_BITS-1:0] RID_M0_F,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M0_F,
	output logic [1:0] RRESP_M0_F,
	output logic RLAST_M0_F,
	output logic RVALID_M0_F,
	input RREADY_M0_F,
	
	//READ ADDRESS1
	input [`AXI_ID_BITS-1:0] ARID_M1_F,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M1_F,
	input [`AXI_LEN_BITS-1:0] ARLEN_M1_F,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M1_F,
	input [1:0] ARBURST_M1_F,
	input ARVALID_M1_F,
	output logic ARREADY_M1_F,
	
	//READ DATA1
	output logic [`AXI_ID_BITS-1:0] RID_M1_F,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M1_F,
	output logic [1:0] RRESP_M1_F,
	output logic RLAST_M1_F,
	output logic RVALID_M1_F,
	input RREADY_M1_F,




	//MASTER INTERFACE FOR SLAVES

	//READ ADDRESS0   ROM
	output logic [`AXI_IDS_BITS-1:0] ARID_S0_F,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S0_F,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S0_F,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0_F,
	output logic [1:0] ARBURST_S0_F,
	output logic ARVALID_S0_F,
	input ARREADY_S0_F,
	
	//READ DATA0
	input [`AXI_IDS_BITS-1:0] RID_S0_F,
	input [`AXI_DATA_BITS-1:0] RDATA_S0_F,
	input [1:0] RRESP_S0_F,
	input RLAST_S0_F,
	input RVALID_S0_F,
	output logic RREADY_S0_F,
	
	//WRITE ADDRESS1	IM
	output logic [`AXI_IDS_BITS-1:0] AWID_S1_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S1_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S1_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1_F,
	output logic [1:0] AWBURST_S1_F,
	output logic AWVALID_S1_F,
	input AWREADY_S1_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S1_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S1_F,
	output logic WLAST_S1_F,
	output logic WVALID_S1_F,
	input WREADY_S1_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S1_F,
	input [1:0] BRESP_S1_F,
	input BVALID_S1_F,
	output logic BREADY_S1_F,
	
	//READ ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] ARID_S1_F,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S1_F,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S1_F,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1_F,
	output logic [1:0] ARBURST_S1_F,
	output logic ARVALID_S1_F,
	input ARREADY_S1_F,
	
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S1_F,
	input [`AXI_DATA_BITS-1:0] RDATA_S1_F,
	input [1:0] RRESP_S1_F,
	input RLAST_S1_F,
	input RVALID_S1_F,
	output logic RREADY_S1_F,
	
	//WRITE ADDRESS1	DM
	output logic [`AXI_IDS_BITS-1:0] AWID_S2_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S2_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S2_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S2_F,
	output logic [1:0] AWBURST_S2_F,
	output logic AWVALID_S2_F,
	input AWREADY_S2_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S2_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S2_F,
	output logic WLAST_S2_F,
	output logic WVALID_S2_F,
	input WREADY_S2_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S2_F,
	input [1:0] BRESP_S2_F,
	input BVALID_S2_F,
	output logic BREADY_S2_F,
	
	//READ ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] ARID_S2_F,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S2_F,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S2_F,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S2_F,
	output logic [1:0] ARBURST_S2_F,
	output logic ARVALID_S2_F,
	input ARREADY_S2_F,
	
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S2_F,
	input [`AXI_DATA_BITS-1:0] RDATA_S2_F,
	input [1:0] RRESP_S2_F,
	input RLAST_S2_F,
	input RVALID_S2_F,
	output logic RREADY_S2_F,
	
	//WRITE ADDRESS1	sensor_ctrl
	output logic [`AXI_IDS_BITS-1:0] AWID_S3_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S3_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S3_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S3_F,
	output logic [1:0] AWBURST_S3_F,
	output logic AWVALID_S3_F,
	input AWREADY_S3_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S3_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S3_F,
	output logic WLAST_S3_F,
	output logic WVALID_S3_F,
	input WREADY_S3_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S3_F,
	input [1:0] BRESP_S3_F,
	input BVALID_S3_F,
	output logic BREADY_S3_F,
	
	//READ ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] ARID_S3_F,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S3_F,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S3_F,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S3_F,
	output logic [1:0] ARBURST_S3_F,
	output logic ARVALID_S3_F,
	input ARREADY_S3_F,
	
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S3_F,
	input [`AXI_DATA_BITS-1:0] RDATA_S3_F,
	input [1:0] RRESP_S3_F,
	input RLAST_S3_F,
	input RVALID_S3_F,
	output logic RREADY_S3_F,
	
	//WRITE ADDRESS1	WDT
	output logic [`AXI_IDS_BITS-1:0] AWID_S4_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S4_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S4_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S4_F,
	output logic [1:0] AWBURST_S4_F,
	output logic AWVALID_S4_F,
	input AWREADY_S4_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S4_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S4_F,
	output logic WLAST_S4_F,
	output logic WVALID_S4_F,
	input WREADY_S4_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S4_F,
	input [1:0] BRESP_S4_F,
	input BVALID_S4_F,
	output logic BREADY_S4_F,
	
	
	//WRITE ADDRESS1	DRAM
	output logic [`AXI_IDS_BITS-1:0] AWID_S5_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S5_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S5_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S5_F,
	output logic [1:0] AWBURST_S5_F,
	output logic AWVALID_S5_F,
	input AWREADY_S5_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S5_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S5_F,
	output logic WLAST_S5_F,
	output logic WVALID_S5_F,
	input WREADY_S5_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S5_F,
	input [1:0] BRESP_S5_F,
	input BVALID_S5_F,
	output logic BREADY_S5_F,
	
	//READ ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] ARID_S5_F,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S5_F,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S5_F,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S5_F,
	output logic [1:0] ARBURST_S5_F,
	output logic ARVALID_S5_F,
	input ARREADY_S5_F,
	
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S5_F,
	input [`AXI_DATA_BITS-1:0] RDATA_S5_F,
	input [1:0] RRESP_S5_F,
	input RLAST_S5_F,
	input RVALID_S5_F,
	output logic RREADY_S5_F,
	
	//WRITE ADDRESS1	PWM
	output logic [`AXI_IDS_BITS-1:0] AWID_S6_F,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S6_F,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S6_F,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S6_F,
	output logic [1:0] AWBURST_S6_F,
	output logic AWVALID_S6_F,
	input AWREADY_S6_F,
	
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S6_F,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S6_F,
	output logic WLAST_S6_F,
	output logic WVALID_S6_F,
	input WREADY_S6_F,
	
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S6_F,
	input [1:0] BRESP_S6_F,
	input BVALID_S6_F,
	output logic BREADY_S6_F
);
    //---------- you should put your design here ----------//

//state machine
parameter read_IDLE=4'd0;
parameter M0_read_S0=4'd1; //ROM
parameter M0_read_S1=4'd2; //IM
parameter M0_read_S2=4'd3; //DM
parameter M0_read_S3=4'd4; //sensor_ctrl
parameter M0_read_S5=4'd6; //DRAM

parameter M1_read_S0=4'd7; //ROM
parameter M1_read_S1=4'd8; //IM
parameter M1_read_S2=4'd9; //DM
parameter M1_read_S3=4'd10; //sensor_ctrl
parameter M1_read_S5=4'd12; //DRAM


parameter write_IDLE=3'd0;
parameter M1_write_S1=3'd1; //IM
parameter M1_write_S2=3'd2; //DM
parameter M1_write_S3=3'd3; //sensor_ctrl
parameter M1_write_S4=3'd4; //WDT
parameter M1_write_S5=3'd5; //DRAM
parameter M1_write_S6=3'd6; //PWM

logic [3:0] read_curr_state,read_next_state;
logic [2:0] write_curr_state,write_next_state;

//SLAVE INTERFACE FOR MASTERS
	
	//WRITE ADDRESS
logic [`AXI_ID_BITS-1:0] AWID_M1;
logic [`AXI_ADDR_BITS-1:0] AWADDR_M1;
logic [`AXI_LEN_BITS-1:0] AWLEN_M1;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_M1;
logic [1:0] AWBURST_M1;
logic AWVALID_M1;
logic AWREADY_M1;
	
//WRITE DATA
logic [`AXI_DATA_BITS-1:0] WDATA_M1;
logic [`AXI_STRB_BITS-1:0] WSTRB_M1;
logic WLAST_M1;
logic WVALID_M1;
logic WREADY_M1;

//WRITE RESPONSE
logic [`AXI_ID_BITS-1:0] BID_M1;
logic [1:0] BRESP_M1;
logic BVALID_M1;
logic BREADY_M1;

//READ ADDRESS0
logic [`AXI_ID_BITS-1:0] ARID_M0;
logic [`AXI_ADDR_BITS-1:0] ARADDR_M0;
logic [`AXI_LEN_BITS-1:0] ARLEN_M0;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_M0;
logic [1:0] ARBURST_M0;
logic ARVALID_M0;
logic ARREADY_M0;

//READ DATA0
logic [`AXI_ID_BITS-1:0] RID_M0;
logic [`AXI_DATA_BITS-1:0] RDATA_M0;
logic [1:0] RRESP_M0;
logic RLAST_M0;
logic RVALID_M0;
logic RREADY_M0;

//READ ADDRESS1
logic [`AXI_ID_BITS-1:0] ARID_M1;
logic [`AXI_ADDR_BITS-1:0] ARADDR_M1;
logic [`AXI_LEN_BITS-1:0] ARLEN_M1;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_M1;
logic [1:0] ARBURST_M1;
logic ARVALID_M1;
logic ARREADY_M1;

//READ DATA1
logic [`AXI_ID_BITS-1:0] RID_M1;
logic [`AXI_DATA_BITS-1:0] RDATA_M1;
logic [1:0] RRESP_M1;
logic RLAST_M1;
logic RVALID_M1;
logic RREADY_M1;




//MASTER INTERFACE FOR SLAVES

//READ ADDRESS0   ROM
logic [`AXI_IDS_BITS-1:0] ARID_S0;
logic [`AXI_ADDR_BITS-1:0] ARADDR_S0;
logic [`AXI_LEN_BITS-1:0] ARLEN_S0;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0;
logic [1:0] ARBURST_S0;
logic ARVALID_S0;
logic ARREADY_S0;

//READ DATA0
logic [`AXI_IDS_BITS-1:0] RID_S0;
logic [`AXI_DATA_BITS-1:0] RDATA_S0;
logic [1:0] RRESP_S0;
logic RLAST_S0;
logic RVALID_S0;
logic RREADY_S0;

//WRITE ADDRESS1	IM
logic [`AXI_IDS_BITS-1:0] AWID_S1;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S1;
logic [`AXI_LEN_BITS-1:0] AWLEN_S1;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1;
logic [1:0] AWBURST_S1;
logic AWVALID_S1;
logic AWREADY_S1;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S1;
logic [`AXI_STRB_BITS-1:0] WSTRB_S1;
logic WLAST_S1;
logic WVALID_S1;
logic WREADY_S1;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S1;
logic [1:0] BRESP_S1;
logic BVALID_S1;
logic BREADY_S1;

//READ ADDRESS1
logic [`AXI_IDS_BITS-1:0] ARID_S1;
logic [`AXI_ADDR_BITS-1:0] ARADDR_S1;
logic [`AXI_LEN_BITS-1:0] ARLEN_S1;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1;
logic [1:0] ARBURST_S1;
logic ARVALID_S1;
logic ARREADY_S1;

//READ DATA1
logic [`AXI_IDS_BITS-1:0] RID_S1;
logic [`AXI_DATA_BITS-1:0] RDATA_S1;
logic [1:0] RRESP_S1;
logic RLAST_S1;
logic RVALID_S1;
logic RREADY_S1;

//WRITE ADDRESS1	DM
logic [`AXI_IDS_BITS-1:0] AWID_S2;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S2;
logic [`AXI_LEN_BITS-1:0] AWLEN_S2;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S2;
logic [1:0] AWBURST_S2;
logic AWVALID_S2;
logic AWREADY_S2;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S2;
logic [`AXI_STRB_BITS-1:0] WSTRB_S2;
logic WLAST_S2;
logic WVALID_S2;
logic WREADY_S2;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S2;
logic [1:0] BRESP_S2;
logic BVALID_S2;
logic BREADY_S2;

//READ ADDRESS1
logic [`AXI_IDS_BITS-1:0] ARID_S2;
logic [`AXI_ADDR_BITS-1:0] ARADDR_S2;
logic [`AXI_LEN_BITS-1:0] ARLEN_S2;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_S2;
logic [1:0] ARBURST_S2;
logic ARVALID_S2;
logic ARREADY_S2;

//READ DATA1
logic [`AXI_IDS_BITS-1:0] RID_S2;
logic [`AXI_DATA_BITS-1:0] RDATA_S2;
logic [1:0] RRESP_S2;
logic RLAST_S2;
logic RVALID_S2;
logic RREADY_S2;

//WRITE ADDRESS1	sensor_ctrl
logic [`AXI_IDS_BITS-1:0] AWID_S3;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S3;
logic [`AXI_LEN_BITS-1:0] AWLEN_S3;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S3;
logic [1:0] AWBURST_S3;
logic AWVALID_S3;
logic AWREADY_S3;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S3;
logic [`AXI_STRB_BITS-1:0] WSTRB_S3;
logic WLAST_S3;
logic WVALID_S3;
logic WREADY_S3;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S3;
logic [1:0] BRESP_S3;
logic BVALID_S3;
logic BREADY_S3;

//READ ADDRESS1
logic [`AXI_IDS_BITS-1:0] ARID_S3;
logic [`AXI_ADDR_BITS-1:0] ARADDR_S3;
logic [`AXI_LEN_BITS-1:0] ARLEN_S3;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_S3;
logic [1:0] ARBURST_S3;
logic ARVALID_S3;
logic ARREADY_S3;

//READ DATA1
logic [`AXI_IDS_BITS-1:0] RID_S3;
logic [`AXI_DATA_BITS-1:0] RDATA_S3;
logic [1:0] RRESP_S3;
logic RLAST_S3;
logic RVALID_S3;
logic RREADY_S3;

//WRITE ADDRESS1	WDT
logic [`AXI_IDS_BITS-1:0] AWID_S4;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S4;
logic [`AXI_LEN_BITS-1:0] AWLEN_S4;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S4;
logic [1:0] AWBURST_S4;
logic AWVALID_S4;
logic AWREADY_S4;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S4;
logic [`AXI_STRB_BITS-1:0] WSTRB_S4;
logic WLAST_S4;
logic WVALID_S4;
logic WREADY_S4;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S4;
logic [1:0] BRESP_S4;
logic BVALID_S4;
logic BREADY_S4;


//WRITE ADDRESS1	DRAM
logic [`AXI_IDS_BITS-1:0] AWID_S5;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S5;
logic [`AXI_LEN_BITS-1:0] AWLEN_S5;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S5;
logic [1:0] AWBURST_S5;
logic AWVALID_S5;
logic AWREADY_S5;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S5;
logic [`AXI_STRB_BITS-1:0] WSTRB_S5;
logic WLAST_S5;
logic WVALID_S5;
logic WREADY_S5;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S5;
logic [1:0] BRESP_S5;
logic BVALID_S5;
logic BREADY_S5;

//READ ADDRESS1
logic [`AXI_IDS_BITS-1:0] ARID_S5;
logic [`AXI_ADDR_BITS-1:0] ARADDR_S5;
logic [`AXI_LEN_BITS-1:0] ARLEN_S5;
logic [`AXI_SIZE_BITS-1:0] ARSIZE_S5;
logic [1:0] ARBURST_S5;
logic ARVALID_S5;
logic ARREADY_S5;

//READ DATA1
logic [`AXI_IDS_BITS-1:0] RID_S5;
logic [`AXI_DATA_BITS-1:0] RDATA_S5;
logic [1:0] RRESP_S5;
logic RLAST_S5;
logic RVALID_S5;
logic RREADY_S5;

//WRITE ADDRESS1	PWM
logic [`AXI_IDS_BITS-1:0] AWID_S6;
logic [`AXI_ADDR_BITS-1:0] AWADDR_S6;
logic [`AXI_LEN_BITS-1:0] AWLEN_S6;
logic [`AXI_SIZE_BITS-1:0] AWSIZE_S6;
logic [1:0] AWBURST_S6;
logic AWVALID_S6;
logic AWREADY_S6;

//WRITE DATA1
logic [`AXI_DATA_BITS-1:0] WDATA_S6;
logic [`AXI_STRB_BITS-1:0] WSTRB_S6;
logic WLAST_S6;
logic WVALID_S6;
logic WREADY_S6;

//WRITE RESPONSE1
logic [`AXI_IDS_BITS-1:0] BID_S6;
logic [1:0] BRESP_S6;
logic BVALID_S6;
logic BREADY_S6;


logic [48:0] aw_s1_wdata,aw_s1_rdata;
logic [48:0] aw_m1_wdata,aw_m1_rdata;
logic [48:0] aw_m2_wdata,aw_m2_rdata;
logic [48:0] aw_m3_wdata,aw_m3_rdata;
logic [48:0] aw_m4_wdata,aw_m4_rdata;
logic [48:0] aw_m5_wdata,aw_m5_rdata;
logic [48:0] aw_m6_wdata,aw_m6_rdata;

assign aw_s1_wdata={4'd0,AWID_M1_F,AWADDR_M1_F,AWLEN_M1_F,AWSIZE_M1_F,AWBURST_M1_F};
assign AWID_M1=aw_s1_rdata[44:41];
assign AWADDR_M1=aw_s1_rdata[40:9];
assign AWLEN_M1=aw_s1_rdata[8:5];
assign AWSIZE_M1=aw_s1_rdata[4:2];
assign AWBURST_M1=aw_s1_rdata[1:0];

assign aw_m1_wdata={AWID_S1,AWADDR_S1,AWLEN_S1,AWSIZE_S1,AWBURST_S1};
assign AWID_S1_F=aw_m1_rdata[48:41];
assign AWADDR_S1_F=aw_m1_rdata[40:9];
assign AWLEN_S1_F=aw_m1_rdata[8:5];
assign AWSIZE_S1_F=aw_m1_rdata[4:2];
assign AWBURST_S1_F=aw_m1_rdata[1:0];

assign aw_m2_wdata={AWID_S2,AWADDR_S2,AWLEN_S2,AWSIZE_S2,AWBURST_S2};
assign AWID_S2_F=aw_m2_rdata[48:41];
assign AWADDR_S2_F=aw_m2_rdata[40:9];
assign AWLEN_S2_F=aw_m2_rdata[8:5];
assign AWSIZE_S2_F=aw_m2_rdata[4:2];
assign AWBURST_S2_F=aw_m2_rdata[1:0];

assign aw_m3_wdata={AWID_S3,AWADDR_S3,AWLEN_S3,AWSIZE_S3,AWBURST_S3};
assign AWID_S3_F=aw_m3_rdata[48:41];
assign AWADDR_S3_F=aw_m3_rdata[40:9];
assign AWLEN_S3_F=aw_m3_rdata[8:5];
assign AWSIZE_S3_F=aw_m3_rdata[4:2];
assign AWBURST_S3_F=aw_m3_rdata[1:0];

assign aw_m4_wdata={AWID_S4,AWADDR_S4,AWLEN_S4,AWSIZE_S4,AWBURST_S4};
assign AWID_S4_F=aw_m4_rdata[48:41];
assign AWADDR_S4_F=aw_m4_rdata[40:9];
assign AWLEN_S4_F=aw_m4_rdata[8:5];
assign AWSIZE_S4_F=aw_m4_rdata[4:2];
assign AWBURST_S4_F=aw_m4_rdata[1:0];

assign aw_m5_wdata={AWID_S5,AWADDR_S5,AWLEN_S5,AWSIZE_S5,AWBURST_S5};
assign AWID_S5_F=aw_m5_rdata[48:41];
assign AWADDR_S5_F=aw_m5_rdata[40:9];
assign AWLEN_S5_F=aw_m5_rdata[8:5];
assign AWSIZE_S5_F=aw_m5_rdata[4:2];
assign AWBURST_S5_F=aw_m5_rdata[1:0];

assign aw_m6_wdata={AWID_S6,AWADDR_S6,AWLEN_S6,AWSIZE_S6,AWBURST_S6};
assign AWID_S6_F=aw_m6_rdata[48:41];
assign AWADDR_S6_F=aw_m6_rdata[40:9];
assign AWLEN_S6_F=aw_m6_rdata[8:5];
assign AWSIZE_S6_F=aw_m6_rdata[4:2];
assign AWBURST_S6_F=aw_m6_rdata[1:0];

//aw
FIFO_AW aw_s1(
	.wdata(aw_s1_wdata),
	.valid_i(AWVALID_M1_F),
	.valid_o(AWVALID_M1),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(aw_s1_rdata),
	.ready_i(AWREADY_M1),
	.ready_o(AWREADY_M1_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_AW aw_m1(
	.wdata(aw_m1_wdata),
	.valid_i(AWVALID_S1),
	.valid_o(AWVALID_S1_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m1_rdata),
	.ready_i(AWREADY_S1_F),
	.ready_o(AWREADY_S1),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);

FIFO_AW aw_m2(
	.wdata(aw_m2_wdata),
	.valid_i(AWVALID_S2),
	.valid_o(AWVALID_S2_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m2_rdata),
	.ready_i(AWREADY_S2_F),
	.ready_o(AWREADY_S2),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);
FIFO_AW aw_m3(
	.wdata(aw_m3_wdata),
	.valid_i(AWVALID_S3),
	.valid_o(AWVALID_S3_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m3_rdata),
	.ready_i(AWREADY_S3_F),
	.ready_o(AWREADY_S3),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_AW aw_m4(
	.wdata(aw_m4_wdata),
	.valid_i(AWVALID_S4),
	.valid_o(AWVALID_S4_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m4_rdata),
	.ready_i(AWREADY_S4_F),
	.ready_o(AWREADY_S4),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_AW aw_m5(
	.wdata(aw_m5_wdata),
	.valid_i(AWVALID_S5),
	.valid_o(AWVALID_S5_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m5_rdata),
	.ready_i(AWREADY_S5_F),
	.ready_o(AWREADY_S5),
	.rrst_n(~DRAM_RST_i),
	.rclk(DRAM_CLK_i)
);

FIFO_AW aw_m6(
	.wdata(aw_m6_wdata),
	.valid_i(AWVALID_S6),
	.valid_o(AWVALID_S6_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(aw_m6_rdata),
	.ready_i(AWREADY_S6_F),
	.ready_o(AWREADY_S6),
	.rrst_n(~PWM_RST_i),
	.rclk(PWM_CLK_i)
);

logic [36:0] w_s1_wdata,w_s1_rdata;
logic [36:0] w_m1_wdata,w_m1_rdata;
logic [36:0] w_m2_wdata,w_m2_rdata;
logic [36:0] w_m3_wdata,w_m3_rdata;
logic [36:0] w_m4_wdata,w_m4_rdata;
logic [36:0] w_m5_wdata,w_m5_rdata;
logic [36:0] w_m6_wdata,w_m6_rdata;

assign w_s1_wdata={WDATA_M1_F,WSTRB_M1_F,WLAST_M1_F};
assign WDATA_M1=w_s1_rdata[36:5];
assign WSTRB_M1=w_s1_rdata[4:1];
assign WLAST_M1=w_s1_rdata[0];

assign w_m1_wdata={WDATA_S1,WSTRB_S1,WLAST_S1};
assign WDATA_S1_F=w_m1_rdata[36:5];
assign WSTRB_S1_F=w_m1_rdata[4:1];
assign WLAST_S1_F=w_m1_rdata[0];

assign w_m2_wdata={WDATA_S2,WSTRB_S2,WLAST_S2};
assign WDATA_S2_F=w_m2_rdata[36:5];
assign WSTRB_S2_F=w_m2_rdata[4:1];
assign WLAST_S2_F=w_m2_rdata[0];

assign w_m3_wdata={WDATA_S3,WSTRB_S3,WLAST_S3};
assign WDATA_S3_F=w_m3_rdata[36:5];
assign WSTRB_S3_F=w_m3_rdata[4:1];
assign WLAST_S3_F=w_m3_rdata[0];

assign w_m4_wdata={WDATA_S4,WSTRB_S4,WLAST_S4};
assign WDATA_S4_F=w_m4_rdata[36:5];
assign WSTRB_S4_F=w_m4_rdata[4:1];
assign WLAST_S4_F=w_m4_rdata[0];

assign w_m5_wdata={WDATA_S5,WSTRB_S5,WLAST_S5};
assign WDATA_S5_F=w_m5_rdata[36:5];
assign WSTRB_S5_F=w_m5_rdata[4:1];
assign WLAST_S5_F=w_m5_rdata[0];

assign w_m6_wdata={WDATA_S6,WSTRB_S6,WLAST_S6};
assign WDATA_S6_F=w_m6_rdata[36:5];
assign WSTRB_S6_F=w_m6_rdata[4:1];
assign WLAST_S6_F=w_m6_rdata[0];

//w
FIFO_W w_s1(
	.wdata(w_s1_wdata),
	.valid_i(WVALID_M1_F),
	.valid_o(WVALID_M1),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(w_s1_rdata),
	.ready_i(WREADY_M1),
	.ready_o(WREADY_M1_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_W w_m1(
	.wdata(w_m1_wdata),
	.valid_i(WVALID_S1),
	.valid_o(WVALID_S1_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m1_rdata),
	.ready_i(WREADY_S1_F),
	.ready_o(WREADY_S1),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);

FIFO_W w_m2(
	.wdata(w_m2_wdata),
	.valid_i(WVALID_S2),
	.valid_o(WVALID_S2_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m2_rdata),
	.ready_i(WREADY_S2_F),
	.ready_o(WREADY_S2),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);

FIFO_W w_m3(
	.wdata(w_m3_wdata),
	.valid_i(WVALID_S3),
	.valid_o(WVALID_S3_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m3_rdata),
	.ready_i(WREADY_S3_F),
	.ready_o(WREADY_S3),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_W w_m4(
	.wdata(w_m4_wdata),
	.valid_i(WVALID_S4),
	.valid_o(WVALID_S4_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m4_rdata),
	.ready_i(WREADY_S4_F),
	.ready_o(WREADY_S4),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_W w_m5(
	.wdata(w_m5_wdata),
	.valid_i(WVALID_S5),
	.valid_o(WVALID_S5_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m5_rdata),
	.ready_i(WREADY_S5_F),
	.ready_o(WREADY_S5),
	.rrst_n(~DRAM_RST_i),
	.rclk(DRAM_CLK_i)
);

FIFO_W w_m6(
	.wdata(w_m6_wdata),
	.valid_i(WVALID_S6),
	.valid_o(WVALID_S6_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(w_m6_rdata),
	.ready_i(WREADY_S6_F),
	.ready_o(WREADY_S6),
	.rrst_n(~PWM_RST_i),
	.rclk(PWM_CLK_i)
);

logic [9:0] b_s1_wdata,b_s1_rdata;
logic [9:0] b_m1_wdata,b_m1_rdata;
logic [9:0] b_m2_wdata,b_m2_rdata;
logic [9:0] b_m3_wdata,b_m3_rdata;
logic [9:0] b_m4_wdata,b_m4_rdata;
logic [9:0] b_m5_wdata,b_m5_rdata;
logic [9:0] b_m6_wdata,b_m6_rdata;

assign b_s1_wdata={4'd0,BID_M1,BRESP_M1};
assign BID_M1_F=b_s1_rdata[5:2];
assign BRESP_M1_F=b_s1_rdata[1:0];

assign b_m1_wdata={BID_S1_F,BRESP_S1_F};
assign BID_S1=b_m1_rdata[9:2];
assign BRESP_S1=b_m1_rdata[1:0];

assign b_m2_wdata={BID_S2_F,BRESP_S2_F};
assign BID_S2=b_m2_rdata[9:2];
assign BRESP_S2=b_m2_rdata[1:0];

assign b_m3_wdata={BID_S3_F,BRESP_S3_F};
assign BID_S3=b_m3_rdata[9:2];
assign BRESP_S3=b_m3_rdata[1:0];

assign b_m4_wdata={BID_S4_F,BRESP_S4_F};
assign BID_S4=b_m4_rdata[9:2];
assign BRESP_S4=b_m4_rdata[1:0];

assign b_m5_wdata={BID_S5_F,BRESP_S5_F};
assign BID_S5=b_m5_rdata[9:2];
assign BRESP_S5=b_m5_rdata[1:0];

assign b_m6_wdata={BID_S6_F,BRESP_S6_F};
assign BID_S6=b_m6_rdata[9:2];
assign BRESP_S6=b_m6_rdata[1:0];

//b
FIFO_B b_s1(
	.wdata(b_s1_wdata),
	.valid_i(BVALID_M1),
	.valid_o(BVALID_M1_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(b_s1_rdata),
	.ready_i(BREADY_M1_F),
	.ready_o(BREADY_M1),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_B b_m1(
	.wdata(b_m1_wdata),
	.valid_i(BVALID_S1_F),
	.valid_o(BVALID_S1),
	.wrst_n(~SRAM_RST_i),
	.wclk(SRAM_CLK_i),
	.rdata(b_m1_rdata),
	.ready_i(BREADY_S1),
	.ready_o(BREADY_S1_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_B b_m2(
	.wdata(b_m2_wdata),
	.valid_i(BVALID_S2_F),
	.valid_o(BVALID_S2),
	.wrst_n(~SRAM_RST_i),
	.wclk(SRAM_CLK_i),
	.rdata(b_m2_rdata),
	.ready_i(BREADY_S2),
	.ready_o(BREADY_S2_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_B b_m3(
	.wdata(b_m3_wdata),
	.valid_i(BVALID_S3_F),
	.valid_o(BVALID_S3),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(b_m3_rdata),
	.ready_i(BREADY_S3),
	.ready_o(BREADY_S3_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_B b_m4(
	.wdata(b_m4_wdata),
	.valid_i(BVALID_S4_F),
	.valid_o(BVALID_S4),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(b_m4_rdata),
	.ready_i(BREADY_S4),
	.ready_o(BREADY_S4_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_B b_m5(
	.wdata(b_m5_wdata),
	.valid_i(BVALID_S5_F),
	.valid_o(BVALID_S5),
	.wrst_n(~DRAM_RST_i),
	.wclk(DRAM_CLK_i),
	.rdata(b_m5_rdata),
	.ready_i(BREADY_S5),
	.ready_o(BREADY_S5_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_B b_m6(
	.wdata(b_m6_wdata),
	.valid_i(BVALID_S6_F),
	.valid_o(BVALID_S6),
	.wrst_n(~PWM_RST_i),
	.wclk(PWM_CLK_i),
	.rdata(b_m6_rdata),
	.ready_i(BREADY_S6),
	.ready_o(BREADY_S6_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

logic [48:0] ar_s0_wdata,ar_s0_rdata;						 
logic [48:0] ar_s1_wdata,ar_s1_rdata;
logic [48:0] ar_m0_wdata,ar_m0_rdata;
logic [48:0] ar_m1_wdata,ar_m1_rdata;
logic [48:0] ar_m2_wdata,ar_m2_rdata;
logic [48:0] ar_m3_wdata,ar_m3_rdata;
logic [48:0] ar_m5_wdata,ar_m5_rdata;

assign ar_s0_wdata={4'd0,ARID_M0_F,ARADDR_M0_F,ARLEN_M0_F,ARSIZE_M0_F,ARBURST_M0_F};
assign ARID_M0=ar_s0_rdata[44:41];
assign ARADDR_M0=ar_s0_rdata[40:9];
assign ARLEN_M0=ar_s0_rdata[8:5];
assign ARSIZE_M0=ar_s0_rdata[4:2];
assign ARBURST_M0=ar_s0_rdata[1:0];

assign ar_s1_wdata={4'd0,ARID_M1_F,ARADDR_M1_F,ARLEN_M1_F,ARSIZE_M1_F,ARBURST_M1_F};
assign ARID_M1=ar_s1_rdata[44:41];
assign ARADDR_M1=ar_s1_rdata[40:9];
assign ARLEN_M1=ar_s1_rdata[8:5];
assign ARSIZE_M1=ar_s1_rdata[4:2];
assign ARBURST_M1=ar_s1_rdata[1:0];

assign ar_m0_wdata={ARID_S0,ARADDR_S0,ARLEN_S0,ARSIZE_S0,ARBURST_S0};
assign ARID_S0_F=ar_m0_rdata[48:41];
assign ARADDR_S0_F=ar_m0_rdata[40:9];
assign ARLEN_S0_F=ar_m0_rdata[8:5];
assign ARSIZE_S0_F=ar_m0_rdata[4:2];
assign ARBURST_S0_F=ar_m0_rdata[1:0];

assign ar_m1_wdata={ARID_S1,ARADDR_S1,ARLEN_S1,ARSIZE_S1,ARBURST_S1};
assign ARID_S1_F=ar_m1_rdata[48:41];
assign ARADDR_S1_F=ar_m1_rdata[40:9];
assign ARLEN_S1_F=ar_m1_rdata[8:5];
assign ARSIZE_S1_F=ar_m1_rdata[4:2];
assign ARBURST_S1_F=ar_m1_rdata[1:0];

assign ar_m2_wdata={ARID_S2,ARADDR_S2,ARLEN_S2,ARSIZE_S2,ARBURST_S2};
assign ARID_S2_F=ar_m2_rdata[48:41];
assign ARADDR_S2_F=ar_m2_rdata[40:9];
assign ARLEN_S2_F=ar_m2_rdata[8:5];
assign ARSIZE_S2_F=ar_m2_rdata[4:2];
assign ARBURST_S2_F=ar_m2_rdata[1:0];

assign ar_m3_wdata={ARID_S3,ARADDR_S3,ARLEN_S3,ARSIZE_S3,ARBURST_S3};
assign ARID_S3_F=ar_m3_rdata[48:41];
assign ARADDR_S3_F=ar_m3_rdata[40:9];
assign ARLEN_S3_F=ar_m3_rdata[8:5];
assign ARSIZE_S3_F=ar_m3_rdata[4:2];
assign ARBURST_S3_F=ar_m3_rdata[1:0];

assign ar_m5_wdata={ARID_S5,ARADDR_S5,ARLEN_S5,ARSIZE_S5,ARBURST_S5};
assign ARID_S5_F=ar_m5_rdata[48:41];
assign ARADDR_S5_F=ar_m5_rdata[40:9];
assign ARLEN_S5_F=ar_m5_rdata[8:5];
assign ARSIZE_S5_F=ar_m5_rdata[4:2];
assign ARBURST_S5_F=ar_m5_rdata[1:0];

//ar
FIFO_AR ar_s0(
	.wdata(ar_s0_wdata),
	.valid_i(ARVALID_M0_F),
	.valid_o(ARVALID_M0),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(ar_s0_rdata),
	.ready_i(ARREADY_M0),
	.ready_o(ARREADY_M0_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_AR ar_s1(
	.wdata(ar_s1_wdata),
	.valid_i(ARVALID_M1_F),
	.valid_o(ARVALID_M1),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(ar_s1_rdata),
	.ready_i(ARREADY_M1),
	.ready_o(ARREADY_M1_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_AR ar_m0(
	.wdata(ar_m0_wdata),
	.valid_i(ARVALID_S0),
	.valid_o(ARVALID_S0_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(ar_m0_rdata),
	.ready_i(ARREADY_S0_F),
	.ready_o(ARREADY_S0),
	.rrst_n(~ROM_RST_i),
	.rclk(ROM_CLK_i)
);

FIFO_AR ar_m1(
	.wdata(ar_m1_wdata),
	.valid_i(ARVALID_S1),
	.valid_o(ARVALID_S1_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(ar_m1_rdata),
	.ready_i(ARREADY_S1_F),
	.ready_o(ARREADY_S1),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);

FIFO_AR ar_m2(
	.wdata(ar_m2_wdata),
	.valid_i(ARVALID_S2),
	.valid_o(ARVALID_S2_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(ar_m2_rdata),
	.ready_i(ARREADY_S2_F),
	.ready_o(ARREADY_S2),
	.rrst_n(~SRAM_RST_i),
	.rclk(SRAM_CLK_i)
);

FIFO_AR ar_m3(
	.wdata(ar_m3_wdata),
	.valid_i(ARVALID_S3),
	.valid_o(ARVALID_S3_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(ar_m3_rdata),
	.ready_i(ARREADY_S3_F),
	.ready_o(ARREADY_S3),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_AR ar_m5(
	.wdata(ar_m5_wdata),
	.valid_i(ARVALID_S5),
	.valid_o(ARVALID_S5_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(ar_m5_rdata),
	.ready_i(ARREADY_S5_F),
	.ready_o(ARREADY_S5),
	.rrst_n(~DRAM_RST_i),
	.rclk(DRAM_CLK_i)
);

logic [41:0] r_s0_wdata,r_s0_rdata;
logic [41:0] r_s1_wdata,r_s1_rdata;
logic [41:0] r_m0_wdata,r_m0_rdata;
logic [41:0] r_m1_wdata,r_m1_rdata;
logic [41:0] r_m2_wdata,r_m2_rdata;
logic [41:0] r_m3_wdata,r_m3_rdata;
logic [41:0] r_m5_wdata,r_m5_rdata;

assign r_s0_wdata={4'd0,RID_M0,RDATA_M0,RRESP_M0};
assign RID_M0_F=r_s0_rdata[37:34];
assign RDATA_M0_F=r_s0_rdata[33:2];
assign RRESP_M0_F=r_s0_rdata[1:0];

assign r_s1_wdata={4'd0,RID_M1,RDATA_M1,RRESP_M1};
assign RID_M1_F=r_s1_rdata[37:34];
assign RDATA_M1_F=r_s1_rdata[33:2];
assign RRESP_M1_F=r_s1_rdata[1:0];

assign r_m0_wdata={RID_S0_F,RDATA_S0_F,RRESP_S0_F};
assign RID_S0=r_m0_rdata[41:34];
assign RDATA_S0=r_m0_rdata[33:2];
assign RRESP_S0=r_m0_rdata[1:0];

assign r_m1_wdata={RID_S1_F,RDATA_S1_F,RRESP_S1_F};
assign RID_S1=r_m1_rdata[41:34];
assign RDATA_S1=r_m1_rdata[33:2];
assign RRESP_S1=r_m1_rdata[1:0];

assign r_m2_wdata={RID_S2_F,RDATA_S2_F,RRESP_S2_F};
assign RID_S2=r_m2_rdata[41:34];
assign RDATA_S2=r_m2_rdata[33:2];
assign RRESP_S2=r_m2_rdata[1:0];

assign r_m3_wdata={RID_S3_F,RDATA_S3_F,RRESP_S3_F};
assign RID_S3=r_m3_rdata[41:34];
assign RDATA_S3=r_m3_rdata[33:2];
assign RRESP_S3=r_m3_rdata[1:0];

assign r_m5_wdata={RID_S5_F,RDATA_S5_F,RRESP_S5_F};
assign RID_S5=r_m5_rdata[41:34];
assign RDATA_S5=r_m5_rdata[33:2];
assign RRESP_S5=r_m5_rdata[1:0];
//r
FIFO_R r_s0(
	.wdata(r_s0_wdata),
	.valid_i(RVALID_M0),
	.valid_o(RVALID_M0_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(r_s0_rdata),
	.ready_i(RREADY_M0_F),
	.ready_o(RREADY_M0),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_R r_s1(
	.wdata(r_s1_wdata),
	.valid_i(RVALID_M1),
	.valid_o(RVALID_M1_F),
	.wrst_n(~ARESETn),
	.wclk(ACLK),
	.rdata(r_s1_rdata),
	.ready_i(RREADY_M1_F),
	.ready_o(RREADY_M1),
	.rrst_n(~CPU_RST_i),
	.rclk(CPU_CLK_i)
);

FIFO_R r_m0(
	.wdata(r_m0_wdata),
	.valid_i(RVALID_S0_F),
	.valid_o(RVALID_S0),
	.wrst_n(~ROM_RST_i),
	.wclk(ROM_CLK_i),
	.rdata(r_m0_rdata),
	.ready_i(RREADY_S0),
	.ready_o(RREADY_S0_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_R r_m1(
	.wdata(r_m1_wdata),
	.valid_i(RVALID_S1_F),
	.valid_o(RVALID_S1),
	.wrst_n(~SRAM_RST_i),
	.wclk(SRAM_CLK_i),
	.rdata(r_m1_rdata),
	.ready_i(RREADY_S1),
	.ready_o(RREADY_S1_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_R r_m2(
	.wdata(r_m2_wdata),
	.valid_i(RVALID_S2_F),
	.valid_o(RVALID_S2),
	.wrst_n(~SRAM_RST_i),
	.wclk(SRAM_CLK_i),
	.rdata(r_m2_rdata),
	.ready_i(RREADY_S2),
	.ready_o(RREADY_S2_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_R r_m3(
	.wdata(r_m3_wdata),
	.valid_i(RVALID_S3_F),
	.valid_o(RVALID_S3),
	.wrst_n(~CPU_RST_i),
	.wclk(CPU_CLK_i),
	.rdata(r_m3_rdata),
	.ready_i(RREADY_S3),
	.ready_o(RREADY_S3_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

FIFO_R r_m5(
	.wdata(r_m5_wdata),
	.valid_i(RVALID_S5_F),
	.valid_o(RVALID_S5),
	.wrst_n(~DRAM_RST_i),
	.wclk(DRAM_CLK_i),
	.rdata(r_m5_rdata),
	.ready_i(RREADY_S5),
	.ready_o(RREADY_S5_F),
	.rrst_n(~ARESETn),
	.rclk(ACLK)
);

logic [2:0] counter_S0;
always_ff@(posedge CPU_CLK_i ) begin
	if(~CPU_RST_i) counter_S0<=3'd0;
	else if(RVALID_M0_F==1'd1) counter_S0<=counter_S0+3'd1;
	else if(counter_S0==3'd4) counter_S0<=3'd0;
	else counter_S0<=counter_S0;
end
assign RLAST_M0_F=(counter_S0==3'd3)?RVALID_M0_F:1'd0;

logic [2:0] counter_S1;
always_ff@(posedge CPU_CLK_i ) begin
	if(~CPU_RST_i) counter_S1<=3'd0;
	else if(RVALID_M1_F==1'd1) counter_S1<=counter_S1+3'd1;
	else if(counter_S1==3'd4) counter_S1<=3'd0;
	else counter_S1<=counter_S1;
end
//assign RLAST_M1_F=(counter_S1==3'd3)?RVALID_M1_F:1'd0;
logic [3:0] len_reg;
always_comb begin
	if(len_reg==4'd0) RLAST_M1_F=RVALID_M1_F;
	else if(counter_S1==3'd3) RLAST_M1_F=RVALID_M1_F;
	else RLAST_M1_F=1'd0;
end

always_ff@(posedge CPU_CLK_i) begin
	if(~CPU_RST_i) len_reg<=4'd1;
	else if(ARVALID_M1_F==1'd1) len_reg<=ARLEN_M1_F;
	else len_reg<=len_reg;
end

logic [2:0] counter_M0;
always_ff@(posedge ACLK ) begin
	if(~ARESETn) counter_M0<=3'd0;
	else if(RVALID_S0==1'd1) counter_M0<=counter_M0+3'd1;
	else if(counter_M0==3'd4) counter_M0<=3'd0;
	else counter_M0<=counter_M0;
end
assign RLAST_S0=(counter_M0==3'd3)?RVALID_S0:1'd0;

logic [2:0] counter_M1;
always_ff@(posedge ACLK ) begin
	if(~ARESETn) counter_M1<=3'd0;
	else if(RVALID_S1==1'd1) counter_M1<=counter_M1+3'd1;
	else if(counter_M1==3'd4) counter_M1<=3'd0;
	else counter_M1<=counter_M1;
end
assign RLAST_S1=(counter_M1==3'd3)?RVALID_S1:1'd0;

logic [2:0] counter_M2;
always_ff@(posedge ACLK ) begin
	if(~ARESETn) counter_M2<=3'd0;
	else if(RVALID_S2==1'd1) counter_M2<=counter_M2+3'd1;
	else if(counter_M2==3'd4) counter_M2<=3'd0;
	else counter_M2<=counter_M2;
end
assign RLAST_S2=(counter_M2==3'd3)?RVALID_S2:1'd0;


assign RLAST_S3=RVALID_S3;

logic [2:0] counter_M5;
always_ff@(posedge ACLK ) begin
	if(~ARESETn) counter_M5<=3'd0;
	else if(RVALID_S5==1'd1) counter_M5<=counter_M5+3'd1;
	else if(counter_M5==3'd4) counter_M5<=3'd0;
	else counter_M5<=counter_M5;
end
assign RLAST_S5=(counter_M5==3'd3)?RVALID_S5:1'd0;

always_ff@(posedge ACLK ) begin
	if(~ARESETn) read_curr_state<=read_IDLE;
	else read_curr_state<=read_next_state;
end

always_ff@(posedge ACLK ) begin
	if(~ARESETn) write_curr_state<=write_IDLE;
	else write_curr_state<=write_next_state;
end

always_comb begin //next state logic for read
	unique case (read_curr_state)
		read_IDLE: begin
			if(ARVALID_M0==1'd1)  begin
				unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
				else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
				else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
				else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
				else  read_next_state=M0_read_S5; //DRAM
			end
			else if(ARVALID_M1==1'd1)  begin
				unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
				else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
				else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
				else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
				else  read_next_state=M1_read_S5; //DRAM
			end
			else read_next_state=read_IDLE;
		end
		M0_read_S0: begin //M0 read ROM
			unique if(RVALID_S0==1'd1 && RREADY_M0==1'd1 && RLAST_S0) begin
				unique if(ARVALID_M1==1'd1) begin
					unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
					else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
					else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
					else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
					else  read_next_state=M1_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M0_read_S0;
		end
		M0_read_S1: begin  //M0 read IM
			unique if(RVALID_S1==1'd1 && RREADY_M0==1'd1 && RLAST_S1) begin
				unique if(ARVALID_M1==1'd1) begin
					unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
					else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
					else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
					else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
					else  read_next_state=M1_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M0_read_S1;
		end
		M0_read_S2: begin //M0 read DM
			unique if(RVALID_S2==1'd1 && RREADY_M0==1'd1 && RLAST_S2) begin
				unique if(ARVALID_M1==1'd1) begin
					unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
					else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
					else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
					else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
					else  read_next_state=M1_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M0_read_S2;
		end
		M0_read_S3: begin //M0 read sensor_ctrl
			unique if(RVALID_S3==1'd1 && RREADY_M0==1'd1 && RLAST_S3) begin
				unique if(ARVALID_M1==1'd1) begin
					unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
					else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
					else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
					else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
					else  read_next_state=M1_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M0_read_S3;
		end
		M0_read_S5: begin //M0 read DRAM
			unique if(RVALID_S5==1'd1 && RREADY_M0==1'd1 && RLAST_S5) begin
				unique if(ARVALID_M1==1'd1) begin
					unique if(ARADDR_M1<=32'h00001FFF) read_next_state=M1_read_S0; //ROM
					else if(ARADDR_M1<=32'h0001FFFF && ARADDR_M1>=32'h00010000) read_next_state=M1_read_S1; //IM
					else if(ARADDR_M1<=32'h0002FFFF && ARADDR_M1>=32'h00020000) read_next_state=M1_read_S2; //DM
					else if(ARADDR_M1<=32'h100003FF && ARADDR_M1>=32'h10000000) read_next_state=M1_read_S3; //sensor_ctrl
					else  read_next_state=M1_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M0_read_S5;
		end
		M1_read_S0: begin  //M1 read ROM
			unique if(RVALID_S0==1'd1 && RREADY_M1==1'd1 && RLAST_S0) begin
				unique if(ARVALID_M0==1'd1) begin
					unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
					else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
					else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
					else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
					else  read_next_state=M0_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M1_read_S0;
		end
		M1_read_S1: begin //M1 read IM
			unique if(RVALID_S1==1'd1 && RREADY_M1==1'd1 && RLAST_S1) begin
				unique if(ARVALID_M0==1'd1) begin
					unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
					else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
					else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
					else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
					else  read_next_state=M0_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M1_read_S1;
		end
		M1_read_S2: begin //M1 read DM
			unique if(RVALID_S2==1'd1 && RREADY_M1==1'd1 && RLAST_S2) begin
				unique if(ARVALID_M0==1'd1) begin
					unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
					else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
					else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
					else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
					else  read_next_state=M0_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M1_read_S2;
		end
		M1_read_S3: begin //M1 read sensor_ctrl
			unique if(RVALID_S3==1'd1 && RREADY_M1==1'd1 && RLAST_S3) begin
				unique if(ARVALID_M0==1'd1) begin
					unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
					else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
					else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
					else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
					else  read_next_state=M0_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M1_read_S3;
		end
		M1_read_S5: begin //M1 read DRAM
			unique if(RVALID_S5==1'd1 && RREADY_M1==1'd1 && RLAST_S5) begin
				unique if(ARVALID_M0==1'd1) begin
					unique if(ARADDR_M0<=32'h00001FFF) read_next_state=M0_read_S0; //ROM
					else if(ARADDR_M0<=32'h0001FFFF && ARADDR_M0>=32'h00010000) read_next_state=M0_read_S1; //IM
					else if(ARADDR_M0<=32'h0002FFFF && ARADDR_M0>=32'h00020000) read_next_state=M0_read_S2; //DM
					else if(ARADDR_M0<=32'h100003FF && ARADDR_M0>=32'h10000000) read_next_state=M0_read_S3; //sensor_ctrl
					else  read_next_state=M0_read_S5; //DRAM
				end
				else read_next_state=read_IDLE;
			end
			else read_next_state=M1_read_S5;
		end
		default: begin
			read_next_state=read_IDLE;
		end
	endcase
end

always_comb begin //next state logic for write
	unique case (write_curr_state)
		write_IDLE: begin
			if(AWVALID_M1==1'd1)  begin
				unique if(AWADDR_M1<=32'h0001FFFF && AWADDR_M1>=32'h00010000) write_next_state=M1_write_S1; //IM
				else if(AWADDR_M1<=32'h0002FFFF && AWADDR_M1>=32'h00020000) write_next_state=M1_write_S2; //DM
				else if(AWADDR_M1<=32'h100003FF && AWADDR_M1>=32'h10000000) write_next_state=M1_write_S3; //sensor_ctrl
				else if(AWADDR_M1<=32'h100103FF && AWADDR_M1>=32'h10010000) write_next_state=M1_write_S4; //WDT
				else if(AWADDR_M1<=32'h201FFFFF && AWADDR_M1>=32'h20000000) write_next_state=M1_write_S5; //DRAM
				else write_next_state=M1_write_S6; //PWM
			end
			else write_next_state=write_IDLE;
		end
		M1_write_S1: begin
			unique if(BREADY_M1==1'd1 && BVALID_S1==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S1;
		end
		M1_write_S2: begin
			unique if(BREADY_M1==1'd1 && BVALID_S2==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S2;
		end
		M1_write_S3: begin
			unique if(BREADY_M1==1'd1 && BVALID_S3==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S3;
		end
		M1_write_S4: begin
			unique if(BREADY_M1==1'd1 && BVALID_S4==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S4;
		end
		M1_write_S5: begin
			unique if(BREADY_M1==1'd1 && BVALID_S5==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S5;
		end
		M1_write_S6: begin
			unique if(BREADY_M1==1'd1 && BVALID_S6==1'd1) write_next_state=write_IDLE;
			else write_next_state=M1_write_S6;
		end
		default: begin
			write_next_state=write_IDLE;
		end
	endcase
end

always_comb begin
	unique case (read_curr_state)
		read_IDLE: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
			
		end
		M0_read_S0: begin
			ARID_S0={4'd0,ARID_M0};//MASTER interface READ ADDRESS0
			ARADDR_S0=ARADDR_M0;
			ARLEN_S0=ARLEN_M0;
			ARSIZE_S0=ARSIZE_M0;
			ARBURST_S0=ARBURST_M0;
			ARVALID_S0=ARVALID_M0;
			
			RREADY_S0=RREADY_M0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			ARREADY_M0=ARREADY_S0; //SLAVE interface READ ADDRESS0
			
			RID_M0=RID_S0[3:0]; //SLAVE interface READ DATA0
			RDATA_M0=RDATA_S0;
			RRESP_M0=RRESP_S0;
			RLAST_M0=RLAST_S0;
			RVALID_M0=RVALID_S0;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
			
		end
		M0_read_S1: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1={4'd0,ARID_M0}; //MASTER interface READ ADDRESS1
			ARADDR_S1=ARADDR_M0;
			ARLEN_S1=ARLEN_M0;
			ARSIZE_S1=ARSIZE_M0;
			ARBURST_S1=ARBURST_M0;
			ARVALID_S1=ARVALID_M0;
					
			RREADY_S1=RREADY_M0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			ARREADY_M0=ARREADY_S1; //SLAVE interface READ ADDRESS0
			
			RID_M0=RID_S1[3:0]; //SLAVE interface READ DATA0
			RDATA_M0=RDATA_S1;
			RRESP_M0=RRESP_S1;
			RLAST_M0=RLAST_S1;
			RVALID_M0=RVALID_S1;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
			
		end
		M0_read_S2: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2={4'd0,ARID_M0}; //MASTER interface READ ADDRESS2
			ARADDR_S2=ARADDR_M0;
			ARLEN_S2=ARLEN_M0;
			ARSIZE_S2=ARSIZE_M0;
			ARBURST_S2=ARBURST_M0;
			ARVALID_S2=ARVALID_M0;
					
			RREADY_S2=RREADY_M0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=ARREADY_S2; //SLAVE interface READ ADDRESS0
			
			RID_M0=RID_S2[3:0]; //SLAVE interface READ DATA0
			RDATA_M0=RDATA_S2;
			RRESP_M0=RRESP_S2;
			RLAST_M0=RLAST_S2;
			RVALID_M0=RVALID_S2;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
			
		end
		M0_read_S3: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3={4'd0,ARID_M0}; //MASTER interface READ ADDRESS3
			ARADDR_S3=ARADDR_M0;
			ARLEN_S3=ARLEN_M0;
			ARSIZE_S3=ARSIZE_M0;
			ARBURST_S3=ARBURST_M0;
			ARVALID_S3=ARVALID_M0;
					
			RREADY_S3=RREADY_M0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=ARREADY_S3; //SLAVE interface READ ADDRESS0
			
			RID_M0=RID_S3[3:0]; //SLAVE interface READ DATA0
			RDATA_M0=RDATA_S3;
			RRESP_M0=RRESP_S3;
			RLAST_M0=RLAST_S3;
			RVALID_M0=RVALID_S3;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
		end
		M0_read_S5: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5={4'd0,ARID_M0}; //MASTER interface READ ADDRESS5
			ARADDR_S5=ARADDR_M0;
			ARLEN_S5=ARLEN_M0;
			ARSIZE_S5=ARSIZE_M0;
			ARBURST_S5=ARBURST_M0;
			ARVALID_S5=ARVALID_M0;
					
			RREADY_S5=RREADY_M0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=ARREADY_S5; //SLAVE interface READ ADDRESS0
			
			RID_M0=RID_S5[3:0]; //SLAVE interface READ DATA0
			RDATA_M0=RDATA_S5;
			RRESP_M0=RRESP_S5;
			RLAST_M0=RLAST_S5;
			RVALID_M0=RVALID_S5;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
		end
		M1_read_S0: begin
			ARID_S0={4'd0,ARID_M1};//MASTER interface READ ADDRESS0
			ARADDR_S0=ARADDR_M1;
			ARLEN_S0=ARLEN_M1;
			ARSIZE_S0=ARSIZE_M1;
			ARBURST_S0=ARBURST_M1;
			ARVALID_S0=ARVALID_M1;
			
			RREADY_S0=RREADY_M1; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=ARREADY_S0; //SLAVE interface READ ADDRESS1
			
			RID_M1=RID_S0[3:0]; //SLAVE interface READ DATA1
			RDATA_M1=RDATA_S0;
			RRESP_M1=RRESP_S0;
			RLAST_M1=RLAST_S0;
			RVALID_M1=RVALID_S0;
		end
		M1_read_S1: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1={4'd0,ARID_M1}; //MASTER interface READ ADDRESS1
			ARADDR_S1=ARADDR_M1;
			ARLEN_S1=ARLEN_M1;
			ARSIZE_S1=ARSIZE_M1;
			ARBURST_S1=ARBURST_M1;
			ARVALID_S1=ARVALID_M1;
					
			RREADY_S1=RREADY_M1; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=ARREADY_S1; //SLAVE interface READ ADDRESS1
			
			RID_M1=RID_S1[3:0]; //SLAVE interface READ DATA1
			RDATA_M1=RDATA_S1;
			RRESP_M1=RRESP_S1;
			RLAST_M1=RLAST_S1;
			RVALID_M1=RVALID_S1;
		end
		M1_read_S2: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2={4'd0,ARID_M1}; //MASTER interface READ ADDRESS2
			ARADDR_S2=ARADDR_M1;
			ARLEN_S2=ARLEN_M1;
			ARSIZE_S2=ARSIZE_M1;
			ARBURST_S2=ARBURST_M1;
			ARVALID_S2=ARVALID_M1;
					
			RREADY_S2=RREADY_M1; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=ARREADY_S2; //SLAVE interface READ ADDRESS1
			
			RID_M1=RID_S2[3:0]; //SLAVE interface READ DATA1
			RDATA_M1=RDATA_S2;
			RRESP_M1=RRESP_S2;
			RLAST_M1=RLAST_S2;
			RVALID_M1=RVALID_S2;
			
		end
		M1_read_S3: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3={4'd0,ARID_M1}; //MASTER interface READ ADDRESS3
			ARADDR_S3=ARADDR_M1;
			ARLEN_S3=ARLEN_M1;
			ARSIZE_S3=ARSIZE_M1;
			ARBURST_S3=ARBURST_M1;
			ARVALID_S3=ARVALID_M1;
					
			RREADY_S3=RREADY_M1; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=ARREADY_S3; //SLAVE interface READ ADDRESS1
			
			RID_M1=RID_S3[3:0]; //SLAVE interface READ DATA1
			RDATA_M1=RDATA_S3;
			RRESP_M1=RRESP_S3;
			RLAST_M1=RLAST_S3;
			RVALID_M1=RVALID_S3;
			
		end
		M1_read_S5: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0;; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5={4'd0,ARID_M1}; //MASTER interface READ ADDRESS5
			ARADDR_S5=ARADDR_M1;
			ARLEN_S5=ARLEN_M1;
			ARSIZE_S5=ARSIZE_M1;
			ARBURST_S5=ARBURST_M1;
			ARVALID_S5=ARVALID_M1;
					
			RREADY_S5=RREADY_M1; //MASTER interface READ DATA5
			
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=ARREADY_S5; //SLAVE interface READ ADDRESS1
			
			RID_M1=RID_S5[3:0]; //SLAVE interface READ DATA1
			RDATA_M1=RDATA_S5;
			RRESP_M1=RRESP_S5;
			RLAST_M1=RLAST_S5;
			RVALID_M1=RVALID_S5;
		end
		default: begin
			ARID_S0=8'd0;//MASTER interface READ ADDRESS0
			ARADDR_S0=32'd0;
			ARLEN_S0=4'd0;
			ARSIZE_S0=3'd2;
			ARBURST_S0=2'd1;
			ARVALID_S0=1'd0;
			
			RREADY_S0=1'd0; //MASTER interface READ DATA0
			
			ARID_S1=8'd0; //MASTER interface READ ADDRESS1
			ARADDR_S1=32'd0;
			ARLEN_S1=4'd0;
			ARSIZE_S1=3'd2;
			ARBURST_S1=2'd1;
			ARVALID_S1=1'd0;
			
			RREADY_S1=1'd0; //MASTER interface READ DATA1
			
			ARID_S2=8'd0; //MASTER interface READ ADDRESS2
			ARADDR_S2=32'd0;
			ARLEN_S2=4'd0;
			ARSIZE_S2=3'd2;
			ARBURST_S2=2'd1;
			ARVALID_S2=1'd0;
			
			RREADY_S2=1'd0; //MASTER interface READ DATA2
			
			ARID_S3=8'd0; //MASTER interface READ ADDRESS3
			ARADDR_S3=32'd0;
			ARLEN_S3=4'd0;
			ARSIZE_S3=3'd2;
			ARBURST_S3=2'd1;
			ARVALID_S3=1'd0;
			
			RREADY_S3=1'd0; //MASTER interface READ DATA3
			
			
			ARID_S5=8'd0; //MASTER interface READ ADDRESS5
			ARADDR_S5=32'd0;
			ARLEN_S5=4'd0;
			ARSIZE_S5=3'd2;
			ARBURST_S5=2'd1;
			ARVALID_S5=1'd0;
			
			RREADY_S5=1'd0; //MASTER interface READ DATA5
			
			
			ARREADY_M0=1'd0; //SLAVE interface READ ADDRESS0
			
			RID_M0=4'd0; //SLAVE interface READ DATA0
			RDATA_M0=32'd0;
			RRESP_M0=2'd0;
			RLAST_M0=1'd0;
			RVALID_M0=1'd0;
			
			ARREADY_M1=1'd0; //SLAVE interface READ ADDRESS1
			
			RID_M1=4'd0; //SLAVE interface READ DATA1
			RDATA_M1=32'd0;
			RRESP_M1=2'd0;
			RLAST_M1=1'd0;
			RVALID_M1=1'd0;
		end
	endcase
end

always_comb begin
	unique case (write_curr_state)
		write_IDLE: begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=1'd0; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=1'd0; //SLAVE interface WRITE DATA
			
			BID_M1=4'd0; //SLAVE interface WRITE RESPONSE
			BRESP_M1=2'd0;
			BVALID_M1=1'd0;
		end
		M1_write_S1: begin
			AWID_S1={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=AWADDR_M1;
			AWLEN_S1=AWLEN_M1;
			AWSIZE_S1=AWSIZE_M1;
			AWBURST_S1=AWBURST_M1;
			AWVALID_S1=AWVALID_M1;
					
			WDATA_S1=WDATA_M1; //MASTER interface WRITE DATA1
			WSTRB_S1=WSTRB_M1;
			WLAST_S1=WLAST_M1;
			WVALID_S1=WVALID_M1;
					
			BREADY_S1=BREADY_M1; //MASTER interface WRITE RESPONSE1
		
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S1; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S1; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S1[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S1;
			BVALID_M1=BVALID_S1;
		end
		M1_write_S2: begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=AWADDR_M1;
			AWLEN_S2=AWLEN_M1;
			AWSIZE_S2=AWSIZE_M1;
			AWBURST_S2=AWBURST_M1;
			AWVALID_S2=AWVALID_M1;
					
			WDATA_S2=WDATA_M1; //MASTER interface WRITE DATA2
			WSTRB_S2=WSTRB_M1;
			WLAST_S2=WLAST_M1;
			WVALID_S2=WVALID_M1;
					
			BREADY_S2=BREADY_M1; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S2; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S2; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S2[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S2;
			BVALID_M1=BVALID_S2;
		end
		M1_write_S3: begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=AWADDR_M1;
			AWLEN_S3=AWLEN_M1;
			AWSIZE_S3=AWSIZE_M1;
			AWBURST_S3=AWBURST_M1;
			AWVALID_S3=AWVALID_M1;
					
			WDATA_S3=WDATA_M1; //MASTER interface WRITE DATA3
			WSTRB_S3=WSTRB_M1;
			WLAST_S3=WLAST_M1;
			WVALID_S3=WVALID_M1;
					
			BREADY_S3=BREADY_M1; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S3; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S3; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S3[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S3;
			BVALID_M1=BVALID_S3;
		end
		M1_write_S4: begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=AWADDR_M1;
			AWLEN_S4=AWLEN_M1;
			AWSIZE_S4=AWSIZE_M1;
			AWBURST_S4=AWBURST_M1;
			AWVALID_S4=AWVALID_M1;
					
			WDATA_S4=WDATA_M1; //MASTER interface WRITE DATA4
			WSTRB_S4=WSTRB_M1;
			WLAST_S4=WLAST_M1;
			WVALID_S4=WVALID_M1;
					
			BREADY_S4=BREADY_M1; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S4; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S4; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S4[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S4;
			BVALID_M1=BVALID_S4;
		end
		M1_write_S5: begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=AWADDR_M1;
			AWLEN_S5=AWLEN_M1;
			AWSIZE_S5=AWSIZE_M1;
			AWBURST_S5=AWBURST_M1;
			AWVALID_S5=AWVALID_M1;
					
			WDATA_S5=WDATA_M1; //MASTER interface WRITE DATA5
			WSTRB_S5=WSTRB_M1;
			WLAST_S5=WLAST_M1;
			WVALID_S5=WVALID_M1;
					
			BREADY_S5=BREADY_M1; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S5; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S5; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S5[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S5;
			BVALID_M1=BVALID_S5;
		end
		M1_write_S6 :begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6={4'd0,AWID_M1}; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=AWADDR_M1;
			AWLEN_S6=AWLEN_M1;
			AWSIZE_S6=AWSIZE_M1;
			AWBURST_S6=AWBURST_M1;
			AWVALID_S6=AWVALID_M1;
					
			WDATA_S6=WDATA_M1; //MASTER interface WRITE DATA6
			WSTRB_S6=WSTRB_M1;
			WLAST_S6=WLAST_M1;
			WVALID_S6=WVALID_M1;
					
			BREADY_S6=BREADY_M1; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=AWREADY_S6; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=WREADY_S6; //SLAVE interface WRITE DATA
			
			BID_M1=BID_S6[3:0]; //SLAVE interface WRITE RESPONSE
			BRESP_M1=BRESP_S6;
			BVALID_M1=BVALID_S6;
		end
		default :begin
			AWID_S1=8'd0; //MASTER interface WRITE ADDRESS1
			AWADDR_S1=32'd0;
			AWLEN_S1=4'd0;
			AWSIZE_S1=3'd2;
			AWBURST_S1=2'd1;
			AWVALID_S1=1'd0;
			
			WDATA_S1=32'd0; //MASTER interface WRITE DATA1
			WSTRB_S1=4'b1111;
			WLAST_S1=1'd0;
			WVALID_S1=1'd0;
			
			BREADY_S1=1'd0; //MASTER interface WRITE RESPONSE1
			
			AWID_S2=8'd0; //MASTER interface WRITE ADDRESS2
			AWADDR_S2=32'd0;
			AWLEN_S2=4'd0;
			AWSIZE_S2=3'd2;
			AWBURST_S2=2'd1;
			AWVALID_S2=1'd0;
			
			WDATA_S2=32'd0; //MASTER interface WRITE DATA2
			WSTRB_S2=4'b1111;
			WLAST_S2=1'd0;
			WVALID_S2=1'd0;
			
			BREADY_S2=1'd0; //MASTER interface WRITE RESPONSE2
			
			AWID_S3=8'd0; //MASTER interface WRITE ADDRESS3
			AWADDR_S3=32'd0;
			AWLEN_S3=4'd0;
			AWSIZE_S3=3'd2;
			AWBURST_S3=2'd1;
			AWVALID_S3=1'd0;
			
			WDATA_S3=32'd0; //MASTER interface WRITE DATA3
			WSTRB_S3=4'b1111;
			WLAST_S3=1'd0;
			WVALID_S3=1'd0;
			
			BREADY_S3=1'd0; //MASTER interface WRITE RESPONSE3
			
			AWID_S4=8'd0; //MASTER interface WRITE ADDRESS4
			AWADDR_S4=32'd0;
			AWLEN_S4=4'd0;
			AWSIZE_S4=3'd2;
			AWBURST_S4=2'd1;
			AWVALID_S4=1'd0;
			
			WDATA_S4=32'd0; //MASTER interface WRITE DATA4
			WSTRB_S4=4'b1111;
			WLAST_S4=1'd0;
			WVALID_S4=1'd0;
			
			BREADY_S4=1'd0; //MASTER interface WRITE RESPONSE4
		
			AWID_S5=8'd0; //MASTER interface WRITE ADDRESS5
			AWADDR_S5=32'd0;
			AWLEN_S5=4'd0;
			AWSIZE_S5=3'd2;
			AWBURST_S5=2'd1;
			AWVALID_S5=1'd0;
			
			WDATA_S5=32'd0; //MASTER interface WRITE DATA5
			WSTRB_S5=4'b1111;
			WLAST_S5=1'd0;
			WVALID_S5=1'd0;
			
			BREADY_S5=1'd0; //MASTER interface WRITE RESPONSE5
			
			AWID_S6=8'd0; //MASTER interface WRITE ADDRESS6
			AWADDR_S6=32'd0;
			AWLEN_S6=4'd0;
			AWSIZE_S6=3'd2;
			AWBURST_S6=2'd1;
			AWVALID_S6=1'd0;
			
			WDATA_S6=32'd0; //MASTER interface WRITE DATA6
			WSTRB_S6=4'b1111;
			WLAST_S6=1'd0;
			WVALID_S6=1'd0;
			
			BREADY_S6=1'd0; //MASTER interface WRITE RESPONSE6
			
			AWREADY_M1=1'd0; //SLAVE interface WRITE ADDRESS
					
			WREADY_M1=1'd0; //SLAVE interface WRITE DATA
			
			BID_M1=4'd0; //SLAVE interface WRITE RESPONSE
			BRESP_M1=2'd0;
			BVALID_M1=1'd0;
		end
	endcase
end

endmodule*/
