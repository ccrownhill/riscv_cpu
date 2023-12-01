module riscvpipe (
	input logic clk,
	input logic rst,
	
	output logic [31:0] a0
);

// signals for IF stage output
logic [4:0] 	rs1_IF;
logic [4:0] 	rs2_IF;
logic [4:0] 	rd_IF;
logic [31:0]	PC_IF;
logic [31:0] 	pcPlus4_IF;
logic [31:7] 	Instr31_7_IF;
logic [6:0] 	op_IF;
logic [2:0] 	funct3_IF;

// signals for ID stage output
logic        	RegWrite_ID;
logic        	ALUsrc_ID;
logic [1:0]  	WriteSrc_ID;
logic        	Branch_ID;
logic [1:0]  	ALUOp_ID;
logic        	Jump_ID;
logic       	Ret_ID;
logic        	MemWrite_ID;

logic [31:0] 	PC_ID;
logic [31:0] 	pcPlus4_ID;
logic [31:0] 	ALUop1_ID;
logic [31:0] 	regOp2_ID;
logic [31:0] 	ImmOp_ID;

logic [4:0]  	rd_ID;
logic [2:0]  	funct3_ID;

logic [4:0]   rs1D_o;
logic [4:0]   rs2D_o;

// signals for EX stage output
logic        EQ_EX;
logic [31:0] ALUout_EX;
logic        RegWrite_EX;
logic [1:0]  WriteSrc_EX;
logic        Branch_EX;
logic        Jump_EX;
logic        Ret_EX;
logic        MemWrite_EX;
logic [31:0] pcPlus4_EX;
logic [31:0] pcPlusImm_EX;
logic [31:0] ImmOp_EX;
logic [31:0] regOp2_EX;
logic [4:0]  rd_EX;

// signals for MEM stage output
logic 				RegWrite_MEM;
logic [1:0] 	WriteSrc_MEM;
logic [31:0] ALUout_MEM; // input for WB stage
logic [31:0] DataMemOut_MEM;
logic [31:0] pcPlus4_MEM;
logic [31:0] ImmOp_MEM;
logic [4:0]  rd_MEM;
	// input for IF stage
logic [1:0]	IF_PCsrc_MEM;
logic [31:0]  IF_pcPlusImm_MEM;
logic [31:0] IF_ALUout_MEM; // ALUout output that is used as input for IF stage

// signals for WB stage output
logic RegWrite_WB;
logic [4:0] rd_WB;
logic [31:0] WD3_WB;

//signals for hazard stage
logic [1:0] ForwardAE_HAZ;
logic [1:0] ForwardBE_HAZ;

IFStage IFStage (
  .clk_i (clk),
  .rst_i (rst),
  .PCsrc_i (IF_PCsrc_MEM),
  .pcPlusImm_i (IF_pcPlusImm_MEM),
  .ALUout_i (IF_ALUout_MEM),

  .rs1_o (rs1_IF),
  .rs2_o (rs2_IF),
  .rd_o (rd_IF),
  .Instr31_7_o (Instr31_7_IF),
  .op_o (op_IF),
  .funct3_o (funct3_IF),
  .PC_o (PC_IF),
	.pcPlus4_o (pcPlus4_IF)
);

IDStage IDStage (
  .clk_i (clk),
  .rs1_i (rs1_IF),
  .rs2_i (rs2_IF),
  .Instr31_7_i (Instr31_7_IF),
  .rd_i (rd_IF),
  .op_i (op_IF),
  .PC_i (PC_IF),
  .pcPlus4_i (pcPlus4_IF),
	.funct3_i (funct3_IF),

  .RegWriteWB_i (RegWrite_WB),
  .writeRegAddr_i (rd_WB),
  .WD3_i (WD3_WB),

  .RegWrite_o (RegWrite_ID),
  .ALUsrc_o (ALUsrc_ID),
  .WriteSrc_o (WriteSrc_ID),
  .Branch_o (Branch_ID),
  .ALUOp_o (ALUOp_ID),
  .Jump_o (Jump_ID),
  .Ret_o (Ret_ID),
  .MemWrite_o (MemWrite_ID),
  .PC_o (PC_ID),
  .pcPlus4_o (pcPlus4_ID),
  .ALUop1_o (ALUop1_ID),
  .regOp2_o (regOp2_ID),
  .ImmOp_o (ImmOp_ID),
  .rd_o (rd_ID),
  .funct3_o (funct3_ID),
  .a0_o (a0),

  //hazard
  .rs1_o(rs1D_o),
  .rs2_o(rs2D_o)
);

