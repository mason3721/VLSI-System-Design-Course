module RegisterFile (
    input               clk,
    input               rst,
	input               Interrupt_Confirm_Timer,
    input               AXI_Stall,
       
    input        [4:0]  ReadRegister1,
    input        [4:0]  ReadRegister2,
       
    input               RegWrite,
    input        [4:0]  WriteRegister,
    input        [31:0] WriteData,

    output logic [31:0] ReadData1,
    output logic [31:0] ReadData2
);
    logic [31:0] registers [31:0];

    //Write
    always_ff @(posedge clk) begin
        priority if (rst) begin
            foreach (registers[i]) begin
                registers[i] <= 32'd0;
            end
        end else if (Interrupt_Confirm_Timer) begin
            foreach (registers[i]) begin
                registers[i] <= 32'd0;
            end
        end else if (!AXI_Stall)begin
            unique if (RegWrite && (WriteRegister != 5'd0)) begin
                registers[WriteRegister] <= WriteData; 
            end else begin 
                registers[WriteRegister] <= registers[WriteRegister];
            end
        end else begin
            registers[WriteRegister] <= registers[WriteRegister];
        end
    end

    //Read
    always_ff @(posedge clk) begin
        priority if (rst) begin
            ReadData1 <= 32'd0;
            ReadData2 <= 32'd0;
        end else if (Interrupt_Confirm_Timer) begin
            ReadData1 <= 32'd0;
            ReadData2 <= 32'd0;
        end else if (!AXI_Stall) begin
            ReadData1 <= ((WriteRegister == ReadRegister1) && RegWrite && (WriteRegister != 5'd0)) ? WriteData : registers[ReadRegister1];
            ReadData2 <= ((WriteRegister == ReadRegister2) && RegWrite && (WriteRegister != 5'd0)) ? WriteData : registers[ReadRegister2];
        end else begin
            ReadData1 <= ReadData1;
            ReadData2 <= ReadData2;
        end
    end
endmodule
