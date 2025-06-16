`include "PC.v"
`include "instr_mem.v"
`include "reg_file.v"
`include "alu.v"
`include "data_mem.v"
`include "Control_Unit.v"
`include "ALUcontrol.v"

module mips_cpu (
    input wire clk, pc_reset
);

wire [31:0] pc_out, next_pc;
wire [31:0] instr;

wire RegWrite, RegDst, ALUSrc;
wire Branch, MemWrite, MemtoReg, Jump, Jal, Lui;
wire [1:0] ALUOp;

// alu wires
wire [31:0] SrcA, SrcB;
wire Zero;
wire [31:0] ALUResult;

// data_mem wires
wire [31:0] WriteData;
wire [31:0] ReadData;

// Intermediate wires
wire [31:0] WriteBackData;
wire [4:0] WriteReg;
wire [31:0] SignImm;
wire [31:0] PCBranch;
wire PCSrc;

control_unit control_unit (
    .op_code(instr[31:26]),
    .RegDst(RegDst),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .MemWrite(MemWrite),
    .Branch(Branch),
    .Jump(Jump),
    .Jal(Jal),
    .Lui(Lui),
    .ALUOp(ALUOp)
);

wire [3:0] ALUControlCode;

ALUControl ALUControl (
    .ALUOp(ALUOp),
    .funct(instr[5:0]),
    .op_code(instr[31:26]),
    .code(ALUControlCode)
);

pc PC (
    .clk(clk),
    .reset(pc_reset),
    .next_pc(next_pc),
    .pc_out(pc_out)
);

instr_mem instr_mem (
    .addr(pc_out),
    .instr(instr)
);

reg_file reg_file (
    .clk(clk),
    .we3(RegWrite),
    .ra1(instr[25:21]),
    .ra2(instr[20:16]),
    .wa3(WriteReg),
    .wd3(WriteBackData),
    .rd1(SrcA),
    .rd2(WriteData)
);

assign WriteReg = Jal ? 5'd31 :
                  (RegDst ? instr[15:11] : instr[20:16]);


alu alu (
    .a(SrcA),
    .b(SrcB),
    .alu_op(ALUControlCode),
    .zero(Zero),
    .result(ALUResult)
);

assign SrcB = ALUSrc ? SignImm : WriteData;

data_mem data_mem (
    .clk(clk),
    .write_en(MemWrite),
    .alu_result(ALUResult),
    .write_data(WriteData),
    .read_data(ReadData)
);

assign WriteBackData = Lui ? {instr[15:0], 16'b0} :
                (Jal ? pc_out + 4 :
                (MemtoReg ? ReadData : ALUResult));

assign SignImm = { {16{instr[15]}}, instr[15:0] };

assign PCSrc = Branch & ~Zero;
assign PCBranch = pc_out + (SignImm << 2);

wire [31:0] PCJump;
assign PCJump = {pc_out[31:28], instr[25:0], 2'b00};

assign next_pc = Jump ? PCJump : 
                (PCSrc ? PCBranch : pc_out + 4);



endmodule