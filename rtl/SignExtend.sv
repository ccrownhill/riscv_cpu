/// Sign extend immediate value to 32 bit
module SignExtend (
	input logic ImmSrc, // 0 -> 12 bit, 1 -> 13 bit
	input logic [31:7] Instr31_7,
	output logic [31:0] ImmOp
);
always_comb begin
	case (ImmSrc)
		1'b0: ImmOp = {{20{Instr31_7[31]}}, Instr31_7[31:20]};
		1'b1: ImmOp = {{20{Instr31_7[31]}}, Instr31_7[7], Instr31_7[30:25], Instr31_7[11:8], 1'b0};
	endcase
end

endmodule
