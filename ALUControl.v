module ALUControl (
    input wire [1:0] ALUOp,
    input wire [5:0] funct,
    input wire [5:0] op_code,

    output reg [3:0] code
);

always @(*) begin

    case (ALUOp)
    2'b00: code = 4'b0000;

    2'b01: code = 4'b0110;
    
    2'b10: begin
        case (funct)
        6'b100000: code = 4'b0010;
        6'b100010: code = 4'b0110;
        6'b100100: code = 4'b0000;
        6'b100101: code = 4'b0001;
        6'b101010: code = 4'b0111;

        default: code = 4'b1111;
        endcase
    end

    2'b11: begin
        case (op_code)
        6'b001100: code = 4'b0000; // andi
        6'b001101: code = 4'b0001; // ori
        6'b001010: code = 4'b0111; // slti
        default: code = 4'b1111;
    endcase
    end

    endcase

end
    
endmodule