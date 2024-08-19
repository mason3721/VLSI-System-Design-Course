//================================================
// Auther:      Lin Meng-Yu            
// Filename:    SRAM_Wrapper.sv                            
// Description: SRAM Wrapper module of AXI                  
// Version:     Submit Version 
// Date:        2023/10/25
//================================================

`include "AXI_define.svh"

module SRAM_wrapper (
    input ACLK,
    input ARESETn,
  
  // ******************************  WRITE ADDRESS CHANNEL  ******************************//
  	input [`AXI_IDS_BITS-1:0]           AWID                                ,
	input [`AXI_ADDR_BITS-1:0]          AWADDR                              ,
	input [`AXI_LEN_BITS-1:0]           AWLEN                               ,
	input [`AXI_SIZE_BITS-1:0]          AWSIZE                              ,
	input [1:0]                         AWBURST                             ,
	input                               AWVALID                             ,
    output logic                        AWREADY                             ,

  // ******************************  WRITE DATA CHANNEL ******************************//    
    input [`AXI_DATA_BITS-1:0]          WDATA                               ,
	input [`AXI_STRB_BITS-1:0]          WSTRB                               ,
	input                               WLAST                               ,
	input                               WVALID                              ,
    output logic                        WREADY                              ,

// ******************************  READ RESPONSE CHANNAL ******************************//    
    input                               BREADY                              ,
    output logic [`AXI_IDS_BITS-1:0]    BID                                 ,
	output logic [1:0]                  BRESP                               ,
	output logic                        BVALID                              ,

 // ******************************  READ ADDRESS CHANNAL ******************************//   
    input [`AXI_IDS_BITS-1:0]           ARID                                ,
	input [`AXI_ADDR_BITS-1:0]          ARADDR                              ,
	input [`AXI_LEN_BITS-1:0]           ARLEN                               ,
	input [`AXI_SIZE_BITS-1:0]          ARSIZE                              ,
	input [1:0]                         ARBURST                             ,
	input                               ARVALID                             ,
    output logic                        ARREADY                             ,