EXStage EXStage (
  .clk_i (clk),

  .RegWrite_i (RegWrite_ID),
  .ALUsrc_i (ALUsrc_ID),
  .WriteSrc_i (WriteSrc_ID),
  .Branch_i (Branch_ID),
  .ALUOp_i (ALUOp_ID),
  .Jump_i (Jump_ID),
  .Ret_i (Ret_ID),
  .MemWrite_i (MemWrite_ID),
  .PC_i (PC_ID),
  .pcPlus4_i (pcPlus4_ID),
  //.ALUop1_i (ALUop1_ID),
  //.regOp2_i (regOp2_ID),
  .ImmOp_i (ImmOp_ID),
  .rd_i (rd_ID),
  .funct3_i (funct3_ID),


  .EQ_o (EQ_EX),
  .ALUout_o (ALUout_EX),

  .RegWrite_o (RegWrite_EX),
  .WriteSrc_o (WriteSrc_EX),
  .Branch_o (Branch_EX),
  .Jump_o (Jump_EX),
  .Ret_o (Ret_EX),
  .MemWrite_o (MemWrite_EX),
  .ImmOp_o (ImmOp_EX),
  .pcPlus4_o (pcPlus4_EX),
  .pcPlusImm_o (pcPlusImm_EX),
  .regOp2_o (regOp2_EX),
  .rd_o (rd_EX),

  // for hazard multiplexers
  .ALUResultM_i(ALUout_EX),
  .RD1E(ALUop1_ID), // order is correct 
  .RD2E(regOp2_ID), // 
  .ForwardAE(ForwardAE_HAZ),
  .ForwardBE(ForwardBE_HAZ),
  .ResultW(WD3_WB)
);

MEMStage MEMStage (
  .clk_i (clk),
  .EQ_i (EQ_EX),
  .ALUout_i (ALUout_EX),

  .RegWrite_i (RegWrite_EX),
  .WriteSrc_i (WriteSrc_EX),
  .Branch_i (Branch_EX),
  .Jump_i (Jump_EX),
  .Ret_i (Ret_EX),
  .MemWrite_i (MemWrite_EX),
  .ImmOp_i (ImmOp_EX),
  .pcPlus4_i (pcPlus4_EX),
  .pcPlusImm_i (pcPlusImm_EX),
  .regOp2_i (regOp2_EX),
  .rd_i (rd_EX),

	.RegWrite_o (RegWrite_MEM),
  .WriteSrc_o (WriteSrc_MEM),
  .ALUout_o (ALUout_MEM),
  .DataMemOut_o (DataMemOut_MEM),
  .pcPlus4_o (pcPlus4_MEM),
  .ImmOp_o (ImmOp_MEM),
  .rd_o (rd_MEM),

	.IF_PCsrc_o (IF_PCsrc_MEM),
  .IF_pcPlusImm_o (IF_pcPlusImm_MEM),
  .IF_ALUout_o (IF_ALUout_MEM)
);

WBStage WBStage (
	.RegWrite_i (RegWrite_MEM),
  .WriteSrc_i (WriteSrc_MEM),
  .ALUout_i (ALUout_MEM),
  .DataMemOut_i (DataMemOut_MEM),
  .pcPlus4_i (pcPlus4_MEM),
  .ImmOp_i (ImmOp_MEM),
  .rd_i (rd_MEM),

	.RegWrite_o (RegWrite_WB),
	.rd_o (rd_WB),
	.WD3_o (WD3_WB)
);

Hazard Hazard  (
//.clk_i(clk),
  .Rs1E_i(rs1D_o),
  .Rs2E_i(rs2D_o),
  .RdM_i(rd_MEM),
  .RdW_i(rd_WB),
//  .ResultW(),
  .RegWriteM_i(RegWrite_EX),
  .RegWriteW_i(RegWrite_MEM),
  .ForwardAE(ForwardAE_HAZ),
  .ForwardBE(ForwardBE_HAZ)
);

endmodule
