module RegFile (
    input logic clk,
    //input logic rst,
    input logic wb_en,
    input logic [31:0] wb_data,
    input logic [4:0] rd_index,
    input bit [4:0] rs1_index,
    input bit [4:0] rs2_index,
    output logic [31:0] rs1_data_out,
    output logic [31:0] rs2_data_out
);

logic [31:0] registers [0:31];
//logic [4:0] index;

always_ff @(posedge clk) begin  // Write back sequential
       // if(rst) begin
            //for(index = 0; index < 32; index++) begin
                //registers[index] <= 32'd0;
            //end
        //end

        if(wb_en)begin
            if(rd_index == 5'd0)    // block write back to register rd == x0 
                registers[0] <= 32'd0;
            else
                registers[rd_index] <= wb_data;
        end
        else
            registers[rd_index] <= registers[rd_index];
    end
    
    always_comb begin // Output combinational
        rs1_data_out = registers[rs1_index];
        rs2_data_out = registers[rs2_index]; 
        
    end

endmodule