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
logic         funct7_5_IF;

IFStage IFStage (
  .clk_i (clk),
  .flush_i (IF_Flush),
  .IF_ID_En_i (IF_ID_En),
  .PCEn_i (PCEn),
  .rst_i (rst),
  .PCsrc_i (IF_PCsrc_ID),
  .pcPlusImm_i (IF_pcPlusImm_ID),
  .regPlusImm_i (IF_regPlusImm_ID),

  .rs1_o (rs1_IF),
  .rs2_o (rs2_IF),
  .rd_o (rd_IF),
  .Instr31_7_o (Instr31_7_IF),
  .op_o (op_IF),
  .funct3_o (funct3_IF),
  .funct7_5_o (funct7_5_IF),
  .PC_o (PC_IF),
	.pcPlus4_o (pcPlus4_IF)
);


// output signals for hazard unit
logic PCEn;
logic IF_ID_En;
logic controlZeroSel; // make this an input for MainDecode and set everything to 0 if it is set
logic IF_Flush;


HazardDetectionUnit HazardDetectionUnit (
  .MemRead_ID_EX_i (MemRead_ID),
  .rd_ID_EX_i (rd_ID),
  .rd_EX_MEM_i (rd_EX),
  .RegWrite_ID_EX_i (RegWrite_ID),
  .RegWrite_EX_MEM_i (RegWrite_EX),
  .rs1_IF_ID_i (rs1_IF),
  .rs2_IF_ID_i (rs2_IF),
  .Branch_i (Branch_ID),
  .Jump_i (Jump_ID),
  .Ret_i (Ret_ID),
  .EQ_i (EQ_ID),

  .IF_Flush_o (IF_Flush),
  .PCEn_o (PCEn),
  .IF_ID_En_o (IF_ID_En),
  .controlZeroSel_o (controlZeroSel)
);


// signals for ID stage output
logic        	RegWrite_ID;
logic        	ALUsrc_ID;
logic [1:0]  	WriteSrc_ID;
logic [1:0]  	ALUOp_ID;
logic        	MemRead_ID;
logic        	MemWrite_ID;

logic [31:0] 	pcPlus4_ID;
logic [31:0] 	ALUop1_ID;
logic [31:0] 	regOp2_ID;
logic [31:0] 	ImmOp_ID;

logic [4:0]   rs1_ID;
logic [4:0]   rs2_ID;
logic [4:0]  	rd_ID;
logic [2:0]  	funct3_ID;
logic         funct7_5_ID;
// input for HazardDetectionUnit
logic Branch_ID;
logic Jump_ID;
logic Ret_ID;
logic EQ_ID;
// input for IF stage
logic [1:0]	IF_PCsrc_ID;
logic [31:0]  IF_pcPlusImm_ID;
logic [31:0] IF_regPlusImm_ID; // ALUout output that is used as input for IF stage


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
  .funct7_5_i (funct7_5_IF),

  .RegWriteWB_i (RegWrite_WB),
  .writeRegAddr_i (rd_WB),
  .WD3_i (WD3_WB),
  .controlZeroSel_i (controlZeroSel),

  .RegWrite_o (RegWrite_ID),
  .ALUsrc_o (ALUsrc_ID),
  .WriteSrc_o (WriteSrc_ID),
  .ALUOp_o (ALUOp_ID),
  .MemRead_o (MemRead_ID),
  .MemWrite_o (MemWrite_ID),
  .pcPlus4_o (pcPlus4_ID),
  .ALUop1_o (ALUop1_ID),
  .regOp2_o (regOp2_ID),
  .ImmOp_o (ImmOp_ID),
  .rs1_o (rs1_ID),
  .rs2_o (rs2_ID),
  .rd_o (rd_ID),
  .funct3_o (funct3_ID),
  .funct7_5_o (funct7_5_ID),
  .a0_o (a0),

  .Branch_o (Branch_ID),
  .Jump_o (Jump_ID),
  .Ret_o (Ret_ID),
  .EQ_o (EQ_ID),

  .IF_PCsrc_o (IF_PCsrc_ID),
  .IF_pcPlusImm_o (IF_pcPlusImm_ID),
  .IF_regPlusImm_o (IF_regPlusImm_ID)
);


