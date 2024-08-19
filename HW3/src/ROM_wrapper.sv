//================================================
// Auther:      Lin Meng-Yu            
// Filename:    ROM_Wrapper.sv                            
// Description: ROM Wrapper module                   
// Version:     HW3 Submit Version 
// Date:        2023/11/23
//================================================

`include "../include/AXI_define.svh"

module ROM_wrapper (
    input ACLK,
    input ARESETn,
  
 // ******************  READ ADDRESS CHANNEL ******************* //   
    input [`AXI_IDS_BITS-1:0]           ARID                 ,
	input [`AXI_ADDR_BITS-1:0]          ARADDR               ,
	input [`AXI_LEN_BITS-1:0]           ARLEN                ,
	input [`AXI_SIZE_BITS-1:0]          ARSIZE               ,
	input [1:0]                         ARBURST              ,
	input                               ARVALID              ,
    output logic                        ARREADY              ,

// *******************  READ DATA CHANNEL ********************** // 
    input                               RREADY               ,
    output logic [`AXI_IDS_BITS-1:0]    RID                  ,        
	output logic [`AXI_DATA_BITS-1:0]   RDATA                ,
	output logic [1:0]                  RRESP                ,
	output logic                        RLAST                ,
	output logic                        RVALID               ,        

// ************************  ROM Siganl ************************ //    
    input [31:0]                        ROM_out              ,
    output logic [11:0]                 ROM_address          ,
	output logic                        ROM_enable           ,
	output logic                        ROM_read                                  
);
	logic [`AXI_IDS_BITS-1:0]           current_arid          ;
	logic [`AXI_ADDR_BITS-1:0]          current_araddr        ;

	logic [`AXI_IDS_BITS-1:0]           next_arid             ;
	logic [`AXI_ADDR_BITS-1:0]          next_araddr           ;

    logic                               current_state         ;
    logic                               next_state            ;
    logic [31:0]                        data_temp             ;
    logic [11:0]                        addr_temp             ;

   // ----------------------- Parameters ----------------------- //    
    parameter         AR   =   1'd0         ,
                      R    =    1'd1        ;

   // ----------------------- Sequential ----------------------- //
    always_ff@(posedge ACLK) begin
        if (~ARESETn) begin
            current_state     <=    AR;
            current_arid      <=    8'd0;     
            current_araddr    <=    32'd0;
            data_temp         <=    0;
            addr_temp         <=    0; 
    	end

        else begin
            current_state     <=      next_state;
            current_arid      <=      next_arid;     
            current_araddr    <=      next_araddr;
            if(RREADY) begin
                data_temp        <=      ROM_out;
            end
            else begin
                data_temp        <=      data_temp;
            end
            if(ARVALID) begin
                addr_temp        <=     ARADDR[13:2];
            end
            else begin
                addr_temp        <=     addr_temp;
            end 
        end
    end
    //-------------------------------------------------------------------//
 
  // ************************  Combinational  ************************** //
    // --------------- Next State Logic  ----------------- //
    always_comb begin
        case(current_state) 
    		AR: begin
    			if(ARVALID) begin
    				next_state      =    R;
    			end
    			else begin
    				next_state      =    AR;
    			end
    		end
    		R: begin
    			if(RREADY) begin
    				next_state      =   AR;
    			end
    			else begin
    				next_state	    = 	R;
    			end
    		end  
    		default: begin
    			next_state      =   AR;
    		end
    	endcase
    end
      // ------------------------------------------------- //
    // ******** Constant Outputs ******** //
    assign      ROM_enable   =   1'd1   ;
    assign      ROM_read     =   1'd1   ;
    assign      RRESP        =   2'd0   ;

    // ******** Control ROM Signal ******** //
    always_comb begin
        case(current_state)
            AR: begin
                    next_arid    =  ARID;
                    next_araddr  =  ARADDR;
            end
            R: begin
                    next_arid    =  current_arid;
                    next_araddr  =  current_araddr;
    	    end
        endcase    
    end

    // ******** Control Outputs to AXI  ******** //
    always_comb begin
        case(current_state)
            AR: begin
                ARREADY         =       1'd1;
                ROM_address     =       ARADDR[13:2];         
			    RID             =       8'd0;
			    RLAST           =       1'd0;
			    RVALID          =       1'd0;
			    RDATA           =       32'd0;
            end

            R : begin
                ROM_address     =       addr_temp;
                ARREADY         =       1'd0;
			    RID             =       current_arid;
			    RVALID          =       1'd1;
			    RDATA           =       ROM_out;
                RLAST           =       1'd1;
            end 
        endcase    
    end
endmodule
