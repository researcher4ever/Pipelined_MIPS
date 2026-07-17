`timescale 1ns / 1ps

module register_file(

    input wire clk,
    input wire reset,

    input wire reg_write,

    input wire [4:0] read_reg1,
    input wire [4:0] read_reg2,

    input wire [4:0] write_reg,
    input wire [31:0] write_data,

    output wire [31:0] read_data1,
    output wire [31:0] read_data2

);

    // 32 general-purpose registers
    reg [31:0] registers [0:31];

    integer i;

    // Reset and Write
    always @(posedge clk or posedge reset)
    begin
        if (reset)
        begin
            for(i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end
        else if(reg_write && (write_reg != 5'd0))  // FIXED: Don't write to $0
        begin
            registers[write_reg] <= write_data;
        end
    end

    // Asynchronous reads - FIXED: $0 always reads 0
    assign read_data1 = (read_reg1 == 5'd0) ? 32'b0 : registers[read_reg1];
    assign read_data2 = (read_reg2 == 5'd0) ? 32'b0 : registers[read_reg2];

endmodule