//================================================
// Auther:      Lin Meng-Yu            
// Filename:    WDT.sv                            
// Description: Watch Dog Timer  module                   
// Version:     HW3 Submit Version 
// Date:        2023/11/23
//================================================

module WDT (
    input               clk     ,    // CPU clock (Fast)
    input               rst     ,
    input               clk2    ,   // WDT clock (Slow)
    input               rst2    ,
    input               WDEN    ,   
    input               WDLIVE  ,   
    input        [31:0] WTOCNT  ,
    output logic        WTO
);

   // -------- WDT Signal ---------- //
    logic        wdt_WDEN;
    logic        wdt_WDLIVE;
    logic [31:0] wdt_cnt;


    // -------- CDC Buffer ---------- //
    logic        WDLIVE_buffer1;
    logic        WDLIVE_buffer2;

    logic        WTO_buffer1;
    logic        WTO_buffer2;

    logic        WDEN_buffer1;
    logic        WDEN_buffer2;

    logic [31:0] WTOCNT_buffer1;
    logic [31:0] WTOCNT_buffer2;


    // ---------------- WDLIVE CDC ---------------- //
    always_ff @(posedge clk2) begin
        WDLIVE_buffer1 <= WDLIVE;
        WDLIVE_buffer2 <= WDLIVE_buffer1;
    end


    // --------------- WDEN CDC ------------------- //
    always_ff @(posedge clk2) begin
        WDEN_buffer1 <= WDEN;
        WDEN_buffer2 <= WDEN_buffer1;
    end

    //WTOCNT clock domain cross
    /*
    always_ff @(posedge clk2) begin
        WTOCNT_buffer1 <= WTOCNT;
        WTOCNT_buffer2 <= WTOCNT_buffer1;
    end
    */

    // ----------- Mux Synchronizer -------------- //
    always_comb begin
        priority if ({WDEN_buffer2, WDLIVE_buffer2} == 2'b10) begin
            WTOCNT_buffer1 = WTOCNT;
        end 
        else if ({WDEN_buffer2, WDLIVE_buffer2} == 2'b01) begin
            WTOCNT_buffer1 = 32'd0;
        end 
        else begin
            WTOCNT_buffer1 = WTOCNT_buffer2;
        end
    end



    always_ff @(posedge clk2) begin
        WTOCNT_buffer2 <= WTOCNT_buffer1;
    end

    // ----------- WDT -------------- //
    always_ff @(posedge clk2) begin
        priority if (rst2) begin
            wdt_WDEN <= 1'b0;
            wdt_WDLIVE <= 1'b0;
            wdt_cnt <= 32'd0;
            WTO_buffer1 <= 1'b0;
        end 
        else begin
            wdt_WDEN <= WDEN_buffer2;
            wdt_WDLIVE <= WDLIVE_buffer2;
            unique if (wdt_WDEN) begin
                unique if (wdt_WDLIVE) begin
                    wdt_cnt <= 32'd0;
                    WTO_buffer1 <= 1'b0;
                end 
                else if ({WDEN_buffer2, wdt_WDEN} == 2'b10) begin  
                    wdt_cnt <= 32'd0;
                    WTO_buffer1 <= 1'b0;
                end 
                else if (wdt_cnt > WTOCNT_buffer2) begin 
                    wdt_cnt <= wdt_cnt;
                    WTO_buffer1 <= 1'b1;
                end 
                else begin 
                    wdt_cnt <= wdt_cnt + 32'd1;
                    WTO_buffer1 <= WTO_buffer1;
                end
            end else 
            begin
                wdt_cnt <= 32'd0;
                WTO_buffer1 <= 1'b0;
            end
        end
    end

    // --------------- WTO output CDC -------------- //
    always_ff @(posedge clk) begin
        WTO_buffer2 <= WTO_buffer1;
        WTO <= WTO_buffer2;
    end
endmodule