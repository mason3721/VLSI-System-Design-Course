//================================================
// Auther:      Lin Meng-Yu            
// Filename:    RegFile.sv                            
// Description: Reg File module of CPU                  
// Version:     HW3 Submit Version
// Date:        2023/11/23
//================================================


module RegFile (
    input logic clk,
    input logic rst,
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
        if(rst) begin
                registers[0] <= 32'd0;
                registers[1] <= 32'd0;
                registers[2] <= 32'd0;
                registers[3] <= 32'd0;
                registers[4] <= 32'd0;
                registers[5] <= 32'd0;
                registers[6] <= 32'd0;
                registers[7] <= 32'd0;
                registers[8] <= 32'd0;
                registers[9] <= 32'd0;
                registers[10] <= 32'd0;
                registers[11] <= 32'd0;
                registers[12] <= 32'd0;
                registers[13] <= 32'd0;
                registers[14] <= 32'd0;
                registers[15] <= 32'd0;
                registers[16] <= 32'd0;
                registers[17] <= 32'd0;
                registers[18] <= 32'd0;
                registers[19] <= 32'd0;
                registers[20] <= 32'd0;
                registers[21] <= 32'd0;
                registers[22] <= 32'd0;
                registers[23] <= 32'd0;
                registers[24] <= 32'd0;
                registers[25] <= 32'd0;
                registers[26] <= 32'd0;
                registers[27] <= 32'd0;
                registers[28] <= 32'd0;
                registers[29] <= 32'd0;
                registers[30] <= 32'd0;
                registers[31] <= 32'd0;

            end
        else begin
            if(wb_en)begin
                if(rd_index == 5'd0)    // block write back to register rd == x0 
                    registers[0] <= 32'd0;
                else
                    registers[rd_index] <= wb_data;
            end
        else begin
            registers[rd_index] <= registers[rd_index];
        end
        end
end
    
    always_comb begin // Output combinational
        rs1_data_out = registers[rs1_index];
        rs2_data_out = registers[rs2_index]; 
    
    end

endmodule