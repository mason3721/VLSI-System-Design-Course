`include "CPU_wrapper.sv"
`include "SRAM_wrapper.sv"
`include "ROM_wrapper.sv"
`include "DRAM_wrapper.sv"
`include "sensor_ctrl_wrapper.sv"
`include "WDT_wrapper.sv"
`include "PWM_wrapper.sv"
`include "AXI.sv"
`include "AXI_define.svh"
`include "data_array_wrapper.sv"
`include "tag_array_wrapper.sv"
module top(
  input  logic           cpu_clk,
  input  logic           axi_clk,
  input  logic           rom_clk,
  input  logic           dram_clk,
  input  logic           sram_clk,
  input  logic           pwm_clk,
  input  logic           cpu_rst,
  input  logic           axi_rst,
  input  logic           rom_rst,
  input  logic           dram_rst,
  input  logic           sram_rst,
  input  logic           pwm_rst,
  input  logic           sensor_ready,
  input  logic [    31:0] sensor_out_0,
  input  logic [    31:0] sensor_out_1,
  input  logic [    31:0] sensor_out_2,
    input logic [31:0] sensor_out_3,
  input logic [31:0] sensor_out_4,
  input logic [31:0] sensor_out_5,
  input logic [31:0] sensor_out_6,
  input logic [31:0] sensor_out_7,
  output logic           sensor_en,
  input  logic [   31:0] ROM_out,
  input  logic [   31:0] DRAM_Q,
  output logic           ROM_read,
  output logic           ROM_enable,
  output logic [   11:0] ROM_address,
  output logic           DRAM_CSn,
  output logic [    3:0] DRAM_WEn,
  output logic           DRAM_RASn,
  output logic           DRAM_CASn,
  output logic [   10:0] DRAM_A,
  output logic [   31:0] DRAM_D,
  input  logic           DRAM_valid,
  output logic 			 pwm_o_0,
  output logic 			 pwm_o_1,
  output logic 			 pwm_o_2,
  output logic 			 pwm_o_3
);


 // user defined AXI parameters
    localparam DATA_WIDTH              = 32;
    localparam ADDR_WIDTH              = 32;
    localparam ID_WIDTH                = 4;
    localparam IDS_WIDTH               = 8;
    localparam LEN_WIDTH               = 4;
    localparam MAXLEN                  = 4;
    // fixed AXI parameters
    localparam STRB_WIDTH              = DATA_WIDTH/8;
    localparam SIZE_WIDTH              = 3;
    localparam BURST_WIDTH             = 2;  
    localparam CACHE_WIDTH             = 4;  
    localparam PROT_WIDTH              = 3;  
    localparam BRESP_WIDTH             = 2; 
    localparam RRESP_WIDTH             = 2;      
    localparam AWUSER_WIDTH            = 32; // Size of AWUser field
    localparam WUSER_WIDTH             = 32; // Size of WUser field
    localparam BUSER_WIDTH             = 32; // Size of BUser field
    localparam ARUSER_WIDTH            = 32; // Size of ARUser field
    localparam RUSER_WIDTH             = 32; // Size of RUser field
    localparam QOS_WIDTH               = 4;  // Size of QOS field
    localparam REGION_WIDTH            = 4;  // Size of Region field
	
	logic reset;
	logic sctrl_interrupt;
	logic WTO;
  	assign axi_reset=~axi_rst;
	assign cpu_reset=~cpu_rst;  	
	assign rom_reset=~rom_rst;
	assign dram_reset=~dram_rst;
	assign sram_reset=~sram_rst;
	assign pwm_reset=~pwm_rst;
// ----------slave 0---------- //
    // Write address channel signals
    /*logic    [IDS_WIDTH-1:0]     awid_s0;      // Write address ID tag
    logic    [ADDR_WIDTH-1:0]    awaddr_s0;    // Write address
    logic    [LEN_WIDTH-1:0]     awlen_s0;     // Write address burst length
    logic    [SIZE_WIDTH-1:0]    awsize_s0;    // Write address burst size
    logic    [BURST_WIDTH-1:0]   awburst_s0;   // Write address burst type


    // Write data channel signals
    logic    [DATA_WIDTH-1:0]    wdata_s0;     // Write data
    logic    [DATA_WIDTH/8-1:0]  wstrb_s0;     // Write strobe
    logic                        wlast_s0;     // Write last
    logic                        wvalid_s0;    // Write valid
    logic                        wready_s0;    // Write ready


    // Write response channel signals
    logic    [IDS_WIDTH-1:0]     bid_s0;       // Write response ID tag
    logic    [BRESP_WIDTH-1:0]   bresp_s0;     // Write response
    logic                        bvalid_s0;    // Write response valid
    logic                        bready_s0;    // Write response ready*/
    
    // Read address channel signals
    logic    [IDS_WIDTH-1:0]     arid_s0;      // Read address ID tag
    logic    [ADDR_WIDTH-1:0]    araddr_s0;    // Read address
    logic    [LEN_WIDTH-1:0]     arlen_s0;     // Read address burst length
    logic    [SIZE_WIDTH-1:0]    arsize_s0;    // Read address burst size
    logic    [BURST_WIDTH-1:0]   arburst_s0;   // Read address burst type
    logic                        arvalid_s0;   // Read address valid
    logic                        arready_s0;   // Read address ready

    // Read data channel signals
    logic    [IDS_WIDTH-1:0]     rid_s0;       // Read ID tag
    logic    [DATA_WIDTH-1:0]    rdata_s0;     // Read data
    logic                        rlast_s0;     // Read last
    logic                        rvalid_s0;    // Read valid
    logic                        rready_s0;    // Read ready
    logic    [RRESP_WIDTH-1:0]   rresp_s0;     // Read response
	
	// ----------slave1---------- //
    // Write address channel signals
    logic    [IDS_WIDTH-1:0]     awid_s1;      // Write address ID tag
    logic    [ADDR_WIDTH-1:0]    awaddr_s1;    // Write address
    logic    [LEN_WIDTH-1:0]     awlen_s1;     // Write address burst length
    logic    [SIZE_WIDTH-1:0]    awsize_s1;    // Write address burst size
    logic    [BURST_WIDTH-1:0]   awburst_s1;   // Write address burst type
    logic                        awvalid_s1;   // Write address valid
    logic                        awready_s1;   // Write address ready

    // Write data channel signals
    logic    [DATA_WIDTH-1:0]    wdata_s1;     // Write data
    logic    [DATA_WIDTH/8-1:0]  wstrb_s1;     // Write strobe
    logic                        wlast_s1;     // Write last
    logic                        wvalid_s1;    // Write valid
    logic                        wready_s1;    // Write ready

    // Write response channel signals
    logic    [IDS_WIDTH-1:0]     bid_s1;       // Write response ID tag
    logic    [BRESP_WIDTH-1:0]   bresp_s1;     // Write response
    logic                        bvalid_s1;    // Write response valid
    logic                        bready_s1;    // Write response ready

    // Read address channel signals
    logic    [IDS_WIDTH-1:0]     arid_s1;      // Read address ID tag
    logic    [ADDR_WIDTH-1:0]    araddr_s1;    // Read address
    logic    [LEN_WIDTH-1:0]     arlen_s1;     // Read address burst length
    logic    [SIZE_WIDTH-1:0]    arsize_s1;    // Read address burst size
    logic    [BURST_WIDTH-1:0]   arburst_s1;   // Read address burst type
    logic                        arvalid_s1;   // Read address valid
    logic                        arready_s1;   // Read address ready

    // Read data channel signals
    logic    [IDS_WIDTH-1:0]     rid_s1;       // Read ID tag
    logic    [DATA_WIDTH-1:0]    rdata_s1;     // Read data
    logic                        rlast_s1;     // Read last
    logic                        rvalid_s1;    // Read valid
    logic                        rready_s1;    // Read ready
    logic    [RRESP_WIDTH-1:0]   rresp_s1;     // Read response
	
	// ----------slave2---------- //
    // Write address channel signals
    logic    [IDS_WIDTH-1:0]     awid_s2;      // Write address ID tag
    logic    [ADDR_WIDTH-1:0]    awaddr_s2;    // Write address
    logic    [LEN_WIDTH-1:0]     awlen_s2;     // Write address burst length
    logic    [SIZE_WIDTH-1:0]    awsize_s2;    // Write address burst size
    logic    [BURST_WIDTH-1:0]   awburst_s2;   // Write address burst type
    logic                        awvalid_s2;   // Write address valid
    logic                        awready_s2;   // Write address ready

    // Write data channel signals
    logic    [DATA_WIDTH-1:0]    wdata_s2;     // Write data
    logic    [DATA_WIDTH/8-1:0]  wstrb_s2;     // Write strobe
    logic                        wlast_s2;     // Write last
    logic                        wvalid_s2;    // Write valid
    logic                        wready_s2;    // Write ready

    // Write response channel signals
    logic    [IDS_WIDTH-1:0]     bid_s2;       // Write response ID tag
    logic    [BRESP_WIDTH-1:0]   bresp_s2;     // Write response
    logic                        bvalid_s2;    // Write response valid
    logic                        bready_s2;    // Write response ready

    // Read address channel signals
    logic    [IDS_WIDTH-1:0]     arid_s2;      // Read address ID tag
    logic    [ADDR_WIDTH-1:0]    araddr_s2;    // Read address
    logic    [LEN_WIDTH-1:0]     arlen_s2;     // Read address burst length
    logic    [SIZE_WIDTH-1:0]    arsize_s2;    // Read address burst size
    logic    [BURST_WIDTH-1:0]   arburst_s2;   // Read address burst type
    logic                        arvalid_s2;   // Read address valid
    logic                        arready_s2;   // Read address ready

    // Read data channel signals
    logic    [IDS_WIDTH-1:0]     rid_s2;       // Read ID tag
    logic    [DATA_WIDTH-1:0]    rdata_s2;     // Read data
    logic                        rlast_s2;     // Read last
    logic                        rvalid_s2;    // Read valid
    logic                        rready_s2;    // Read ready
    logic    [RRESP_WIDTH-1:0]   rresp_s2;     // Read response
	// ----------slave3---------- //
    // Write address channel signals
    logic    [IDS_WIDTH-1:0]     awid_s3;      // Write address ID tag
    logic    [ADDR_WIDTH-1:0]    awaddr_s3;    // Write address
    logic    [LEN_WIDTH-1:0]     awlen_s3;     // Write address burst length
    logic    [SIZE_WIDTH-1:0]    awsize_s3;    // Write address burst size
    logic    [BURST_WIDTH-1:0]   awburst_s3;   // Write address burst type
    logic                        awvalid_s3;   // Write address valid
    logic                        awready_s3;   // Write address ready

    // Write data channel signals
    logic    [DATA_WIDTH-1:0]    wdata_s3;     // Write data
    logic    [DATA_WIDTH/8-1:0]  wstrb_s3;     // Write strobe
    logic                        wlast_s3;     // Write last
    logic                        wvalid_s3;    // Write valid
    logic                        wready_s3;    // Write ready

    // Write response channel signals
    logic    [IDS_WIDTH-1:0]     bid_s3;       // Write response ID tag
    logic    [BRESP_WIDTH-1:0]   bresp_s3;     // Write response
    logic                        bvalid_s3;    // Write response valid
    logic                        bready_s3;    // Write response ready

    // Read address channel signals
    logic    [IDS_WIDTH-1:0]     arid_s3;      // Read address ID tag
    logic    [ADDR_WIDTH-1:0]    araddr_s3;    // Read address
    logic    [LEN_WIDTH-1:0]     arlen_s3;     // Read address burst length
    logic    [SIZE_WIDTH-1:0]    arsize_s3;    // Read address burst size
    logic    [BURST_WIDTH-1:0]   arburst_s3;   // Read address burst type
    logic                        arvalid_s3;   // Read address valid
    logic                        arready_s3;   // Read address ready

    // Read data channel signals
    logic    [IDS_WIDTH-1:0]     rid_s3;       // Read ID tag
    logic    [DATA_WIDTH-1:0]    rdata_s3;     // Read data
    logic                        rlast_s3;     // Read last
    logic                        rvalid_s3;    // Read valid
    logic                        rready_s3;    // Read ready
    logic    [RRESP_WIDTH-1:0]   rresp_s3;     // Read response
	// ----------slave4---------- //
    // Write address channel signals
    logic    [IDS_WIDTH-1:0]     awid_s4;      // Write address ID tag
    logic    [ADDR_WIDTH-1:0]    awaddr_s4;    // Write address
    logic    [LEN_WIDTH-1:0]     awlen_s4;     // Write address burst length
    logic    [SIZE_WIDTH-1:0]    awsize_s4;    // Write address burst size
    logic    [BURST_WIDTH-1:0]   awburst_s4;   // Write address burst type
    logic                        awvalid_s4;   // Write address valid
    logic                        awready_s4;   // Write address ready

    // Write data channel signals
    logic    [DATA_WIDTH-1:0]    wdata_s4;     // Write data
    logic    [DATA_WIDTH/8-1:0]  wstrb_s4;     // Write strobe
    logic                        wlast_s4;     // Write last
    logic                        wvalid_s4;    // Write valid
    logic                        wready_s4;    // Write ready

    // Write response channel signals
    logic    [IDS_WIDTH-1:0]     bid_s4;       // Write response ID tag
    logic    [BRESP_WIDTH-1:0]   bresp_s4;     // Write response
    logic                        bvalid_s4;    // Write response valid
    logic                        bready_s4;    // Write response ready
	
	// ----------slave5---------- //
    // Write address channel signals
    logic    [IDS_WIDTH-1:0]     awid_s5;      // Write address ID tag
    logic    [ADDR_WIDTH-1:0]    awaddr_s5;    // Write address
    logic    [LEN_WIDTH-1:0]     awlen_s5;     // Write address burst length
    logic    [SIZE_WIDTH-1:0]    awsize_s5;    // Write address burst size
    logic    [BURST_WIDTH-1:0]   awburst_s5;   // Write address burst type
    logic                        awvalid_s5;   // Write address valid
    logic                        awready_s5;   // Write address ready

    // Write data channel signals
    logic    [DATA_WIDTH-1:0]    wdata_s5;     // Write data
    logic    [DATA_WIDTH/8-1:0]  wstrb_s5;     // Write strobe
    logic                        wlast_s5;     // Write last
    logic                        wvalid_s5;    // Write valid
    logic                        wready_s5;    // Write ready

    // Write response channel signals
    logic    [IDS_WIDTH-1:0]     bid_s5;       // Write response ID tag
    logic    [BRESP_WIDTH-1:0]   bresp_s5;     // Write response
    logic                        bvalid_s5;    // Write response valid
    logic                        bready_s5;    // Write response ready

    // Read address channel signals
    logic    [IDS_WIDTH-1:0]     arid_s5;      // Read address ID tag
    logic    [ADDR_WIDTH-1:0]    araddr_s5;    // Read address
    logic    [LEN_WIDTH-1:0]     arlen_s5;     // Read address burst length
    logic    [SIZE_WIDTH-1:0]    arsize_s5;    // Read address burst size
    logic    [BURST_WIDTH-1:0]   arburst_s5;   // Read address burst type
    logic                        arvalid_s5;   // Read address valid
    logic                        arready_s5;   // Read address ready

    // Read data channel signals
    logic    [IDS_WIDTH-1:0]     rid_s5;       // Read ID tag
    logic    [DATA_WIDTH-1:0]    rdata_s5;     // Read data
    logic                        rlast_s5;     // Read last
    logic                        rvalid_s5;    // Read valid
    logic                        rready_s5;    // Read ready
    logic    [RRESP_WIDTH-1:0]   rresp_s5;     // Read response
	
	// ----------slave6---------- //
    // Write address channel signals
    logic    [IDS_WIDTH-1:0]     awid_s6;      // Write address ID tag
    logic    [ADDR_WIDTH-1:0]    awaddr_s6;    // Write address
    logic    [LEN_WIDTH-1:0]     awlen_s6;     // Write address burst length
    logic    [SIZE_WIDTH-1:0]    awsize_s6;    // Write address burst size
    logic    [BURST_WIDTH-1:0]   awburst_s6;   // Write address burst type
    logic                        awvalid_s6;   // Write address valid
    logic                        awready_s6;   // Write address ready

    // Write data channel signals
    logic    [DATA_WIDTH-1:0]    wdata_s6;     // Write data
    logic    [DATA_WIDTH/8-1:0]  wstrb_s6;     // Write strobe
    logic                        wlast_s6;     // Write last
    logic                        wvalid_s6;    // Write valid
    logic                        wready_s6;    // Write ready

    // Write response channel signals
    logic    [IDS_WIDTH-1:0]     bid_s6;       // Write response ID tag
    logic    [BRESP_WIDTH-1:0]   bresp_s6;     // Write response
    logic                        bvalid_s6;    // Write response valid
    logic                        bready_s6;    // Write response ready
	
	// ----------master0---------- //
    // Read address channel signals
    logic    [ID_WIDTH-1:0]      arid_m0;      // Read address ID tag
    logic    [ADDR_WIDTH-1:0]    araddr_m0;    // Read address
    logic    [LEN_WIDTH-1:0]     arlen_m0;     // Read address burst length
    logic    [SIZE_WIDTH-1:0]    arsize_m0;    // Read address burst size
    logic    [BURST_WIDTH-1:0]   arburst_m0;   // Read address burst type
    logic                        arvalid_m0;   // Read address valid
    logic                        arready_m0;   // Read address ready

    // Read data channel signals
    logic    [ID_WIDTH-1:0]      rid_m0;       // Read ID tag
    logic    [DATA_WIDTH-1:0]    rdata_m0;     // Read data
    logic                        rlast_m0;     // Read last
    logic                        rvalid_m0;    // Read valid
    logic                        rready_m0;    // Read ready
    logic    [RRESP_WIDTH-1:0]   rresp_m0;     // Read response


    // ----------master1---------- //
    // Write address channel signals
    logic    [ID_WIDTH-1:0]      awid_m1;      // Write address ID tag
    logic    [ADDR_WIDTH-1:0]    awaddr_m1;    // Write address
    logic    [LEN_WIDTH-1:0]     awlen_m1;     // Write address burst length
    logic    [SIZE_WIDTH-1:0]    awsize_m1;    // Write address burst size
    logic    [BURST_WIDTH-1:0]   awburst_m1;   // Write address burst type
    logic                        awvalid_m1;   // Write address valid
    logic                        awready_m1;   // Write address ready


    // Write data channel signals
    logic    [DATA_WIDTH-1:0]    wdata_m1;     // Write data
    logic    [DATA_WIDTH/8-1:0]  wstrb_m1;     // Write strobe
    logic                        wlast_m1;     // Write last
    logic                        wvalid_m1;    // Write valid
    logic                        wready_m1;    // Write ready

    // Write response channel signals
    logic    [ID_WIDTH-1:0]      bid_m1;       // Write response ID tag
    logic    [BRESP_WIDTH-1:0]   bresp_m1;     // Write response
    logic                        bvalid_m1;    // Write response valid
    logic                        bready_m1;    // Write response ready

    // Read address channel signals
    logic    [ID_WIDTH-1:0]      arid_m1;      // Read address ID tag
    logic    [ADDR_WIDTH-1:0]    araddr_m1;    // Read address
    logic    [LEN_WIDTH-1:0]     arlen_m1;     // Read address burst length
    logic    [SIZE_WIDTH-1:0]    arsize_m1;    // Read address burst size
    logic    [BURST_WIDTH-1:0]   arburst_m1;   // Read address burst type
    logic                        arvalid_m1;   // Read address valid
    logic                        arready_m1;   // Read address ready


    // Read data channel signals
    logic    [ID_WIDTH-1:0]      rid_m1;       // Read ID tag
    logic    [DATA_WIDTH-1:0]    rdata_m1;     // Read data
    logic                        rlast_m1;     // Read last
    logic                        rvalid_m1;    // Read valid
    logic                        rready_m1;    // Read ready
    logic    [RRESP_WIDTH-1:0]   rresp_m1;     // Read response

 // Instance of the AXI bridge DUV
    AXI axi_duv_bridge(
	 .CPU_CLK_i    (cpu_clk   ),
	 .ROM_CLK_i   (rom_clk   ),
	 .DRAM_CLK_i   (dram_clk  ),
	 .SRAM_CLK_i   (sram_clk  ),
	 .PWM_CLK_i   (pwm_clk  ),
	 .CPU_RST_i    (cpu_reset ),
	 .ROM_RST_i    (rom_reset ),
	 .DRAM_RST_i   (dram_reset),
	 .SRAM_RST_i   (sram_reset),
	 .PWM_RST_i   (pwm_reset),
	 .ACLK         (axi_clk   ),//slave1 interface write channel
	 .ARESETn      (axi_reset ),
	 .AWID_M1_F    (awid_m1   ),
	 .AWADDR_M1_F  (awaddr_m1 ),
	 .AWLEN_M1_F   (awlen_m1  ),
	 .AWSIZE_M1_F  (awsize_m1 ),
	 .AWBURST_M1_F (awburst_m1),
	 .AWVALID_M1_F (awvalid_m1),
	 .AWREADY_M1_F (awready_m1),
	 .WDATA_M1_F   (wdata_m1  ),
	 .WSTRB_M1_F   (wstrb_m1  ),
	 .WLAST_M1_F   (wlast_m1  ),
	 .WVALID_M1_F  (wvalid_m1 ),
	 .WREADY_M1_F  (wready_m1 ),
	 .BID_M1_F     (bid_m1    ),
	 .BRESP_M1_F   (bresp_m1  ),
	 .BVALID_M1_F  (bvalid_m1 ),
	 .BREADY_M1_F  (bready_m1 ),
	 .ARID_M0_F    (arid_m0   ),//slave0 interface read channel
	 .ARADDR_M0_F  (araddr_m0 ),
	 .ARLEN_M0_F   (arlen_m0  ),
	 .ARSIZE_M0_F  (arsize_m0 ),
	 .ARBURST_M0_F (arburst_m0),
	 .ARVALID_M0_F (arvalid_m0),
	 .ARREADY_M0_F (arready_m0),
	 .RID_M0_F     (rid_m0    ),
	 .RDATA_M0_F   (rdata_m0  ),
	 .RRESP_M0_F   (rresp_m0  ),
	 .RLAST_M0_F   (rlast_m0  ),
	 .RVALID_M0_F  (rvalid_m0 ),
	 .RREADY_M0_F  (rready_m0 ),
	 .ARID_M1_F    (arid_m1   ),//slave1 interface read channel
	 .ARADDR_M1_F  (araddr_m1 ),
	 .ARLEN_M1_F   (arlen_m1  ),
	 .ARSIZE_M1_F  (arsize_m1 ),
	 .ARBURST_M1_F (arburst_m1),
	 .ARVALID_M1_F (arvalid_m1),
	 .ARREADY_M1_F (arready_m1),
	 .RID_M1_F     (rid_m1    ),
	 .RDATA_M1_F   (rdata_m1  ),
	 .RRESP_M1_F   (rresp_m1  ),
	 .RLAST_M1_F   (rlast_m1  ),
	 .RVALID_M1_F  (rvalid_m1 ),
	 .RREADY_M1_F  (rready_m1 ),
	 .ARID_S0_F    (arid_s0   ),//master0 interface read channel,ROM
	 .ARADDR_S0_F  (araddr_s0 ),
	 .ARLEN_S0_F   (arlen_s0  ),
	 .ARSIZE_S0_F  (arsize_s0 ),
	 .ARBURST_S0_F (arburst_s0),
	 .ARVALID_S0_F (arvalid_s0),
	 .ARREADY_S0_F (arready_s0),
	 .RID_S0_F     (rid_s0    ),
	 .RDATA_S0_F   (rdata_s0  ),
	 .RRESP_S0_F   (rresp_s0  ),
	 .RLAST_S0_F   (rlast_s0  ),
	 .RVALID_S0_F  (rvalid_s0 ),
	 .RREADY_S0_F  (rready_s0 ),
	 
	 .AWID_S1_F    (awid_s1   ),//master1 interface write channel,IM
	 .AWADDR_S1_F  (awaddr_s1 ),
	 .AWLEN_S1_F   (awlen_s1  ),
	 .AWSIZE_S1_F  (awsize_s1 ),
	 .AWBURST_S1_F (awburst_s1),
	 .AWVALID_S1_F (awvalid_s1),
	 .AWREADY_S1_F (awready_s1),
	 .WDATA_S1_F   (wdata_s1  ),
	 .WSTRB_S1_F   (wstrb_s1  ),
	 .WLAST_S1_F   (wlast_s1  ),
	 .WVALID_S1_F  (wvalid_s1 ),
	 .WREADY_S1_F  (wready_s1 ),
	 .BID_S1_F     (bid_s1    ),
	 .BRESP_S1_F   (bresp_s1  ),
	 .BVALID_S1_F  (bvalid_s1 ),
	 .BREADY_S1_F  (bready_s1 ),
	 
	 .ARID_S1_F    (arid_s1   ),//master1 interface read channel,IM
	 .ARADDR_S1_F  (araddr_s1 ),
	 .ARLEN_S1_F   (arlen_s1  ),
	 .ARSIZE_S1_F  (arsize_s1 ),
	 .ARBURST_S1_F (arburst_s1),
	 .ARVALID_S1_F (arvalid_s1),
	 .ARREADY_S1_F (arready_s1),
	 .RID_S1_F     (rid_s1    ),
	 .RDATA_S1_F   (rdata_s1  ),
	 .RRESP_S1_F   (rresp_s1  ),
	 .RLAST_S1_F   (rlast_s1  ),
	 .RVALID_S1_F  (rvalid_s1 ),
	 .RREADY_S1_F  (rready_s1 ),
	 
	 .AWID_S2_F    (awid_s2   ),//master2 interface write channel,DM
	 .AWADDR_S2_F  (awaddr_s2 ),
	 .AWLEN_S2_F   (awlen_s2  ),
	 .AWSIZE_S2_F  (awsize_s2 ),
	 .AWBURST_S2_F (awburst_s2),
	 .AWVALID_S2_F (awvalid_s2),
	 .AWREADY_S2_F (awready_s2),
	 .WDATA_S2_F   (wdata_s2  ),
	 .WSTRB_S2_F   (wstrb_s2  ),
	 .WLAST_S2_F   (wlast_s2  ),
	 .WVALID_S2_F  (wvalid_s2 ),
	 .WREADY_S2_F  (wready_s2 ),
	 .BID_S2_F     (bid_s2    ),
	 .BRESP_S2_F   (bresp_s2  ),
	 .BVALID_S2_F  (bvalid_s2 ),
	 .BREADY_S2_F  (bready_s2 ),
	 
	 .ARID_S2_F    (arid_s2   ),//master2 interface read channel,DM
	 .ARADDR_S2_F  (araddr_s2 ),
	 .ARLEN_S2_F   (arlen_s2  ),
	 .ARSIZE_S2_F  (arsize_s2 ),
	 .ARBURST_S2_F (arburst_s2),
	 .ARVALID_S2_F (arvalid_s2),
	 .ARREADY_S2_F (arready_s2),
	 .RID_S2_F     (rid_s2    ),
	 .RDATA_S2_F   (rdata_s2  ),
	 .RRESP_S2_F   (rresp_s2  ),
	 .RLAST_S2_F   (rlast_s2  ),
	 .RVALID_S2_F  (rvalid_s2 ),
	 .RREADY_S2_F  (rready_s2 ),
	 
	 .AWID_S3_F    (awid_s3   ),//master3 interface write channel,sensor_ctrl
	 .AWADDR_S3_F  (awaddr_s3 ),
	 .AWLEN_S3_F   (awlen_s3  ),
	 .AWSIZE_S3_F  (awsize_s3 ),
	 .AWBURST_S3_F (awburst_s3),
	 .AWVALID_S3_F (awvalid_s3),
	 .AWREADY_S3_F (awready_s3),
	 .WDATA_S3_F   (wdata_s3  ),
	 .WSTRB_S3_F   (wstrb_s3  ),
	 .WLAST_S3_F   (wlast_s3  ),
	 .WVALID_S3_F  (wvalid_s3 ),
	 .WREADY_S3_F  (wready_s3 ),
	 .BID_S3_F     (bid_s3    ),
	 .BRESP_S3_F   (bresp_s3  ),
	 .BVALID_S3_F  (bvalid_s3 ),
	 .BREADY_S3_F  (bready_s3 ),
	 
	 .ARID_S3_F    (arid_s3   ),//master3 interface read channel,sensor_ctrl
	 .ARADDR_S3_F  (araddr_s3 ),
	 .ARLEN_S3_F   (arlen_s3  ),
	 .ARSIZE_S3_F  (arsize_s3 ),
	 .ARBURST_S3_F (arburst_s3),
	 .ARVALID_S3_F (arvalid_s3),
	 .ARREADY_S3_F (arready_s3),
	 .RID_S3_F     (rid_s3    ),
	 .RDATA_S3_F   (rdata_s3  ),
	 .RRESP_S3_F   (rresp_s3  ),
	 .RLAST_S3_F   (rlast_s3  ),
	 .RVALID_S3_F  (rvalid_s3	 ),
	 .RREADY_S3_F  (rready_s3 ),
	 
	 .AWID_S4_F    (awid_s4   ),//master4 interface write channel,WDT
	 .AWADDR_S4_F  (awaddr_s4 ),
	 .AWLEN_S4_F   (awlen_s4  ),
	 .AWSIZE_S4_F  (awsize_s4 ),
	 .AWBURST_S4_F (awburst_s4),
	 .AWVALID_S4_F (awvalid_s4),
	 .AWREADY_S4_F (awready_s4),
	 .WDATA_S4_F   (wdata_s4  ),
	 .WSTRB_S4_F   (wstrb_s4  ),
	 .WLAST_S4_F   (wlast_s4  ),
	 .WVALID_S4_F  (wvalid_s4 ),
	 .WREADY_S4_F  (wready_s4 ),
	 .BID_S4_F     (bid_s4    ),
	 .BRESP_S4_F   (bresp_s4  ),
	 .BVALID_S4_F  (bvalid_s4 ),
	 .BREADY_S4_F  (bready_s4 ),
	 
	 
	 .AWID_S5_F    (awid_s5   ),//master5 interface write channel,DRAM
	 .AWADDR_S5_F  (awaddr_s5 ),
	 .AWLEN_S5_F   (awlen_s5  ),
	 .AWSIZE_S5_F  (awsize_s5 ),
	 .AWBURST_S5_F (awburst_s5),
	 .AWVALID_S5_F (awvalid_s5),
	 .AWREADY_S5_F (awready_s5),
	 .WDATA_S5_F   (wdata_s5  ),
	 .WSTRB_S5_F   (wstrb_s5  ),
	 .WLAST_S5_F   (wlast_s5  ),
	 .WVALID_S5_F  (wvalid_s5 ),
	 .WREADY_S5_F  (wready_s5 ),
	 .BID_S5_F     (bid_s5    ),
	 .BRESP_S5_F   (bresp_s5  ),
	 .BVALID_S5_F  (bvalid_s5 ),
	 .BREADY_S5_F  (bready_s5 ),
	 
	 .ARID_S5_F    (arid_s5   ),//master5 interface read channel,DRAM
	 .ARADDR_S5_F  (araddr_s5 ),
	 .ARLEN_S5_F   (arlen_s5  ),
	 .ARSIZE_S5_F  (arsize_s5 ),
	 .ARBURST_S5_F (arburst_s5),
	 .ARVALID_S5_F (arvalid_s5),
	 .ARREADY_S5_F (arready_s5),
	 .RID_S5_F     (rid_s5    ),
	 .RDATA_S5_F   (rdata_s5  ),
	 .RRESP_S5_F   (rresp_s5  ),
	 .RLAST_S5_F   (rlast_s5  ),
	 .RVALID_S5_F  (rvalid_s5 ),
	 .RREADY_S5_F  (rready_s5 ),
	 
	 .AWID_S6_F    (awid_s6   ),//master6 interface write channel,PWM
	 .AWADDR_S6_F  (awaddr_s6 ),
	 .AWLEN_S6_F   (awlen_s6  ),
	 .AWSIZE_S6_F  (awsize_s6 ),
	 .AWBURST_S6_F (awburst_s6),
	 .AWVALID_S6_F (awvalid_s6),
	 .AWREADY_S6_F (awready_s6),
	 .WDATA_S6_F   (wdata_s6  ),
	 .WSTRB_S6_F   (wstrb_s6  ),
	 .WLAST_S6_F   (wlast_s6  ),
	 .WVALID_S6_F  (wvalid_s6 ),
	 .WREADY_S6_F  (wready_s6 ),
	 .BID_S6_F     (bid_s6    ),
	 .BRESP_S6_F   (bresp_s6  ),
	 .BVALID_S6_F  (bvalid_s6 ),
	 .BREADY_S6_F  (bready_s6 )
	);

// Instance of the CPU_wrapper DUV
CPU_wrapper CPU_wrapper(
	.ACLK		     (cpu_clk),
    .ARESETn	     (cpu_reset),
	.AWID_M1	     (awid_m1),
	.AWADDR_M1	     (awaddr_m1),
	.AWLEN_M1	     (awlen_m1),
	.AWSIZE_M1       (awsize_m1),
	.AWBURST_M1	     (awburst_m1),
	.AWVALID_M1	     (awvalid_m1),
	.AWREADY_M1	     (awready_m1),
	.WDATA_M1        (wdata_m1),
	.WSTRB_M1		 (wstrb_m1),                 
	.WLAST_M1        (wlast_m1),       
	.WVALID_M1       (wvalid_m1), 
	.WREADY_M1		 (wready_m1),	  
	.BID_M1		  	 (bid_m1),
	.BRESP_M1		 (bresp_m1), 
	.BVALID_M1       (bvalid_m1),
	.BREADY_M1       (bready_m1),
	.ARID_M0		 (arid_m0),
	.ARADDR_M0       (araddr_m0),
	.ARLEN_M0        (arlen_m0),
	.ARSIZE_M0       (arsize_m0),
	.ARBURST_M0      (arburst_m0),
	.ARVALID_M0		 (arvalid_m0),
	.ARREADY_M0      (arready_m0),
	.RID_M0			 (rid_m0),
	.RDATA_M0        (rdata_m0),
	.RRESP_M0        (rresp_m0),
    .RLAST_M0        (rlast_m0),
	.RVALID_M0       (rvalid_m0),
	.RREADY_M0       (rready_m0),
	.ARID_M1		 (arid_m1),
	.ARADDR_M1       (araddr_m1),
	.ARLEN_M1        (arlen_m1),
	.ARSIZE_M1       (arsize_m1),
	.ARBURST_M1      (arburst_m1),
	.ARVALID_M1		 (arvalid_m1),
	.ARREADY_M1      (arready_m1),
	.RID_M1          (rid_m1),
	.RDATA_M1        (rdata_m1),
	.RRESP_M1        (rresp_m1),
	.RLAST_M1        (rlast_m1),
	.RVALID_M1       (rvalid_m1),
	.RREADY_M1       (rready_m1),
	.sctrl_interrupt (sctrl_interrupt),
	.WTO             (WTO)
);

ROM_wrapper ROM(
		.ACLK			(rom_clk),
		.ARESETn		(rom_reset),
		.ARID_S      	(arid_s0),
		.ARADDR_S       (araddr_s0),
		.ARLEN_S        (arlen_s0),
		.ARSIZE_S       (arsize_s0),
		.ARBURST_S      (arburst_s0),
		.ARVALID_S      (arvalid_s0),
		.ARREADY_S      (arready_s0),
		.RID_S			(rid_s0),
	    .RDATA_S        (rdata_s0),
		.RRESP_S        (rresp_s0),
		.RLAST_S        (rlast_s0),
		.RVALID_S       (rvalid_s0),
		.RREADY_S       (rready_s0),
		.CS 			(ROM_enable ),
		.OE 			(ROM_read   ),
		.A  			(ROM_address),
		.DO 			(ROM_out    )
	);

SRAM_wrapper IM1(
		.ACLK			(sram_clk),
		.ARESETn		(sram_reset),
		.AWID_S			(awid_s1),
		.AWADDR_S       (awaddr_s1),
		.AWLEN_S        (awlen_s1),
		.AWSIZE_S       (awsize_s1),
		.AWBURST_S      (awburst_s1),
		.AWVALID_S		(awvalid_s1),
		.AWREADY_S      (awready_s1),
		.WDATA_S		(wdata_s1),
		.WSTRB_S        (wstrb_s1),
		.WLAST_S        (wlast_s1),
		.WVALID_S       (wvalid_s1),
		.WREADY_S       (wready_s1),
		.BID_S			(bid_s1),
		.BRESP_S        (bresp_s1),
		.BVALID_S       (bvalid_s1),
		.BREADY_S       (bready_s1),
		.ARID_S      	(arid_s1),
		.ARADDR_S       (araddr_s1),
		.ARLEN_S        (arlen_s1),
		.ARSIZE_S       (arsize_s1),
		.ARBURST_S      (arburst_s1),
		.ARVALID_S      (arvalid_s1),
		.ARREADY_S      (arready_s1),
		.RID_S			(rid_s1),
	    .RDATA_S        (rdata_s1),
		.RRESP_S        (rresp_s1),
		.RLAST_S        (rlast_s1),
		.RVALID_S       (rvalid_s1),
		.RREADY_S       (rready_s1)
	);


SRAM_wrapper DM1(
		.ACLK			(sram_clk),
		.ARESETn		(sram_reset),
		.AWID_S			(awid_s2),
		.AWADDR_S       (awaddr_s2),
		.AWLEN_S        (awlen_s2),
		.AWSIZE_S       (awsize_s2),
		.AWBURST_S      (awburst_s2),
		.AWVALID_S		(awvalid_s2),
		.AWREADY_S      (awready_s2),
		.WDATA_S		(wdata_s2),
		.WSTRB_S        (wstrb_s2),
		.WLAST_S        (wlast_s2),
		.WVALID_S       (wvalid_s2),
		.WREADY_S       (wready_s2),
		.BID_S			(bid_s2),
		.BRESP_S        (bresp_s2),
		.BVALID_S       (bvalid_s2),
		.BREADY_S       (bready_s2),
		.ARID_S      	(arid_s2),
		.ARADDR_S       (araddr_s2),
		.ARLEN_S        (arlen_s2),
		.ARSIZE_S       (arsize_s2),
		.ARBURST_S      (arburst_s2),
		.ARVALID_S      (arvalid_s2),
		.ARREADY_S      (arready_s2),
		.RID_S			(rid_s2),
	    .RDATA_S        (rdata_s2),
		.RRESP_S        (rresp_s2),
		.RLAST_S        (rlast_s2),
		.RVALID_S       (rvalid_s2),
		.RREADY_S       (rready_s2)
	);
	
sensor_ctrl_wrapper sensor_ctrl(
		.ACLK			(cpu_clk),
		.ARESETn		(cpu_reset),
		.AWID_S			(awid_s3),
		.AWADDR_S       (awaddr_s3),
		.AWLEN_S        (awlen_s3),
		.AWSIZE_S       (awsize_s3),
		.AWBURST_S      (awburst_s3),
		.AWVALID_S		(awvalid_s3),
		.AWREADY_S      (awready_s3),
		.WDATA_S		(wdata_s3),
		.WSTRB_S        (wstrb_s3),
		.WLAST_S        (wlast_s3),
		.WVALID_S       (wvalid_s3),
		.WREADY_S       (wready_s3),
		.BID_S			(bid_s3),
		.BRESP_S        (bresp_s3),
		.BVALID_S       (bvalid_s3),
		.BREADY_S       (bready_s3),
		.ARID_S      	(arid_s3),
		.ARADDR_S       (araddr_s3),
		.ARLEN_S        (arlen_s3),
		.ARSIZE_S       (arsize_s3),
		.ARBURST_S      (arburst_s3),
		.ARVALID_S      (arvalid_s3),
		.ARREADY_S      (arready_s3),
		.RID_S			(rid_s3),
	    .RDATA_S        (rdata_s3),
		.RRESP_S        (rresp_s3),
		.RLAST_S        (rlast_s3),
		.RVALID_S       (rvalid_s3),
		.RREADY_S       (rready_s3),
		.sctrl_interrupt(sctrl_interrupt),
		.sensor_ready   (sensor_ready),
		.sensor_out_0	(sensor_out_0),
		.sensor_out_1	(sensor_out_1),	
		.sensor_out_2	(sensor_out_2),
		.sensor_out_3	(sensor_out_3),
		.sensor_out_4	(sensor_out_4),	
		.sensor_out_5	(sensor_out_5),
		.sensor_out_6	(sensor_out_6),
		.sensor_out_7	(sensor_out_7),	
		.sensor_en      (sensor_en)
	);
	
WDT_wrapper WDT(
		.ACLK			(cpu_clk),
		.ARESETn		(cpu_reset),
		.AWID_S			(awid_s4),
		.AWADDR_S       (awaddr_s4),
		.AWLEN_S        (awlen_s4),
		.AWSIZE_S       (awsize_s4),
		.AWBURST_S      (awburst_s4),
		.AWVALID_S		(awvalid_s4),
		.AWREADY_S      (awready_s4),
		.WDATA_S		(wdata_s4),
		.WSTRB_S        (wstrb_s4),
		.WLAST_S        (wlast_s4),
		.WVALID_S       (wvalid_s4),
		.WREADY_S       (wready_s4),
		.BID_S			(bid_s4),
		.BRESP_S        (bresp_s4),
		.BVALID_S       (bvalid_s4),
		.BREADY_S       (bready_s4),
		.WTO            (WTO)
	);	
	
DRAM_wrapper DRAM(
		.ACLK			(dram_clk),
		.ARESETn		(dram_reset),
		.AWID_S			(awid_s5),
		.AWADDR_S       (awaddr_s5),
		.AWLEN_S        (awlen_s5),
		.AWSIZE_S       (awsize_s5),
		.AWBURST_S      (awburst_s5),
		.AWVALID_S		(awvalid_s5),
		.AWREADY_S      (awready_s5),
		.WDATA_S		(wdata_s5),
		.WSTRB_S        (wstrb_s5),
		.WLAST_S        (wlast_s5),
		.WVALID_S       (wvalid_s5),
		.WREADY_S       (wready_s5),
		.BID_S			(bid_s5),
		.BRESP_S        (bresp_s5),
		.BVALID_S       (bvalid_s5),
		.BREADY_S       (bready_s5),
		.ARID_S      	(arid_s5),
		.ARADDR_S       (araddr_s5),
		.ARLEN_S        (arlen_s5),
		.ARSIZE_S       (arsize_s5),
		.ARBURST_S      (arburst_s5),
		.ARVALID_S      (arvalid_s5),
		.ARREADY_S      (arready_s5),
		.RID_S			(rid_s5),
	    .RDATA_S        (rdata_s5),
		.RRESP_S        (rresp_s5),
		.RLAST_S        (rlast_s5),
		.RVALID_S       (rvalid_s5),
		.RREADY_S       (rready_s5),
		.Q   			(DRAM_Q     ),
		.CSn 			(DRAM_CSn   ),
		.WEn 	 		(DRAM_WEn   ),
		.RASn 			(DRAM_RASn  ),
		.CASn 			(DRAM_CASn  ),
		.A    			(DRAM_A     ),
		.D    			(DRAM_D     ),
		.VALID			(DRAM_valid )
	);

PWM_wrapper PWM(
		.ACLK			(pwm_clk),
		.ARESETn		(pwm_reset),
		.AWID_S			(awid_s6),
		.AWADDR_S       (awaddr_s6),
		.AWLEN_S        (awlen_s6),
		.AWSIZE_S       (awsize_s6),
		.AWBURST_S      (awburst_s6),
		.AWVALID_S		(awvalid_s6),
		.AWREADY_S      (awready_s6),
		.WDATA_S		(wdata_s6),
		.WSTRB_S        (wstrb_s6),
		.WLAST_S        (wlast_s6),
		.WVALID_S       (wvalid_s6),
		.WREADY_S       (wready_s6),
		.BID_S			(bid_s6),
		.BRESP_S        (bresp_s6),
		.BVALID_S       (bvalid_s6),
		.BREADY_S       (bready_s6),
		.pwm_o_0		(pwm_o_0),
		.pwm_o_1		(pwm_o_1),
		.pwm_o_2		(pwm_o_2),
		.pwm_o_3		(pwm_o_3)
	);	

endmodule

