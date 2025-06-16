/* Implementation of 32-bit ALU with 4-bit control code */

module alu (
    input  wire [31:0] a, b,
    input  wire [3:0]  alu_op,
    output reg  [31:0] result,
    output reg zero
);

    wire [32:0] add_result = {1'b0, a} + {1'b0, b};
    wire [32:0] sub_result = {1'b0, a} - {1'b0, b};

    always @(*) begin
        case (alu_op)
            4'b0000: begin // AND
                result = a & b;
            end
            4'b0001: begin // OR
                result = a | b;
            end
            4'b0010: begin // ADD
                result = add_result[31:0];
            end
            4'b0110: begin // SUB
                result = sub_result[31:0];
            end
            4'b0111: begin // SLT (set if a < b)
                result = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;
            end
            default: begin
                result = 32'b0;
            end
        endcase

        zero = (result == 32'b0);
    end

endmodule