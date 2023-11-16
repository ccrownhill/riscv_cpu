module ControlUnit (
	input logic EQ,
	input logic Instr[31:0],

	output logic RegWrite,
	output logic ALUctrl,
	output logic ALUsrc,
	output logic ImmSrc,
	output logic PCsrc
);

always_comb begin
	casez (Instr[6:0])
		// I-type instruction
		7'b00?????: begin
			ALUctrl = 0;
			ALUSrc = 1;
			ImmSrc = 0;
			PCsrc = 0;
		end
		// R-type instruction
		7'b0110011: begin
			ALUctrl = 0;
			ALUsrc = 0;
			ImmSrc = 0;
			PCsrc = 0;
		end
		// B-type instruction
		7'b1100011: begin
			ALUctrl = 1; // subtract for comparison
			ALUsrc = 1;
			ImmSrc = 1; // for 13 bit
			PCsrc = EQ;
		end
	endcase
end

endmodule
