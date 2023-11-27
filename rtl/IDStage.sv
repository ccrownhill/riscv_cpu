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
  input logic         controlZeroSel_i,

	output logic        RegWrite_o,
	output logic        ALUsrc_o,
	output logic [1:0]  WriteSrc_o,
	output logic [1:0]  ALUOp_o,
  output logic        MemRead_o,
  output logic        MemWrite_o,

  output logic [31:0] pcPlus4_o,
  output logic [31:0] ALUop1_o,
  output logic [31:0] regOp2_o,
  output logic [31:0] ImmOp_o,

  output logic [4:0]  rs1_o,
  output logic [4:0]  rs2_o,
  output logic [4:0]  rd_o,
  output logic [2:0]  funct3_o,

	output logic [31:0]	a0_o,

  // input for HazardDetectionUnit
  output logic Branch_o,
  output logic Jump_o,
  output logic Ret_o,
  output logic EQ_o,
	// input for IF stage
	output logic [1:0]	IF_PCsrc_o,
  output logic [31:0]  IF_pcPlusImm_o,
  output logic [31:0] IF_regPlusImm_o // ALUout output that is used as input for IF stage
);


logic        RegWrite;
logic [2:0]  ImmSrc;
logic        ALUsrc;
logic [1:0]  WriteSrc;
logic [1:0]  ALUOp;
logic        MemRead;
logic        MemWrite;
logic        Jump;


logic        RegWriteAfterReset;
logic        ALUsrcAfterReset;
logic [1:0]  WriteSrcAfterReset;
logic [1:0]  ALUOpAfterReset;
logic        MemReadAfterReset;
logic        MemWriteAfterReset;

logic [31:0] ALUop1;
logic [31:0] regOp2;
logic [31:0] ImmOp;

MainDecode MainDecode (
  .op_i (op_i),

  .RegWrite_o (RegWrite),
  .ImmSrc_o (ImmSrc),
  .ALUsrc_o (ALUsrc),
  .WriteSrc_o (WriteSrc),
  .ALUOp_o (ALUOp),
  .Branch_o (Branch_o),
  .Jump_o (Jump_o),
  .Ret_o (Ret_o),
  .MemRead_o (MemRead),
  .MemWrite_o (MemWrite)
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

Adder adderImm (PC_i, ImmOp, IF_pcPlusImm_o);
Adder adderRegImm (ALUop1, ImmOp, IF_regPlusImm_o);

assign EQ_o = (ALUop1 == regOp2) ? 1'b1 : 1'b0;

PCsrcDecode PCsrcDecode (
  .EQ_i (EQ_o),
  .Branch_i (Branch_o),
  .Jump_i (Jump_o),
  .Ret_i (Ret_o),

  .PCsrc_o (IF_PCsrc_o) // output PCsrc directly to put into IF (don't put in MEM_WB register)
);


ControlResetMux ControlResetMux (
  .controlZeroSel_i (controlZeroSel_i),
  .RegWrite_i (RegWrite),
  .ALUsrc_i (ALUsrc),
  .WriteSrc_i (WriteSrc),
  .ALUOp_i (ALUOp),
  .MemRead_i (MemRead),
  .MemWrite_i (MemWrite),

  .RegWrite_o (RegWriteAfterReset),
  .ALUsrc_o (ALUsrcAfterReset),
  .WriteSrc_o (WriteSrcAfterReset),
  .ALUOp_o (ALUOpAfterReset),
  .MemRead_o (MemReadAfterReset),
  .MemWrite_o (MemWriteAfterReset)
);

ID_EXReg ID_EXReg (
  .clk_i (clk_i),

  .RegWrite_i (RegWriteAfterReset),
  .ALUsrc_i (ALUsrcAfterReset),
  .WriteSrc_i (WriteSrcAfterReset),
  .ALUOp_i (ALUOpAfterReset),
  .MemRead_i (MemReadAfterReset),
  .MemWrite_i (MemWriteAfterReset),

  .pcPlus4_i (pcPlus4_i),
  .ALUop1_i (ALUop1),
  .regOp2_i (regOp2),
  .ImmOp_i (ImmOp),

  .rs1_i (rs1_i),
  .rs2_i (rs2_i),
  .rd_i (rd_i),
  .funct3_i (funct3_i),


  .RegWrite_o (RegWrite_o),
  .ALUsrc_o (ALUsrc_o),
  .WriteSrc_o (WriteSrc_o),
  .ALUOp_o (ALUOp_o),
  .MemRead_o (MemRead_o),
  .MemWrite_o (MemWrite_o),

  .pcPlus4_o (pcPlus4_o),
  .ALUop1_o (ALUop1_o),
  .regOp2_o (regOp2_o),
  .ImmOp_o (ImmOp_o),

  .rs1_o (rs1_o),
  .rs2_o (rs2_o),
  .rd_o (rd_o),
  .funct3_o (funct3_o)
);
endmodule
