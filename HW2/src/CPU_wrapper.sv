//================================================
// Auther:      Lin Meng-Yu            
// Filename:    CPU_Wrapper.sv                            
// Description: CPU Wrapper module of AXI                  
// Version:     Submit Version
// Date:        2023/10/31
//================================================
`include "AXI_define.svh"
`include "CPU.sv"

module CPU_wrapper(

	input ACLK,
	input ARESETn,

	// --------------------------- Signals of AXI ---------------------------  //
	// M0 -> IM
    // M1 -> DM
	// ******************************  WRITE ADDRESS  ******************************//
	output logic [`AXI_ID_BITS-1:0]             AWID_M1      	,
	output logic [`AXI_ADDR_BITS-1:0]           AWADDR_M1    	,	// Control output
	output logic [`AXI_LEN_BITS-1:0]            AWLEN_M1     	,	// Consant 
	output logic [`AXI_SIZE_BITS-1:0]           AWSIZE_M1    	,	// Consant 
	output logic [1:0]                          AWBURST_M1   	,	// Consant 
	output logic                                AWVALID_M1   	,	// Control output
	input                                       AWREADY_M1   	,
	
	// ****************************** WRITE DATA ****************************** //
	output logic [`AXI_DATA_BITS-1:0]           WDATA_M1     	,	// Control output
	output logic [`AXI_STRB_BITS-1:0]           WSTRB_M1     	,	// Consant 
	output logic                                WLAST_M1     	,	// Control output
	output logic                                WVALID_M1    	,	// Control output 
	input                                       WREADY_M1    	,	
	
	// ****************************** WRITE RESPONSE ****************************** //
	input  [`AXI_ID_BITS-1:0]                   BID_M1       	,
	input  [1:0]                                BRESP_M1     	,
	input                                       BVALID_M1    	,
	output logic                                BREADY_M1    	,	// Consant output

	// ****************************** READ ADDRESS M0 ****************************** //
	output logic [`AXI_ID_BITS-1:0]             ARID_M0      	,	// Consant 
	output logic [`AXI_ADDR_BITS-1:0]           ARADDR_M0    	,	// Control output 
	output logic [`AXI_LEN_BITS-1:0]            ARLEN_M0     	,	// Consant 
	output logic [`AXI_SIZE_BITS-1:0]           ARSIZE_M0       ,	// Consant 
	output logic [1:0]                          ARBURST_M0		,	// Consant 
	output logic                                ARVALID_M0		,	// Control output 
	input                                       ARREADY_M0		,
	
	// ****************************** READ DATA M0 ****************************** //
	input [`AXI_ID_BITS-1:0]                    RID_M0   		, 
	input [`AXI_DATA_BITS-1:0]                  RDATA_M0 		, 
	input [1:0] 								RRESP_M0		,   // (x)
	input                                       RLAST_M0  		,
	input                                       RVALID_M0 		,
	output logic                                RREADY_M0 		,	// Control output 

	// ****************************** READ ADDRESS M1 ****************************** //
	output logic [`AXI_ID_BITS-1:0]             ARID_M1     	,
	output logic [`AXI_ADDR_BITS-1:0]           ARADDR_M1   	,
	output logic [`AXI_LEN_BITS-1:0]            ARLEN_M1        ,
	output logic [`AXI_SIZE_BITS-1:0]           ARSIZE_M1       ,
	output logic [1:0]                          ARBURST_M1      ,
	output logic                                ARVALID_M1      ,
	input                                       ARREADY_M1      ,
	
	// ****************************** READ DATA M1 ****************************** //
	input [`AXI_ID_BITS-1:0]                    RID_M1      	,
	input [`AXI_DATA_BITS-1:0]                  RDATA_M1     	,
	input [1:0] 								RRESP_M1		,	// (x)
	input                                       RLAST_M1     	,	
	input                                       RVALID_M1    	,
	output logic                                RREADY_M1    		// Control output

    // ******************* MASTER to SLAVE CONTROL ************************ //
    //output logic   [3:0]                        IM_WEB          ,
   // output logic                                IM_OE           ,
    //output logic   [3:0]                        DM_WEB          ,
    //output logic                                DM_OE           ,
    //output logic                                stall_AXI       

);
	logic [3:0] 								DM_WEB			;
	logic										DM_OE			;
    logic   [31:0]                              IM_DO           ;
    logic   [31:0]                              DM_DO           ;
    logic   [31:0]                              IM_A            ;
    logic   [31:0]                              DM_A            ;    
    logic   [31:0]                              DM_DI           ;

	logic			                            m0_stall		;
	logic			                            m1_stall		;
	logic			                            next_stall		;		
	logic			                            m0_next_stall	;
	logic			                            m1_next_stall	;


	 // --------------------------- CPU Ports ---------------------------  //
    CPU CPU(
        .clk        (ACLK)                    ,
        .rst        (~ARESETn)                ,
        .IM_DO      (IM_DO)                   , 
	    .DM_DO      (DM_DO)                   , 
        .stall_AXI  (stall_AXI)               ,

	    .IM_A       (IM_A)                    ,

	    .DM_WEB     (DM_WEB)                  ,
        .DM_OE      (DM_OE)                   ,
	    .DM_A       (DM_A)                    , 
	    .DM_DI      (DM_DI)		
	);
    // -------------------------------------------------------------------- //

    // ------------------------------ State Parameters --------------------------- //
	parameter [3:0]		IDLE  			= 		4'd0	,
			  			AR  			= 		4'd1	,
			  			R  				= 		4'd2	,
			  			AW    			= 		4'd3	,
			  			W 				= 		4'd4	,
			  			B 				= 		4'd5	,
			  			WAIT 			= 		4'd6	,
						STAY			= 		4'd7	,
						SPECIAL_AR  	=       4'd8	,
						SPECIAL_R		=		4'd9	,
						SPECIAL_WAIT	=		4'd10   ,
						SPECIAL_STAY	=		4'd11   ;

						
	// --------------------------------------------------------------------------- //

    // ------------------------------ Registers  ------------------------------ //	

	logic [3:0] 	m0_current_state ;
	logic [3:0] 	m1_current_state ;
	logic [3:0] 	m0_next_state    ;
	logic [3:0] 	m1_next_state    ;
	logic [31:0]	DM_DO_temp       ;
	logic [31:0]	DM_DO_temp_temp  ;
	logic [31:0]	IM_DO_temp       ;     
	logic			special_flag	 ;
    logic           waiting			 ;
	// ------------------------------------------------------------------------ //

	 // ------------------------------ Stall signal  ------------------------------ //
	assign	stall_AXI			= 	m0_stall || m1_stall; 	
	assign	next_stall			=	m0_next_stall || m1_next_stall;

    // ------------------------------------------------------------------------ //

	// -------------------------- Sequential -------------------------- //
	// ********* State Register **********//
    always_ff @(posedge ACLK or negedge ARESETn) begin
        if(~ARESETn) begin
			  	m0_current_state	<= 	4'd0;
			   	m1_current_state	<= 	4'd0;
				m0_stall			<=	1'd1;
				m1_stall			<=	1'd1;
		end

        else begin
				m0_current_state 	<=	m0_next_state;
				m1_current_state 	<=	m1_next_state;
				m0_stall			<=	m0_next_stall;
				m1_stall			<=	m1_next_stall;
		end
	end

	// ********* Data Output Register **********//
	always_ff@(posedge ACLK or negedge ARESETn) begin
		if(~ARESETn)begin
			    IM_DO 	<=	32'd0;
			    DM_DO 	<=	32'd0;
				DM_DO_temp_temp <= 32'd0;
		end
		else begin		
			if(m0_current_state == R) begin
				IM_DO 	<=  IM_DO_temp;
				DM_DO 	<=  DM_DO;
				DM_DO_temp_temp <= DM_DO_temp_temp;
			end

			else if(m1_current_state == R) begin
				IM_DO 	<=  IM_DO;
				DM_DO 	<=  DM_DO;
				DM_DO_temp_temp <= DM_DO_temp;
			end

			else if(m0_current_state == SPECIAL_R) begin
				IM_DO 	<=  IM_DO;
				DM_DO 	<=  DM_DO;
				DM_DO_temp_temp <= IM_DO_temp;
			end	

			else if(stall_AXI == 1'b0) begin
				IM_DO 	<=  IM_DO;
				DM_DO	<=	DM_DO_temp_temp;
				DM_DO_temp_temp <= DM_DO_temp_temp;
			end		

			else begin
				IM_DO 	<=  IM_DO;
				DM_DO 	<=  DM_DO;
				DM_DO_temp_temp <= DM_DO_temp_temp;

			end
		end
	end

	always_ff@(posedge ACLK or negedge ARESETn) begin
		if(~ARESETn) begin
			 special_flag 	<=	1'd0;
		end
			
		else begin
			if( (m0_current_state == SPECIAL_STAY)) begin
				special_flag <= 1'd1;
			end		

			else begin
				special_flag <= 1'd0;
			end
		end
	end

	always_ff@(posedge ACLK or negedge ARESETn) begin
		if(~ARESETn) begin
			waiting 	<=	1'd0;
		end
		else begin
			if( (m0_current_state == R && ~(m0_next_state == WAIT)) || (m1_current_state == R && m1_next_state == WAIT) ||((m0_current_state == AR && m0_next_state == R))) begin
				waiting <= 1'd1;
			end		
			else begin
				waiting <= 1'd0;
			end
		end
	end
	// ---------------------------------------------------------------------------- //

    // -------------------------- Next State Logic -------------------------- //
	// ********* M0 state control **********//
	always_comb begin

		case(m0_current_state)
			IDLE: begin
				if(DM_OE && (DM_A[31:16] == 16'h0000) && (special_flag == 1'd0)) begin					// Wait M1
					m0_next_state 	= 	SPECIAL_AR;
					m0_next_stall 	= 	1'd1;
				end
				
				else if(DM_OE && m1_current_state == IDLE && m1_next_state == AR) begin
					m0_next_state 	= 	IDLE;
					m0_next_stall 	= 	1'd1;	
				end				

				else begin
					m0_next_state 	= 	AR;
					m0_next_stall 	=	1'd1;		
				end		
			end

			AR: begin

				if(ARREADY_M0 && ARVALID_M0) begin
					m0_next_state   = 	R;
					m0_next_stall 	= 	1'd1;
				end		

				else begin
					m0_next_state   = 	AR;
					m0_next_stall 	= 	1'd1;
				end		
			end

			R: begin
				if(RVALID_M0 && RREADY_M0) begin
					m0_next_state 	= 	WAIT;
					m0_next_stall 	= 	1'd1;
				end

				else begin
					m0_next_state   =   R;
					m0_next_stall 	= 	1'd1;
				end
			end

			WAIT: begin
				m0_next_state 	=	STAY;
				m0_next_stall 	= 	1'd0;
			end


			STAY: begin
				m0_next_state 	=	IDLE;
				m0_next_stall 	= 	1'd1;
			end		

			default: begin
				m0_next_state 	= 	IDLE;
				m0_next_stall 	= 	1'd1;
			end


			SPECIAL_AR: begin
				if(ARVALID_M0 & ARREADY_M0) begin
					m0_next_state 	= 	SPECIAL_R;
					m0_next_stall 	= 	1'd1;
				end

				else begin
					m0_next_state 	=	SPECIAL_AR;
					m0_next_stall 	= 	1'd1;
				end
			end		

			SPECIAL_R: begin
				if(RVALID_M0 && RREADY_M0) begin
					m0_next_state 	= 	SPECIAL_WAIT;
					m0_next_stall 	= 	1'd1;
				end

				else begin
					m0_next_state   =   SPECIAL_R;
					m0_next_stall 	= 	1'd1;
				end
			end

			SPECIAL_WAIT: begin
				m0_next_state 	= 	SPECIAL_STAY;
				m0_next_stall 	= 	1'd1;
			end

			SPECIAL_STAY: begin
				m0_next_state 	= 	IDLE;
				m0_next_stall 	= 	1'd1;
			end


		endcase
		
	end

	// ************ M1 state control *************** //
		always_comb begin

		case(m1_current_state)
			IDLE: begin
				if(DM_WEB != 4'b1111) begin 			// Store (~OE_DM) 
					m1_next_state 	= 	AW;
					m1_next_stall	=	1'd1;
				end

				else if(DM_OE && (DM_A[31:16] == 16'h0001)) begin						// Load
					m1_next_state 	= 	AR;
					m1_next_stall	=	1'd1;
				end

				else begin									// Others
					m1_next_state 	= 	IDLE;
					m1_next_stall	=	1'd0;
				end
			end

			AR: begin
				if(ARVALID_M1 & ARREADY_M1) begin
					m1_next_state	 = 	R;
					m1_next_stall	 =	1'd1;
				end
				else begin
					m1_next_state   =   AR;
					m1_next_stall	=	1'd1;
				end
			end

			R: begin
				if(RREADY_M1 & RVALID_M1) begin
					m1_next_state   =   WAIT;
					m1_next_stall	=	1'd1;
				end

				else begin
					m1_next_state	= 	R;
					m1_next_stall	=	1'd1;
				end
			end

			AW: begin
				if(AWVALID_M1 & AWREADY_M1) begin
					m1_next_state	= 	W;
					m1_next_stall	=	1'd1;
				end
				else begin
					m1_next_state   =   AW;
					m1_next_stall	=	1'd1;
				end
			end

			W: begin
				if(WVALID_M1 & WREADY_M1) begin
					 m1_next_state 	= 	B;
					 m1_next_stall	=	1'd0;
				end
				else begin
					m1_next_state	= 	W;
					m1_next_stall	=	1'd1;
				end
			end

			B: begin
				if(BVALID_M1 & BREADY_M1) begin
					m1_next_state 	= 	STAY;
					m1_next_stall	=	1'd0;
				end
				else begin
					m1_next_state 	= 	B;
					m1_next_stall	=	1'd1;

				end
			end

			WAIT: begin
				if(waiting) begin
					m1_next_state 	= 	WAIT;
					m1_next_stall	=	1'd1;
				end
				else begin
					m1_next_state 	= 	STAY;
					m1_next_stall	=	1'd0;
				end
			end

			STAY: begin
				m1_next_state 	=	IDLE;
				m1_next_stall 	= 	1'd1;
			end

			default: begin
				m1_next_state 	=	 IDLE;
				m1_next_stall	=	 1'd1;
			end
		endcase
		
	end

	// ------------------------------------ Output Combinational Logic ------------------------------ //
	// ******** Constant Outputs  ******** //
	assign AWID_M1		=	4'd0;
    assign AWLEN_M1		=	4'd0;			
    assign AWSIZE_M1	= 	3'b010;     // Data size is 32 bits
    assign AWBURST_M1	= 	2'b01;      // Burst type is INCR mode

	assign WSTRB_M1		= 	4'b1111;	// All valid	

	//assign BREADY_M1 	= 	1'b1;		// Master always ready to receive response

	assign ARID_M0   	= 	4'd0;
    assign ARLEN_M0  	= 	4'd0;		
    assign ARSIZE_M0 	= 	3'b010;     // Data size is 32 bits
    assign ARBURST_M0 	=	2'b01;      // Burst type is INCR mode

	assign ARID_M1   	= 	4'd0;
    assign ARLEN_M1 	= 	4'd0;		
    assign ARSIZE_M1 	= 	3'b010;     // Data size is 32 bits
    assign ARBURST_M1 	= 	2'b01;      // Burst type is INCR mode

    // ******** Control Outputs  ******** //
    	// M0
    	always_comb begin
    		case(m0_current_state)
    			IDLE: begin
    				ARVALID_M0	=	1'd0;
    				ARADDR_M0	= 	32'd0;      
    				RREADY_M0	= 	1'd0;
    				IM_DO_temp	=	32'd0;
    			end

    			AR: begin
    				RREADY_M0	= 	1'd0;
    				IM_DO_temp	=	32'd0;

    				//if(ARVALID_M1) begin
    					//ARVALID_M0	=	1'd0;
    					//ARADDR_M0	=	32'd0;
    				//end					

    				//else begin		// ~ARVALID_M1 && AR Handshake
    					ARVALID_M0	=	1'd1;
    					ARADDR_M0	=	IM_A;
    				//end
    			end

    			R: begin
    				ARVALID_M0	=	1'd0;
    				ARADDR_M0	=	32'd0;
    				RREADY_M0	=	1'd1;
    				IM_DO_temp	=	RDATA_M0;

    			end

    			WAIT: begin
    				ARVALID_M0	=	1'd0;
    				ARADDR_M0	=	32'd0;
    				RREADY_M0	=	1'd0;
    				IM_DO_temp	=	32'd0;
    			end

    			SPECIAL_AR: begin
    				ARVALID_M0	=	1'd1;
    				ARADDR_M0	=	DM_A;
    				RREADY_M0	=	1'd0;
    				IM_DO_temp	=	32'd0;
    			end

    			SPECIAL_R: begin
    				ARVALID_M0	=	1'd0;
    				ARADDR_M0	=	32'd0;
    				RREADY_M0	=	1'd1;
    				IM_DO_temp	=	RDATA_M0;
    			end

    			STAY: begin
    				ARVALID_M0	=	1'd0;
    				ARADDR_M0	=	32'd0;
    				RREADY_M0	=	1'd0;
    				IM_DO_temp	=	32'd0;
    			end

				SPECIAL_WAIT: begin
    				ARVALID_M0	=	1'd0;
    				ARADDR_M0	=	32'd0;
    				RREADY_M0	=	1'd0;
    				IM_DO_temp	=	32'd0;
				end		

				SPECIAL_STAY: begin
    				ARVALID_M0	=	1'd0;
    				ARADDR_M0	=	32'd0;
    				RREADY_M0	=	1'd0;
    				IM_DO_temp	=	32'd0;
				end	


				default: begin
    				ARVALID_M0	=	1'd0;
    				ARADDR_M0	=	32'd0;
    				RREADY_M0	=	1'd0;
    				IM_DO_temp	=	32'd0;			
				end

    		endcase
    	end

	    // M1
	    always_comb begin
	    	case(m1_current_state)
	    		IDLE: begin
	    			AWADDR_M1	=	32'd0;
	    			AWVALID_M1	=	1'd0;
	    			WDATA_M1	=	32'd0;
	    			WLAST_M1	=	1'd0;
	    			WVALID_M1	=	1'd0;
	    			ARADDR_M1 	= 	32'd0;      
        			ARVALID_M1 	= 	1'd0;
	    			RREADY_M1	=	1'd0;
	    			DM_DO_temp	=	32'd0;	
	    			BREADY_M1	=	1'd0;
	    		end

	    		AR: begin
	    			AWADDR_M1	=	32'd0;
	    			AWVALID_M1	=	1'd0;
	    			WDATA_M1	=	32'd0;
	    			WLAST_M1	=	1'd0;
	    			WVALID_M1	=	1'd0;
	    			RREADY_M1	=	1'd0;
	    			DM_DO_temp	=	32'd0;
	    			BREADY_M1	=	1'd0;

	    			ARADDR_M1	=	DM_A;   	/***/
	    			ARVALID_M1	=	1'd1;
	    		end

	    		R: begin
	    			AWADDR_M1	=	32'd0;
	    			AWVALID_M1	=	1'd0;

	    			WDATA_M1	=	32'd0;
	    			WLAST_M1	=	1'd0;
	    			WVALID_M1	=	1'd0;

	    			ARADDR_M1	=	32'd0;
	    			ARVALID_M1	=	1'd0;

	    			BREADY_M1	=	1'd0;

	    			RREADY_M1 	=  1'd1;
	    			DM_DO_temp	=  RDATA_M1; 	/***/
	    			end

	    		AW: begin
	    			WDATA_M1	=	32'd0;
	    			WLAST_M1	=	1'd0;
	    			WVALID_M1	=	1'd0;

	    			ARADDR_M1	=	32'd0;
	    			ARVALID_M1	=	1'd0;

	    			RREADY_M1 	=	1'd0;
	    			DM_DO_temp	=	32'd0;

	    			BREADY_M1	=	1'd0;

	    			AWADDR_M1	=	DM_A;	/***/
	    			AWVALID_M1	=	1'd1;
	    		end

	    		W: begin
	    			AWADDR_M1	=	DM_A;
	    			AWVALID_M1	=	1'd0;

	    			ARADDR_M1	=	32'd0;
	    			ARVALID_M1	=	1'd0;

	    			RREADY_M1 	=	1'd0;
	    			DM_DO_temp	=	32'd0;

	    			BREADY_M1	=	1'd0;

	    			WDATA_M1	=	DM_DI;	/***/
	    			WLAST_M1	=	1'd1;
	    			WVALID_M1	=	1'd1;	

	    		end

	    		B: begin
	    			AWADDR_M1	=	32'd0;
	    			AWVALID_M1	=	1'd0;

	    			WDATA_M1	=	32'd0;
	    			WLAST_M1	=	1'd0;
	    			WVALID_M1	=	1'd0;

	    			ARADDR_M1	=	32'd0;
	    			ARVALID_M1	=	1'd0;

	    			RREADY_M1 	=	1'd0;
	    			DM_DO_temp	=	32'd0;

	    			BREADY_M1	=	1'd1;
	    		end

	    		WAIT: begin
	    			AWADDR_M1	=	32'd0;
	    			AWVALID_M1	=	1'd0;

	    			WDATA_M1	=	32'd0;
	    			WLAST_M1	=	1'd0;
	    			WVALID_M1	=	1'd0;

	    			ARADDR_M1	=	32'd0;
	    			ARVALID_M1	=	1'd0;

	    			RREADY_M1 	=	1'd0;
	    			DM_DO_temp	=	32'd0;

	    			BREADY_M1	=	1'd0;
	    		end

				STAY:begin
	    			AWADDR_M1	=	32'd0;
	    			AWVALID_M1	=	1'd0;

	    			WDATA_M1	=	32'd0;
	    			WLAST_M1	=	1'd0;
	    			WVALID_M1	=	1'd0;

	    			ARADDR_M1	=	32'd0;
	    			ARVALID_M1	=	1'd0;

	    			RREADY_M1 	=	1'd0;
	    			DM_DO_temp	=	32'd0;

	    			BREADY_M1	=	1'd0;
	    		end	
			
				default: begin
	    			AWADDR_M1	=	32'd0;
	    			AWVALID_M1	=	1'd0;

	    			WDATA_M1	=	32'd0;
	    			WLAST_M1	=	1'd0;
	    			WVALID_M1	=	1'd0;

	    			ARADDR_M1	=	32'd0;
	    			ARVALID_M1	=	1'd0;

	    			RREADY_M1 	=	1'd0;
	    			DM_DO_temp	=	32'd0;

	    			BREADY_M1	=	1'd0;					
				end
			endcase
		end	

endmodule