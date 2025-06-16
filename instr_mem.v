module instr_mem(
    input wire [31:0] addr,
    output wire [31:0] instr
);
    reg [31:0] memory [0:255];  // 1 KB of instruction space

    initial begin
        // Example: Load your instructions manually (machine code)

        // R-type: add $3, $1, $2
        memory[0] = 32'b000000_00001_00010_00011_00000_100000;

        // R-type: sub $4, $3, $1
        memory[1] = 32'b000000_00011_00001_00100_00000_100010;

        // I-type: addi $5, $0, 10
        memory[2] = 32'b001000_00000_00101_0000000000001010;

        // I-type: lw $6, 4($5)
        memory[3] = 32'b100011_00101_00110_0000000000000100;

        // I-type: sw $6, 8($5)
        memory[4] = 32'b101011_00101_00110_0000000000001000;

        // I-type: beq $1, $2, +2 (skip next 2 instructions if equal)
        memory[5] = 32'b000100_00001_00010_0000000000000010;

        // R-type: and $7, $1, $2 (this will be skipped if branch is taken)
        memory[6] = 32'b000000_00001_00010_00111_00000_100100;

        // J-type: j 0x00000003 (jump to instruction at address 0x0000000C)
        memory[7] = 32'b000010_00000000000000000000000011;

        // JAL: jal 0x00000004 (jump and link)
        memory[8] = 32'b000011_00000000000000000000000100;

        // LUI: lui $8, 0x1234 → $8 = 0x12340000
        memory[9] = 32'b001111_00000_01000_0001001000110100;

        // Fill rest with no-ops
        // integer i;
        // for (i = 10; i < 256; i = i + 1) begin
        //     memory[i] = 32'b000000_00000_00000_00000_00000_000000; // nop
        // end
    end

    assign instr = memory[addr[9:2]]; // Word aligned
    
endmodule
