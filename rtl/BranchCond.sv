module BranchCond (
  input logic [31:0] regOp1_i,
  input logic [31:0] regOp2_i,
  input logic [2:0]  funct3_i,

  output logic BranchCond_o
);

always_comb
  case (funct3_i)
    3'b000: BranchCond_o = regOp1_i == regOp2_i; // beq
    3'b001: BranchCond_o = regOp1_i != regOp2_i; // bne
    3'b100: BranchCond_o = $signed(regOp1_i) < $signed(regOp2_i); // blt
    3'b101: BranchCond_o = $signed(regOp1_i) >= $signed(regOp2_i); //bge
    3'b110: BranchCond_o = regOp1_i < regOp2_i; //bltu
    3'b111: BranchCond_o = regOp1_i >= regOp2_i; //bgeu
    default: BranchCond_o = 1'b0;
  endcase
endmodule