// ******************************  READ DATA CHANNAL ******************************// 
    input                               RREADY                              ,
    output logic [`AXI_IDS_BITS-1:0]    RID                                 ,        
	output logic [`AXI_DATA_BITS-1:0]   RDATA                               ,
	output logic [1:0]                  RRESP                               ,
	output logic                        RLAST                               ,
	output logic                        RVALID                                                                                        
);

  logic [3:0]       current_state               ;
  logic [3:0]       next_state                  ;  
  logic             OE                          ;                 
  logic             CS                          ;
  logic [13:0]      A                           ;
  logic [31:0]      DI                          ;
  logic [31:0]      DO                          ;
  logic [3:0]       WEB                         ;

  logic [31:0]      ARADDR_temp                 ;
  logic [31:0]      AWADDR_temp                 ;
  logic [31:0]      WDATA_temp                  ;
  logic [7:0]       relay_ARID                  ;
  logic [7:0]       relay_AWID                  ;

  // --------------------------------- Parameters ---------------------------------- //    
  parameter [3:0]   IDLE    =       4'd0         ,
                    AR      =       4'd1         ,
                    R       =       4'd2         ,
                    AW      =       4'd3         ,
                    W       =       4'd4         ,
                    B       =       4'd5         ,
                    WAIT    =       4'd6         ,
  		            STAY    =       4'd7         ; 
 // ------------------------------------------------------------------------------  //

 // --------------------------- SRAM Ports ---------------------------  //
  SRAM i_SRAM (
    .A0   (A[0]  ),
    .A1   (A[1]  ),
    .A2   (A[2]  ),
    .A3   (A[3]  ),
    .A4   (A[4]  ),
    .A5   (A[5]  ),
    .A6   (A[6]  ),
    .A7   (A[7]  ),
    .A8   (A[8]  ),
    .A9   (A[9]  ),
    .A10  (A[10] ),
    .A11  (A[11] ),
    .A12  (A[12] ),
    .A13  (A[13] ),
    .DO0  (DO[0] ),
    .DO1  (DO[1] ),
    .DO2  (DO[2] ),
    .DO3  (DO[3] ),
    .DO4  (DO[4] ),
    .DO5  (DO[5] ),
    .DO6  (DO[6] ),
    .DO7  (DO[7] ),
    .DO8  (DO[8] ),
    .DO9  (DO[9] ),
    .DO10 (DO[10]),
    .DO11 (DO[11]),
    .DO12 (DO[12]),
    .DO13 (DO[13]),
    .DO14 (DO[14]),
    .DO15 (DO[15]),
    .DO16 (DO[16]),
    .DO17 (DO[17]),
    .DO18 (DO[18]),
    .DO19 (DO[19]),
    .DO20 (DO[20]),
    .DO21 (DO[21]),
    .DO22 (DO[22]),
    .DO23 (DO[23]),
    .DO24 (DO[24]),
    .DO25 (DO[25]),
    .DO26 (DO[26]),
    .DO27 (DO[27]),
    .DO28 (DO[28]),
    .DO29 (DO[29]),
    .DO30 (DO[30]),
    .DO31 (DO[31]),
    .DI0  (DI[0] ),
    .DI1  (DI[1] ),
    .DI2  (DI[2] ),
    .DI3  (DI[3] ),
    .DI4  (DI[4] ),
    .DI5  (DI[5] ),
    .DI6  (DI[6] ),
    .DI7  (DI[7] ),
    .DI8  (DI[8] ),
    .DI9  (DI[9] ),
    .DI10 (DI[10]),
    .DI11 (DI[11]),
    .DI12 (DI[12]),
    .DI13 (DI[13]),
    .DI14 (DI[14]),
    .DI15 (DI[15]),
    .DI16 (DI[16]),
    .DI17 (DI[17]),
    .DI18 (DI[18]),
    .DI19 (DI[19]),
    .DI20 (DI[20]),
    .DI21 (DI[21]),
    .DI22 (DI[22]),
    .DI23 (DI[23]),
    .DI24 (DI[24]),
    .DI25 (DI[25]),
    .DI26 (DI[26]),
    .DI27 (DI[27]),
    .DI28 (DI[28]),
    .DI29 (DI[29]),
    .DI30 (DI[30]),
    .DI31 (DI[31]),
    .CK   (ACLK  ),
    .WEB0 (WEB[0]),
    .WEB1 (WEB[1]),
    .WEB2 (WEB[2]),
    .WEB3 (WEB[3]),
    .OE   (OE    ),
    .CS   (CS    )
  );
  // -----------------------------------------------------------  //

  // ------------------------- Signal to SRAM --------------------- // 
    assign      CS      =   1'd1          ;  // Chip select 
    assign      OE      =   1'd1          ;  // Output enable
  // -------------------------------------------------------------- //


    // --------------------------- Sequential --------------------------- //
    always_ff@(posedge ACLK or negedge ARESETn) begin
        if (~ARESETn) begin
            current_state   <=      IDLE;
    	    relay_ARID      <=      8'd0;
            relay_AWID      <=      8'd0;
            ARADDR_temp     <=      32'd0;
            AWADDR_temp     <=      32'd0;
            WDATA_temp      <=      32'd0;
    	end

        else begin
            current_state   <=      next_state;
            case(current_state)
                IDLE : begin
                        relay_ARID          <=      relay_ARID;
                        relay_AWID          <=      relay_AWID;
                        ARADDR_temp         <=      ARADDR_temp;
                        AWADDR_temp         <=      AWADDR_temp; 
                        WDATA_temp          <=      WDATA_temp;

                end
                AR : begin

                        relay_ARID          <=      ARID;
                        relay_AWID          <=      relay_AWID;
                        ARADDR_temp         <=      ARADDR;
                        AWADDR_temp         <=      AWADDR_temp; 
                        WDATA_temp          <=      WDATA_temp;                    
                end
                R : begin
 
                        relay_ARID          <=      relay_ARID;
                        relay_AWID          <=      relay_AWID;
                        ARADDR_temp         <=      ARADDR_temp;
                        AWADDR_temp         <=      AWADDR_temp; 
                        WDATA_temp          <=      WDATA_temp;
                    end 
                AW : begin

                        relay_ARID          <=      relay_ARID;
                        relay_AWID          <=      AWID;
                        ARADDR_temp         <=      ARADDR_temp;
                        AWADDR_temp         <=      AWADDR; 
                        WDATA_temp          <=      WDATA_temp; 
                end
                W : begin
                        relay_ARID          <=      relay_ARID;
                        relay_AWID          <=      relay_AWID;
                        ARADDR_temp         <=      ARADDR_temp;
                        AWADDR_temp         <=      AWADDR_temp; 
                        WDATA_temp          <=      WDATA;
                end
                B : begin
                        relay_ARID          <=     relay_ARID;
                        relay_AWID          <=     relay_AWID;
                        ARADDR_temp         <=      ARADDR_temp;
                        AWADDR_temp         <=      AWADDR_temp; 
                        WDATA_temp          <=      WDATA_temp;
                end
                WAIT : begin
                        relay_ARID          <=     relay_ARID;
                        relay_AWID          <=     relay_AWID;
                        ARADDR_temp         <=      ARADDR_temp;
                        AWADDR_temp         <=      AWADDR_temp; 
                        WDATA_temp          <=      WDATA_temp;
                end

                STAY : begin
                        relay_ARID          <=     relay_ARID;
                        relay_AWID          <=     relay_AWID;
                        ARADDR_temp         <=      ARADDR_temp;
                        AWADDR_temp         <=      AWADDR_temp; 
                        WDATA_temp          <=      WDATA_temp;
                end
                default : begin
                        relay_ARID          <=     relay_ARID;
                        relay_AWID          <=     relay_AWID;
                        ARADDR_temp         <=     ARADDR_temp;
                        AWADDR_temp         <=     AWADDR_temp; 
                        WDATA_temp          <=     WDATA_temp; 
                 end
            endcase
        end
    end
    //-------------------------------------------------------------------------//

    // ------------------------- Next State Logic  ------------------------- //
    always_comb begin
            if(~ARESETn) begin 
    			next_state  	= 	IDLE;
    		end

            else begin
                case(current_state) 
    			IDLE: begin
    				if(AWVALID)begin 			        // Store (~OE_DM) 
    					next_state  	= 	AW;
    				end

    				else if(ARVALID) begin					    	// Load
    					next_state  	= 	AR;
                    end

    				else begin									// Others
    					next_state 	    = 	IDLE;
    				end
    			end

    			AR: begin
    				if(ARREADY && ARVALID) begin
    					next_state      =    R;
    				end
    				else begin
    					next_state      =    AR;
    				end
    			end
    			R: begin
    				if(RREADY && RVALID) begin
    					next_state      =   WAIT;
    				end
    				else begin
    					next_state	    = 	R;
    				end
    			end  
    			AW: begin
    				if(AWREADY && AWVALID) begin
    					next_state      =    W;
    				end
    				else begin
    					next_state      =    AW;
    				end
    			end
    			W: begin
    				if(WREADY && WVALID) begin
    					next_state      =    B;
    				end
    				else begin
    				    next_state      =    W;
    				end
    			end

    			B: begin
                    if(BREADY && BVALID) begin
    					next_state      =   IDLE;
                    end
                    else   begin
                        next_state      =   B;
                    end
    			end

    			WAIT: begin
                        next_state      =   STAY;
               		 end


    			STAY: begin
    				    next_state      =   IDLE;
    			end


    			default: begin
    				    next_state      =   IDLE;
    			end
    		    endcase
            end
    	end
      // --------------------------------------------------------------- //
  
  // ****************************** Output Combinational Logic ****************************** //
