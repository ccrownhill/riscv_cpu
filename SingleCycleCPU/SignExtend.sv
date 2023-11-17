/// Sign extend immediate value to 32 bit
module SignExtend #(
	parameter DATA_WIDTH = 32
)(
	input logic ImmSrc, // 0 -> 12 bit, 1 -> 13 bit
	input logic [DATA_WIDTH-1:0] Instr,
	output logic [DATA_WIDTH-1:0] ImmOp
);
always_comb begin
	if (ImmSrc == 1'b0) begin
		ImmOp = {{20{Instr[DATA_WIDTH-1]}}, Instr[DATA_WIDTH-1:20]};
	end
	else begin
		ImmOp = {{20{Instr[DATA_WIDTH-1]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};
	end
end

endmodule
