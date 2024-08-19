module CSR (
    input               clk,
    input               rst,
    input               stall_controller,
    input               stall_AXI,
    input               jb,

    input        [1:0]  CSR_in,
    output logic [31:0] CSR_out
);
    logic        [63:0] rd_cycle;
    logic        [63:0] rd_instret;
    logic        [63:0] instret;
    logic        [63:0] CSR_rdinstret_ADD;
    //csr_cycle & csr_instret
    always_ff @(posedge clk or posedge rst) begin
        priority if (rst) begin
            rd_cycle <= 64'd0;
            rd_instret <= 64'd0;
        end else if (stall_controller || stall_AXI) begin
            rd_cycle <= rd_cycle + 64'd1;
            rd_instret <= rd_instret; //retired instruction minus 1 because of stall
        end else if (jb) begin
            rd_cycle <= rd_cycle + 64'd1;
            rd_instret <= rd_instret - 64'd1; //retired instruction minus 2 because of flush
        end else begin
            rd_cycle <= rd_cycle + 64'd1;
            rd_instret <= rd_instret + 64'd1;
        end
    end
    //MUX for ouput (RDINSTRETH, RDINSTRET, RDCYCLEH, RDCYCLE)
    always_comb begin
        unique case (CSR_in)
            2'b11: begin //RDINSTRETH
                CSR_rdinstret_ADD = rd_instret - 64'd1;
                CSR_out = CSR_rdinstret_ADD[63:32];
            end  
            2'b01: begin //RDINSTRET
                CSR_rdinstret_ADD = rd_instret - 64'd1;
                CSR_out = CSR_rdinstret_ADD[31:0]; 
            end   
            2'b10: begin //RDCYCLEH
                CSR_rdinstret_ADD = 64'd0;
                CSR_out = rd_cycle[63:32];
            end              
            default: begin //RDCYCLE
                CSR_rdinstret_ADD = 64'd0;
                CSR_out = rd_cycle[31:0];
            end             
        endcase
    end
endmodule