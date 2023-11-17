/// This module recieves all connections from other modules and passes the necessary connections to the mux
/// It then decides based on rst whether PC becomes 0 or next_PC
/// From here it then updates PC on the next clk rising edge or asynchronously for rst
module PCtop #(
	parameter DATA_WIDTH = 32
)(
    input logic PCsrc,
    input logic clk,
    input logic rst,
    input logic [DATA_WIDTH-1:0] ImmOp,

    output logic [DATA_WIDTH-1:0] PC
);

logic [DATA_WIDTH-1:0] next_PC;

PCreg PCreg (
    .next_PC (next_PC),
    .rst (rst),
    .clk (clk),
    .PC (PC)
);

Mux2 #(DATA_WIDTH) MuxReg (
    .sel (PCsrc),
    .in0 (PC + 4),
    .in1 (PC + ImmOp),
    .out (next_PC)
); 
  
endmodule
