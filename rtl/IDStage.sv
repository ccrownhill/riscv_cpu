module IDStage (
	input logic					clk_i,

	input logic [4:0]   rs1_i,
	input logic [4:0]   rs2_i,
	input logic [4:0]   rd_i,
  input logic [31:7]  Instr31_7_i,
  input logic [6:0]   op_i,
  input logic [2:0]   funct3_i,
  input logic [31:0]  PC_i,
  input logic [31:0]  pcPlus4_i,
  input logic         RegWriteWB_i, // from WB stage
  input logic [4:0]   writeRegAddr_i, // write address from WB stage
  input logic [31:0]  WD3_i, // write data from WB stage

	output logic        RegWrite_o,
	output logic        ALUsrc_o,
	output logic [1:0]  WriteSrc_o,
	output logic        Branch_o,
	output logic [1:0]  ALUOp_o,
	output logic        Jump_o,
  output logic        Ret_o,
  output logic        MemWrite_o,

	output logic [31:0] PC_o,
  output logic [31:0] pcPlus4_o,
  output logic [31:0] ALUop1_o,
  output logic [31:0] regOp2_o,
  output logic [31:0] ImmOp_o,

  output logic [4:0]  rd_o,
  output logic [2:0]  funct3_o,

	output logic [31:0]	a0_o
);


logic        RegWrite;
logic [2:0]  ImmSrc;
logic        ALUsrc;
logic [1:0]  WriteSrc;
logic        Branch;
logic [1:0]  ALUOp;
logic        Jump;
logic        Ret;
logic        MemWrite;

logic [31:0] ALUop1;
logic [31:0] regOp2;
logic [31:0] ImmOp;



MainDecode MainDecode (
  .op_i (op_i),

  .RegWrite_o (RegWrite),
  .ImmSrc_o (ImmSrc),
  .ALUsrc_o (ALUsrc),
  .WriteSrc_o (WriteSrc),
  .Branch_o (Branch),
  .ALUOp_o (ALUOp),
  .Jump_o (Jump),
  .MemWrite_o (MemWrite),
  .Ret_o (Ret)
);

RegFile RegFile(
  .clk (clk_i),
  .AD1 (rs1_i),
  .AD2 (rs2_i),
  .AD3 (writeRegAddr_i),
  .WE3 (RegWriteWB_i),
  .WD3 (WD3_i),
  .RD1 (ALUop1),
  .RD2 (regOp2),

  .a0_o (a0_o)
);

SignExtend SignExtend(
  .Instr31_7 (Instr31_7_i),
  .ImmSrc (ImmSrc),

  .ImmOp (ImmOp)
);

ID_EXReg ID_EXReg (
  .clk_i (clk_i),

  .RegWrite_i (RegWrite),
  .ALUsrc_i (ALUsrc),
  .WriteSrc_i (WriteSrc),
  .Branch_i (Branch),
  .ALUOp_i (ALUOp),
  .Jump_i (Jump),
  .Ret_i (Ret),
  .MemWrite_i (MemWrite),

  .PC_i (PC_i),
  .pcPlus4_i (pcPlus4_i),
  .ALUop1_i (ALUop1),
  .regOp2_i (regOp2),
  .ImmOp_i (ImmOp),

  .rd_i (rd_i),
  .funct3_i (funct3_i),


  .RegWrite_o (RegWrite_o),
  .ALUsrc_o (ALUsrc_o),
  .WriteSrc_o (WriteSrc_o),
  .Branch_o (Branch_o),
  .ALUOp_o (ALUOp_o),
  .Jump_o (Jump_o),
  .Ret_o (Ret_o),
  .MemWrite_o (MemWrite_o),

  .PC_o (PC_o),
  .pcPlus4_o (pcPlus4_o),
  .ALUop1_o (ALUop1_o),
  .regOp2_o (regOp2_o),
  .ImmOp_o (ImmOp_o),

  .rd_o (rd_o),
  .funct3_o (funct3_o)
);
endmodule
