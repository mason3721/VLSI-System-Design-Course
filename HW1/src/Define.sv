`ifndef Define
`define Define


// Opcode for instructions (5-bit [6:2])
`define R   5'b01100 // R-type
`define I1  5'b00000 // I-type-1 (lb...)
`define I2  5'b00100 // I-type-2 (addi...)
`define I3  5'b11001 // I-type-3 (jalr)
`define S   5'b01000 // S-type 
`define B   5'b11000 // B-type
`define U1  5'b01101 // U-type-1 (lui)
`define U2  5'b00101 // U-type-2 (auipc)
`define J   5'b11011 // J-type (jal)
`define CSR 5'b11100 // CSR instruction

`endif 