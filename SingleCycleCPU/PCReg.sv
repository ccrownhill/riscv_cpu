/// This module recieves all connections from other modules and passes the necessary connections to the mux
/// It then decides based on rst whether PC becomes 0 or next_PC
/// From here it then updates PC on the next clk rising edge or asynchronously for rst
module PCReg(
    input logic PCsrc,
    input logic clk,
    input logic rst,
    input logic [31:0] ImmOp,
    output logic [31:0] PC
);

 logic [31:0] next_PC

always_ff @(posedge ck or posedge rst) begin
    if (rst)  
        PC <= 32'b0;
    else 
        PC <= next_PC;
    
end 

MuxReg MuxReg (
    .PCsrc (PCsrc),
    .PC (PC),
    .ImmOp (ImmOp),
    .next_PC (next_PC)
);   
endmodule