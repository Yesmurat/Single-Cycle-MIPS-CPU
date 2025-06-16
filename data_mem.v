module data_mem (
    input wire clk,
    input wire write_en,
    input wire [2:0] mem_op,
    input wire [31:0] alu_result,
    input wire [31:0] write_data,
    output reg [31:0] read_data
);

    // Byte-addressable 1 KB memory
    reg [7:0] memory [0:1023];
    wire [31:0] addr = alu_result;

    always @(*) begin
        case (mem_op)
            3'b000:  // lw
                read_data = {memory[addr], memory[addr+1], memory[addr+2], memory[addr+3]};
            3'b010:  // lb (signed)
                read_data = {{24{memory[addr][7]}}, memory[addr]};
            3'b011:  // lbu (unsigned)
                read_data = {24'b0, memory[addr]};
            3'b101:  // lh (signed)
                read_data = {{16{memory[addr+1][7]}}, memory[addr+1], memory[addr]};
            3'b110:  // lhu (unsigned)
                read_data = {16'b0, memory[addr+1], memory[addr]};
            default:
                read_data = 32'b0;
        endcase
    end

    always @(posedge clk) begin
        if (write_en) begin
            case (mem_op)
                3'b001: begin // sw
                    memory[addr]   <= write_data[31:24];
                    memory[addr+1] <= write_data[23:16];
                    memory[addr+2] <= write_data[15:8];
                    memory[addr+3] <= write_data[7:0];
                end
                3'b100: begin // sb
                    memory[addr] <= write_data[7:0];
                end
                3'b111: begin // sh
                    memory[addr]   <= write_data[7:0];
                    memory[addr+1] <= write_data[15:8];
                end
            endcase
        end
    end

endmodule
