`timescale 1ns / 1ps

module mips_pipelined_top_tb;

// Inputs
reg clk;
reg reset;

// Instantiate the Unit Under Test (UUT)
mips_pipelined_top uut (
    .clk(clk),
    .reset(reset)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns clock period
end

// Test sequence
initial begin
    // Initialize
    reset = 1;
    
    // Hold reset for 4 clock cycles
    #40;
    
    // Release reset
    reset = 0;
    
    // Run for 100 clock cycles
    #1000;
    
    // Finish simulation
    $display("Simulation finished at time %t", $time);
    $finish;
end

// Monitor important signals
initial begin
    $monitor("Time: %0t, PC: %h, Instruction: %h, RegWrite: %b, WriteReg: %d, WriteData: %h",
            $time, uut.pc, uut.instruction_id, uut.RegWrite_wb, 
            uut.write_reg_wb, uut.MemtoReg_wb ? uut.read_data_wb : uut.alu_result_wb);
end

// Dump waveforms
initial begin
    $dumpfile("mips_pipelined.vcd");
    $dumpvars(0, mips_pipelined_top_tb);
end

endmodule