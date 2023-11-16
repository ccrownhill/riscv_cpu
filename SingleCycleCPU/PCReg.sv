module PCreg (
    input logic [31:0] next_PC,
    input logic rst,
    input logic clk,
    output logic [31:0] PC
);

logic [31:0] register;

always_ff @(posedge clk, posedge rst)
    if (rst)
        register <= 0;
    else
        register <= next_PC;

assign PC = register;
endmodule
