module Forwarding (
    input               MEM_RegWrite,
    input               WB_RegWrite,
    input        [4:0]  EXE_RS1,
    input        [4:0]  EXE_RS2,
    input        [4:0]  MEM_WA,
    input        [4:0]  WB_WA,
    
    input               MEM_RegWrite_CSR,
    input               WB_RegWrite_CSR,
    input        [11:0] EXE_ADDR_CSR,
    input        [11:0] MEM_ADDR_CSR,
    input        [11:0] WB_ADDR_CSR,

    output logic [1:0]  FA,
    output logic [1:0]  FB,
    output logic [1:0]  FC    
);

always_comb begin
    //FA
    if (MEM_RegWrite && (MEM_WA != 5'b00000) && (MEM_WA == EXE_RS1)) begin
        FA = 2'b10;
    end else if (WB_RegWrite && (WB_WA != 5'b00000) && (WB_WA == EXE_RS1)) begin
        FA = 2'b01;
    end else begin
        FA = 2'b00;
    end

    //FB
    if (MEM_RegWrite && (MEM_WA != 5'b00000) && (MEM_WA == EXE_RS2)) begin
        FB = 2'b10;
    end else if (WB_RegWrite && (WB_WA != 5'b00000) && (WB_WA == EXE_RS2)) begin
        FB = 2'b01;
    end else begin
        FB = 2'b00;
    end

    //FC
    if (MEM_RegWrite_CSR && (MEM_ADDR_CSR == EXE_ADDR_CSR)) begin
        FC = 2'b10;
    end else if (WB_RegWrite_CSR && (WB_ADDR_CSR == EXE_ADDR_CSR)) begin
        FC = 2'b01;
    end else begin
        FC = 2'b00;
    end  
end
endmodule