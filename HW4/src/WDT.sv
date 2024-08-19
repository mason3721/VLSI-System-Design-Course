module WDT (
    input               clk,    // system clock
    input               clk2,   // WDT clock
    input               rst,
    input               rst2,
    input               WDEN,   //enable
    input               WDLIVE, // CPU send
    input        [31:0] WTOCNT,
    output logic        WTO
);
    //temp
    logic        temp_WDEN_1;
    logic        temp_WDEN_2;
    logic        temp_WDLIVE_1;
    logic        temp_WDLIVE_2;
    logic [31:0] temp_WTOCNT_1;
    logic [31:0] temp_WTOCNT_2;
    logic        temp_WTO_1;
    logic        temp_WTO_2;

    //watch dog timer
    logic        wdt_WDEN;
    logic        wdt_WDLIVE;
    logic [31:0] wdt_count;

    //WDEN clock domain cross
    always_ff @(posedge clk2) begin
        temp_WDEN_1 <= WDEN;
        temp_WDEN_2 <= temp_WDEN_1;
    end

    //WDLIVE clock domain cross
    always_ff @(posedge clk2) begin
        temp_WDLIVE_1 <= WDLIVE;
        temp_WDLIVE_2 <= temp_WDLIVE_1;
    end

    //WTOCNT clock domain cross
    always_comb begin
        priority if ({temp_WDEN_2, temp_WDLIVE_2} == 2'b10) begin
            temp_WTOCNT_1 = WTOCNT;
        end else if ({temp_WDEN_2, temp_WDLIVE_2} == 2'b01) begin
            temp_WTOCNT_1 = 32'd0;
        end else begin
            temp_WTOCNT_1 = temp_WTOCNT_2;
        end
    end

    always_ff @(posedge clk2) begin
        temp_WTOCNT_2 <= temp_WTOCNT_1;
    end

    //watch dog timer
    always_ff @(posedge clk2) begin
        priority if (rst2) begin
            wdt_WDEN <= 1'b0;
            wdt_WDLIVE <= 1'b0;
            wdt_count <= 32'd0;
            temp_WTO_1 <= 1'b0;
        end else begin
            wdt_WDEN <= temp_WDEN_2;
            wdt_WDLIVE <= temp_WDLIVE_2;
            unique if (wdt_WDEN) begin
                unique if (wdt_WDLIVE) begin
                    wdt_count <= 32'd0;
                    temp_WTO_1 <= 1'b0;
                end else if ({temp_WDEN_2, wdt_WDEN} == 2'b10) begin // the moment WDEN_wdt is going to assigned 
                    wdt_count <= 32'd0;
                    temp_WTO_1 <= 1'b0;
                end else if (wdt_count > temp_WTOCNT_2) begin // WDT times up
                    wdt_count <= wdt_count;
                    temp_WTO_1 <= 1'b1;
                end else begin //keep counting
                    wdt_count <= wdt_count + 32'd1;
                    temp_WTO_1 <= temp_WTO_1;
                end
            end else begin
                wdt_count <= 32'd0;
                temp_WTO_1 <= 1'b0;
            end
        end
    end

    //WTO output clock domain cross
    always_ff @(posedge clk) begin
        temp_WTO_2 <= temp_WTO_1;
        WTO <= temp_WTO_2;
    end
endmodule