/// Sign extend immediate value to 32 bit
module SignExtend (
	input logic ImmSrc; // 0 -> 12 bit, 1 -> 13 bit
	input logic Instr[31:0];
	output logic ImmOp[31:0];
);

if (ImmSrc == 1'b0) begin
	assign ImmOp = {{20{Instr[31]}}, Instr[31:20]};
end
else begin
	assign ImmOp = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0}

end

endmodule
