//================================================
// Auther:      Lin Meng-Yu            
// Filename:    CSR.sv                            
// Description: CSR module of CPU                  
// Version:     HW3 Submit Version
// Date:        2023/11/23
//================================================

module CSR ( 
    input                clk,
    input                rst,
    input                stall_CPU,
    input                stall_AXI,
    input                jb,

    input                sctrl_interrupt,
    input                wdt_interrupt,
    input                E_MRET,
    input                E_WFI,

    input        [31:0]  E_pc_add4,
    input        [11:0]  CSR_read_addr,
    input                E_CSR_write_en,
    input        [11:0]  E_CSR_write_addr,
    input        [31:0]  E_CSR_write_data,
    output logic [31:0]  CSR_read_data,

    output logic [31:0]  mtvec,
    output logic [31:0]  mepc,
    output logic         ext_interrupt,
    output logic         tim_interrupt
);

    logic [31:0] reg_mstatus;
    logic [31:0] reg_mtvec;
    logic [31:0] reg_mie;
    logic [31:0] reg_mip;
    logic [31:0] reg_mepc;
    logic [31:0] reg_mcycle;
    logic [31:0] reg_mcycleh;
    logic [31:0] reg_minstret;
    logic [31:0] reg_minstreth;
    logic [63:0] temp;

    parameter ADDR_MSTATUS   = 12'h300;
    parameter ADDR_MTVEC     = 12'h305;
    parameter ADDR_MIE       = 12'h304;
    parameter ADDR_MIP       = 12'h344;
    parameter ADDR_MEPC      = 12'h341;
    parameter ADDR_MCYCLE    = 12'hC00;
    parameter ADDR_MCYCLEH   = 12'hC80;
    parameter ADDR_MINSTRET  = 12'hC02;
    parameter ADDR_MINSTRETH = 12'hC82;

    assign ext_interrupt = E_WFI && sctrl_interrupt && reg_mie[11];
    assign tim_interrupt = wdt_interrupt && reg_mie[7];

   // **************** Read CSR ***************** //
    always_comb begin
        unique if (tim_interrupt) begin
            temp =  64'd0;
            CSR_read_data = 32'd0;
        end 
        else begin
            temp =  {reg_minstreth, reg_minstret} - 64'd1;
            unique if ((E_CSR_write_addr == CSR_read_addr) && (E_CSR_write_en == 1'b1)) begin
                unique case (E_CSR_write_addr)
                    ADDR_MSTATUS: CSR_read_data = {19'd0, E_CSR_write_data[12:11], 3'd0, E_CSR_write_data[7], 3'd0, E_CSR_write_data[3], 3'd0};
                    ADDR_MIE: CSR_read_data = {20'd0, E_CSR_write_data[11], 11'd0};
                    ADDR_MTVEC: CSR_read_data = E_CSR_write_data;
                    ADDR_MEPC: CSR_read_data = E_CSR_write_data;
                    ADDR_MIP: CSR_read_data = {20'd0, E_CSR_write_data[11], 11'd0};
                     ADDR_MCYCLE: CSR_read_data = reg_mcycle;
                    ADDR_MINSTRET: CSR_read_data = temp[31:0];
                    ADDR_MCYCLEH: CSR_read_data = reg_mcycle; 
                    ADDR_MINSTRETH: CSR_read_data = temp[63:32]; 
                    default: CSR_read_data = 32'd0;
                endcase
            end 
            else begin
                unique case (CSR_read_addr)
                    ADDR_MSTATUS: CSR_read_data = reg_mstatus;
                    ADDR_MIE: CSR_read_data = reg_mie;
                    ADDR_MTVEC: CSR_read_data = reg_mtvec;
                    ADDR_MEPC: CSR_read_data = reg_mepc;
                    ADDR_MIP: CSR_read_data = reg_mip;
                    ADDR_MCYCLE: CSR_read_data = reg_mcycle;
                    ADDR_MINSTRET: CSR_read_data = temp[31:0];
                    ADDR_MCYCLEH: CSR_read_data = reg_mcycle; 
                    ADDR_MINSTRETH: CSR_read_data = temp[63:32]; 
                    default: CSR_read_data = 32'd0;
                endcase
            end
        end
    end


   // **************** Write CSR ***************** //
    always_ff @(posedge clk) begin
        priority if (rst) begin
            reg_mstatus <= 32'd0;
            reg_mie <= 32'd0;
            reg_mtvec <= 32'd0;
            reg_mepc <= 32'd0;
            reg_mip <= 32'd0;
            reg_mcycle <= 32'd0;
            reg_minstret <= 32'd0;
            reg_mcycle <= 32'd0;
            reg_minstreth <= 32'd0;
        end
        else if (tim_interrupt) begin
            reg_mstatus <= 32'd0;
            reg_mie <= reg_mie;
            reg_mtvec <= 32'd0;
            reg_mepc <= 32'd0;
            reg_mip <= 32'd0;
            reg_mcycle <= 32'd0;
            reg_minstret <= 32'd0;
            reg_mcycle <= 32'd0;
            reg_minstreth <= 32'd0;
        end 
        else begin 
            priority if ((sctrl_interrupt && reg_mie[11]) || (wdt_interrupt && reg_mie[7])) begin
                reg_mstatus <= {19'd0, 2'b11, 3'd0, reg_mstatus[3], 3'd0, 1'b0, 3'd0};
            end 
            else if (E_MRET) begin
                reg_mstatus <= {19'd0, 2'b11, 3'd0, 1'b1, 3'd0, reg_mstatus[7], 3'd0};
            end 
            else begin
                reg_mstatus <= reg_mstatus;
            end
            unique if (wdt_interrupt) begin
                reg_mie <= {reg_mie[31:8], 1'd1, reg_mie[6:0]}; 
            end 
            else begin
                reg_mie <= reg_mie;
            end
            reg_mtvec <= 32'h0001_0000;
            unique if (ext_interrupt) begin
                reg_mepc <= E_pc_add4; 
            end 
            else begin
                reg_mepc <= reg_mepc;
            end
            reg_mip <= {20'd0, (sctrl_interrupt && reg_mie[11]), 3'd0, (wdt_interrupt && reg_mie[7]), 7'd0}; 

            {reg_mcycle, reg_mcycle} <= {reg_mcycle, reg_mcycle} + 64'd1; 

            priority if (stall_CPU || stall_AXI) begin
                {reg_minstreth, reg_minstret} <= {reg_minstreth, reg_minstret}; 
            end
            else if (jb) begin
                {reg_minstreth, reg_minstret} <= {reg_minstreth, reg_minstret} - 64'd1; 
            end 
            else begin
                {reg_minstreth, reg_minstret} <= {reg_minstreth, reg_minstret} + 64'd1;
            end 

            if (E_CSR_write_en) begin
                case (E_CSR_write_addr)
                    ADDR_MSTATUS: reg_mstatus <= E_CSR_write_data;
                    ADDR_MIE: reg_mie <= E_CSR_write_data;
                    ADDR_MTVEC: reg_mtvec <= E_CSR_write_data;
                    ADDR_MEPC: reg_mepc <= E_CSR_write_data;
                    ADDR_MIP: reg_mip <= E_CSR_write_data;
                endcase
            end
        end
    end

    assign mtvec = {reg_mtvec[31:2], 2'b00};
    assign mepc  = reg_mepc;

endmodule