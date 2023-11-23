module MainDecode (
	input logic [6:0] op,

	output logic RegWrite,
	output logic [2:0] ImmSrc,
	output logic ALUsrc,
	output logic [1:0] WriteSrc,
	output logic Branch
	output logic [1:0] ALUOp
	output logic Jump
);

logic [10:0] controls;

assign {RegWrite, ImmSrc, ALUsrc, WriteSrc, Branch, ALUOp, Jump} = controls;

//ImmSrc is 2 bits 10 = PC+4, 01 = Memory 00 = ALUout
//

always_comb
	// RegWrite_ImmSrc_ALUsrc_WriteSrc_Branch_ALUOp_Jump
	case (op)
		7'b1101111: controls = 11'b1_011_x_10_0_xx_1; // jal
		7b'1100111: controls = 11'b1_000_0_10_0_10_0; // jalr(not sure it's j-type but different from jal)
		7b'0010011: controls = 11'b1_000_1_00_0_10_0; // addi + slli + srli + andi
		7b'0110011: controls = 11'b1_xxx_0_00_0_10_0; // add + xor + and(r-type)
		7b'0100011: controls = 11'b0_001_1_xx_0_00_0; // sb
		7b'1100011: controls = 11'b0_010_0_xx_1_01_0; // bne
		7b'0110111: controls = 11'b1_100_x_11_0_xx_0; // lui u-type
		7b'0000011: controls = 11'b1_000_1_01_0_00_0; // lbu(i-type)
		default: controls = 11'bx_xxx_x_xx_x_xx_x;
	endcase



endmodule
