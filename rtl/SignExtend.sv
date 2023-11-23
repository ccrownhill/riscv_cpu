/// Sign extend immediate value to 32 bit
/// There are 4 cases of immediates that must be formed
module SignExtend (
	input logic [2:0] ImmSrc, // 000 = I type, 001 = S, 010 = B, 011 = J, 100 = U
	input logic [31:7] Instr31_7,
	output logic [31:0] ImmOp
);	

always_comb begin
	case (ImmSrc)
		3'b000: ImmOp = {{20{Instr31_7[31]}}, Instr31_7[31:20]};
		3'b001: ImmOp = {{20{Instr31_7[31]}}, Instr31_7[31:25], Instr31_7[11:7]}
		3'b010: ImmOp = {{19{Instr31_7[31]}}, Instr31_7[31], Instr31_7[7], Instr31_7[30:25], Instr31_7[11:8], 1'b0}
		3'b011: ImmOp = {{11{Instr31_7[31]}}, Instr31_7[31], Instr31_7[19:12], Instr31_7[20], Instr31_7[30:21], 1'b0}
    3'b100: ImmOp = {{12(Instr31_7[31]}}, Instr31_7[31:12]};
	endcase
end
// should always output a sign extended 32 bit ImmOp
endmodule
