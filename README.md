# Single-Cycle MIPS CPU in Verilog  
**By Yesmurat Sagyndyk – June 2025**

## 🎯 Objective
The purpose of this project was to design and implement a simplified **single-cycle MIPS processor** using Verilog HDL. The processor supports a core subset of MIPS instructions and demonstrates complete instruction fetch-decode-execute cycles within a single clock cycle.

---

## 🧱 Architecture

This CPU includes the following major components:

- **Program Counter (PC):**  
  Holds the address of the current instruction. Automatically increments by 4 unless altered by branch/jump logic.

- **Instruction Memory:**  
  Read-only memory storing 32-bit MIPS instructions, addressed using the PC. Supports word-aligned accesses.

- **Control Unit:**  
  Decodes the opcode and generates control signals that dictate data path behavior and ALU operations via an `ALUOp`.

- **Register File:**  
  Contains 32 general-purpose registers. Supports two simultaneous reads and one write.

- **ALU & ALU Control:**  
  ALU executes arithmetic/logic operations. ALU Control decodes `funct` and `opcode` fields to choose the correct operation based on `ALUOp`.

- **Data Memory:**  
  Used for `lw` and `sw` instructions. Allows read/write access using an address computed by the ALU.

---

## 🧠 Supported Instructions

- **R-type:** `add`, `sub`, `and`, `or`, `slt`  
- **I-type:** `lw`, `sw`, `beq`, `addi`, `andi`, `ori`, `slti`, `lui`  
- **J-type:** `j`, `jal`

---

## ⚙️ Implementation Highlights

- **Control Flow:**  
  The Control Unit determines high-level behavior for each instruction via control signals and sets `ALUOp`, which drives the ALU Control logic to select the correct operation.

- **PC Update Logic:**  
  ```verilog
  if (Jump)         next_pc = {PC[31:28], instr[25:0], 2'b00};
  else if (PCSrc)   next_pc = PC + (SignImm << 2);
  else              next_pc = PC + 4;
