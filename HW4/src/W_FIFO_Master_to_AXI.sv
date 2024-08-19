module W_FIFO_Master_to_AXI (
    //Write
    input               wclk, //Write domain clock
    input               wrst, //Write domain reset
    input               wpush, //Data push enable
    input        [36:0] wdata, //Write data

    output logic        wfull, //FIFO full

    //read
    input               rclk, //Read domain clock
    input               rrst, //Read domain reset
    input               rpop, //Data pop enable

    output logic [36:0] rdata, //Read data
    output logic        rempty //FIFO empty
);    
    //`define FIFO_DEPTH 2
    //FIFO Controllers
    //Write
    logic wptr; //Write pointer && Write address (FIFO RAM address)
    //2-flop synchronizer
    logic wptr_rclk_1; //Write pointer && Write address in read clk domain
    logic wptr_rclk_2; //Write pointer && Write address in read clk domain

    //Read
    logic rptr; //Read pointer && Read address (FIFO RAM address)
    //2-flop synchronizer
    logic rptr_wclk_1; //Read pointer && Read address in write clk domain -gray code
    logic rptr_wclk_2; //Read pointer && Read address in write clk domain -gray code

    //FIFO Memory
    logic [36:0] FIFO_mem [1:0]; //width = 37, depth = 2

    //FIFO_RAM
    assign rdata = FIFO_mem[rptr];

    always_ff @(posedge wclk) begin
        if (wrst) begin
            FIFO_mem[0] <= 37'd0;
            FIFO_mem[1] <= 37'd0;
        end else if (wpush && (~wfull)) begin
            FIFO_mem[wptr] <= wdata;
        end else begin
            FIFO_mem[wptr] <= FIFO_mem[wptr];
        end
    end

    //FIFO_Controller
    //Write
    always_ff @(posedge wclk) begin
        if (wrst) begin
            wptr <= 1'b0;
        end else begin
            wptr <= wptr ^ (wpush && ~wfull);
        end
    end

    //Memory write-address pointer (okay to use binary to address memory)
    assign wfull = (wptr ^ rptr_wclk_2);

    //2-flop synchronizer: rclk to wclk
    always_ff @(posedge wclk) begin
        if (wrst) begin
            rptr_wclk_1 <= 1'b0;
            rptr_wclk_2 <= 1'b0;
        end else begin
            rptr_wclk_1 <= rptr;
            rptr_wclk_2 <= rptr_wclk_1;
        end
    end

    //Read
    always_ff @(posedge rclk) begin
        if (rrst) begin
            rptr <= 1'b0;
        end else begin
            rptr <= rptr ^ (rpop && ~rempty);
        end
    end

    //FIFO empty when the next rptr == synchronized wptr or on reset
    assign rempty = ~(rptr ^ wptr_rclk_2);

    //2-flop synchronizer: wclk to rclk
    always_ff @(posedge rclk) begin
        if (rrst) begin
            wptr_rclk_1 <= 1'b0;
            wptr_rclk_2 <= 1'b0;
        end else begin
            wptr_rclk_1 <= wptr;
            wptr_rclk_2 <= wptr_rclk_1;
        end
    end
endmodule