// signals for Forward Unit
logic [1:0]   F1Sel;
logic [1:0]   F2Sel;
logic [31:0]  forwardOp1;
logic [31:0]  forwardOp2;
logic         EX_ImmOpSel;
logic [31:0]  forward_EX;


ForwardUnit ForwardUnit (
  .rs1 (rs1_ID),
  .rs2 (rs2_ID),
  .EX_MEM_rd (rd_EX),
  .MEM_WB_rd (rd_MEM),
  .EX_MEM_RegWrite (RegWrite_EX),
  .EX_MEM_WriteSrc (WriteSrc_EX),
  .MEM_WB_RegWrite (RegWrite_MEM),

  .F1Sel (F1Sel),
  .F2Sel (F2Sel),
  .EX_ImmOpSel (EX_ImmOpSel)
);

Mux2 #(32) exForwardOpMux (
  .sel (EX_ImmOpSel),
  .in0 (ALUout_EX),
  .in1 (ImmOp_EX),
  .out (forward_EX)
);

Mux3 #(32) f1Mux (
  .sel_i (F1Sel),
  .in0_i (ALUop1_ID),
  .in1_i (forward_EX),
  .in2_i (WD3_WB),

  .out_o (forwardOp1)
);

Mux3 #(32) f2Mux (
  .sel_i (F2Sel),
  .in0_i (regOp2_ID),
  .in1_i (forward_EX),
  .in2_i (WD3_WB),

  .out_o (forwardOp2)
);



// signals for EX stage output
logic [31:0] ALUout_EX;
logic        RegWrite_EX;
logic [1:0]  WriteSrc_EX;
logic        MemWrite_EX;
logic [31:0] pcPlus4_EX;
logic [31:0] ImmOp_EX;
logic [31:0] regOp2_EX;
logic [4:0]  rd_EX;


EXStage EXStage (
  .clk_i (clk),

  .RegWrite_i (RegWrite_ID),
  .ALUsrc_i (ALUsrc_ID),
  .WriteSrc_i (WriteSrc_ID),
  .ALUOp_i (ALUOp_ID),
  .MemWrite_i (MemWrite_ID),
  .pcPlus4_i (pcPlus4_ID),
  .ALUop1_i (forwardOp1),
  .regOp2_i (forwardOp2),
  .ImmOp_i (ImmOp_ID),
  .rd_i (rd_ID),
  .funct3_i (funct3_ID),
  .funct7_5_i (funct7_5_ID),


  .ALUout_o (ALUout_EX),

  .RegWrite_o (RegWrite_EX),
  .WriteSrc_o (WriteSrc_EX),
  .MemWrite_o (MemWrite_EX),
  .ImmOp_o (ImmOp_EX),
  .pcPlus4_o (pcPlus4_EX),
  .regOp2_o (regOp2_EX),
  .rd_o (rd_EX)
);



// signals for MEM stage output
logic 				RegWrite_MEM;
logic [1:0] 	WriteSrc_MEM;
logic [31:0] ALUout_MEM; // input for WB stage
logic [31:0] DataMemOut_MEM;
logic [31:0] pcPlus4_MEM;
logic [31:0] ImmOp_MEM;
logic [4:0]  rd_MEM;


MEMStage MEMStage (
  .clk_i (clk),
  .ALUout_i (ALUout_EX),

  .RegWrite_i (RegWrite_EX),
  .WriteSrc_i (WriteSrc_EX),
  .MemWrite_i (MemWrite_EX),
  .ImmOp_i (ImmOp_EX),
  .pcPlus4_i (pcPlus4_EX),
  .regOp2_i (regOp2_EX),
  .rd_i (rd_EX),

	.RegWrite_o (RegWrite_MEM),
  .WriteSrc_o (WriteSrc_MEM),
  .ALUout_o (ALUout_MEM),
  .DataMemOut_o (DataMemOut_MEM),
  .pcPlus4_o (pcPlus4_MEM),
  .ImmOp_o (ImmOp_MEM),
  .rd_o (rd_MEM)
);



// signals for WB stage output
logic RegWrite_WB;
logic [4:0] rd_WB;
logic [31:0] WD3_WB;


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

endmodule
