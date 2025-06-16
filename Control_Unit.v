module control_unit (
    input wire [5:0] op_code, // inputs
    output reg RegDst, RegWrite, ALUSrc, MemtoReg,
                MemWrite, Branch, Jump, Lui, Jal,
    
    output reg [1:0] ALUOp
);

always @(*) begin
    
    case (op_code)
        6'b000000: begin // R-type
            RegDst = 1;
            RegWrite = 1;
            ALUSrc = 0;
            MemWrite = 0;
            MemtoReg = 0;
            Branch = 0;
            Jump = 0;
            Jal = 0;
            Lui = 0;
            ALUOp = 2'b10;
        end

        6'b100011: begin // lw
            RegDst = 0;
            RegWrite = 1;
            ALUSrc = 1;
            MemWrite = 0;
            MemtoReg = 1;
            Branch = 0;
            Jump = 0;
            Jal = 0;
            Lui = 0;
            ALUOp = 2'b00;
        end

        6'b101011: begin // sw
            RegDst = 1'b0; // don't care
            RegWrite = 0;
            ALUSrc = 1;
            MemWrite = 1;
            MemtoReg = 1'b0; // don't care
            Branch = 0;
            Jump = 0;
            Jal = 0;
            Lui = 0;
            ALUOp = 2'b00;            
        end

        6'b000100: begin // beq
            RegDst = 1'b0; // don't care
            RegWrite = 0;
            ALUSrc = 0;
            MemWrite = 0;
            MemtoReg = 1'b0; // don't care
            Branch = 1;
            Jump = 0;
            Jal = 0;
            Lui = 0;
            ALUOp = 2'b01;
        end

        6'b001000: begin // addi
            RegDst = 0;
            RegWrite = 1;
            ALUSrc = 1;
            MemWrite = 0;
            MemtoReg = 0;
            Branch = 0;
            Jump = 0;
            Jal = 0;
            Lui = 0;
            ALUOp = 2'b00;
        end

        6'b001100: begin // andi
            RegDst = 0;
            RegWrite = 1;
            ALUSrc = 1;
            MemWrite = 0;
            MemtoReg = 0;
            Branch = 0;
            Jump = 0;
            Jal = 0;
            Lui = 0;
            ALUOp = 2'b11;
        end

        6'b001101: begin // ori
            RegDst = 0;
            RegWrite = 1;
            ALUSrc = 1;
            MemWrite = 0;
            MemtoReg = 0;
            Branch = 0;
            Jump = 0;
            Jal = 0;
            Lui = 0;
            ALUOp = 2'b11;
        end

        6'b001010: begin // slti
            RegDst = 0;
            RegWrite = 1;
            ALUSrc = 1;
            MemWrite = 0;
            MemtoReg = 0;
            Branch = 0;
            Jump = 0;
            Jal = 0;
            Lui = 0;
            ALUOp = 2'b11;
        end

        6'b000010: begin // j
            RegDst = 1'b0; // don't care
            RegWrite = 0;
            ALUSrc = 1'b0; // don't care
            MemWrite = 0;
            MemtoReg = 1'b0; // don't care
            Branch = 0;
            Jump = 1;
            Jal = 0;
            Lui = 0;
            ALUOp = 2'b00; // don't care
        end

        6'b000011: begin // jal
            RegDst = 1'b0; // don't care
            RegWrite = 1;
            ALUSrc = 1'b0; // don't care
            MemWrite = 0;
            MemtoReg = 1'b0; // don't care
            Branch = 0;
            Jump = 1;
            Jal = 1;
            Lui = 0;
            ALUOp = 2'b00; // don't care
        end

        6'b001111: begin
            RegDst = 0;
            RegWrite = 1;
            ALUSrc = 1'b0; // don't care
            MemWrite = 0;
            MemtoReg = 0;
            Branch = 0;
            Jump = 0;
            Jal = 0;
            Lui = 1;
            ALUOp = 2'b00; // don't care
        end
        default: begin
            RegDst = 0;
            RegWrite = 0;
            ALUSrc = 0;
            MemWrite = 0;
            MemtoReg = 0;
            Branch = 0;
            Jump = 0;
            Jal = 0;
            Lui = 0;
            ALUOp = 2'b00;
        end 
    endcase
end
    
endmodule