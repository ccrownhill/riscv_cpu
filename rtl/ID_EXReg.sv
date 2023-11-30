module ID_EXReg (
  input logic        clk_i,
  input logic        RegWrite_i,
  input logic        ALUsrc_i,
  input logic [1:0]  WriteSrc_i,
  input logic        Branch_i,
  input logic [1:0]  ALUOp_i,
  input logic        Jump_i,
  input logic        Ret_i,
  input logic        MemWrite_i,

  input logic [31:0] PC_i,
  input logic [31:0] pcPlus4_i,
  input logic [31:0] ALUop1_i,
  input logic [31:0] regOp2_i,
  input logic [31:0] ImmOp_i,

  input logic [4:0]  rd_i,
  input logic [2:0]  funct3_i,

  //hazard
  input logic [4:0] rs1_i,
  input logic [4:0] rs2_i,

  output logic [4:0] rs1_o,
  output logic [4:0] rs2_o,
  //end 

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
  output logic [2:0]  funct3_o
);

always_ff @(posedge clk_i) begin
	RegWrite_o <= RegWrite_i;
	ALUsrc_o <= ALUsrc_i;
	WriteSrc_o <= WriteSrc_i;
	Branch_o <= Branch_i;
	ALUOp_o <= ALUOp_i;
	Jump_o <= Jump_i;
	Ret_o <= Ret_i;
	MemWrite_o <= MemWrite_i;
	
	PC_o <= PC_i;
  pcPlus4_o <= pcPlus4_i;
	ALUop1_o <= ALUop1_i;
	regOp2_o <= regOp2_i;
	ImmOp_o <= ImmOp_i;
	
	rd_o <= rd_i;
	funct3_o <= funct3_i;

  // hazard
  rs1_o <= rs1_i;
  rs2_o <= rs2_i;
end
	
endmodule
