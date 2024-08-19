//================================================
// Auther:      Lin Meng-Yu            
// Filename:    sctrl_wrapper.sv                            
// Description: Sensor Control Wrapper module                   
// Version:     HW3 Submit Version 
// Date:        2023/11/23
//================================================

`include "../include/AXI_define.svh"
`include "sensor_ctrl.sv"

module sctrl_wrapper(
    input clk,
    input rst,
 // *********************  READ ADDRESS CHANNEL ******************** // 
    input  [`AXI_IDS_BITS -1:0]             ARID            ,
    input  [`AXI_ADDR_BITS-1:0]             ARADDR          ,
    input  [`AXI_LEN_BITS -1:0]             ARLEN           ,
    input  [`AXI_SIZE_BITS-1:0]             ARSIZE          ,
    input  [1:0]                            ARBURST         ,
    input                                   ARVALID         ,
    output logic                            ARREADY         ,

// **********************  READ DATA CHANNEL *********************** // 
    output logic [`AXI_IDS_BITS -1:0]       RID             ,
    output logic [`AXI_DATA_BITS-1:0]       RDATA           ,
    output logic [1:0]                      RRESP           ,  
    output logic                            RLAST           ,
    output logic                            RVALID          ,
    input                                   RREADY          ,

// **********************  WRITE ADDRESS CHANNEL ******************* // 
    input  [`AXI_IDS_BITS -1:0]             AWID            ,
    input  [`AXI_ADDR_BITS-1:0]             AWADDR          ,
    input  [`AXI_LEN_BITS -1:0]             AWLEN           ,
    input  [`AXI_SIZE_BITS-1:0]             AWSIZE          ,
    input  [1:0]                            AWBURST         ,
    input                                   AWVALID         ,
    output logic                            AWREADY         ,

// **********************  WRITE DATA CHANNEL *********************** // 
    input  [`AXI_DATA_BITS-1:0]             WDATA           ,
    input  [`AXI_STRB_BITS-1:0]             WSTRB           ,
    input                                   WLAST           ,
    input                                   WVALID          ,
    output logic                            WREADY          ,

// **********************  WRITE RESPONSE CHANNEL ******************* //
    output logic [`AXI_IDS_BITS -1:0]       BID             ,
    output logic [1:0]                      BRESP           ,
    output logic                            BVALID          ,
    input                                   BREADY          ,

// **********************  Sensor Control ******************* //
    output logic                            sctrl_interrupt ,
    input                                   sensor_ready    ,
    input [31:0]                            sensor_out      ,
    output logic                            sensor_en
);

    logic [2:0]         current_state     ;
    logic [2:0]         next_state        ;
    logic [7:0]         ARID_temp         ; 
    logic [7:0]         AWID_temp         ;
    logic [31:0]        ARADDR_temp       ;
    logic [31:0]        AWADDR_temp       ;
    logic               sctrl_en_temp     ;    
    logic               sctrl_clear_temp  ;

    logic               sctrl_en          ;
    logic               sctrl_clear       ; 
    logic [5:0]         sctrl_addr        ;
    logic [31:0]        sctrl_out         ;

  // ----------------------- Parameters ----------------------- //
    parameter [2:0]     IDLE    =   3'd0,
				        AR 	    =   3'd1,
				        R 	    =   3'd2,
				        AW 	    =   3'd3,
                        W       =   3'd4,
                        B       =   3'd5;

    sensor_ctrl sensor_ctrl(
        .clk             (clk             ),
        .rst             (rst             ),
        .sctrl_en        (sctrl_en        ),
        .sctrl_clear     (sctrl_clear     ),
        .sctrl_addr      (sctrl_addr      ),
        .sensor_ready    (sensor_ready    ),
        .sensor_out      (sensor_out      ),
        .sctrl_interrupt (sctrl_interrupt ),
        .sctrl_out       (sctrl_out       ),
        .sensor_en       (sensor_en       )
    );
											
    // --------------------- Sequential ----------------------- //
    always_ff @(posedge clk)begin
    	if(rst) begin
    		current_state     <=   IDLE;
    		sctrl_en_temp     <=   1'b0;
    		sctrl_clear_temp  <=   1'b0;
    		ARID_temp         <=   8'b0;
            AWID_temp         <=   8'b0;
    		ARADDR_temp       <=   32'd0;
    		AWADDR_temp       <=   32'd0;
    	end
    	else begin
    		current_state     <=   next_state;
    		sctrl_en_temp     <=   sctrl_en;
    		sctrl_clear_temp  <=   sctrl_clear;
    		ARID_temp         <=   ARID;
            AWID_temp         <=   AWID;
    		ARADDR_temp       <=   ARADDR;
    		AWADDR_temp       <=   AWADDR;
    	end
    end

// *******************  Combinational  ********************* //
 // ------------ Next State Logic  -------------- //
    always_comb begin     
    	case(current_state)
    		IDLE:begin
    			if(AWVALID) begin
    				next_state = AW;
                end
    			else if(ARVALID) begin
    				next_state = AR;
                end
    			else begin
    				next_state = IDLE;
                end
    		end
            AR: begin
        	    if(ARREADY && ARVALID) begin
        	    	next_state  = R;
        	    end
        	    else begin
        	    	next_state  = AR;
        	    end
            end
    		R: begin
    			if(RREADY) begin
    				next_state = IDLE;
                end
    			else begin
    				next_state = R;
                end
    		end
            AW: begin
    			if(AWVALID) begin
    				next_state = W;
                end
    			else begin
    				next_state = AW;
                end
            end

    		W: begin
    			if(WVALID) begin
    				next_state = B;
                end
    			else begin
    				next_state = W;
                end
    		end
    		B: begin
    			if(BREADY)
    				next_state = IDLE;
    			else
    				next_state = B;
    		end
    		default: begin
    			next_state = IDLE;
    		end
    	endcase
    end
  // ------------ Output Logic  -------------- //

// ******** Constant Outputs ******** //
    assign BRESP = 2'd0;                         
    assign RRESP = 2'd0;

// ******** Control Outputs ******** //
    always_comb begin
    		case(current_state)
    		IDLE : begin
    			    AWREADY     =      1'd0;
                    WREADY      =      1'd0;
                    BID         =      8'd0;
                    BVALID      =      1'd0; 
                    ARREADY     =      1'd0;
                    RID         =      8'd0;
    				RDATA       =      32'd0;
                    RLAST       =      1'd0;
                    RVALID      =      1'd0;
    				sctrl_en    =      sctrl_en_temp;
    				sctrl_clear =      sctrl_clear_temp;
    				sctrl_addr  =      6'd0;
    		end
    		AR : begin
    			    AWREADY     =      1'd0;
                    WREADY      =      1'd0;
                    BID         =      8'd0;
                    BVALID      =      1'd0; 
                    ARREADY     =      1'd1;
                    RID         =      8'd0;
    				RDATA       =      32'd0;
                    RLAST       =      1'd0;
                    RVALID      =      1'd0;
    				sctrl_en    =      sctrl_en_temp;
    				sctrl_clear =      sctrl_clear_temp;
    				sctrl_addr  =      6'd0;
    		end
    		R : begin
    			    AWREADY     =      1'd0;
                    WREADY      =      1'd0;
                    BID         =      8'd0;
                    BVALID      =      1'd0; 
                    ARREADY     =      1'd0;
                    RID         =      ARID_temp;
    				RDATA       =      sctrl_out;
                    RLAST       =      1'b1;
                    RVALID      =      1'b1;
    				sctrl_en    =      sctrl_en_temp;
    				sctrl_clear =      sctrl_clear_temp;
    				sctrl_addr  =      ARADDR_temp[7:2];
    		end
    		AW : begin
    			    AWREADY     =      1'd1;
                    WREADY      =      1'd0;
                    BID         =      8'd0;
                    BVALID      =      1'd0; 
                    ARREADY     =      1'd0;
                    RID         =      8'd0;
    				RDATA       =      32'd0;
                    RLAST       =      1'd0;
                    RVALID      =      1'd0;
    				sctrl_en    =      sctrl_en_temp;
    				sctrl_clear =      sctrl_clear_temp;
    				sctrl_addr  =      6'd0;
    		end
    		W : begin
    			    AWREADY = 1'b0;
                    WREADY  = 1'b1;
                    BID     = 8'd0;
                    BVALID  = 1'b0; 
                    ARREADY = 1'b0;
                    RID     = 8'd0;
    				RDATA   = 32'd0;
                    RLAST   = 1'b0;
                    RVALID  = 1'b0;
    				sctrl_en = (AWADDR_temp[15:0] == 16'h0100) ? (|WDATA) : sctrl_en_temp;
    				sctrl_clear =  (AWADDR_temp[15:0] == 16'h0200) ? (|WDATA) : sctrl_clear_temp;
    				sctrl_addr = 6'd0;	
    		end
    		B : begin
    			    AWREADY = 1'b0;
                    WREADY  = 1'b0;
                    BID     = AWID_temp;
                    BVALID  = 1'b1; 
                    ARREADY = 1'b0;
                    RID     = 8'd0;
    				RDATA   = 32'd0;
                    RLAST   = 1'b0;
                    RVALID  = 1'b0;
    				sctrl_en = sctrl_en_temp;
    				sctrl_clear = sctrl_clear_temp;	
    				sctrl_addr = 6'd0;
    		end	

    		default : begin
    			    AWREADY = 1'b0;
                    WREADY  = 1'b0;
                    BID     = 8'd0;
                    BVALID  = 1'b1; 
                    ARREADY = 1'b0;
                    RID     = 8'd0;
    				RDATA   = 32'd0;
                    RLAST   = 1'b0;
                    RVALID  = 1'b0;
    				sctrl_en = sctrl_en_temp;
    				sctrl_clear = sctrl_clear_temp;	
    				sctrl_addr = 6'd0;
    		end
    	endcase
    end


endmodule
