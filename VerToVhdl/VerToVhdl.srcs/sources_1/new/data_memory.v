module data_memory (CLK, W_EN, ADDR, D_IN , D_OUT, SWITCHES, SEVEN_SEG);
    parameter WIDTH = 32;
    parameter ADDR_SPACE = 10;

    input CLK, W_EN; // clock and write enable
    input [ADDR_SPACE-1:0] ADDR; // Address from ALU
    input [WIDTH-1:0] D_IN; // Write Data from Register File
    input [15:0] SWITCHES; // Switch input

    output reg [WIDTH-1:0] D_OUT; // Read Data to Writeback Mux
    output reg [15:0] SEVEN_SEG; // Seven Segment Display Output

    reg [WIDTH-1:0] mips_mem [(2**ADDR_SPACE)-1:0];

    always @(posedge CLK)
        if (W_EN)
            mips_mem[ADDR] <= D_IN;

    always @(posedge CLK)
        if (ADDR == 10'h3ff)
            if (W_EN)
                SEVEN_SEG <= D_IN[15:0];

    always @(posedge CLK)
        if (ADDR == 10'h3fe)
            D_OUT = {16'h0000,SWITCHES};
        else
            D_OUT = mips_mem[ADDR];

endmodule
