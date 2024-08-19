//================================================
// Auther:      Lin Meng Yu           
// Filename:    AXI.sv                            
// Description: Top module of AXI                  
// Version:     Submit Version
// Date:        10/31 
//================================================


`include "AXI_define.svh"
`include "AR_channel.sv"
`include "R_channel.sv"
`include "DefaultSlave.sv"
`include "AW_channel.sv"
`include "B_channel.sv"
`include "W_channel.sv"

module AXI(

	input ACLK,
	input ARESETn,
	
	//SLAVE INTERFACE FOR MASTERS
	//WRITE ADDRESS
	input [`AXI_ID_BITS-1:0] AWID_M1,
	input [`AXI_ADDR_BITS-1:0] AWADDR_M1,
	input [`AXI_LEN_BITS-1:0] AWLEN_M1,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_M1,
	input [1:0] AWBURST_M1,
	input AWVALID_M1,
	output logic AWREADY_M1,
	//WRITE DATA
	input [`AXI_DATA_BITS-1:0] WDATA_M1,
	input [`AXI_STRB_BITS-1:0] WSTRB_M1,
	input WLAST_M1,
	input WVALID_M1,
	output logic WREADY_M1,
	//WRITE RESPONSE
	output logic [`AXI_ID_BITS-1:0] BID_M1,
	output logic [1:0] BRESP_M1,
	output logic BVALID_M1,
	input BREADY_M1,

	//READ ADDRESS0
	input [`AXI_ID_BITS-1:0] ARID_M0,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M0,
	input [`AXI_LEN_BITS-1:0] ARLEN_M0,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M0,
	input [1:0] ARBURST_M0,
	input ARVALID_M0,
	output logic ARREADY_M0,
	//READ DATA0
	output logic [`AXI_ID_BITS-1:0] RID_M0,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M0,
	output logic [1:0] RRESP_M0,
	output logic RLAST_M0,
	output logic RVALID_M0,
	input RREADY_M0,
	//READ ADDRESS1
	input [`AXI_ID_BITS-1:0] ARID_M1,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M1,
	input [`AXI_LEN_BITS-1:0] ARLEN_M1,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M1,
	input [1:0] ARBURST_M1,
	input ARVALID_M1,
	output logic ARREADY_M1,
	//READ DATA1
	output logic [`AXI_ID_BITS-1:0] RID_M1,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M1,
	output logic [1:0] RRESP_M1,
	output logic RLAST_M1,
	output logic RVALID_M1,
	input RREADY_M1,
	//MASTER INTERFACE FOR SLAVES
	//WRITE ADDRESS0
	output logic [`AXI_IDS_BITS-1:0] AWID_S0,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S0,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S0,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S0,
	output logic [1:0] AWBURST_S0,
	output logic AWVALID_S0,
	input AWREADY_S0,
	//WRITE DATA0
	output logic [`AXI_DATA_BITS-1:0] WDATA_S0,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S0,
	output logic WLAST_S0,
	output logic WVALID_S0,
	input WREADY_S0,
	//WRITE RESPONSE0
	input [`AXI_IDS_BITS-1:0] BID_S0,
	input [1:0] BRESP_S0,
	input BVALID_S0,
	output logic BREADY_S0,
	//WRITE ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] AWID_S1,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S1,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S1,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1,
	output logic [1:0] AWBURST_S1,
	output logic AWVALID_S1,
	input AWREADY_S1,
	//WRITE DATA1
	output logic [`AXI_DATA_BITS-1:0] WDATA_S1,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S1,
	output logic WLAST_S1,
	output logic WVALID_S1,
	input WREADY_S1,
	//WRITE RESPONSE1
	input [`AXI_IDS_BITS-1:0] BID_S1,
	input [1:0] BRESP_S1,
	input BVALID_S1,
	output logic BREADY_S1,
	//READ ADDRESS0
	output logic [`AXI_IDS_BITS-1:0] ARID_S0,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S0,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S0,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0,
	output logic [1:0] ARBURST_S0,
	output logic ARVALID_S0,
	input ARREADY_S0,
	//READ DATA0
	input [`AXI_IDS_BITS-1:0] RID_S0,
	input [`AXI_DATA_BITS-1:0] RDATA_S0,
	input [1:0] RRESP_S0,
	input RLAST_S0,
	input RVALID_S0,
	output logic RREADY_S0,
	//READ ADDRESS1
	output logic [`AXI_IDS_BITS-1:0] ARID_S1,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S1,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S1,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1,
	output logic [1:0] ARBURST_S1,
	output logic ARVALID_S1,
	input ARREADY_S1,
	//READ DATA1
	input [`AXI_IDS_BITS-1:0] RID_S1,
	input [`AXI_DATA_BITS-1:0] RDATA_S1,
	input [1:0] RRESP_S1,
	input RLAST_S1,
	input RVALID_S1,
	output logic RREADY_S1
	
);
    //---------- you should put your design here ----------//
	
