`timescale 1ns / 1ps

module tb_MIPS_CPU;

reg clk = 0;
reg pc_reset;

mips_cpu uut (
    .clk(clk),
    .pc_reset(pc_reset)
);

// Clock generation: 10ns period
always #5 clk = ~clk;

initial begin

    $dumpfile("mips_cpu.vcd"); // VCD file to generate
    $dumpvars(0, tb_MIPS_CPU);
    // Initial reset
    pc_reset = 1;
    #10;
    pc_reset = 0;

    // Run simulation
    #200;

    $finish;
end

// Debug output
initial begin
    $monitor("Time: %t | PC: %h | Instr: %h | ALUResult: %h | WriteBackData: %h",
             $time, uut.pc_out, uut.instr, uut.ALUResult, uut.WriteBackData);
end

endmodule
