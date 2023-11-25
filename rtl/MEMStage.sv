module MEMStage (
	input logic					clk_i,
  input logic        	EQ_i,
  input logic [31:0] 	ALUout_i,

  input logic        	RegWrite_i,
  input logic [1:0]  	WriteSrc_i,
  input logic        	Branch_i,
	input logic [31:0]	regOp2_i,
  input logic        	Jump_i,
  input logic        	Ret_i,
  input logic        	MemWrite_i,
  input logic [31:0] 	pcPlus4_i,
	input logic [31:0] 	pcPlusImm_i,
  input logic [31:0] 	ImmOp_i,
  input logic [4:0]   rd_i,

	output logic 				RegWrite_o,
  output logic [1:0] 	WriteSrc_o,
  output logic [31:0] ALUout_o, // input for WB stage
  output logic [31:0] DataMemOut_o,
  output logic [31:0] pcPlus4_o,
  output logic [31:0] ImmOp_o,
  output logic [4:0]  rd_o,

	// input for IF stage
	output logic [1:0]	IF_PCsrc_o,
  output logic [31:0]  IF_pcPlusImm_o,
  output logic [31:0] IF_ALUout_o // ALUout output that is used as input for IF stage
);

logic [7:0] 	MemByteOut;
logic [31:0] 	MemWordOut;

PCsrcDecode PCsrcDecode (
  .EQ_i (EQ_i),
  .Branch_i (Branch_i),
  .Jump_i (Jump_i),
  .Ret_i (Ret_i),

  .PCsrc_o (IF_PCsrc_o) // output PCsrc directly to put into IF (don't put in MEM_WB register)
);

DataMem DataMem (
  .clk_i (clk_i),
	.AddressPort_i (ALUout_i),
  .WriteData_i (regOp2_i),
  .MemWrite_i (MemWrite_i),

	.ReadData_o (MemByteOut)
);

ZeroExtend ZeroExtend (
  .in_i (MemByteOut),
  .out_i (MemWordOut)
);

assign IF_pcPlusImm_o = pcPlusImm_i;
assign IF_ALUout_o = ALUout_i;

MEM_WBReg MEM_WBReg (
	.clk_i (clk_i),
	.RegWrite_i (RegWrite_i),
  .WriteSrc_i (WriteSrc_i),
  .ALUout_i (ALUout_i),
  .DataMemOut_i (MemWordOut),
  .pcPlus4_i (pcPlus4_i),
  .ImmOp_i (ImmOp_i),
  .rd_i (rd_i),

	.RegWrite_o (RegWrite_o),
  .WriteSrc_o (WriteSrc_o),
  .ALUout_o (ALUout_o),
  .DataMemOut_o (DataMemOut_o),
  .pcPlus4_o (pcPlus4_o),
  .ImmOp_o (ImmOp_o),
  .rd_o (rd_o)
);

endmodule