//DS
logic [7:0]AWID_DS;
logic AWVALID_DS;
logic WVALID_DS;
logic AWREADY_DS;
logic WREADY_DS;
logic BREADY_DS;
logic [7:0]BID_DS;
logic BVALID_DS;
//logic [7:0]ARID_DS;
logic ARVALID_DS;
logic ARREADY_DS;
logic RREADY_DS;
logic [7:0]RID_DS;
logic RVALID_DS;



logic [7:0]ARID;
logic [31:0]ARADDR;
logic [3:0]ARLEN;
logic [2:0]ARSIZE;
logic [1:0]ARBURST;

logic [7:0]BID_M1_net;
assign BID_M1 = BID_M1_net[3:0];

assign ARID_S0 = ARID;
assign ARADDR_S0 = ARADDR;
assign ARLEN_S0 = ARLEN;
assign ARSIZE_S0 = ARSIZE;
assign ARBURST_S0 = ARBURST;

assign ARID_S1 = ARID;
assign ARADDR_S1 = ARADDR;
assign ARLEN_S1 = ARLEN;
assign ARSIZE_S1 = ARSIZE;
assign ARBURST_S1 = ARBURST;

AR_channel AR_channel(

	.ACLK(ACLK),
	.ARESETn(ARESETn),
	
	.ARREADY_S0(ARREADY_S0),
	.ARREADY_S1(ARREADY_S1),
	.ARREADY_DS(ARREADY_DS),
//READ ADDRESS0
	.ARID_M0(ARID_M0),
	.ARADDR_M0(ARADDR_M0),
	.ARLEN_M0(ARLEN_M0),
	.ARSIZE_M0(ARSIZE_M0),
	.ARBURST_M0(ARBURST_M0),
	.ARVALID_M0(ARVALID_M0),
//READ ADDRESS1
	.ARID_M1(ARID_M1),
	.ARADDR_M1(ARADDR_M1),
	.ARLEN_M1(ARLEN_M1),
	.ARSIZE_M1(ARSIZE_M1),
	.ARBURST_M1(ARBURST_M1),
	.RVALID_S0(RVALID_S0),
	.RVALID_S1(RVALID_S1),
	.RVALID_DS(RVALID_DS),

	.RREADY_S0(RREADY_S0),
	.RREADY_S1(RREADY_S1),
	.RREADY_DS(RREADY_DS),
	
	
	.ARVALID_M1(ARVALID_M1),
	.ARID(ARID),
	.ARADDR(ARADDR),
	.ARLEN(ARLEN),
	.ARSIZE(ARSIZE),
	.ARBURST(ARBURST),
	//output logic logic ARVALID,	
	.ARVALID_S0(ARVALID_S0),
	.ARVALID_S1(ARVALID_S1),
	.ARVALID_DS(ARVALID_DS),
	.ARREADY_M0(ARREADY_M0),
	.ARREADY_M1(ARREADY_M1)
);


R_channel R_channel(

	.ACLK(ACLK), 
	.ARESETn(ARESETn),
//S0
	.RID_S0(RID_S0),
	.RDATA_S0(RDATA_S0),
	.RRESP_S0(RRESP_S0),
	.RLAST_S0(RLAST_S0),
	.RVALID_S0(RVALID_S0),
//S1
	.RID_S1(RID_S1),
	.RDATA_S1(RDATA_S1),
	.RRESP_S1(RRESP_S1),
	.RLAST_S1(RLAST_S1),
	.RVALID_S1(RVALID_S1),
//D		
	.RID_DS(RID_DS),
	.RVALID_DS(RVALID_DS),
//RREADY	
	.RREADY_M0(RREADY_M0),
	.RREADY_M1(RREADY_M1),
//M0		
	.RID_M0(RID_M0),
	.RDATA_M0(RDATA_M0),
	.RRESP_M0(RRESP_M0),
	.RLAST_M0(RLAST_M0),
	.RVALID_M0(RVALID_M0),
//M1	
	.RID_M1(RID_M1),
	.RDATA_M1(RDATA_M1),
	.RRESP_M1(RRESP_M1),
	.RLAST_M1(RLAST_M1),
	.RVALID_M1(RVALID_M1),
//slave RREADY	
	.RREADY_S0(RREADY_S0),
	.RREADY_S1(RREADY_S1),
	.RREADY_DS(RREADY_DS)
);

