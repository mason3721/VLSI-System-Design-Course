module Default_Slave (
    input              ACLK,
    input              ARESETn, 

    //WRITE ADDRESS
    input        [7:0] AWID_DS,
    input              AWVALID_DS,
    output logic       AWREADY_DS,

    //WRITE DATA
    input              WVALID_DS,
    output logic       WREADY_DS,

    //WRITE RESPONSE
    input              BREADY_DS,
    output logic [7:0] BID_DS,
    output logic       BVALID_DS,

    //READ ADDRESS
    input        [7:0] ARID_DS,
    input              ARVALID_DS,
    output logic       ARREADY_DS,

    //READ DATA
    input              RREADY_DS,
    output logic [7:0] RID_DS,
    output logic       RVALID_DS
);
    //state
    logic [1:0] W_current_state;
    logic [1:0] W_next_state;
    logic       R_current_state;
    logic       R_next_state;
    //write state
    localparam W_address = 2'd0;
    localparam W_data    = 2'd1;
    localparam W_B       = 2'd2;
    //read state                                  
    localparam R_address = 1'b0;
    localparam R_data    = 1'b1;

    //state: Sequential Circuit
    always_ff @(posedge ACLK) begin
        unique if (~ARESETn) begin
            W_current_state <= W_address; //WRITE
            R_current_state <= R_address; //READ
        end else begin
            W_current_state <= W_next_state;
            R_current_state <= R_next_state;
        end
    end

    //next_state: Combinational Circuit
    always_comb begin
        //WRITE
        unique case (W_current_state)
            W_address: 
            begin
                unique if (AWVALID_DS) begin
                    W_next_state = W_data;
                end else begin
                    W_next_state = W_address;
                end
            end
            W_data:
            begin 
                unique if (WVALID_DS) begin
                    W_next_state = W_B;
                end else begin
                    W_next_state = W_data;
                end
            end
            W_B: 
            begin
                unique if (BREADY_DS) begin
                    W_next_state = W_address;
                end else begin
                    W_next_state = W_B;
                end
            end
            default: 
            begin
                W_next_state = 2'd0;
            end
        endcase
        //READ
        unique case (R_current_state)
            R_address:	
            begin
                unique if (ARVALID_DS) begin
                    R_next_state = R_data;
                end else begin
                    R_next_state = R_address;
                end
            end
            default: //R_data
            begin
                unique if (RREADY_DS) begin
                    R_next_state = R_address;
                end else begin
                    R_next_state = R_data;
                end
            end
        endcase

    end

    //output: Combinational Circuit
    always_comb begin
        //WRITE
        unique case (W_current_state)
            W_address: 
            begin
                //WRITE ADDRESS
                AWREADY_DS = 1'b1;

                //WRITE DATA
                WREADY_DS = 1'b0;

                //WRITE RESPONSE
                BID_DS = 8'd0;		
                BVALID_DS = 1'b0;
            end
            W_data: 
            begin
                //WRITE ADDRESS
                AWREADY_DS = 1'b1;

                //WRITE DATA
                WREADY_DS = 1'b1;

                //WRITE RESPONSE	
                BID_DS = 8'd0;		
                BVALID_DS = 1'b0;		
            end
            W_B: 
            begin
                //WRITE ADDRESS
                AWREADY_DS = 1'b0;

                //WRITE DATA
                WREADY_DS = 1'b0;

                //WRITE RESPONSE
                BID_DS = AWID_DS;
                BVALID_DS = 1'b0;
            end
            default: 
            begin
                //WRITE ADDRESS
                AWREADY_DS = 1'b0;

                //WRITE DATA
                WREADY_DS = 1'b0;

                //WRITE RESPONSE
                BID_DS = 8'd0;
                BVALID_DS = 1'b0;
            end
        endcase
        //READ
        unique case (R_current_state)
            R_address: 
            begin
                //READ ADDRESS
                ARREADY_DS = 1'b1;

                //READ DATA
                RID_DS = 8'd0;		
                RVALID_DS = 1'b0;
            end
            default: //R_data
            begin
                //READ ADDRESS
                ARREADY_DS = 1'b0;

                //READ DATA
                RID_DS = ARID_DS;
                RVALID_DS = 1'b1;
            end
        endcase
    end
endmodule