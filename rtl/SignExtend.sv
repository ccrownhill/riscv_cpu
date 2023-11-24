/// Sign extend immediate value to 32 bit
/// There are 4 cases of immediates that must be formed
module SignExtend (
  input logic [1:0] ImmSrc, // 00 = I type 01 = S 10 = B 11 = J
  input logic [31:7] Instr31_7,
  output logic [31:0] ImmOp
);  

always_comb begin
  case (ImmSrc)
    2'b00: ImmOp = {{20{Instr31_7[31]}}, Instr31_7[31:20]};
    2'b01: ImmOp = {{20{Instr31_7[31]}}, Instr31_7[31:25], Instr31_7[11:7]}
    2'b10: ImmOp = {{19{Instr31_7[31]}}, Instr31_7[31], Instr31_7[7], Instr31_7[30:25], Instr31_7[11:8], 1'b0}
    2'b11: ImmOp = {{11{Instr31_7[31]}}, Instr31_7[31], Instr31_7[19:12], Instr31_7[20], Instr31_7[30:21], 1'b0}
  endcase
end
// should always output a sign extended 32 bit ImmOp
endmodule