DefaultSlave DefaultSlave(

	.ACLK(ACLK),
	.ARESETn(ARESETn),
	
	//WRITE ADDRESS CHANNEL
	.AWID_DS(AWID_DS),
	.AWVALID_DS(AWVALID_DS),
	.AWREADY_DS(AWREADY_DS),
	//WRITE DATA CHANNEL
	.WVALID_DS(WVALID_DS),
	.WREADY_DS(WREADY_DS),
	//WRITE RESPONSE CHANNEL
	.BREADY_DS(BREADY_DS),
	.BID_DS(BID_DS),
	.BVALID_DS(BVALID_DS),
	//READ ADDRESS CHANNEL
	.ARID_DS(ARID),
	.ARVALID_DS(ARVALID_DS),
	.ARREADY_DS(ARREADY_DS),
	//READ DATA CHANNEL
	.RREADY_DS(RREADY_DS),
	.RID_DS(RID_DS),
	.RVALID_DS(RVALID_DS)
);


AW_channel AW_channel(
//Master1
    .AWVALID_M1(AWVALID_M1),
    .AWID_M1(AWID_M1),
    .AWADDR_M1(AWADDR_M1),
    .AWLEN_M1(AWLEN_M1),
    .AWSIZE_M1(AWSIZE_M1),
    .AWBURST_M1(AWBURST_M1),
    .AWREADY_M1(AWREADY_M1),
                                
    //S0
    .AWREADY_S0(AWREADY_S0),
    .AWVALID_S0(AWVALID_S0),
    .AWID_S0(AWID_S0),            
    .AWADDR_S0(AWADDR_S0),
    .AWLEN_S0(AWLEN_S0),
    .AWSIZE_S0(AWSIZE_S0),
    .AWBURST_S0(AWBURST_S0),
    
    //S1
    .AWREADY_S1(AWREADY_S1),
    .AWVALID_S1(AWVALID_S1),
    .AWID_S1(AWID_S1),            
    .AWADDR_S1(AWADDR_S1),
    .AWLEN_S1(AWLEN_S1),
    .AWSIZE_S1(AWSIZE_S1),
    .AWBURST_S1(AWBURST_S1),
    
    //Default Slave
    .AWREADY_DS(AWREADY_DS),
    .AWVALID_DS(AWVALID_DS),
    .AWID_DS(AWID_DS)            
);

W_channel W_channel(

    .ACLK(ACLK),
    .ARESETn(ARESETn),
    
    //WRITE ADDRESS  CHANNEL
    .AWADDR_M1(AWADDR_M1),
    .AWVALID_M1(AWVALID_M1),
    .AWREADY_M1(AWREADY_M1),

    //Master1
    .WDATA_M1(WDATA_M1),
    .WSTRB_M1(WSTRB_M1),
    .WLAST_M1(WLAST_M1),
    .WVALID_M1(WVALID_M1),
    .WREADY_M1(WREADY_M1),
    
    //S0
    .WREADY_S0(WREADY_S0),
    .WDATA_S0(WDATA_S0),
    .WSTRB_S0(WSTRB_S0),
    .WLAST_S0(WLAST_S0),
    .WVALID_S0(WVALID_S0),

    //S1
    .WREADY_S1(WREADY_S1),
    .WDATA_S1(WDATA_S1),
    .WSTRB_S1(WSTRB_S1),
    .WLAST_S1(WLAST_S1),
    .WVALID_S1(WVALID_S1),

    //DS
    .WREADY_DS(WREADY_DS),
    .WVALID_DS(WVALID_DS)
);

B_channel B_channel(

    .ACLK(ACLK),
    .ARESETn(ARESETn),	
    
    //S0
    .BID_S0(BID_S0),
    .BRESP_S0(BRESP_S0),
    .BVALID_S0(BVALID_S0),
    .BREADY_S0(BREADY_S0),
    
    //S1
    .BID_S1(BID_S1),
    .BRESP_S1(BRESP_S1),
    .BVALID_S1(BVALID_S1),
    .BREADY_S1(BREADY_S1),
    
    //DS
    .BID_DS(BID_DS),
    .BVALID_DS(BVALID_DS),
    .BREADY_DS(BREADY_DS),
    
    //Master1
    .BREADY_M1(BREADY_M1),
    .BID_M1(BID_M1_net),
    .BRESP_M1(BRESP_M1),
    .BVALID_M1(BVALID_M1)
);
endmodule
