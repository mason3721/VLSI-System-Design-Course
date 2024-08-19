`include "Define.sv"

module ALU (
    input logic  [4:0] opcode,
    input logic  [2:0] func3,
    input logic  [1:0] func7,    // {func7[5], func7[0]}
    input logic  [31:0] operand1,
    input logic  [31:0] operand2,
    output logic [31:0] alu_out
    //output logic [1:0] load_addr_sel
);

    logic [63:0] multiplexer;

    always_comb begin
        case(opcode)
            `R: begin // R-type
               case(func3)
                    3'b000: begin  // add or sub or mul
                        case(func7)
                            2'b00: begin // add
                                multiplexer = 64'd0;
                                alu_out = operand1 + operand2;
                            end
                            2'b10: begin // sub
                                multiplexer = 64'd0;
                                alu_out = operand1 - operand2;
                            end
                            2'b01: begin // mul
                                multiplexer = 64'd0;
                                alu_out = operand1 * operand2;
                            end
                            default: begin
                                multiplexer = 64'd0;
                                alu_out = 32'd0;
                            end
                        endcase
                    end

                    3'b001: begin  // sll or mul
                        if(func7[0]) begin
                            multiplexer = $signed(operand1) * $signed(operand2) >> 32;
                            alu_out = multiplexer[31:0];
                        end
                        else begin
                            multiplexer = 64'd0;
                            alu_out = operand1 << operand2[4:0];
                        end
                    end

                    3'b010: begin  // slt or mulhsu
                        if(func7[0]) begin
                            multiplexer = ($signed( {32'hffffffff, operand1} ) * operand2);
                            multiplexer = multiplexer >> 32;
                            alu_out = multiplexer[31:0];
                        end
                        else begin
                            multiplexer = 64'd0;
                            alu_out = ($signed(operand1) < $signed(operand2)) ? 32'd1 : 32'd0;
                        end
                    end

                    3'b011: begin  // sltu or mulhu
                        if(func7[0]) begin
                            multiplexer = (operand1 * operand2) ;
                            multiplexer = multiplexer >> 32;
                            alu_out = multiplexer[31:0]; 
                        end
                        else begin
                            multiplexer = 64'd0;
                            alu_out = (operand1 < operand2) ? 32'd1 : 32'd0;
                        end
                    end
                    3'b100: begin // xor
                        multiplexer = 64'd0;
                        alu_out = operand1 ^ operand2;
                    end
                    3'b101: begin // srl or sra
                        if(func7[1]) begin
                            multiplexer = 64'd0;
                            alu_out = ($signed(operand1) >>> operand2[4:0]);
                        end
                        else begin
                            multiplexer = 64'd0;
                            alu_out = (operand1  >> operand2[4:0]);
                        end
                    end
                    3'b110: begin //or
                        multiplexer = 64'd0;
                        alu_out = operand1 | operand2;                      
                    end
                    3'b111: begin //and
                        multiplexer = 64'd0;
                        alu_out = operand1 & operand2;                       
                    end

                    /*default: begin
                        multiplexer = 0;
                        alu_out = 0;
                    end*/
               endcase
            end
            `I1: begin //I lb..
                multiplexer = 64'd0;
                alu_out = operand1 + operand2; 
            end
            `I2: begin //I addi...
               case(func3)
                    3'b000: begin//addi
                        multiplexer = 64'd0;
                        alu_out = operand1+operand2;    
                    end
                    3'b001: begin//slli
                        multiplexer = 64'd0;
                        alu_out = (operand1 << operand2[4:0]);
                    end
                    3'b010: begin//slti
                        multiplexer = 64'd0;
                        alu_out = ($signed(operand1) < $signed(operand2)) ? 32'd1 : 32'd0;       
                    end
                    3'b011: begin//sltiu
                        multiplexer = 64'd0;
                        alu_out = (operand1 < operand2) ? 32'd1 : 32'd0;       
                    end
                    3'b100: begin
                        multiplexer = 64'd0;
                        alu_out = operand1 ^ operand2;
                    end
                    3'b101: begin
                        if(func7[1]) begin//srai
                            multiplexer = 64'd0;
                            alu_out= $signed(operand1) >>> operand2[4:0];
                        end
                        else begin     //srli
                            multiplexer = 64'd0;
                            alu_out= operand1 >> operand2[4:0];
                        end
                    end
                    3'b110: begin //ori
                        multiplexer = 64'd0;
                        alu_out = operand1 | operand2;   
                    end
                    3'b111: begin //andi
                        multiplexer = 64'd0;
                        alu_out= operand1 & operand2;
                    end
                    /*default: begin
                        multiplexer = 64'd0;
                        alu_out = 32'd0;
                    end*/
               endcase
            end
            `I3: begin // I jalr...
                multiplexer = 64'd0;
                alu_out = operand1 + 32'd4;
            end
            `S: begin
                multiplexer = 64'd0;
                alu_out = operand1 + operand2;
            end
            `B: begin
                case(func3)
                    3'b000: begin // beq
                        multiplexer = 64'd0;
                        alu_out = (operand1 == operand2) ? 1 : 0;                       
                    end
                    3'b001: begin // bne
                        multiplexer = 64'd0;
                        alu_out = (operand1 != operand2) ? 1 : 0;       
                    end
                    3'b100: begin // blt
                        multiplexer = 64'd0;
                        alu_out = ($signed(operand1) < $signed(operand2)) ? 1 : 0;       
                    end
                    3'b101: begin // bge
                        multiplexer = 64'd0;
                        alu_out = ($signed(operand1) >= $signed(operand2)) ? 1 : 0;       
                    end
                    3'b110: begin // bltu
                        multiplexer = 64'd0;
                        alu_out = ($unsigned(operand1) < $unsigned(operand2)) ? 1 : 0;       
                    end
                    3'b111: begin // bgeu
                        multiplexer = 64'd0;
                        alu_out = ($unsigned(operand1) >= $unsigned(operand2)) ? 1 : 0;                  
                    end
                    default: begin
                        multiplexer = 64'd0;
                        alu_out = 32'd0;
                    end
               endcase                
            end
            `U1: begin
                multiplexer = 64'd0;
                alu_out = operand2;
            end
            `U2: begin
                multiplexer = 64'd0;
                alu_out = operand1 + operand2;     
            end
            `J: begin
                multiplexer = 64'd0;
                alu_out = operand1 + 32'd4;
            end
            default: begin
                multiplexer = 64'd0;
                alu_out = 32'd0;
            end
        endcase 
    end
endmodule