// ******** Constant Outputs  ******** //
    //assign      RID      =   8'd0        ;
    assign      RRESP    =   2'd0        ;
    //assign      BID      =   8'd0        ;
    assign      BRESP    =   2'd0        ;

// ******** Control Outputs  ******** //
    always_comb begin
        case(current_state)
            IDLE : begin
    			    AWREADY         =       1'b0;
    			    WREADY          =       1'b0;
    			    BVALID          =       1'b0;
                    BID             =       8'd0;

    			    ARREADY         =       1'b0;         
    			    RDATA           =       32'd0;
    			    RLAST           =       1'b0;
    			    RVALID          =       1'b0;
                    RID             =       8'd0;

                    A               =       14'd0;
                    DI              =       32'd0;
                    WEB             =       4'b1111;
            end

            AR  : begin
    			    AWREADY         =       1'b0;
    			    WREADY          =       1'b0;
    			    BVALID          =       1'b0;
                    BID             =       8'd0;
    			    ARREADY         =       1'd1;         
    			    RDATA           =       32'd0;
    			    RLAST           =       1'b0;
    			    RVALID          =       1'b0;
                    RID             =       8'd0;

                    A               =       ARADDR[15:2];
                    DI              =       32'd0;
                    WEB             =       4'b1111;   
                end

            R : begin
                    AWREADY         =       1'b0;
                    WREADY          =       1'b0;
                    BVALID          =       1'b0;
                    BID             =       8'd0;
                    ARREADY         =       1'b0; 
                    RDATA           =       DO;       
                    RLAST           =       1'b1;
                    RVALID          =       1'b1;
                    RID             =       relay_ARID;

                    A               =       ARADDR_temp[15:2];
                    DI              =       32'd0;
                    WEB             =       4'b1111;
    	        end

            AW : begin
                    AWREADY     =       1'b1;
                    WREADY      =       1'b0;
                    BVALID      =       1'b0;
                    BID         =       8'd0;
                    ARREADY     =       1'b0;
                    RDATA       =       32'd0;
                    RLAST       =       1'b0;
                    RVALID      =       1'b0;
                    RID         =       8'd0;

                    A           =       AWADDR[15:2];
                    DI          =       32'd0;
                    WEB         =       4'b1111;

            end
            W : begin
                    AWREADY     =       1'b0;
                    WREADY      =       1'b1;
                    BVALID      =       1'b0;
                    BID         =       8'd0;
                    ARREADY     =       1'b0;
                    RDATA       =       32'd0;
                    RLAST       =       1'b0;
                    RVALID      =       1'b0;   
                    RID         =       8'd0;

                    A           =       AWADDR_temp[15:2];
                    DI          =       WDATA;
                    WEB         =       4'b0000;
            end

            B : begin
                AWREADY         =       1'b0;
                WREADY          =       1'b0;
                BVALID          =       1'b1;     // Write response
                BID             =       relay_AWID;

                ARREADY         =       1'b0;
                RDATA           =       32'd0;
                RLAST           =       1'b0;
                RVALID          =       1'b0;   
                RID             =       8'd0;

                A               =       AWADDR_temp[15:2];
                DI              =       WDATA_temp;
                WEB             =       4'b1111;
                end

            WAIT : begin
                AWREADY         =       1'b0;
                WREADY          =       1'b0;
                BVALID          =       1'b0; 
                BID             =       8'd0;

                ARREADY         =       1'b0;
                RDATA           =       32'd0;
                RLAST           =       1'b0;
                RVALID          =       1'b0;
                RID             =       8'd0;

                A               =       14'd0;
                DI              =       32'd0;
                WEB             =       4'b1111;
                end

            STAY : begin
                AWREADY         =       1'b0;
                WREADY          =       1'b0;
                BVALID          =       1'b0; 
                BID             =       8'd0;

                ARREADY         =       1'b0;
                RDATA           =       32'd0;
                RLAST           =       1'b0;
                RVALID          =       1'b0;  
                RID             =       8'd0;

                A               =       14'd0;
                DI              =       32'd0;
                WEB             =       4'b1111;
                end

            default : begin
                AWREADY         =       1'b0; 
                WREADY          =       1'b0;
                BVALID          =       1'b0;
                BID             =       8'd0;

                ARREADY         =       1'd0;
                RDATA           =       32'd0;
                RLAST           =       1'b0;
                RVALID          =       1'b0;
                RID             =       8'd0;

                A               =       14'd0;
                DI              =       32'd0;
                WEB             =       4'b1111;
                end    
        endcase    
    end
endmodule
