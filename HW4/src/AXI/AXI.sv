//================================================
// Auther:      Chen Zhi-Yu (Willy)           
// Filename:    AXI.sv                            
// Description: Top module of AXI                  
// Version:     1.0 
//================================================
`include "AXI_define.svh"
`include "Default_Slave.sv"
`include "AR_channel.sv"
`include "R_channel.sv"
`include "AW_channel.sv"
`include "W_channel.sv"
`include "B_channel.sv"
module AXI(
	input ACLK,
	input ARESETn,

	//SLAVE INTERFACE FOR MASTERS	
	//WRITE ADDRESS (DM)
	input [`AXI_ID_BITS-1:0] AWID_M1,
	input [`AXI_ADDR_BITS-1:0] AWADDR_M1,
	input [`AXI_LEN_BITS-1:0] AWLEN_M1,
	input [`AXI_SIZE_BITS-1:0] AWSIZE_M1,
	input [1:0] AWBURST_M1,
	input AWVALID_M1,
	output logic AWREADY_M1,
	
	//WRITE DATA (DM)
	input [`AXI_DATA_BITS-1:0] WDATA_M1,
	input [`AXI_STRB_BITS-1:0] WSTRB_M1,
	input WLAST_M1,
	input WVALID_M1,
	output logic WREADY_M1,
	
	//WRITE RESPONSE (DM)
	output logic [`AXI_ID_BITS-1:0] BID_M1,
	output logic [1:0] BRESP_M1,
	output logic BVALID_M1,
	input BREADY_M1,

	//READ ADDRESS (IM)
	input [`AXI_ID_BITS-1:0] ARID_M0,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M0,
	input [`AXI_LEN_BITS-1:0] ARLEN_M0,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M0,
	input [1:0] ARBURST_M0,
	input ARVALID_M0,
	output logic ARREADY_M0,
	
	//READ DATA (IM)
	output logic [`AXI_ID_BITS-1:0] RID_M0,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M0,
	output logic [1:0] RRESP_M0,
	output logic RLAST_M0,
	output logic RVALID_M0,
	input RREADY_M0,
	
	//READ ADDRESS (DM)
	input [`AXI_ID_BITS-1:0] ARID_M1,
	input [`AXI_ADDR_BITS-1:0] ARADDR_M1,
	input [`AXI_LEN_BITS-1:0] ARLEN_M1,
	input [`AXI_SIZE_BITS-1:0] ARSIZE_M1,
	input [1:0] ARBURST_M1,
	input ARVALID_M1,
	output logic ARREADY_M1,
	
	//READ DATA (DM)
	output logic [`AXI_ID_BITS-1:0] RID_M1,
	output logic [`AXI_DATA_BITS-1:0] RDATA_M1,
	output logic [1:0] RRESP_M1,
	output logic RLAST_M1,
	output logic RVALID_M1,
	input RREADY_M1,

	//MASTER INTERFACE FOR SLAVES
	//S0 : ROM
	//S1 : IM
	//S2 : DM
	//S3 : sensor control
	//S4 : WDT
	//S5 : DRAM

	//WRITE ADDRESS (IM)
	output logic [`AXI_IDS_BITS-1:0] AWID_S1,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S1,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S1,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1,
	output logic [1:0] AWBURST_S1,
	output logic AWVALID_S1,
	input AWREADY_S1,
	
	//WRITE DATA (IM)
	output logic [`AXI_DATA_BITS-1:0] WDATA_S1,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S1,
	output logic WLAST_S1,
	output logic WVALID_S1,
	input WREADY_S1,
	
	//WRITE RESPONSE (IM)
	input [`AXI_IDS_BITS-1:0] BID_S1,
	input [1:0] BRESP_S1,
	input BVALID_S1,
	output logic BREADY_S1,

	//WRITE ADDRESS (DM)
	output logic [`AXI_IDS_BITS-1:0] AWID_S2,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S2,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S2,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S2,
	output logic [1:0] AWBURST_S2,
	output logic AWVALID_S2,
	input AWREADY_S2,
	
	//WRITE DATA (DM)
	output logic [`AXI_DATA_BITS-1:0] WDATA_S2,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S2,
	output logic WLAST_S2,
	output logic WVALID_S2,
	input WREADY_S2,
	
	//WRITE RESPONSE (DM)
	input [`AXI_IDS_BITS-1:0] BID_S2,
	input [1:0] BRESP_S2,
	input BVALID_S2,
	output logic BREADY_S2,

	//WRITE ADDRESS (sensor control)
	output logic [`AXI_IDS_BITS-1:0] AWID_S3,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S3,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S3,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S3,
	output logic [1:0] AWBURST_S3,
	output logic AWVALID_S3,
	input AWREADY_S3,
	
	//WRITE DATA (sensor control)
	output logic [`AXI_DATA_BITS-1:0] WDATA_S3,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S3,
	output logic WLAST_S3,
	output logic WVALID_S3,
	input WREADY_S3,
	
	//WRITE RESPONSE (sensor control)
	input [`AXI_IDS_BITS-1:0] BID_S3,
	input [1:0] BRESP_S3,
	input BVALID_S3,
	output logic BREADY_S3,

	//WRITE ADDRESS (WDT)
	output logic [`AXI_IDS_BITS-1:0] AWID_S4,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S4,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S4,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S4,
	output logic [1:0] AWBURST_S4,
	output logic AWVALID_S4,
	input AWREADY_S4,
	
	//WRITE DATA (WDT)
	output logic [`AXI_DATA_BITS-1:0] WDATA_S4,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S4,
	output logic WLAST_S4,
	output logic WVALID_S4,
	input WREADY_S4,
	
	//WRITE RESPONSE (WDT)
	input [`AXI_IDS_BITS-1:0] BID_S4,
	input [1:0] BRESP_S4,
	input BVALID_S4,
	output logic BREADY_S4,
	
	//WRITE ADDRESS (DRAM)
	output logic [`AXI_IDS_BITS-1:0] AWID_S5,
	output logic [`AXI_ADDR_BITS-1:0] AWADDR_S5,
	output logic [`AXI_LEN_BITS-1:0] AWLEN_S5,
	output logic [`AXI_SIZE_BITS-1:0] AWSIZE_S5,
	output logic [1:0] AWBURST_S5,
	output logic AWVALID_S5,
	input AWREADY_S5,
	
	//WRITE DATA (DRAM)
	output logic [`AXI_DATA_BITS-1:0] WDATA_S5,
	output logic [`AXI_STRB_BITS-1:0] WSTRB_S5,
	output logic WLAST_S5,
	output logic WVALID_S5,
	input WREADY_S5,
	
	

	//WRITE RESPONSE (DRAM)
	input [`AXI_IDS_BITS-1:0] BID_S5,
	input [1:0] BRESP_S5,
	input BVALID_S5,
	output logic BREADY_S5,
	
	//READ ADDRESS (ROM)
	output logic [`AXI_IDS_BITS-1:0] ARID_S0,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S0,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S0,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0,
	output logic [1:0] ARBURST_S0,
	output logic ARVALID_S0,
	input ARREADY_S0,
	
	//READ DATA (ROM)
	input [`AXI_IDS_BITS-1:0] RID_S0,
	input [`AXI_DATA_BITS-1:0] RDATA_S0,
	input [1:0] RRESP_S0,
	input RLAST_S0,
	input RVALID_S0,
	output logic RREADY_S0,
	
	//READ ADDRESS (IM)
	output logic [`AXI_IDS_BITS-1:0] ARID_S1,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S1,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S1,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1,
	output logic [1:0] ARBURST_S1,
	output logic ARVALID_S1,
	input ARREADY_S1,
	
	//READ DATA (IM)
	input [`AXI_IDS_BITS-1:0] RID_S1,
	input [`AXI_DATA_BITS-1:0] RDATA_S1,
	input [1:0] RRESP_S1,
	input RLAST_S1,
	input RVALID_S1,
	output logic RREADY_S1,
	
	//READ ADDRESS (DM)
	output logic [`AXI_IDS_BITS-1:0] ARID_S2,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S2,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S2,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S2,
	output logic [1:0] ARBURST_S2,
	output logic ARVALID_S2,
	input ARREADY_S2,
	
	//READ DATA (DM)
	input [`AXI_IDS_BITS-1:0] RID_S2,
	input [`AXI_DATA_BITS-1:0] RDATA_S2,
	input [1:0] RRESP_S2,
	input RLAST_S2,
	input RVALID_S2,
	output logic RREADY_S2,

	//READ ADDRESS (sensor control)
	output logic [`AXI_IDS_BITS-1:0] ARID_S3,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S3,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S3,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S3,
	output logic [1:0] ARBURST_S3,
	output logic ARVALID_S3,
	input ARREADY_S3,
	
	//READ DATA (sensor control)
	input [`AXI_IDS_BITS-1:0] RID_S3,
	input [`AXI_DATA_BITS-1:0] RDATA_S3,
	input [1:0] RRESP_S3,
	input RLAST_S3,
	input RVALID_S3,
	output logic RREADY_S3,

	//READ ADDRESS (WDT)
	output logic [`AXI_IDS_BITS-1:0] ARID_S4,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S4,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S4,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S4,
	output logic [1:0] ARBURST_S4,
	output logic ARVALID_S4,
	input ARREADY_S4,
	
	//READ DATA (WDT)
	input [`AXI_IDS_BITS-1:0] RID_S4,
	input [`AXI_DATA_BITS-1:0] RDATA_S4,
	input [1:0] RRESP_S4,
	input RLAST_S4,
	input RVALID_S4,
	output logic RREADY_S4,

	//READ ADDRESS (DRAM)
	output logic [`AXI_IDS_BITS-1:0] ARID_S5,
	output logic [`AXI_ADDR_BITS-1:0] ARADDR_S5,
	output logic [`AXI_LEN_BITS-1:0] ARLEN_S5,
	output logic [`AXI_SIZE_BITS-1:0] ARSIZE_S5,
	output logic [1:0] ARBURST_S5,
	output logic ARVALID_S5,
	input ARREADY_S5,
	
	//READ DATA (DRAM)
	input [`AXI_IDS_BITS-1:0] RID_S5,
	input [`AXI_DATA_BITS-1:0] RDATA_S5,
	input [1:0] RRESP_S5,
	input RLAST_S5,
	input RVALID_S5,
	output logic RREADY_S5
);
    //---------- you should put your design here ----------//

	//DS
	//WRITE ADDRESS
    logic [7:0] AWID_DS;
    logic       AWVALID_DS;
    logic       AWREADY_DS;

    //WRITE DATA
    logic       WVALID_DS;
    logic       WREADY_DS;

    //WRITE RESPONSE
    logic       BREADY_DS;
    logic [7:0] BID_DS;
    logic       BVALID_DS;

    //READ ADDRESS
    logic [7:0] ARID_DS;
    logic       ARVALID_DS;
    logic       ARREADY_DS;

    //READ DATA
    logic       RREADY_DS;
    logic [7:0] RID_DS;
    logic       RVALID_DS;

	Default_Slave Default_Slave (
        .ACLK       (ACLK),
        .ARESETn    (ARESETn), 

		//WRITE ADDRESS
		.AWID_DS    (AWID_DS),
		.AWVALID_DS (AWVALID_DS),
		.AWREADY_DS (AWREADY_DS),

		//WRITE DATA
		.WVALID_DS  (WVALID_DS),
		.WREADY_DS  (WREADY_DS),

		//WRITE RESPONSE
		.BREADY_DS  (BREADY_DS),
		.BID_DS     (BID_DS),
		.BVALID_DS  (BVALID_DS),

		//READ ADDRESS
		.ARID_DS    (ARID_DS),
		.ARVALID_DS (ARVALID_DS),
		.ARREADY_DS (ARREADY_DS),

		//READ DATA
		.RREADY_DS  (RREADY_DS),
		.RID_DS     (RID_DS),
		.RVALID_DS  (RVALID_DS)
	);
	
	AR_channel AR_channel (
		.ACLK       (ACLK),
        .ARESETn    (ARESETn),

		//Master READ ADDRESS0
		.ARVALID_M0 (ARVALID_M0),
		.ARID_M0    (ARID_M0),   
		.ARADDR_M0  (ARADDR_M0), 
		.ARLEN_M0   (ARLEN_M0),  
		.ARSIZE_M0  (ARSIZE_M0), 
		.ARBURST_M0 (ARBURST_M0),

		.ARREADY_M0 (ARREADY_M0),

		//Master READ ADDRESS1
		.ARVALID_M1 (ARVALID_M1),
		.ARID_M1    (ARID_M1),   
		.ARADDR_M1  (ARADDR_M1), 
		.ARLEN_M1   (ARLEN_M1),  
		.ARSIZE_M1  (ARSIZE_M1), 
		.ARBURST_M1 (ARBURST_M1),

		.ARREADY_M1 (ARREADY_M1),
		
		//S0
		.ARREADY_S0 (ARREADY_S0),

		.ARVALID_S0 (ARVALID_S0),
		.ARID_S0    (ARID_S0),   
		.ARADDR_S0  (ARADDR_S0), 
		.ARLEN_S0   (ARLEN_S0),  
		.ARSIZE_S0  (ARSIZE_S0), 
		.ARBURST_S0 (ARBURST_S0),

		//S1
		.ARREADY_S1 (ARREADY_S1),

		.ARVALID_S1 (ARVALID_S1),
		.ARID_S1    (ARID_S1),   
		.ARADDR_S1  (ARADDR_S1), 
		.ARLEN_S1   (ARLEN_S1),  
		.ARSIZE_S1  (ARSIZE_S1), 
		.ARBURST_S1 (ARBURST_S1),

		//S2
		.ARREADY_S2 (ARREADY_S2),

		.ARVALID_S2 (ARVALID_S2),
		.ARID_S2    (ARID_S2),   
		.ARADDR_S2  (ARADDR_S2), 
		.ARLEN_S2   (ARLEN_S2),  
		.ARSIZE_S2  (ARSIZE_S2), 
		.ARBURST_S2 (ARBURST_S2),

		//S3
		.ARREADY_S3 (ARREADY_S3),

		.ARVALID_S3 (ARVALID_S3),
		.ARID_S3    (ARID_S3),   
		.ARADDR_S3  (ARADDR_S3), 
		.ARLEN_S3   (ARLEN_S3),  
		.ARSIZE_S3  (ARSIZE_S3), 
		.ARBURST_S3 (ARBURST_S3),

		//S4
		.ARREADY_S4 (ARREADY_S4),

		.ARVALID_S4 (ARVALID_S4),
		.ARID_S4    (ARID_S4),   
		.ARADDR_S4  (ARADDR_S4), 
		.ARLEN_S4   (ARLEN_S4),  
		.ARSIZE_S4  (ARSIZE_S4), 
		.ARBURST_S4 (ARBURST_S4),

		//S5
		.ARREADY_S5 (ARREADY_S5),

		.ARVALID_S5 (ARVALID_S5),
		.ARID_S5    (ARID_S5),   
		.ARADDR_S5  (ARADDR_S5), 
		.ARLEN_S5   (ARLEN_S5),  
		.ARSIZE_S5  (ARSIZE_S5), 
		.ARBURST_S5 (ARBURST_S5),

		//DS
		.ARREADY_DS (ARREADY_DS),

		.ARVALID_DS (ARVALID_DS),
		.ARID_DS    (ARID_DS),

		//for VIP   
		.RVALID_S0  (RVALID_S0),
		.RVALID_S1  (RVALID_S1),
		.RVALID_S2  (RVALID_S2),
		.RVALID_S3  (RVALID_S3),
		.RVALID_S4  (RVALID_S4),
		.RVALID_S5  (RVALID_S5),
		.RVALID_DS  (RVALID_DS),

		.RREADY_S0  (RREADY_S0),
		.RREADY_S1  (RREADY_S1),
		.RREADY_S2  (RREADY_S2),
		.RREADY_S3  (RREADY_S3),
		.RREADY_S4  (RREADY_S4),
		.RREADY_S5  (RREADY_S5),
		.RREADY_DS  (RREADY_DS)
	);

	R_channel R_channel (
		.ACLK       (ACLK),
        .ARESETn    (ARESETn),

		//S0
		.RVALID_S0 (RVALID_S0),
		.RID_S0    (RID_S0),   
		.RDATA_S0  (RDATA_S0), 
		.RRESP_S0  (RRESP_S0),
		.RLAST_S0  (RLAST_S0),

		.RREADY_S0 (RREADY_S0),

		//S1
		.RVALID_S1 (RVALID_S1),
		.RID_S1    (RID_S1),   
		.RDATA_S1  (RDATA_S1), 
		.RRESP_S1  (RRESP_S1),
		.RLAST_S1  (RLAST_S1),

		.RREADY_S1 (RREADY_S1),

		//S2
		.RVALID_S2 (RVALID_S2),
		.RID_S2    (RID_S2),   
		.RDATA_S2  (RDATA_S2), 
		.RRESP_S2  (RRESP_S2),
		.RLAST_S2  (RLAST_S2),

		.RREADY_S2 (RREADY_S2),

		//S3
		.RVALID_S3 (RVALID_S3),
		.RID_S3    (RID_S3),   
		.RDATA_S3  (RDATA_S3), 
		.RRESP_S3  (RRESP_S3),
		.RLAST_S3  (RLAST_S3),

		.RREADY_S3 (RREADY_S3),

		//S4
		.RVALID_S4 (RVALID_S4),
		.RID_S4    (RID_S4),   
		.RDATA_S4  (RDATA_S4), 
		.RRESP_S4  (RRESP_S4),
		.RLAST_S4  (RLAST_S4),

		.RREADY_S4 (RREADY_S4),

		//S5
		.RVALID_S5 (RVALID_S5),
		.RID_S5    (RID_S5),   
		.RDATA_S5  (RDATA_S5), 
		.RRESP_S5  (RRESP_S5),
		.RLAST_S5  (RLAST_S5),

		.RREADY_S5 (RREADY_S5),

		//DS
		.RVALID_DS (RVALID_DS),
		.RID_DS    (RID_DS),   

		.RREADY_DS (RREADY_DS),

		//Master READ DATA0
		.RREADY_M0 (RREADY_M0),

		.RID_M0    (RID_M0),   
		.RDATA_M0  (RDATA_M0), 
		.RRESP_M0  (RRESP_M0),
		.RLAST_M0  (RLAST_M0),
		.RVALID_M0 (RVALID_M0),

		//Master READ DATA1
		.RREADY_M1 (RREADY_M1),

		.RID_M1    (RID_M1),   
		.RDATA_M1  (RDATA_M1), 
		.RRESP_M1  (RRESP_M1),
		.RLAST_M1  (RLAST_M1),
		.RVALID_M1 (RVALID_M1)
	);

	AW_channel AW_channel (
		//Master WRITE ADDRESS1
		.AWVALID_M1 (AWVALID_M1),
		.AWID_M1    (AWID_M1),   
		.AWADDR_M1  (AWADDR_M1), 
		.AWLEN_M1   (AWLEN_M1),  
		.AWSIZE_M1  (AWSIZE_M1), 
		.AWBURST_M1 (AWBURST_M1),                 
		
		.AWREADY_M1 (AWREADY_M1),

		//S1
		.AWREADY_S1 (AWREADY_S1),

		.AWVALID_S1 (AWVALID_S1),
		.AWID_S1    (AWID_S1),   
		.AWADDR_S1  (AWADDR_S1), 
		.AWLEN_S1   (AWLEN_S1),  
		.AWSIZE_S1  (AWSIZE_S1), 
		.AWBURST_S1 (AWBURST_S1),

		//S2
		.AWREADY_S2 (AWREADY_S2),

		.AWVALID_S2 (AWVALID_S2),
		.AWID_S2    (AWID_S2),   
		.AWADDR_S2  (AWADDR_S2), 
		.AWLEN_S2   (AWLEN_S2),  
		.AWSIZE_S2  (AWSIZE_S2), 
		.AWBURST_S2 (AWBURST_S2),

		//S3
		.AWREADY_S3 (AWREADY_S3),

		.AWVALID_S3 (AWVALID_S3),
		.AWID_S3    (AWID_S3),   
		.AWADDR_S3  (AWADDR_S3), 
		.AWLEN_S3   (AWLEN_S3),  
		.AWSIZE_S3  (AWSIZE_S3), 
		.AWBURST_S3 (AWBURST_S3),

		//S4
		.AWREADY_S4 (AWREADY_S4),

		.AWVALID_S4 (AWVALID_S4),
		.AWID_S4    (AWID_S4),   
		.AWADDR_S4  (AWADDR_S4), 
		.AWLEN_S4   (AWLEN_S4),  
		.AWSIZE_S4  (AWSIZE_S4), 
		.AWBURST_S4 (AWBURST_S4),

		//S5
		.AWREADY_S5 (AWREADY_S5),

		.AWVALID_S5 (AWVALID_S5),
		.AWID_S5    (AWID_S5),   
		.AWADDR_S5  (AWADDR_S5), 
		.AWLEN_S5   (AWLEN_S5),  
		.AWSIZE_S5  (AWSIZE_S5), 
		.AWBURST_S5 (AWBURST_S5),

		//DS
		.AWREADY_DS (AWREADY_DS),

		.AWVALID_DS (AWVALID_DS),
		.AWID_DS    (AWID_DS)   
	);

	W_channel W_channel (
		//for VIP
		.ACLK       (ACLK),
        .ARESETn    (ARESETn),

		//Master WRITE ADDRESS1 for selecting slave
		.AWADDR_M1  (AWADDR_M1), 
		.AWVALID_M1 (AWVALID_M1), //for VIP
		.AWREADY_M1 (AWREADY_M1), //for VIP

		//Master WRITE DATA1
		.WVALID_M1  (WVALID_M1),
		.WDATA_M1   (WDATA_M1), 
		.WSTRB_M1   (WSTRB_M1), 
		.WLAST_M1   (WLAST_M1),
		
		.WREADY_M1  (WREADY_M1),

		//S1
		.WREADY_S1  (WREADY_S1),

		.WVALID_S1  (WVALID_S1),
		.WDATA_S1   (WDATA_S1), 
		.WSTRB_S1   (WSTRB_S1), 
		.WLAST_S1   (WLAST_S1),

		//S2
		.WREADY_S2  (WREADY_S2),

		.WVALID_S2  (WVALID_S2),
		.WDATA_S2   (WDATA_S2), 
		.WSTRB_S2   (WSTRB_S2), 
		.WLAST_S2   (WLAST_S2),

		//S3
		.WREADY_S3  (WREADY_S3),

		.WVALID_S3  (WVALID_S3),
		.WDATA_S3   (WDATA_S3), 
		.WSTRB_S3   (WSTRB_S3), 
		.WLAST_S3   (WLAST_S3),

		//S4
		.WREADY_S4  (WREADY_S4),

		.WVALID_S4  (WVALID_S4),
		.WDATA_S4   (WDATA_S4), 
		.WSTRB_S4   (WSTRB_S4), 
		.WLAST_S4   (WLAST_S4),

		//S5
		.WREADY_S5  (WREADY_S5),

		.WVALID_S5  (WVALID_S5),
		.WDATA_S5   (WDATA_S5), 
		.WSTRB_S5   (WSTRB_S5), 
		.WLAST_S5   (WLAST_S5),

		//DS
		.WREADY_DS  (WREADY_DS),

		.WVALID_DS  (WVALID_DS)
	);

	B_channel B_channel (
		.ACLK       (ACLK),
        .ARESETn    (ARESETn),

		//S1
		.BVALID_S1 (BVALID_S1),
		.BID_S1    (BID_S1), 
		.BRESP_S1  (BRESP_S1),

		.BREADY_S1 (BREADY_S1),

		//S2
		.BVALID_S2 (BVALID_S2),
		.BID_S2    (BID_S2), 
		.BRESP_S2  (BRESP_S2),

		.BREADY_S2 (BREADY_S2),

		//S3
		.BVALID_S3 (BVALID_S3),
		.BID_S3    (BID_S3), 
		.BRESP_S3  (BRESP_S3),

		.BREADY_S3 (BREADY_S3),

		//S4
		.BVALID_S4 (BVALID_S4),
		.BID_S4    (BID_S4), 
		.BRESP_S4  (BRESP_S4),

		.BREADY_S4 (BREADY_S4),

		//S5
		.BVALID_S5 (BVALID_S5),
		.BID_S5    (BID_S5), 
		.BRESP_S5  (BRESP_S5),

		.BREADY_S5 (BREADY_S5),

		//DS
		.BVALID_DS (BVALID_DS),
		.BID_DS    (BID_DS), 

		.BREADY_DS (BREADY_DS),

		//Master WRITE RESPONSE1
		.BREADY_M1 (BREADY_M1),

		.BVALID_M1 (BVALID_M1),
		.BID_M1    (BID_M1), 
		.BRESP_M1  (BRESP_M1)
	);
endmodule
