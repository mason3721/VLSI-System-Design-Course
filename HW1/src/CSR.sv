`define RDINSTRETH 2'b11
`define RDINSTRET  2'b01
`define RDCYCLEH   2'b10
`define RDCYCLE    2'b00

module CSR (
    input logic clk,
    input logic rst,
    input logic [1:0] csr_info, // 7-bit ( {inst[27], inst[21]} )
    input logic stall,
    input logic jb,
    output logic [31:0] csr_data_out
);

logic [63:0] instret; // instruction number register
logic [63:0] cycle;   // clock cycle register
logic [63:0] temp;


always_ff @(posedge clk or posedge rst) begin  //  sequential
        if(rst) begin
            instret <= 64'd0;
            cycle <= 64'd0;
        end

        else begin
            if(jb) begin
                instret <= instret - 64'd1;
            end

            else if(stall) begin
                instret <= instret;
            end

            else begin
                instret <= instret + 64'd1;
            end
        cycle <=  cycle + 64'd1;
        end
    end
    
    always_comb begin // CSR Output combinational
        case(csr_info)
            `RDINSTRETH: begin
                temp = instret - 64'd1;
                csr_data_out = temp[63:32];
            end
            `RDINSTRET: begin
                temp = instret - 64'd1;
                csr_data_out = temp[31:0];
            end
            `RDCYCLEH: begin
                temp = 64'd0;
                csr_data_out = cycle[63:32];
            end
            `RDCYCLE: begin
                temp = 64'd0;
                csr_data_out = cycle[31:0];
            end

            /*default: begin
                temp = 64'd0;
                csr_data_out = 32'd0;
            end*/
        endcase
        
    end

endmodule