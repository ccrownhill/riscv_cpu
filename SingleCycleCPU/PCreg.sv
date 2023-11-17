module PCreg #(
	parameter DATA_WIDTH = 32
)(
    input logic [DATA_WIDTH-1:0] next_PC,
    input logic rst,
    input logic clk,
    output logic [DATA_WIDTH-1:0] PC
);

logic [DATA_WIDTH-1:0] register;

always_ff @(posedge clk, posedge rst)
    if (rst)
        register <= 0;
    else
        register <= next_PC;

assign PC = register;
endmodule
