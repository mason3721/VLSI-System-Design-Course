`include "AXI_define.svh"
`include "AXI.sv"
`include "CPU_wrapper.sv"
`include "ROM_wrapper.sv"
`include "SRAM_wrapper.sv"
`include "sctrl_wrapper.sv"
`include "WDT_wrapper.sv"
`include "DRAM_wrapper.sv"
`include "AR_FIFO_Master_to_AXI.sv"
`include "AR_FIFO_AXI_to_Slave.sv"
`include "R_FIFO_Slave_to_AXI.sv"
`include "R_FIFO_AXI_to_Master.sv"
`include "AW_FIFO_Master_to_AXI.sv"
`include "AW_FIFO_AXI_to_Slave.sv"
`include "W_FIFO_Master_to_AXI.sv"
`include "W_FIFO_AXI_to_Slave.sv"
`include "B_FIFO_Slave_to_AXI.sv"
`include "B_FIFO_AXI_to_Master.sv"

module top (
    input               cpu_clk,
    input               axi_clk,
    input               rom_clk,
    input               dram_clk,
    input               sram_clk,
    input               cpu_rst,
    input               axi_rst,
    input               rom_rst,
    input               dram_rst,
    input               sram_rst,

    //sensor control
    input               sensor_ready,
    input        [31:0] sensor_out,

    output logic        sensor_en,

    //ROM
    input        [31:0] ROM_out,
    
    output logic        ROM_read,
    output logic        ROM_enable,
    output logic [11:0] ROM_address,

    //DRAM
    input        [31:0] DRAM_Q,
    input               DRAM_valid,

    output logic        DRAM_CSn,
    output logic [3:0]  DRAM_WEn,
    output logic        DRAM_RASn,
    output logic        DRAM_CASn,
    output logic [10:0] DRAM_A,
    output logic [31:0] DRAM_D
);
    //AXI
    //SLAVE INTERFACE FOR MASTERS
    //WRITE ADDRESS (DM)
    logic [`AXI_ID_BITS-1:0] AWID_M1;
    logic [`AXI_ADDR_BITS-1:0] AWADDR_M1;
    logic [`AXI_LEN_BITS-1:0] AWLEN_M1;
    logic [`AXI_SIZE_BITS-1:0] AWSIZE_M1;
    logic [1:0] AWBURST_M1;
    logic AWVALID_M1;
    logic AWREADY_M1;

    //WRITE DATA (DM)
    logic [`AXI_DATA_BITS-1:0] WDATA_M1;
    logic [`AXI_STRB_BITS-1:0] WSTRB_M1;
    logic WLAST_M1;
    logic WVALID_M1;
    logic WREADY_M1;

    //WRITE RESPONSE (DM)
    logic [`AXI_ID_BITS-1:0] BID_M1;
    logic [1:0] BRESP_M1;
    logic BVALID_M1;
    logic BREADY_M1;

    //READ ADDRESS (IM)
    logic [`AXI_ID_BITS-1:0] ARID_M0;
    logic [`AXI_ADDR_BITS-1:0] ARADDR_M0;
    logic [`AXI_LEN_BITS-1:0] ARLEN_M0;
    logic [`AXI_SIZE_BITS-1:0] ARSIZE_M0;
    logic [1:0] ARBURST_M0;
    logic ARVALID_M0;
    logic ARREADY_M0;

    //READ DATA (IM)
    logic [`AXI_ID_BITS-1:0] RID_M0;
    logic [`AXI_DATA_BITS-1:0] RDATA_M0;
    logic [1:0] RRESP_M0;
    logic RLAST_M0;
    logic RVALID_M0;
    logic RREADY_M0;

    //READ ADDRESS (DM)
    logic [`AXI_ID_BITS-1:0] ARID_M1;
    logic [`AXI_ADDR_BITS-1:0] ARADDR_M1;
    logic [`AXI_LEN_BITS-1:0] ARLEN_M1;
    logic [`AXI_SIZE_BITS-1:0] ARSIZE_M1;
    logic [1:0] ARBURST_M1;
    logic ARVALID_M1;
    logic ARREADY_M1;

    //READ DATA (DM)
    logic [`AXI_ID_BITS-1:0] RID_M1;
    logic [`AXI_DATA_BITS-1:0] RDATA_M1;
    logic [1:0] RRESP_M1;
    logic RLAST_M1;
    logic RVALID_M1;
    logic RREADY_M1;

    //MASTER INTERFACE FOR SLAVES: S0 : ROM; S1 : IM; S2 : DM; S3 : sensor_control; S4 : WDT; S5 : DRAM;
    //WRITE ADDRESS (IM)
    logic [`AXI_IDS_BITS-1:0] AWID_S1;
    logic [`AXI_ADDR_BITS-1:0] AWADDR_S1;
    logic [`AXI_LEN_BITS-1:0] AWLEN_S1;
    logic [`AXI_SIZE_BITS-1:0] AWSIZE_S1;
    logic [1:0] AWBURST_S1;
    logic AWVALID_S1;
    logic AWREADY_S1;

    //WRITE DATA (IM)
    logic [`AXI_DATA_BITS-1:0] WDATA_S1;
    logic [`AXI_STRB_BITS-1:0] WSTRB_S1;
    logic WLAST_S1;
    logic WVALID_S1;
    logic WREADY_S1;

    //WRITE RESPONSE (IM)
    logic [`AXI_IDS_BITS-1:0] BID_S1;
    logic [1:0] BRESP_S1;
    logic BVALID_S1;
    logic BREADY_S1;

    //WRITE ADDRESS (DM)
    logic [`AXI_IDS_BITS-1:0] AWID_S2;
    logic [`AXI_ADDR_BITS-1:0] AWADDR_S2;
    logic [`AXI_LEN_BITS-1:0] AWLEN_S2;
    logic [`AXI_SIZE_BITS-1:0] AWSIZE_S2;
    logic [1:0] AWBURST_S2;
    logic AWVALID_S2;
    logic AWREADY_S2;

    //WRITE DATA (DM)
    logic [`AXI_DATA_BITS-1:0] WDATA_S2;
    logic [`AXI_STRB_BITS-1:0] WSTRB_S2;
    logic WLAST_S2;
    logic WVALID_S2;
    logic WREADY_S2;

    //WRITE RESPONSE (DM)
    logic [`AXI_IDS_BITS-1:0] BID_S2;
    logic [1:0] BRESP_S2;
    logic BVALID_S2;
    logic BREADY_S2;

    //WRITE ADDRESS (sensor_control)
    logic [`AXI_IDS_BITS-1:0] AWID_S3;
    logic [`AXI_ADDR_BITS-1:0] AWADDR_S3;
    logic [`AXI_LEN_BITS-1:0] AWLEN_S3;
    logic [`AXI_SIZE_BITS-1:0] AWSIZE_S3;
    logic [1:0] AWBURST_S3;
    logic AWVALID_S3;
    logic AWREADY_S3;

    //WRITE DATA (sensor_control)
    logic [`AXI_DATA_BITS-1:0] WDATA_S3;
    logic [`AXI_STRB_BITS-1:0] WSTRB_S3;
    logic WLAST_S3;
    logic WVALID_S3;
    logic WREADY_S3;

    //WRITE RESPONSE (sensor_control)
    logic [`AXI_IDS_BITS-1:0] BID_S3;
    logic [1:0] BRESP_S3;
    logic BVALID_S3;
    logic BREADY_S3;

    //WRITE ADDRESS (WDT)
    logic [`AXI_IDS_BITS-1:0] AWID_S4;
    logic [`AXI_ADDR_BITS-1:0] AWADDR_S4;
    logic [`AXI_LEN_BITS-1:0] AWLEN_S4;
    logic [`AXI_SIZE_BITS-1:0] AWSIZE_S4;
    logic [1:0] AWBURST_S4;
    logic AWVALID_S4;
    logic AWREADY_S4;

    //WRITE DATA (WDT)
    logic [`AXI_DATA_BITS-1:0] WDATA_S4;
    logic [`AXI_STRB_BITS-1:0] WSTRB_S4;
    logic WLAST_S4;
    logic WVALID_S4;
    logic WREADY_S4;

    //WRITE RESPONSE (WDT)
    logic [`AXI_IDS_BITS-1:0] BID_S4;
    logic [1:0] BRESP_S4;
    logic BVALID_S4;
    logic BREADY_S4;

    //WRITE ADDRESS (DRAM)
    logic [`AXI_IDS_BITS-1:0] AWID_S5;
    logic [`AXI_ADDR_BITS-1:0] AWADDR_S5;
    logic [`AXI_LEN_BITS-1:0] AWLEN_S5;
    logic [`AXI_SIZE_BITS-1:0] AWSIZE_S5;
    logic [1:0] AWBURST_S5;
    logic AWVALID_S5;
    logic AWREADY_S5;

    //WRITE DATA (DRAM)
    logic [`AXI_DATA_BITS-1:0] WDATA_S5;
    logic [`AXI_STRB_BITS-1:0] WSTRB_S5;
    logic WLAST_S5;
    logic WVALID_S5;
    logic WREADY_S5;

    //WRITE RESPONSE (DRAM)
    logic [`AXI_IDS_BITS-1:0] BID_S5;
    logic [1:0] BRESP_S5;
    logic BVALID_S5;
    logic BREADY_S5;

    //READ ADDRESS (ROM)
    logic [`AXI_IDS_BITS-1:0] ARID_S0;
    logic [`AXI_ADDR_BITS-1:0] ARADDR_S0;
    logic [`AXI_LEN_BITS-1:0] ARLEN_S0;
    logic [`AXI_SIZE_BITS-1:0] ARSIZE_S0;
    logic [1:0] ARBURST_S0;
    logic ARVALID_S0;
    logic ARREADY_S0;

    //READ DATA (ROM)
    logic [`AXI_IDS_BITS-1:0] RID_S0;
    logic [`AXI_DATA_BITS-1:0] RDATA_S0;
    logic [1:0] RRESP_S0;
    logic RLAST_S0;
    logic RVALID_S0;
    logic RREADY_S0;
    
    //READ ADDRESS (IM)
    logic [`AXI_IDS_BITS-1:0] ARID_S1;
    logic [`AXI_ADDR_BITS-1:0] ARADDR_S1;
    logic [`AXI_LEN_BITS-1:0] ARLEN_S1;
    logic [`AXI_SIZE_BITS-1:0] ARSIZE_S1;
    logic [1:0] ARBURST_S1;
    logic ARVALID_S1;
    logic ARREADY_S1;

    //READ DATA (IM)
    logic [`AXI_IDS_BITS-1:0] RID_S1;
    logic [`AXI_DATA_BITS-1:0] RDATA_S1;
    logic [1:0] RRESP_S1;
    logic RLAST_S1;
    logic RVALID_S1;
    logic RREADY_S1;

    //READ ADDRESS (DM)
    logic [`AXI_IDS_BITS-1:0] ARID_S2;
    logic [`AXI_ADDR_BITS-1:0] ARADDR_S2;
    logic [`AXI_LEN_BITS-1:0] ARLEN_S2;
    logic [`AXI_SIZE_BITS-1:0] ARSIZE_S2;
    logic [1:0] ARBURST_S2;
    logic ARVALID_S2;
    logic ARREADY_S2;

    //READ DATA (DM)
    logic [`AXI_IDS_BITS-1:0] RID_S2;
    logic [`AXI_DATA_BITS-1:0] RDATA_S2;
    logic [1:0] RRESP_S2;
    logic RLAST_S2;
    logic RVALID_S2;
    logic RREADY_S2;

    //READ ADDRESS (sensor_control)
    logic [`AXI_IDS_BITS-1:0] ARID_S3;
    logic [`AXI_ADDR_BITS-1:0] ARADDR_S3;
    logic [`AXI_LEN_BITS-1:0] ARLEN_S3;
    logic [`AXI_SIZE_BITS-1:0] ARSIZE_S3;
    logic [1:0] ARBURST_S3;
    logic ARVALID_S3;
    logic ARREADY_S3;

    //READ DATA (sensor_control)
    logic [`AXI_IDS_BITS-1:0] RID_S3;
    logic [`AXI_DATA_BITS-1:0] RDATA_S3;
    logic [1:0] RRESP_S3;
    logic RLAST_S3;
    logic RVALID_S3;
    logic RREADY_S3;

    //READ ADDRESS (WDT)
    logic [`AXI_IDS_BITS-1:0] ARID_S4;
    logic [`AXI_ADDR_BITS-1:0] ARADDR_S4;
    logic [`AXI_LEN_BITS-1:0] ARLEN_S4;
    logic [`AXI_SIZE_BITS-1:0] ARSIZE_S4;
    logic [1:0] ARBURST_S4;
    logic ARVALID_S4;
    logic ARREADY_S4;

    //READ DATA (WDT)
    logic [`AXI_IDS_BITS-1:0] RID_S4;
    logic [`AXI_DATA_BITS-1:0] RDATA_S4;
    logic [1:0] RRESP_S4;
    logic RLAST_S4;
    logic RVALID_S4;
    logic RREADY_S4;

    //READ ADDRESS (DRAM)
    logic [`AXI_IDS_BITS-1:0] ARID_S5;
    logic [`AXI_ADDR_BITS-1:0] ARADDR_S5;
    logic [`AXI_LEN_BITS-1:0] ARLEN_S5;
    logic [`AXI_SIZE_BITS-1:0] ARSIZE_S5;
    logic [1:0] ARBURST_S5;
    logic ARVALID_S5;
    logic ARREADY_S5;

    //READ DATA (DRAM)
    logic [`AXI_IDS_BITS-1:0] RID_S5;
    logic [`AXI_DATA_BITS-1:0] RDATA_S5;
    logic [1:0] RRESP_S5;
    logic RLAST_S5;
    logic RVALID_S5;
    logic RREADY_S5;

    //Interrupt
    logic sensor_interrupt;
    logic WDT_interrupt;

    //for CDC
    //AR
    logic AR_M0_wfull; //FIFO full
    logic AR_M0_rempty; //FIFO empty

    logic AR_M1_wfull; //FIFO full
    logic AR_M1_rempty; //FIFO empty

    logic AR_S0_wfull; //FIFO full
    logic AR_S0_rempty; //FIFO empty

    logic AR_S1_wfull; //FIFO full
    logic AR_S1_rempty; //FIFO empty

    logic AR_S2_wfull; //FIFO full
    logic AR_S2_rempty; //FIFO empty

    logic AR_S3_wfull; //FIFO full
    logic AR_S3_rempty; //FIFO empty

    logic AR_S4_wfull; //FIFO full
    logic AR_S4_rempty; //FIFO empty

    logic AR_S5_wfull; //FIFO full
    logic AR_S5_rempty; //FIFO empty

    //READ ADDRESS (IM)
    logic [`AXI_ID_BITS-1:0] Master_ARID_M0;
    logic [`AXI_ADDR_BITS-1:0] Master_ARADDR_M0;
    logic [`AXI_LEN_BITS-1:0] Master_ARLEN_M0;
    logic [`AXI_SIZE_BITS-1:0] Master_ARSIZE_M0;
    logic [1:0] Master_ARBURST_M0;

    //READ ADDRESS (DM)
    logic [`AXI_ID_BITS-1:0] Master_ARID_M1;
    logic [`AXI_ADDR_BITS-1:0] Master_ARADDR_M1;
    logic [`AXI_LEN_BITS-1:0] Master_ARLEN_M1;
    logic [`AXI_SIZE_BITS-1:0] Master_ARSIZE_M1;
    logic [1:0] Master_ARBURST_M1;

    //READ ADDRESS (ROM)
    logic [`AXI_IDS_BITS-1:0] Slave_ARID_S0;
    logic [`AXI_ADDR_BITS-1:0] Slave_ARADDR_S0;
    logic [`AXI_LEN_BITS-1:0] Slave_ARLEN_S0;
    logic [`AXI_SIZE_BITS-1:0] Slave_ARSIZE_S0;
    logic [1:0] Slave_ARBURST_S0;

    //READ ADDRESS (IM)
    logic [`AXI_IDS_BITS-1:0] Slave_ARID_S1;
    logic [`AXI_ADDR_BITS-1:0] Slave_ARADDR_S1;
    logic [`AXI_LEN_BITS-1:0] Slave_ARLEN_S1;
    logic [`AXI_SIZE_BITS-1:0] Slave_ARSIZE_S1;
    logic [1:0] Slave_ARBURST_S1;

    //READ ADDRESS (DM)
    logic [`AXI_IDS_BITS-1:0] Slave_ARID_S2;
    logic [`AXI_ADDR_BITS-1:0] Slave_ARADDR_S2;
    logic [`AXI_LEN_BITS-1:0] Slave_ARLEN_S2;
    logic [`AXI_SIZE_BITS-1:0] Slave_ARSIZE_S2;
    logic [1:0] Slave_ARBURST_S2;

    //READ ADDRESS (sensor_control)
    logic [`AXI_IDS_BITS-1:0] Slave_ARID_S3;
    logic [`AXI_ADDR_BITS-1:0] Slave_ARADDR_S3;
    logic [`AXI_LEN_BITS-1:0] Slave_ARLEN_S3;
    logic [`AXI_SIZE_BITS-1:0] Slave_ARSIZE_S3;
    logic [1:0] Slave_ARBURST_S3;

    //READ ADDRESS (WDT)
    logic [`AXI_IDS_BITS-1:0] Slave_ARID_S4;
    logic [`AXI_ADDR_BITS-1:0] Slave_ARADDR_S4;
    logic [`AXI_LEN_BITS-1:0] Slave_ARLEN_S4;
    logic [`AXI_SIZE_BITS-1:0] Slave_ARSIZE_S4;
    logic [1:0] Slave_ARBURST_S4;

    //READ ADDRESS (DRAM)
    logic [`AXI_IDS_BITS-1:0] Slave_ARID_S5;
    logic [`AXI_ADDR_BITS-1:0] Slave_ARADDR_S5;
    logic [`AXI_LEN_BITS-1:0] Slave_ARLEN_S5;
    logic [`AXI_SIZE_BITS-1:0] Slave_ARSIZE_S5;
    logic [1:0] Slave_ARBURST_S5;

    //R
    logic R_M0_wfull; //FIFO full
    logic R_M0_rempty; //FIFO empty

    logic R_M1_wfull; //FIFO full
    logic R_M1_rempty; //FIFO empty

    logic R_S0_wfull; //FIFO full
    logic R_S0_rempty; //FIFO empty

    logic R_S1_wfull; //FIFO full
    logic R_S1_rempty; //FIFO empty

    logic R_S2_wfull; //FIFO full
    logic R_S2_rempty; //FIFO empty

    logic R_S3_wfull; //FIFO full
    logic R_S3_rempty; //FIFO empty

    logic R_S4_wfull; //FIFO full
    logic R_S4_rempty; //FIFO empty

    logic R_S5_wfull; //FIFO full
    logic R_S5_rempty; //FIFO empty

    //READ DATA (ROM)
    logic [`AXI_IDS_BITS-1:0] Slave_RID_S0;
    logic [`AXI_DATA_BITS-1:0] Slave_RDATA_S0;
    logic [1:0] Slave_RRESP_S0;
    logic Slave_RLAST_S0;

    //READ DATA (IM)
    logic [`AXI_IDS_BITS-1:0] Slave_RID_S1;
    logic [`AXI_DATA_BITS-1:0] Slave_RDATA_S1;
    logic [1:0] Slave_RRESP_S1;
    logic Slave_RLAST_S1;

    //READ DATA (DM)
    logic [`AXI_IDS_BITS-1:0] Slave_RID_S2;
    logic [`AXI_DATA_BITS-1:0] Slave_RDATA_S2;
    logic [1:0] Slave_RRESP_S2;
    logic Slave_RLAST_S2;

    //READ DATA (sensor_control)
    logic [`AXI_IDS_BITS-1:0] Slave_RID_S3;
    logic [`AXI_DATA_BITS-1:0] Slave_RDATA_S3;
    logic [1:0] Slave_RRESP_S3;
    logic Slave_RLAST_S3;

    //READ DATA (WDT)
    logic [`AXI_IDS_BITS-1:0] Slave_RID_S4;
    logic [`AXI_DATA_BITS-1:0] Slave_RDATA_S4;
    logic [1:0] Slave_RRESP_S4;
    logic Slave_RLAST_S4;

    //READ DATA (DRAM)
    logic [`AXI_IDS_BITS-1:0] Slave_RID_S5;
    logic [`AXI_DATA_BITS-1:0] Slave_RDATA_S5;
    logic [1:0] Slave_RRESP_S5;
    logic Slave_RLAST_S5;

    //READ DATA (IM)
    logic [`AXI_ID_BITS-1:0] Master_RID_M0;
    logic [`AXI_DATA_BITS-1:0] Master_RDATA_M0;
    logic [1:0] Master_RRESP_M0;
    logic Master_RLAST_M0;

    //READ DATA (DM)
    logic [`AXI_ID_BITS-1:0] Master_RID_M1;
    logic [`AXI_DATA_BITS-1:0] Master_RDATA_M1;
    logic [1:0] Master_RRESP_M1;
    logic Master_RLAST_M1;

    //AW
    logic AW_M1_wfull; //FIFO full
    logic AW_M1_rempty; //FIFO empty

    logic AW_S1_wfull; //FIFO full
    logic AW_S1_rempty; //FIFO empty

    logic AW_S2_wfull; //FIFO full
    logic AW_S2_rempty; //FIFO empty

    logic AW_S3_wfull; //FIFO full
    logic AW_S3_rempty; //FIFO empty

    logic AW_S4_wfull; //FIFO full
    logic AW_S4_rempty; //FIFO empty

    logic AW_S5_wfull; //FIFO full
    logic AW_S5_rempty; //FIFO empty

    //WRITE ADDRESS (DM)
    logic [`AXI_ID_BITS-1:0] Master_AWID_M1;
    logic [`AXI_ADDR_BITS-1:0] Master_AWADDR_M1;
    logic [`AXI_LEN_BITS-1:0] Master_AWLEN_M1;
    logic [`AXI_SIZE_BITS-1:0] Master_AWSIZE_M1;
    logic [1:0] Master_AWBURST_M1;

    //WRITE ADDRESS (IM)
    logic [`AXI_IDS_BITS-1:0] Slave_AWID_S1;
    logic [`AXI_ADDR_BITS-1:0] Slave_AWADDR_S1;
    logic [`AXI_LEN_BITS-1:0] Slave_AWLEN_S1;
    logic [`AXI_SIZE_BITS-1:0] Slave_AWSIZE_S1;
    logic [1:0] Slave_AWBURST_S1;

    //WRITE ADDRESS (DM)
    logic [`AXI_IDS_BITS-1:0] Slave_AWID_S2;
    logic [`AXI_ADDR_BITS-1:0] Slave_AWADDR_S2;
    logic [`AXI_LEN_BITS-1:0] Slave_AWLEN_S2;
    logic [`AXI_SIZE_BITS-1:0] Slave_AWSIZE_S2;
    logic [1:0] Slave_AWBURST_S2;

    //WRITE ADDRESS (sensor_control)
    logic [`AXI_IDS_BITS-1:0] Slave_AWID_S3;
    logic [`AXI_ADDR_BITS-1:0] Slave_AWADDR_S3;
    logic [`AXI_LEN_BITS-1:0] Slave_AWLEN_S3;
    logic [`AXI_SIZE_BITS-1:0] Slave_AWSIZE_S3;
    logic [1:0] Slave_AWBURST_S3;

    //WRITE ADDRESS (WDT)
    logic [`AXI_IDS_BITS-1:0] Slave_AWID_S4;
    logic [`AXI_ADDR_BITS-1:0] Slave_AWADDR_S4;
    logic [`AXI_LEN_BITS-1:0] Slave_AWLEN_S4;
    logic [`AXI_SIZE_BITS-1:0] Slave_AWSIZE_S4;
    logic [1:0] Slave_AWBURST_S4;

    //WRITE ADDRESS (DRAM)
    logic [`AXI_IDS_BITS-1:0] Slave_AWID_S5;
    logic [`AXI_ADDR_BITS-1:0] Slave_AWADDR_S5;
    logic [`AXI_LEN_BITS-1:0] Slave_AWLEN_S5;
    logic [`AXI_SIZE_BITS-1:0] Slave_AWSIZE_S5;
    logic [1:0] Slave_AWBURST_S5;

    //W
    logic W_M1_wfull; //FIFO full
    logic W_M1_rempty; //FIFO empty

    logic W_S1_wfull; //FIFO full
    logic W_S1_rempty; //FIFO empty

    logic W_S2_wfull; //FIFO full
    logic W_S2_rempty; //FIFO empty

    logic W_S3_wfull; //FIFO full
    logic W_S3_rempty; //FIFO empty

    logic W_S4_wfull; //FIFO full
    logic W_S4_rempty; //FIFO empty

    logic W_S5_wfull; //FIFO full
    logic W_S5_rempty; //FIFO empty

    //WRITE DATA (DM)
    logic [`AXI_DATA_BITS-1:0] Master_WDATA_M1;
    logic [`AXI_STRB_BITS-1:0] Master_WSTRB_M1;
    logic Master_WLAST_M1;

    //WRITE DATA (IM)
    logic [`AXI_DATA_BITS-1:0] Slave_WDATA_S1;
    logic [`AXI_STRB_BITS-1:0] Slave_WSTRB_S1;
    logic Slave_WLAST_S1;

    //WRITE DATA (DM)
    logic [`AXI_DATA_BITS-1:0] Slave_WDATA_S2;
    logic [`AXI_STRB_BITS-1:0] Slave_WSTRB_S2;
    logic Slave_WLAST_S2;

    //WRITE DATA (sensor_control)
    logic [`AXI_DATA_BITS-1:0] Slave_WDATA_S3;
    logic [`AXI_STRB_BITS-1:0] Slave_WSTRB_S3;
    logic Slave_WLAST_S3;

    //WRITE DATA (WDT)
    logic [`AXI_DATA_BITS-1:0] Slave_WDATA_S4;
    logic [`AXI_STRB_BITS-1:0] Slave_WSTRB_S4;
    logic Slave_WLAST_S4;

    //WRITE DATA (DRAM)
    logic [`AXI_DATA_BITS-1:0] Slave_WDATA_S5;
    logic [`AXI_STRB_BITS-1:0] Slave_WSTRB_S5;
    logic Slave_WLAST_S5;

    //B
    logic B_M1_wfull; //FIFO full
    logic B_M1_rempty; //FIFO empty

    logic B_S1_wfull; //FIFO full
    logic B_S1_rempty; //FIFO empty

    logic B_S2_wfull; //FIFO full
    logic B_S2_rempty; //FIFO empty

    logic B_S3_wfull; //FIFO full
    logic B_S3_rempty; //FIFO empty

    logic B_S4_wfull; //FIFO full
    logic B_S4_rempty; //FIFO empty

    logic B_S5_wfull; //FIFO full
    logic B_S5_rempty; //FIFO empty

    //WRITE RESPONSE (IM)
    logic [`AXI_IDS_BITS-1:0] Slave_BID_S1;
    logic [1:0] Slave_BRESP_S1;

    //WRITE RESPONSE (DM)
    logic [`AXI_IDS_BITS-1:0] Slave_BID_S2;
    logic [1:0] Slave_BRESP_S2;

    //WRITE RESPONSE (sensor_control)
    logic [`AXI_IDS_BITS-1:0] Slave_BID_S3;
    logic [1:0] Slave_BRESP_S3;

    //WRITE RESPONSE (WDT)
    logic [`AXI_IDS_BITS-1:0] Slave_BID_S4;
    logic [1:0] Slave_BRESP_S4;

    //WRITE RESPONSE (DRAM)
    logic [`AXI_IDS_BITS-1:0] Slave_BID_S5;
    logic [1:0] Slave_BRESP_S5;

    //WRITE RESPONSE (DM)
    logic [`AXI_ID_BITS-1:0] Master_BID_M1;
    logic [1:0] Master_BRESP_M1;

    AXI AXI(
        .ACLK       (axi_clk),
        .ARESETn    (!axi_rst),
        
        //SLAVE INTERFACE FOR MASTERS
        //WRITE ADDRESS (DM)
        .AWID_M1    (Master_AWID_M1),
        .AWADDR_M1  (Master_AWADDR_M1),
        .AWLEN_M1   (Master_AWLEN_M1),
        .AWSIZE_M1  (Master_AWSIZE_M1),
        .AWBURST_M1 (Master_AWBURST_M1),
        .AWVALID_M1 (~AW_M1_rempty),
        .AWREADY_M1 (AWREADY_M1),

        //WRITE DATA (DM)
        .WDATA_M1   (Master_WDATA_M1),
        .WSTRB_M1   (Master_WSTRB_M1),
        .WLAST_M1   (Master_WLAST_M1),
        .WVALID_M1  (~W_M1_rempty),
        .WREADY_M1  (WREADY_M1),
        
        //WRITE RESPONSE (DM)
        .BID_M1     (Master_BID_M1),
        .BRESP_M1   (Master_BRESP_M1),
        .BVALID_M1  (BVALID_M1),
        .BREADY_M1  (~B_M1_wfull),

        //READ ADDRESS (IM)
        .ARID_M0    (Master_ARID_M0),
        .ARADDR_M0  (Master_ARADDR_M0),
        .ARLEN_M0   (Master_ARLEN_M0),
        .ARSIZE_M0  (Master_ARSIZE_M0),
        .ARBURST_M0 (Master_ARBURST_M0),
        .ARVALID_M0 (~AR_M0_rempty),
        .ARREADY_M0 (ARREADY_M0),

        //READ DATA (IM)
        .RID_M0     (Master_RID_M0),
        .RDATA_M0   (Master_RDATA_M0),
        .RRESP_M0   (Master_RRESP_M0),
        .RLAST_M0   (Master_RLAST_M0),
        .RVALID_M0  (RVALID_M0),
        .RREADY_M0  (~R_M0_wfull),

        //READ ADDRESS (DM)
        .ARID_M1    (Master_ARID_M1),
        .ARADDR_M1  (Master_ARADDR_M1),
        .ARLEN_M1   (Master_ARLEN_M1),
        .ARSIZE_M1  (Master_ARSIZE_M1),
        .ARBURST_M1 (Master_ARBURST_M1),
        .ARVALID_M1 (~AR_M1_rempty),
        .ARREADY_M1 (ARREADY_M1),

        //READ DATA (DM)
        .RID_M1     (Master_RID_M1),
        .RDATA_M1   (Master_RDATA_M1),
        .RRESP_M1   (Master_RRESP_M1),
        .RLAST_M1   (Master_RLAST_M1),
        .RVALID_M1  (RVALID_M1),
        .RREADY_M1  (~R_M1_wfull),

        //MASTER INTERFACE FOR SLAVES
        //WRITE ADDRESS (IM)
        .AWID_S1    (Slave_AWID_S1),
        .AWADDR_S1  (Slave_AWADDR_S1),
        .AWLEN_S1   (Slave_AWLEN_S1),
        .AWSIZE_S1  (Slave_AWSIZE_S1),
        .AWBURST_S1 (Slave_AWBURST_S1),
        .AWVALID_S1 (AWVALID_S1),
        .AWREADY_S1 (~AW_S1_wfull),

        //WRITE DATA (IM)
        .WDATA_S1   (Slave_WDATA_S1),
        .WSTRB_S1   (Slave_WSTRB_S1),
        .WLAST_S1   (Slave_WLAST_S1),
        .WVALID_S1  (WVALID_S1),
        .WREADY_S1  (~W_S1_wfull),

        //WRITE RESPONSE (IM)
        .BID_S1     (Slave_BID_S1),
        .BRESP_S1   (Slave_BRESP_S1),
        .BVALID_S1  (~B_S1_rempty),
        .BREADY_S1  (BREADY_S1),

        //WRITE ADDRESS (DM)
        .AWID_S2    (Slave_AWID_S2),
        .AWADDR_S2  (Slave_AWADDR_S2),
        .AWLEN_S2   (Slave_AWLEN_S2),
        .AWSIZE_S2  (Slave_AWSIZE_S2),
        .AWBURST_S2 (Slave_AWBURST_S2),
        .AWVALID_S2 (AWVALID_S2),
        .AWREADY_S2 (~AW_S2_wfull),

        //WRITE DATA (DM)
        .WDATA_S2   (Slave_WDATA_S2),
        .WSTRB_S2   (Slave_WSTRB_S2),
        .WLAST_S2   (Slave_WLAST_S2),
        .WVALID_S2  (WVALID_S2),
        .WREADY_S2  (~W_S2_wfull),

        //WRITE RESPONSE (DM)
        .BID_S2     (Slave_BID_S2),
        .BRESP_S2   (Slave_BRESP_S2),
        .BVALID_S2  (~B_S2_rempty),
        .BREADY_S2  (BREADY_S2),

        //WRITE ADDRESS (sensor_control)
        .AWID_S3    (Slave_AWID_S3),
        .AWADDR_S3  (Slave_AWADDR_S3),
        .AWLEN_S3   (Slave_AWLEN_S3),
        .AWSIZE_S3  (Slave_AWSIZE_S3),
        .AWBURST_S3 (Slave_AWBURST_S3),
        .AWVALID_S3 (AWVALID_S3),
        .AWREADY_S3 (~AW_S3_wfull),

        //WRITE DATA (sensor_control)
        .WDATA_S3   (Slave_WDATA_S3),
        .WSTRB_S3   (Slave_WSTRB_S3),
        .WLAST_S3   (Slave_WLAST_S3),
        .WVALID_S3  (WVALID_S3),
        .WREADY_S3  (~W_S3_wfull),

        //WRITE RESPONSE (sensor_control)
        .BID_S3     (Slave_BID_S3),
        .BRESP_S3   (Slave_BRESP_S3),
        .BVALID_S3  (~B_S3_rempty),
        .BREADY_S3  (BREADY_S3),

        //WRITE ADDRESS (WDT)
        .AWID_S4    (Slave_AWID_S4),
        .AWADDR_S4  (Slave_AWADDR_S4),
        .AWLEN_S4   (Slave_AWLEN_S4),
        .AWSIZE_S4  (Slave_AWSIZE_S4),
        .AWBURST_S4 (Slave_AWBURST_S4),
        .AWVALID_S4 (AWVALID_S4),
        .AWREADY_S4 (~AW_S4_wfull),

        //WRITE DATA (WDT)
        .WDATA_S4   (Slave_WDATA_S4),
        .WSTRB_S4   (Slave_WSTRB_S4),
        .WLAST_S4   (Slave_WLAST_S4),
        .WVALID_S4  (WVALID_S4),
        .WREADY_S4  (~W_S4_wfull),

        //WRITE RESPONSE (WDT)
        .BID_S4     (Slave_BID_S4),
        .BRESP_S4   (Slave_BRESP_S4),
        .BVALID_S4  (~B_S4_rempty),
        .BREADY_S4  (BREADY_S4),

        //WRITE ADDRESS (DRAM)
        .AWID_S5    (Slave_AWID_S5),
        .AWADDR_S5  (Slave_AWADDR_S5),
        .AWLEN_S5   (Slave_AWLEN_S5),
        .AWSIZE_S5  (Slave_AWSIZE_S5),
        .AWBURST_S5 (Slave_AWBURST_S5),
        .AWVALID_S5 (AWVALID_S5),
        .AWREADY_S5 (~AW_S5_wfull),

        //WRITE DATA (DRAM)
        .WDATA_S5   (Slave_WDATA_S5),
        .WSTRB_S5   (Slave_WSTRB_S5),
        .WLAST_S5   (Slave_WLAST_S5),
        .WVALID_S5  (WVALID_S5),
        .WREADY_S5  (~W_S5_wfull),

        //WRITE RESPONSE (DRAM)
        .BID_S5     (Slave_BID_S5),
        .BRESP_S5   (Slave_BRESP_S5),
        .BVALID_S5  (~B_S5_rempty),
        .BREADY_S5  (BREADY_S5),

        //READ ADDRESS (ROM)
        .ARID_S0    (Slave_ARID_S0),
        .ARADDR_S0  (Slave_ARADDR_S0),
        .ARLEN_S0   (Slave_ARLEN_S0),
        .ARSIZE_S0  (Slave_ARSIZE_S0),
        .ARBURST_S0 (Slave_ARBURST_S0),
        .ARVALID_S0 (ARVALID_S0),
        .ARREADY_S0 (~AR_S0_wfull),

        //READ DATA (ROM)
        .RID_S0     (Slave_RID_S0),
        .RDATA_S0   (Slave_RDATA_S0),
        .RRESP_S0   (Slave_RRESP_S0),
        .RLAST_S0   (Slave_RLAST_S0),
        .RVALID_S0  (~R_S0_rempty),
        .RREADY_S0  (RREADY_S0),

        //READ ADDRESS (IM)
        .ARID_S1    (Slave_ARID_S1),
        .ARADDR_S1  (Slave_ARADDR_S1),
        .ARLEN_S1   (Slave_ARLEN_S1),
        .ARSIZE_S1  (Slave_ARSIZE_S1),
        .ARBURST_S1 (Slave_ARBURST_S1),
        .ARVALID_S1 (ARVALID_S1),
        .ARREADY_S1 (~AR_S1_wfull),

        //READ DATA (IM)
        .RID_S1     (Slave_RID_S1),
        .RDATA_S1   (Slave_RDATA_S1),
        .RRESP_S1   (Slave_RRESP_S1),
        .RLAST_S1   (Slave_RLAST_S1),
        .RVALID_S1  (~R_S1_rempty),
        .RREADY_S1  (RREADY_S1),

        //READ ADDRESS (DM)
        .ARID_S2    (Slave_ARID_S2),
        .ARADDR_S2  (Slave_ARADDR_S2),
        .ARLEN_S2   (Slave_ARLEN_S2),
        .ARSIZE_S2  (Slave_ARSIZE_S2),
        .ARBURST_S2 (Slave_ARBURST_S2),
        .ARVALID_S2 (ARVALID_S2),
        .ARREADY_S2 (~AR_S2_wfull),

        //READ DATA (DM)
        .RID_S2     (Slave_RID_S2),
        .RDATA_S2   (Slave_RDATA_S2),
        .RRESP_S2   (Slave_RRESP_S2),
        .RLAST_S2   (Slave_RLAST_S2),
        .RVALID_S2  (~R_S2_rempty),
        .RREADY_S2  (RREADY_S2),

        //READ ADDRESS (sensor_control)
        .ARID_S3    (Slave_ARID_S3),
        .ARADDR_S3  (Slave_ARADDR_S3),
        .ARLEN_S3   (Slave_ARLEN_S3),
        .ARSIZE_S3  (Slave_ARSIZE_S3),
        .ARBURST_S3 (Slave_ARBURST_S3),
        .ARVALID_S3 (ARVALID_S3),
        .ARREADY_S3 (~AR_S3_wfull),

        //READ DATA (sensor_control)
        .RID_S3     (Slave_RID_S3),
        .RDATA_S3   (Slave_RDATA_S3),
        .RRESP_S3   (Slave_RRESP_S3),
        .RLAST_S3   (Slave_RLAST_S3),
        .RVALID_S3  (~R_S3_rempty),
        .RREADY_S3  (RREADY_S3),

        //READ ADDRESS (WDT)
        .ARID_S4    (Slave_ARID_S4),
        .ARADDR_S4  (Slave_ARADDR_S4),
        .ARLEN_S4   (Slave_ARLEN_S4),
        .ARSIZE_S4  (Slave_ARSIZE_S4),
        .ARBURST_S4 (Slave_ARBURST_S4),
        .ARVALID_S4 (ARVALID_S4),
        .ARREADY_S4 (~AR_S4_wfull),

        //READ DATA (WDT)
        .RID_S4     (Slave_RID_S4),
        .RDATA_S4   (Slave_RDATA_S4),
        .RRESP_S4   (Slave_RRESP_S4),
        .RLAST_S4   (Slave_RLAST_S4),
        .RVALID_S4  (~R_S4_rempty),
        .RREADY_S4  (RREADY_S4),

        //READ ADDRESS (DRAM)
        .ARID_S5    (Slave_ARID_S5),
        .ARADDR_S5  (Slave_ARADDR_S5),
        .ARLEN_S5   (Slave_ARLEN_S5),
        .ARSIZE_S5  (Slave_ARSIZE_S5),
        .ARBURST_S5 (Slave_ARBURST_S5),
        .ARVALID_S5 (ARVALID_S5),
        .ARREADY_S5 (~AR_S5_wfull),

        //READ DATA (DRAM)
        .RID_S5     (Slave_RID_S5),
        .RDATA_S5   (Slave_RDATA_S5),
        .RRESP_S5   (Slave_RRESP_S5),
        .RLAST_S5   (Slave_RLAST_S5),
        .RVALID_S5  (~R_S5_rempty),
        .RREADY_S5  (RREADY_S5)
    );

    //for CDC
    //AR
    AR_FIFO_Master_to_AXI AR_FIFO_Master_to_AXI_M0 (
        //Write
        .wclk   (cpu_clk), //Write domain clock
        .wrst   (cpu_rst), //Write domain reset
        .wpush  (ARVALID_M0), //Data push enable
        .wdata  ({ARID_M0, ARADDR_M0, ARLEN_M0, ARSIZE_M0, ARBURST_M0}), //Write data

        .wfull  (AR_M0_wfull), //FIFO full

        //read
        .rclk   (axi_clk), //Read domain clock
        .rrst   (axi_rst), //Read domain reset
        .rpop   (ARREADY_M0), //Data pop enable

        .rdata  ({Master_ARID_M0, Master_ARADDR_M0, Master_ARLEN_M0, Master_ARSIZE_M0, Master_ARBURST_M0}), //Read data
        .rempty (AR_M0_rempty)  //FIFO empty
    );

    AR_FIFO_Master_to_AXI AR_FIFO_Master_to_AXI_M1 (
        //Write
        .wclk   (cpu_clk), //Write domain clock
        .wrst   (cpu_rst), //Write domain reset
        .wpush  (ARVALID_M1), //Data push enable
        .wdata  ({ARID_M1, ARADDR_M1, ARLEN_M1, ARSIZE_M1, ARBURST_M1}), //Write data

        .wfull  (AR_M1_wfull), //FIFO full

        //read
        .rclk   (axi_clk), //Read domain clock
        .rrst   (axi_rst), //Read domain reset
        .rpop   (ARREADY_M1), //Data pop enable

        .rdata  ({Master_ARID_M1, Master_ARADDR_M1, Master_ARLEN_M1, Master_ARSIZE_M1, Master_ARBURST_M1}), //Read data
        .rempty (AR_M1_rempty)  //FIFO empty
    );
    //R
    R_FIFO_AXI_to_Master R_FIFO_AXI_to_Master_M0 (
        //Write
        .wclk   (axi_clk), //Write domain clock
        .wrst   (axi_rst), //Write domain reset
        .wpush  (RVALID_M0), //Data push enable
        .wdata  ({Master_RID_M0, Master_RDATA_M0, Master_RRESP_M0, Master_RLAST_M0}), //Write data

        .wfull  (R_M0_wfull), //FIFO full

        //read
        .rclk   (cpu_clk), //Read domain clock
        .rrst   (cpu_rst), //Read domain reset
        .rpop   (RREADY_M0), //Data pop enable

        .rdata  ({RID_M0, RDATA_M0, RRESP_M0, RLAST_M0}), //Read data
        .rempty (R_M0_rempty)  //FIFO empty
    );

    R_FIFO_AXI_to_Master R_FIFO_AXI_to_Master_M1 (
        //Write
        .wclk   (axi_clk), //Write domain clock
        .wrst   (axi_rst), //Write domain reset
        .wpush  (RVALID_M1), //Data push enable
        .wdata  ({Master_RID_M1, Master_RDATA_M1, Master_RRESP_M1, Master_RLAST_M1}), //Write data

        .wfull  (R_M1_wfull), //FIFO full

        //read
        .rclk   (cpu_clk), //Read domain clock
        .rrst   (cpu_rst), //Read domain reset
        .rpop   (RREADY_M1), //Data pop enable

        .rdata  ({RID_M1, RDATA_M1, RRESP_M1, RLAST_M1}), //Read data
        .rempty (R_M1_rempty)  //FIFO empty
    );
    //AW
    AW_FIFO_Master_to_AXI AW_FIFO_Master_to_AXI_M1 (
        //Write
        .wclk   (cpu_clk), //Write domain clock
        .wrst   (cpu_rst), //Write domain reset
        .wpush  (AWVALID_M1), //Data push enable
        .wdata  ({AWID_M1, AWADDR_M1, AWLEN_M1, AWSIZE_M1, AWBURST_M1}), //Write data

        .wfull  (AW_M1_wfull), //FIFO full

        //read
        .rclk   (axi_clk), //Read domain clock
        .rrst   (axi_rst), //Read domain reset
        .rpop   (AWREADY_M1), //Data pop enable

        .rdata  ({Master_AWID_M1, Master_AWADDR_M1, Master_AWLEN_M1, Master_AWSIZE_M1, Master_AWBURST_M1}), //Read data
        .rempty (AW_M1_rempty)  //FIFO empty
    );
    //W
    W_FIFO_Master_to_AXI W_FIFO_Master_to_AXI_M1 (
        //Write
        .wclk   (cpu_clk), //Write domain clock
        .wrst   (cpu_rst), //Write domain reset
        .wpush  (WVALID_M1), //Data push enable
        .wdata  ({WDATA_M1, WSTRB_M1, WLAST_M1}), //Write data

        .wfull  (W_M1_wfull), //FIFO full

        //read
        .rclk   (axi_clk), //Read domain clock
        .rrst   (axi_rst), //Read domain reset
        .rpop   (WREADY_M1), //Data pop enable

        .rdata  ({Master_WDATA_M1, Master_WSTRB_M1, Master_WLAST_M1}), //Read data
        .rempty (W_M1_rempty)  //FIFO empty
    );
    //B
    B_FIFO_AXI_to_Master B_FIFO_AXI_to_Master_M1 (
        //Write
        .wclk   (axi_clk), //Write domain clock
        .wrst   (axi_rst), //Write domain reset
        .wpush  (BVALID_M1), //Data push enable
        .wdata  ({Master_BID_M1, Master_BRESP_M1}), //Write data

        .wfull  (B_M1_wfull), //FIFO full

        //read
        .rclk   (cpu_clk), //Read domain clock
        .rrst   (cpu_rst), //Read domain reset
        .rpop   (BREADY_M1), //Data pop enable

        .rdata  ({BID_M1, BRESP_M1}), //Read data
        .rempty (B_M1_rempty)  //FIFO empty
    );

    CPU_wrapper CPU_wrapper (
        .ACLK             (cpu_clk),
	    .ARESETn          (!cpu_rst),

        //WRITE ADDRESS1
        .AWID_M1          (AWID_M1),   
        .AWADDR_M1        (AWADDR_M1), 
        .AWLEN_M1         (AWLEN_M1),  
        .AWSIZE_M1        (AWSIZE_M1), 
        .AWBURST_M1       (AWBURST_M1),                 
        .AWVALID_M1       (AWVALID_M1),
        
        .AWREADY_M1       (~AW_M1_wfull),

        //WRITE DATA1
        .WDATA_M1         (WDATA_M1), 
        .WSTRB_M1         (WSTRB_M1), 
        .WLAST_M1         (WLAST_M1),
        .WVALID_M1        (WVALID_M1),
        
        .WREADY_M1        (~W_M1_wfull),

        //WRITE RESPONSE1
        .BID_M1           (BID_M1), 
        .BRESP_M1         (BRESP_M1), 
        .BVALID_M1        (~B_M1_rempty),
        
        .BREADY_M1        (BREADY_M1),

        //READ ADDRESS0
        .ARID_M0          (ARID_M0),   
        .ARADDR_M0        (ARADDR_M0), 
        .ARLEN_M0         (ARLEN_M0),  
        .ARSIZE_M0        (ARSIZE_M0), 
        .ARBURST_M0       (ARBURST_M0),
        .ARVALID_M0       (ARVALID_M0),
        
        .ARREADY_M0       (~AR_M0_wfull),

        //READ DATA0
        .RID_M0           (RID_M0),   
        .RDATA_M0         (RDATA_M0), 
        .RRESP_M0         (RRESP_M0),
        .RLAST_M0         (RLAST_M0),
        .RVALID_M0        (~R_M0_rempty),

        .RREADY_M0        (RREADY_M0),

        //READ ADDRESS1
        .ARID_M1          (ARID_M1),  
        .ARADDR_M1        (ARADDR_M1), 
        .ARLEN_M1         (ARLEN_M1),  
        .ARSIZE_M1        (ARSIZE_M1), 
        .ARBURST_M1       (ARBURST_M1),
        .ARVALID_M1       (ARVALID_M1),

        .ARREADY_M1       (~AR_M1_wfull),

        //READ DATA1
        .RID_M1           (RID_M1),   
        .RDATA_M1         (RDATA_M1), 
        .RRESP_M1         (RRESP_M1),
        .RLAST_M1         (RLAST_M1),
        .RVALID_M1        (~R_M1_rempty),

        .RREADY_M1        (RREADY_M1),

        //Interrupt
        .Interrupt_SCtrl (sensor_interrupt),
        .WTO             (WDT_interrupt)
    );

    //for CDC
    //AR
    AR_FIFO_AXI_to_Slave AR_FIFO_AXI_to_Slave_S0 (
        //Write
        .wclk   (axi_clk), //Write domain clock
        .wrst   (axi_rst), //Write domain reset
        .wpush  (ARVALID_S0), //Data push enable
        .wdata  ({Slave_ARID_S0, Slave_ARADDR_S0, Slave_ARLEN_S0, Slave_ARSIZE_S0, Slave_ARBURST_S0}), //Write data

        .wfull  (AR_S0_wfull), //FIFO full

        //read
        .rclk   (rom_clk), //Read domain clock
        .rrst   (rom_rst), //Read domain reset
        .rpop   (ARREADY_S0), //Data pop enable

        .rdata  ({ARID_S0, ARADDR_S0, ARLEN_S0, ARSIZE_S0, ARBURST_S0}), //Read data
        .rempty (AR_S0_rempty)  //FIFO empty
    );
    //R
    R_FIFO_Slave_to_AXI R_FIFO_Slave_to_AXI_S0 (
        //Write
        .wclk   (rom_clk), //Write domain clock
        .wrst   (rom_rst), //Write domain reset
        .wpush  (RVALID_S0), //Data push enable
        .wdata  ({RID_S0, RDATA_S0, RRESP_S0, RLAST_S0}), //Write data

        .wfull  (R_S0_wfull), //FIFO full

        //read
        .rclk   (axi_clk), //Read domain clock
        .rrst   (axi_rst), //Read domain reset
        .rpop   (RREADY_S0), //Data pop enable

        .rdata  ({Slave_RID_S0, Slave_RDATA_S0, Slave_RRESP_S0, Slave_RLAST_S0}), //Read data
        .rempty (R_S0_rempty)  //FIFO empty
    );

    ROM_wrapper ROM (
        .ACLK        (rom_clk),
        .ARESETn     (!rom_rst),

        //READ ADDRESS
        .ARID        (ARID_S0),  
        .ARADDR      (ARADDR_S0), 
        .ARLEN       (ARLEN_S0),  
        .ARSIZE      (ARSIZE_S0), 
        .ARBURST     (ARBURST_S0),
        .ARVALID     (~AR_S0_rempty),

        .ARREADY     (ARREADY_S0),

        //READ DATA
        .RID         (RID_S0),   
        .RDATA       (RDATA_S0), 
        .RRESP       (RRESP_S0),
        .RLAST       (RLAST_S0),
        .RVALID      (RVALID_S0),

        .RREADY      (~R_S0_wfull),

        //ROM
        .ROM_read    (ROM_read),
        .ROM_enable  (ROM_enable),
        .ROM_address (ROM_address),

        .ROM_out     (ROM_out)
    );

    //for CDC
    //AR
    AR_FIFO_AXI_to_Slave AR_FIFO_AXI_to_Slave_S1 (
        //Write
        .wclk   (axi_clk), //Write domain clock
        .wrst   (axi_rst), //Write domain reset
        .wpush  (ARVALID_S1), //Data push enable
        .wdata  ({Slave_ARID_S1, Slave_ARADDR_S1, Slave_ARLEN_S1, Slave_ARSIZE_S1, Slave_ARBURST_S1}), //Write data

        .wfull  (AR_S1_wfull), //FIFO full

        //read
        .rclk   (sram_clk), //Read domain clock
        .rrst   (sram_rst), //Read domain reset
        .rpop   (ARREADY_S1), //Data pop enable

        .rdata  ({ARID_S1, ARADDR_S1, ARLEN_S1, ARSIZE_S1, ARBURST_S1}), //Read data
        .rempty (AR_S1_rempty)  //FIFO empty
    );
    //R
    R_FIFO_Slave_to_AXI R_FIFO_Slave_to_AXI_S1 (
        //Write
        .wclk   (sram_clk), //Write domain clock
        .wrst   (sram_rst), //Write domain reset
        .wpush  (RVALID_S1), //Data push enable
        .wdata  ({RID_S1, RDATA_S1, RRESP_S1, RLAST_S1}), //Write data

        .wfull  (R_S1_wfull), //FIFO full

        //read
        .rclk   (axi_clk), //Read domain clock
        .rrst   (axi_rst), //Read domain reset
        .rpop   (RREADY_S1), //Data pop enable

        .rdata  ({Slave_RID_S1, Slave_RDATA_S1, Slave_RRESP_S1, Slave_RLAST_S1}), //Read data
        .rempty (R_S1_rempty)  //FIFO empty
    );
    //AW
    AW_FIFO_AXI_to_Slave AW_FIFO_AXI_to_Slave_S1 (
        //Write
        .wclk   (axi_clk), //Write domain clock
        .wrst   (axi_rst), //Write domain reset
        .wpush  (AWVALID_S1), //Data push enable
        .wdata  ({Slave_AWID_S1, Slave_AWADDR_S1, Slave_AWLEN_S1, Slave_AWSIZE_S1, Slave_AWBURST_S1}), //Write data

        .wfull  (AW_S1_wfull), //FIFO full

        //read
        .rclk   (sram_clk), //Read domain clock
        .rrst   (sram_rst), //Read domain reset
        .rpop   (AWREADY_S1), //Data pop enable

        .rdata  ({AWID_S1, AWADDR_S1, AWLEN_S1, AWSIZE_S1, AWBURST_S1}), //Read data
        .rempty (AW_S1_rempty)  //FIFO empty
    );
    //W
    W_FIFO_AXI_to_Slave W_FIFO_AXI_to_Slave_S1 (
        //Write
        .wclk   (axi_clk), //Write domain clock
        .wrst   (axi_rst), //Write domain reset
        .wpush  (WVALID_S1), //Data push enable
        .wdata  ({Slave_WDATA_S1, Slave_WSTRB_S1, Slave_WLAST_S1}), //Write data

        .wfull  (W_S1_wfull), //FIFO full

        //read
        .rclk   (sram_clk), //Read domain clock
        .rrst   (sram_rst), //Read domain reset
        .rpop   (WREADY_S1), //Data pop enable

        .rdata  ({WDATA_S1, WSTRB_S1, WLAST_S1}), //Read data
        .rempty (W_S1_rempty)  //FIFO empty
    );
    //B
    B_FIFO_Slave_to_AXI B_FIFO_Slave_to_AXI_S1 (
        //Write
        .wclk   (sram_clk), //Write domain clock
        .wrst   (sram_rst), //Write domain reset
        .wpush  (BVALID_S1), //Data push enable
        .wdata  ({BID_S1, BRESP_S1}), //Write data

        .wfull  (B_S1_wfull), //FIFO full

        //read
        .rclk   (axi_clk), //Read domain clock
        .rrst   (axi_rst), //Read domain reset
        .rpop   (BREADY_S1), //Data pop enable

        .rdata  ({Slave_BID_S1, Slave_BRESP_S1}), //Read data
        .rempty (B_S1_rempty)  //FIFO empty
    );

    SRAM_wrapper IM1 (
        .ACLK        (sram_clk),
        .ARESETn     (!sram_rst),

        //WRITE ADDRESS
        .AWID        (AWID_S1),  
        .AWADDR      (AWADDR_S1), 
        .AWLEN       (AWLEN_S1),  
        .AWSIZE      (AWSIZE_S1), 
        .AWBURST     (AWBURST_S1),
        .AWVALID     (~AW_S1_rempty),

        .AWREADY     (AWREADY_S1),

        //WRITE DATA
        .WDATA       (WDATA_S1), 
        .WSTRB       (WSTRB_S1), 
        .WLAST       (WLAST_S1),
        .WVALID      (~W_S1_rempty),

        .WREADY      (WREADY_S1),

        //WRITE RESPONSE
        .BID         (BID_S1), 
        .BRESP       (BRESP_S1),
        .BVALID      (BVALID_S1),

        .BREADY      (~B_S1_wfull),

        //READ ADDRESS
        .ARID        (ARID_S1),  
        .ARADDR      (ARADDR_S1), 
        .ARLEN       (ARLEN_S1),  
        .ARSIZE      (ARSIZE_S1), 
        .ARBURST     (ARBURST_S1),
        .ARVALID     (~AR_S1_rempty),

        .ARREADY     (ARREADY_S1),

        //READ DATA
        .RID         (RID_S1),   
        .RDATA       (RDATA_S1), 
        .RRESP       (RRESP_S1),
        .RLAST       (RLAST_S1),
        .RVALID      (RVALID_S1),

        .RREADY      (~R_S1_wfull)
    );

    //for CDC
    //AR
    AR_FIFO_AXI_to_Slave AR_FIFO_AXI_to_Slave_S2 (
        //Write
        .wclk   (axi_clk), //Write domain clock
        .wrst   (axi_rst), //Write domain reset
        .wpush  (ARVALID_S2), //Data push enable
        .wdata  ({Slave_ARID_S2, Slave_ARADDR_S2, Slave_ARLEN_S2, Slave_ARSIZE_S2, Slave_ARBURST_S2}), //Write data

        .wfull  (AR_S2_wfull), //FIFO full

        //read
        .rclk   (sram_clk), //Read domain clock
        .rrst   (sram_rst), //Read domain reset
        .rpop   (ARREADY_S2), //Data pop enable

        .rdata  ({ARID_S2, ARADDR_S2, ARLEN_S2, ARSIZE_S2, ARBURST_S2}), //Read data
        .rempty (AR_S2_rempty)  //FIFO empty
    );
    //R
    R_FIFO_Slave_to_AXI R_FIFO_Slave_to_AXI_S2 (
        //Write
        .wclk   (sram_clk), //Write domain clock
        .wrst   (sram_rst), //Write domain reset
        .wpush  (RVALID_S2), //Data push enable
        .wdata  ({RID_S2, RDATA_S2, RRESP_S2, RLAST_S2}), //Write data

        .wfull  (R_S2_wfull), //FIFO full

        //read
        .rclk   (axi_clk), //Read domain clock
        .rrst   (axi_rst), //Read domain reset
        .rpop   (RREADY_S2), //Data pop enable

        .rdata  ({Slave_RID_S2, Slave_RDATA_S2, Slave_RRESP_S2, Slave_RLAST_S2}), //Read data
        .rempty (R_S2_rempty)  //FIFO empty
    );
    //AW
    AW_FIFO_AXI_to_Slave AW_FIFO_AXI_to_Slave_S2 (
        //Write
        .wclk   (axi_clk), //Write domain clock
        .wrst   (axi_rst), //Write domain reset
        .wpush  (AWVALID_S2), //Data push enable
        .wdata  ({Slave_AWID_S2, Slave_AWADDR_S2, Slave_AWLEN_S2, Slave_AWSIZE_S2, Slave_AWBURST_S2}), //Write data

        .wfull  (AW_S2_wfull), //FIFO full

        //read
        .rclk   (sram_clk), //Read domain clock
        .rrst   (sram_rst), //Read domain reset
        .rpop   (AWREADY_S2), //Data pop enable

        .rdata  ({AWID_S2, AWADDR_S2, AWLEN_S2, AWSIZE_S2, AWBURST_S2}), //Read data
        .rempty (AW_S2_rempty)  //FIFO empty
    );
    //W
    W_FIFO_AXI_to_Slave W_FIFO_AXI_to_Slave_S2 (
        //Write
        .wclk   (axi_clk), //Write domain clock
        .wrst   (axi_rst), //Write domain reset
        .wpush  (WVALID_S2), //Data push enable
        .wdata  ({Slave_WDATA_S2, Slave_WSTRB_S2, Slave_WLAST_S2}), //Write data

        .wfull  (W_S2_wfull), //FIFO full

        //read
        .rclk   (sram_clk), //Read domain clock
        .rrst   (sram_rst), //Read domain reset
        .rpop   (WREADY_S2), //Data pop enable

        .rdata  ({WDATA_S2, WSTRB_S2, WLAST_S2}), //Read data
        .rempty (W_S2_rempty)  //FIFO empty
    );
    //B
    B_FIFO_Slave_to_AXI B_FIFO_Slave_to_AXI_S2 (
        //Write
        .wclk   (sram_clk), //Write domain clock
        .wrst   (sram_rst), //Write domain reset
        .wpush  (BVALID_S2), //Data push enable
        .wdata  ({BID_S2, BRESP_S2}), //Write data

        .wfull  (B_S2_wfull), //FIFO full

        //read
        .rclk   (axi_clk), //Read domain clock
        .rrst   (axi_rst), //Read domain reset
        .rpop   (BREADY_S2), //Data pop enable

        .rdata  ({Slave_BID_S2, Slave_BRESP_S2}), //Read data
        .rempty (B_S2_rempty)  //FIFO empty
    );

    SRAM_wrapper DM1 (
        .ACLK        (sram_clk),
        .ARESETn     (!sram_rst),

        //WRITE ADDRESS
        .AWID        (AWID_S2),  
        .AWADDR      (AWADDR_S2), 
        .AWLEN       (AWLEN_S2),  
        .AWSIZE      (AWSIZE_S2), 
        .AWBURST     (AWBURST_S2),
        .AWVALID     (~AW_S2_rempty),

        .AWREADY     (AWREADY_S2),

        //WRITE DATA
        .WDATA       (WDATA_S2), 
        .WSTRB       (WSTRB_S2), 
        .WLAST       (WLAST_S2),
        .WVALID      (~W_S2_rempty),

        .WREADY      (WREADY_S2),

        //WRITE RESPONSE
        .BID         (BID_S2), 
        .BRESP       (BRESP_S2),
        .BVALID      (BVALID_S2),

        .BREADY      (~B_S2_wfull),

        //READ ADDRESS
        .ARID        (ARID_S2),  
        .ARADDR      (ARADDR_S2), 
        .ARLEN       (ARLEN_S2),  
        .ARSIZE      (ARSIZE_S2), 
        .ARBURST     (ARBURST_S2),
        .ARVALID     (~AR_S2_rempty),

        .ARREADY     (ARREADY_S2),

        //READ DATA
        .RID         (RID_S2),   
        .RDATA       (RDATA_S2), 
        .RRESP       (RRESP_S2),
        .RLAST       (RLAST_S2),
        .RVALID      (RVALID_S2),

        .RREADY      (~R_S2_wfull)
    );

    //for CDC
    //AR
    AR_FIFO_AXI_to_Slave AR_FIFO_AXI_to_Slave_S3 (
        //Write
        .wclk   (axi_clk), //Write domain clock
        .wrst   (axi_rst), //Write domain reset
        .wpush  (ARVALID_S3), //Data push enable
        .wdata  ({Slave_ARID_S3, Slave_ARADDR_S3, Slave_ARLEN_S3, Slave_ARSIZE_S3, Slave_ARBURST_S3}), //Write data

        .wfull  (AR_S3_wfull), //FIFO full

        //read
        .rclk   (cpu_clk), //Read domain clock
        .rrst   (cpu_rst), //Read domain reset
        .rpop   (ARREADY_S3), //Data pop enable

        .rdata  ({ARID_S3, ARADDR_S3, ARLEN_S3, ARSIZE_S3, ARBURST_S3}), //Read data
        .rempty (AR_S3_rempty)  //FIFO empty
    );
    //R
    R_FIFO_Slave_to_AXI R_FIFO_Slave_to_AXI_S3 (
        //Write
        .wclk   (cpu_clk), //Write domain clock
        .wrst   (cpu_rst), //Write domain reset
        .wpush  (RVALID_S3), //Data push enable
        .wdata  ({RID_S3, RDATA_S3, RRESP_S3, RLAST_S3}), //Write data

        .wfull  (R_S3_wfull), //FIFO full

        //read
        .rclk   (axi_clk), //Read domain clock
        .rrst   (axi_rst), //Read domain reset
        .rpop   (RREADY_S3), //Data pop enable

        .rdata  ({Slave_RID_S3, Slave_RDATA_S3, Slave_RRESP_S3, Slave_RLAST_S3}), //Read data
        .rempty (R_S3_rempty)  //FIFO empty
    );
    //AW
    AW_FIFO_AXI_to_Slave AW_FIFO_AXI_to_Slave_S3 (
        //Write
        .wclk   (axi_clk), //Write domain clock
        .wrst   (axi_rst), //Write domain reset
        .wpush  (AWVALID_S3), //Data push enable
        .wdata  ({Slave_AWID_S3, Slave_AWADDR_S3, Slave_AWLEN_S3, Slave_AWSIZE_S3, Slave_AWBURST_S3}), //Write data

        .wfull  (AW_S3_wfull), //FIFO full

        //read
        .rclk   (cpu_clk), //Read domain clock
        .rrst   (cpu_rst), //Read domain reset
        .rpop   (AWREADY_S3), //Data pop enable

        .rdata  ({AWID_S3, AWADDR_S3, AWLEN_S3, AWSIZE_S3, AWBURST_S3}), //Read data
        .rempty (AW_S3_rempty)  //FIFO empty
    );
    //W
    W_FIFO_AXI_to_Slave W_FIFO_AXI_to_Slave_S3 (
        //Write
        .wclk   (axi_clk), //Write domain clock
        .wrst   (axi_rst), //Write domain reset
        .wpush  (WVALID_S3), //Data push enable
        .wdata  ({Slave_WDATA_S3, Slave_WSTRB_S3, Slave_WLAST_S3}), //Write data

        .wfull  (W_S3_wfull), //FIFO full

        //read
        .rclk   (cpu_clk), //Read domain clock
        .rrst   (cpu_rst), //Read domain reset
        .rpop   (WREADY_S3), //Data pop enable

        .rdata  ({WDATA_S3, WSTRB_S3, WLAST_S3}), //Read data
        .rempty (W_S3_rempty)  //FIFO empty
    );
    //B
    B_FIFO_Slave_to_AXI B_FIFO_Slave_to_AXI_S3 (
        //Write
        .wclk   (cpu_clk), //Write domain clock
        .wrst   (cpu_rst), //Write domain reset
        .wpush  (BVALID_S3), //Data push enable
        .wdata  ({BID_S3, BRESP_S3}), //Write data

        .wfull  (B_S3_wfull), //FIFO full

        //read
        .rclk   (axi_clk), //Read domain clock
        .rrst   (axi_rst), //Read domain reset
        .rpop   (BREADY_S3), //Data pop enable

        .rdata  ({Slave_BID_S3, Slave_BRESP_S3}), //Read data
        .rempty (B_S3_rempty)  //FIFO empty
    );

    sctrl_wrapper sctrl_wrapper (
        .clk             (cpu_clk),
        .rst             (cpu_rst),

        //WRITE ADDRESS
        .AWID            (AWID_S3),  
        .AWADDR          (AWADDR_S3), 
        .AWLEN           (AWLEN_S3),  
        .AWSIZE          (AWSIZE_S3), 
        .AWBURST         (AWBURST_S3),
        .AWVALID         (~AW_S3_rempty),

        .AWREADY         (AWREADY_S3),

        //WRITE DATA
        .WDATA           (WDATA_S3), 
        .WSTRB           (WSTRB_S3), 
        .WLAST           (WLAST_S3),
        .WVALID          (~W_S3_rempty),

        .WREADY          (WREADY_S3),

        //WRITE RESPONSE
        .BID             (BID_S3), 
        .BRESP           (BRESP_S3),
        .BVALID          (BVALID_S3),

        .BREADY          (~B_S3_wfull),

        //READ ADDRESS
        .ARID            (ARID_S3),  
        .ARADDR          (ARADDR_S3), 
        .ARLEN           (ARLEN_S3),  
        .ARSIZE          (ARSIZE_S3), 
        .ARBURST         (ARBURST_S3),
        .ARVALID         (~AR_S3_rempty),

        .ARREADY         (ARREADY_S3),

        //READ DATA
        .RID             (RID_S3),   
        .RDATA           (RDATA_S3), 
        .RRESP           (RRESP_S3),
        .RLAST           (RLAST_S3),
        .RVALID          (RVALID_S3),

        .RREADY          (~R_S3_wfull),

        //sensor control
        // core output
        .sctrl_interrupt (sensor_interrupt),
        // output from sensor(off chip)
        .sensor_ready    (sensor_ready),
        .sensor_out      (sensor_out),
        // input to sensor(off chip)
        .sensor_en       (sensor_en)
    );

    //for CDC
    //AR
    AR_FIFO_AXI_to_Slave AR_FIFO_AXI_to_Slave_S4 (
        //Write
        .wclk   (axi_clk), //Write domain clock
        .wrst   (axi_rst), //Write domain reset
        .wpush  (ARVALID_S4), //Data push enable
        .wdata  ({Slave_ARID_S4, Slave_ARADDR_S4, Slave_ARLEN_S4, Slave_ARSIZE_S4, Slave_ARBURST_S4}), //Write data

        .wfull  (AR_S4_wfull), //FIFO full

        //read
        .rclk   (cpu_clk), //Read domain clock
        .rrst   (cpu_rst), //Read domain reset
        .rpop   (ARREADY_S4), //Data pop enable

        .rdata  ({ARID_S4, ARADDR_S4, ARLEN_S4, ARSIZE_S4, ARBURST_S4}), //Read data
        .rempty (AR_S4_rempty)  //FIFO empty
    );
    //R
    R_FIFO_Slave_to_AXI R_FIFO_Slave_to_AXI_S4 (
        //Write
        .wclk   (cpu_clk), //Write domain clock
        .wrst   (cpu_rst), //Write domain reset
        .wpush  (RVALID_S4), //Data push enable
        .wdata  ({RID_S4, RDATA_S4, RRESP_S4, RLAST_S4}), //Write data

        .wfull  (R_S4_wfull), //FIFO full

        //read
        .rclk   (axi_clk), //Read domain clock
        .rrst   (axi_rst), //Read domain reset
        .rpop   (RREADY_S4), //Data pop enable

        .rdata  ({Slave_RID_S4, Slave_RDATA_S4, Slave_RRESP_S4, Slave_RLAST_S4}), //Read data
        .rempty (R_S4_rempty)  //FIFO empty
    );
    //AW
    AW_FIFO_AXI_to_Slave AW_FIFO_AXI_to_Slave_S4 (
        //Write
        .wclk   (axi_clk), //Write domain clock
        .wrst   (axi_rst), //Write domain reset
        .wpush  (AWVALID_S4), //Data push enable
        .wdata  ({Slave_AWID_S4, Slave_AWADDR_S4, Slave_AWLEN_S4, Slave_AWSIZE_S4, Slave_AWBURST_S4}), //Write data

        .wfull  (AW_S4_wfull), //FIFO full

        //read
        .rclk   (cpu_clk), //Read domain clock
        .rrst   (cpu_rst), //Read domain reset
        .rpop   (AWREADY_S4), //Data pop enable

        .rdata  ({AWID_S4, AWADDR_S4, AWLEN_S4, AWSIZE_S4, AWBURST_S4}), //Read data
        .rempty (AW_S4_rempty)  //FIFO empty
    );
    //W
    W_FIFO_AXI_to_Slave W_FIFO_AXI_to_Slave_S4 (
        //Write
        .wclk   (axi_clk), //Write domain clock
        .wrst   (axi_rst), //Write domain reset
        .wpush  (WVALID_S4), //Data push enable
        .wdata  ({Slave_WDATA_S4, Slave_WSTRB_S4, Slave_WLAST_S4}), //Write data

        .wfull  (W_S4_wfull), //FIFO full

        //read
        .rclk   (cpu_clk), //Read domain clock
        .rrst   (cpu_rst), //Read domain reset
        .rpop   (WREADY_S4), //Data pop enable

        .rdata  ({WDATA_S4, WSTRB_S4, WLAST_S4}), //Read data
        .rempty (W_S4_rempty)  //FIFO empty
    );
    //B
    B_FIFO_Slave_to_AXI B_FIFO_Slave_to_AXI_S4 (
        //Write
        .wclk   (cpu_clk), //Write domain clock
        .wrst   (cpu_rst), //Write domain reset
        .wpush  (BVALID_S4), //Data push enable
        .wdata  ({BID_S4, BRESP_S4}), //Write data

        .wfull  (B_S4_wfull), //FIFO full

        //read
        .rclk   (axi_clk), //Read domain clock
        .rrst   (axi_rst), //Read domain reset
        .rpop   (BREADY_S4), //Data pop enable

        .rdata  ({Slave_BID_S4, Slave_BRESP_S4}), //Read data
        .rempty (B_S4_rempty)  //FIFO empty
    );

    WDT_wrapper WDT_wrapper (
        .clk            (cpu_clk),
        .clk2           (cpu_clk),
        .rst            (cpu_rst),
        .rst2           (cpu_rst),

        //WRITE ADDRESS
        .AWID           (AWID_S4),  
        .AWADDR         (AWADDR_S4), 
        .AWLEN          (AWLEN_S4),  
        .AWSIZE         (AWSIZE_S4), 
        .AWBURST        (AWBURST_S4),
        .AWVALID        (~AW_S4_rempty),

        .AWREADY        (AWREADY_S4),

        //WRITE DATA
        .WDATA          (WDATA_S4), 
        .WSTRB          (WSTRB_S4), 
        .WLAST          (WLAST_S4),
        .WVALID         (~W_S4_rempty),

        .WREADY         (WREADY_S4),

        //WRITE RESPONSE
        .BID             (BID_S4), 
        .BRESP           (BRESP_S4),
        .BVALID          (BVALID_S4),

        .BREADY          (~B_S4_wfull),

        //READ ADDRESS
        .ARID            (ARID_S4),  
        .ARADDR          (ARADDR_S4), 
        .ARLEN           (ARLEN_S4),  
        .ARSIZE          (ARSIZE_S4), 
        .ARBURST         (ARBURST_S4),
        .ARVALID         (~AR_S4_rempty),

        .ARREADY         (ARREADY_S4),

        //READ DATA
        .RID             (RID_S4),   
        .RDATA           (RDATA_S4), 
        .RRESP           (RRESP_S4),
        .RLAST           (RLAST_S4),
        .RVALID          (RVALID_S4),

        .RREADY          (~R_S4_wfull),

        //WDT
        .WTO             (WDT_interrupt)
    );

    //for CDC
    //AR
    AR_FIFO_AXI_to_Slave AR_FIFO_AXI_to_Slave_S5 (
        //Write
        .wclk   (axi_clk), //Write domain clock
        .wrst   (axi_rst), //Write domain reset
        .wpush  (ARVALID_S5), //Data push enable
        .wdata  ({Slave_ARID_S5, Slave_ARADDR_S5, Slave_ARLEN_S5, Slave_ARSIZE_S5, Slave_ARBURST_S5}), //Write data

        .wfull  (AR_S5_wfull), //FIFO full

        //read
        .rclk   (dram_clk), //Read domain clock
        .rrst   (dram_rst), //Read domain reset
        .rpop   (ARREADY_S5), //Data pop enable

        .rdata  ({ARID_S5, ARADDR_S5, ARLEN_S5, ARSIZE_S5, ARBURST_S5}), //Read data
        .rempty (AR_S5_rempty)  //FIFO empty
    );
    //R
    R_FIFO_Slave_to_AXI R_FIFO_Slave_to_AXI_S5 (
        //Write
        .wclk   (dram_clk), //Write domain clock
        .wrst   (dram_rst), //Write domain reset
        .wpush  (RVALID_S5), //Data push enable
        .wdata  ({RID_S5, RDATA_S5, RRESP_S5, RLAST_S5}), //Write data

        .wfull  (R_S5_wfull), //FIFO full

        //read
        .rclk   (axi_clk), //Read domain clock
        .rrst   (axi_rst), //Read domain reset
        .rpop   (RREADY_S5), //Data pop enable

        .rdata  ({Slave_RID_S5, Slave_RDATA_S5, Slave_RRESP_S5, Slave_RLAST_S5}), //Read data
        .rempty (R_S5_rempty)  //FIFO empty
    );
    //AW
    AW_FIFO_AXI_to_Slave AW_FIFO_AXI_to_Slave_S5 (
        //Write
        .wclk   (axi_clk), //Write domain clock
        .wrst   (axi_rst), //Write domain reset
        .wpush  (AWVALID_S5), //Data push enable
        .wdata  ({Slave_AWID_S5, Slave_AWADDR_S5, Slave_AWLEN_S5, Slave_AWSIZE_S5, Slave_AWBURST_S5}), //Write data

        .wfull  (AW_S5_wfull), //FIFO full

        //read
        .rclk   (dram_clk), //Read domain clock
        .rrst   (dram_rst), //Read domain reset
        .rpop   (AWREADY_S5), //Data pop enable

        .rdata  ({AWID_S5, AWADDR_S5, AWLEN_S5, AWSIZE_S5, AWBURST_S5}), //Read data
        .rempty (AW_S5_rempty)  //FIFO empty
    );
    //W
    W_FIFO_AXI_to_Slave W_FIFO_AXI_to_Slave_S5 (
        //Write
        .wclk   (axi_clk), //Write domain clock
        .wrst   (axi_rst), //Write domain reset
        .wpush  (WVALID_S5), //Data push enable
        .wdata  ({Slave_WDATA_S5, Slave_WSTRB_S5, Slave_WLAST_S5}), //Write data

        .wfull  (W_S5_wfull), //FIFO full

        //read
        .rclk   (dram_clk), //Read domain clock
        .rrst   (dram_rst), //Read domain reset
        .rpop   (WREADY_S5), //Data pop enable

        .rdata  ({WDATA_S5, WSTRB_S5, WLAST_S5}), //Read data
        .rempty (W_S5_rempty)  //FIFO empty
    );
    //B
    B_FIFO_Slave_to_AXI B_FIFO_Slave_to_AXI_S5 (
        //Write
        .wclk   (dram_clk), //Write domain clock
        .wrst   (dram_rst), //Write domain reset
        .wpush  (BVALID_S5), //Data push enable
        .wdata  ({BID_S5, BRESP_S5}), //Write data

        .wfull  (B_S5_wfull), //FIFO full

        //read
        .rclk   (axi_clk), //Read domain clock
        .rrst   (axi_rst), //Read domain reset
        .rpop   (BREADY_S5), //Data pop enable

        .rdata  ({Slave_BID_S5, Slave_BRESP_S5}), //Read data
        .rempty (B_S5_rempty)  //FIFO empty
    );

    DRAM_wrapper DRAM (
        .ACLK        (dram_clk),
        .ARESETn     (!dram_rst),

        //WRITE ADDRESS
        .AWID        (AWID_S5),  
        .AWADDR      (AWADDR_S5), 
        .AWLEN       (AWLEN_S5),  
        .AWSIZE      (AWSIZE_S5), 
        .AWBURST     (AWBURST_S5),
        .AWVALID     (~AW_S5_rempty),

        .AWREADY     (AWREADY_S5),

        //WRITE DATA
        .WDATA       (WDATA_S5), 
        .WSTRB       (WSTRB_S5), 
        .WLAST       (WLAST_S5),
        .WVALID      (~W_S5_rempty),

        .WREADY      (WREADY_S5),

        //WRITE RESPONSE
        .BID         (BID_S5), 
        .BRESP       (BRESP_S5),
        .BVALID      (BVALID_S5),

        .BREADY      (~B_S5_wfull),

        //READ ADDRESS
        .ARID        (ARID_S5),  
        .ARADDR      (ARADDR_S5), 
        .ARLEN       (ARLEN_S5),  
        .ARSIZE      (ARSIZE_S5), 
        .ARBURST     (ARBURST_S5),
        .ARVALID     (~AR_S5_rempty),

        .ARREADY     (ARREADY_S5),

        //READ DATA
        .RID         (RID_S5),   
        .RDATA       (RDATA_S5), 
        .RRESP       (RRESP_S5),
        .RLAST       (RLAST_S5),
        .RVALID      (RVALID_S5),

        .RREADY      (~R_S5_wfull),

        //DRAM
        .DRAM_CSn    (DRAM_CSn),
        .DRAM_WEn    (DRAM_WEn),
        .DRAM_RASn   (DRAM_RASn),
        .DRAM_CASn   (DRAM_CASn),
        .DRAM_A      (DRAM_A),
        .DRAM_D      (DRAM_D),

        .DRAM_Q      (DRAM_Q),
        .DRAM_VALID  (DRAM_valid)
    );
endmodule