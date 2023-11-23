/// This module recieves all connections from other modules and passes the necessary connections to the mux
/// It then decides based on rst whether PC becomes 0 or next_PC
/// From here it then updates PC on the next clk rising edge or asynchronously for rst
module InstrLoad (
    input logic PCsrc,
    input logic clk,
    input logic rst,
    input logic [31:0] ImmOp,

    output logic [31:0] PC,
    output logic [31:0] next_PC
);

logic [31:0] next_PC;


Mux2 #(32) MuxReg (
    .sel (PCsrc),
    .in0 (PC + 4),
    .in1 (PC + ImmOp),
    .out (next_PC)
); 
  
endmodule
