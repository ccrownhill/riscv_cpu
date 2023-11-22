module MainDecode (
	input logic [6:0] op,
	input logic EQ,

	output logic RegWrite,
	output logic ALUctrl,
	output logic ALUsrc,
	output logic ImmSrc,
	output logic PCsrc,
	output logic WriteSrc
);

logic [5:0] controls;
logic Branch;

assign {RegWrite, ALUsrc, ImmSrc, WriteSrc, ALUctrl, Branch} = controls;

always_comb
	// RegWrite_ALUsrc_ImmSrc_WriteSrc_ALUctrl_Branch
	case (op)
		7'b0110011: controls = 6'b1_0_x_0_0_0; // R-type ALU
		7'b0010011: controls = 6'b1_1_0_0_0_0; // I-type ALU
		7'b0000011: controls = 6'b1_1_0_1_0_0; // lw
		7'b1100011: controls = 6'b0_1_1_x_1_1; // bne
		default: controls = 6'bx_x_x_x_x_x;
	endcase

assign PCsrc = Branch & (!EQ);

// always_comb begin
// 	casez (Instr[6:0])
// 		// I-type instruction
// 		7'b00?????: begin
// 			ALUctrl = 1'b0;
// 			ALUsrc = 1'b1;
// 			ImmSrc = 1'b0;
// 			PCsrc = 1'b0;
// 			RegWrite = 1'b1;
// 			// for loading memory
// 			if (Instr[6:0] == 7'b0000011)
// 				WriteSrc = 1'b1;
// 			else
// 				WriteSrc = 1'b0;
// 		end
// 		// R-type instruction
// 		7'b0110011: begin
// 			ALUctrl = 1'b0;
// 			ALUsrc = 1'b0;
// 			ImmSrc = 1'b0;
// 			PCsrc = 1'b0;
// 			RegWrite = 1'b1;
// 			WriteSrc = 1'b0;
// 		end
// 		// B-type instruction
// 		7'b1100011: begin
// 			ALUctrl = 1'b1; // subtract for comparison
// 			ALUsrc = 1'b0; // compare two registers
// 			ImmSrc = 1'b1; // for 13 bit
// 			PCsrc = !EQ;
// 			RegWrite = 1'b0;
// 			WriteSrc = 1'b0;
// 		end
// 		default: begin
// 			ALUctrl = 1'b0;
// 			ALUsrc = 1'b0;
// 			ImmSrc = 1'b0;
// 			PCsrc = 1'b0;
// 			RegWrite = 1'b0;
// 			WriteSrc = 1'b0;
// 		end
// 	endcase
// end

endmodule
