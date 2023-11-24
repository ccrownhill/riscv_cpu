module MainDecode (
	input logic [6:0]   op_i,

	output logic        RegWrite_o,
	output logic [2:0]  ImmSrc_o,
	output logic        ALUsrc_o,
	output logic [1:0]  WriteSrc_o,
	output logic        Branch_o,
	output logic [1:0]  ALUOp_o,
	output logic        Jump_o,
  output logic        Ret_o,
  output logic        MemWrite_o
);

logic [12:0] controls;

// assign {RegWrite_o, ImmSrc_o, ALUsrc_o, WriteSrc_o, Branch_o, ALUOp_o, Jump_o, MemWrite_o, PCsrc_o} = controls;
assign {RegWrite_o, ImmSrc_o, ALUsrc_o, WriteSrc_o, ALUOp_o, MemWrite_o, Branch_o, Jump_o, Ret_o} = controls;

//ImmSrc is 2 bits 10 = PC+4, 01 = Memory 00 = ALUout
//

always_comb
	// RegWrite_ImmSrc_ALUsrc_WriteSrc_Branch_ALUOp_Jump_MemWrite_PCsrc
	// RegWrite_ImmSrc_ALUsrc_WriteSrc_ALUOp_MemWrite_PCsrc
	case (op_i)
		7'b1101111: controls = 13'b1_011_x_10_xx_0_0_1_0; // jal
		7'b1100111: controls = 13'b1_000_1_10_10_0_0_0_1; // jalr
		7'b0010011: controls = 13'b1_000_1_00_10_0_0_0_0; // addi + slli + srli + andi
		7'b0110011: controls = 13'b1_xxx_0_00_10_0_0_0_0; // add + xor + and(r-type)
		7'b0100011: controls = 13'b0_001_1_xx_00_1_0_0_0; // sb
		7'b1100011: controls = 13'b0_010_0_xx_01_0_1_0_0; // bne
		7'b0110111: controls = 13'b1_100_x_11_xx_0_0_0_0; // lui u-type
		7'b0000011: controls = 13'b1_000_1_01_00_0_0_0_0; // lbu(i-type)
		default: controls = 13'bx_xxx_x_xx_xx_x_x_x_x;
	endcase
// 		7'b1101111: controls = 12'b1_011_x_10_0_xx_1_0; // jal
// 		7'b1100111: controls = 12'b1_000_1_10_0_10_1_0; // jalr
// 		7'b0010011: controls = 12'b1_000_1_00_0_10_0_0; // addi + slli + srli + andi
// 		7'b0110011: controls = 12'b1_xxx_0_00_0_10_0_0; // add + xor + and(r-type)
// 		7'b0100011: controls = 12'b0_001_1_xx_0_00_0_1; // sb
// 		7'b1100011: controls = 12'b0_010_0_xx_1_01_0_0; // bne
// 		7'b0110111: controls = 12'b1_100_x_11_0_xx_0_0; // lui u-type
// 		7'b0000011: controls = 12'b1_000_1_01_0_00_0_0; // lbu(i-type)
// 		default: controls = 12'bx_xxx_x_xx_x_xx_x_x;
// 	endcase


endmodule
