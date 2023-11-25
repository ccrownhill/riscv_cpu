module EXStage (
  input logic         clk_i,
  input logic         RegWrite_i,
  input logic         ALUsrc_i,
  input logic [1:0]   WriteSrc_i,
  input logic         Branch_i,
  input logic [1:0]   ALUOp_i,
  input logic         Jump_i,
  input logic         Ret_i,
  input logic         MemWrite_i,

  input logic [31:0]  PC_i,
  input logic [31:0]  pcPlus4_i,
  input logic [31:0]  ALUop1_i,
  input logic [31:0]  regOp2_i,
  input logic [31:0]  ImmOp_i,

  input logic [4:0]   rd_i,
  input logic [2:0]   funct3_i,


  output logic        EQ_o,
  output logic [31:0] ALUout_o,

  output logic        RegWrite_o,
  output logic [1:0]  WriteSrc_o,
  output logic        Branch_o,
  output logic        Jump_o,
  output logic        Ret_o,
  output logic        MemWrite_o,
  output logic [31:0] pcPlus4_o,
  output logic [31:0] pcPlusImm_o,
  output logic [31:0] ImmOp_o,
  output logic [31:0] regOp2_o,
  output logic [4:0]  rd_o
);

logic [31:0] pcPlusImm;
logic [31:0] ALUop2;
logic [2:0] ALUctrl;

// store these in EX_MEMReg
logic        EQ;
logic [31:0] ALUout;

Adder adderImm (PC_i, ImmOp_i, pcPlusImm);

Mux2 #(32) regMux (
	.in0(regOp2_i),
	.in1(ImmOp_i),
	.sel(ALUsrc_i),
	.out(ALUop2)
);

ALUDecode ALUDecode (
  .ALUOp_i (ALUOp_i),
  .funct3_i (funct3_i),

  .ALUctrl_o (ALUctrl)
);

ALU ALU (
	.ALUop1_i (ALUop1_i),
	.ALUop2_i (ALUop2),
	.ALUctrl_i (ALUctrl),
	.EQ_o (EQ),
	.ALUout_o (ALUout)
);

EX_MEMReg EX_MEMReg (
	.clk_i (clk_i),
  .EQ_i (EQ),
  .ALUout_i (ALUout),

  .RegWrite_i (RegWrite_i),
  .WriteSrc_i (WriteSrc_i),
  .Branch_i (Branch_i),
  .Jump_i (Jump_i),
  .Ret_i (Ret_i),
  .MemWrite_i (MemWrite_i),
  .ImmOp_i (ImmOp_i),
  .pcPlus4_i (pcPlus4_i),
  .pcPlusImm_i (pcPlusImm),
  .regOp2_i (regOp2_i),
  .rd_i (rd_i),


  .EQ_o (EQ_o),
  .ALUout_o (ALUout_o),

  .RegWrite_o (RegWrite_o),
  .WriteSrc_o (WriteSrc_o),
  .Branch_o (Branch_o),
  .Jump_o (Jump_o),
  .Ret_o (Ret_o),
  .MemWrite_o (MemWrite_o),
  .ImmOp_o (ImmOp_o),
  .pcPlus4_o (pcPlus4_o),
  .pcPlusImm_o (pcPlusImm_o),
  .regOp2_o (regOp2_o),
  .rd_o (rd_o)
);

endmodule
