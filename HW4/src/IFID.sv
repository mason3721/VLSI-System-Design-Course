module IFID (
    input               clk,
    input               rst,
    input               stall, 
    input        [31:0] IF_Pc,
    input        [31:0] IF_PcPlus4,
	input               Interrupt_Confirm_Timer,
    output logic [31:0] ID_Pc,
    output logic [31:0] ID_PcPlus4
);
    always_ff @(posedge clk) begin
        priority if (rst) begin
            ID_Pc <= 32'd0;
            ID_PcPlus4 <= 32'd0;
        end else if (Interrupt_Confirm_Timer) begin
            ID_Pc <= 32'd0;
            ID_PcPlus4 <= 32'd0;
        end else if (~stall) begin
            ID_Pc <= IF_Pc;
            ID_PcPlus4 <= IF_PcPlus4;
        end else begin
            ID_Pc <= ID_Pc;
            ID_PcPlus4 <= ID_PcPlus4;
        end
    end
endmodule
