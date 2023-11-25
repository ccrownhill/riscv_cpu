module EX_MEMReg (
	input logic					clk_i,
	input logic        	EQ_i,
  input logic [31:0] 	ALUout_i,

  input logic        	RegWrite_i,
  input logic [1:0]  	WriteSrc_i,
  input logic        	Branch_i,
  input logic        	Jump_i,
  input logic        	Ret_i,
  input logic        	MemWrite_i,
  input logic [31:0]  ImmOp_i,
  input logic [31:0]  pcPlus4_i,
  input logic [31:0]  pcPlusImm_i,
  input logic [31:0]  regOp2_i,
  input logic [4:0]   rd_i,
        
  output logic        EQ_o,
  output logic [31:0] ALUout_o,

  output logic        RegWrite_o,
  output logic [1:0]  WriteSrc_o,
  output logic        Branch_o,
  output logic        Jump_o,
  output logic        Ret_o,
  output logic        MemWrite_o,
  output logic [31:0] ImmOp_o,
  output logic [31:0] pcPlus4_o,
  output logic [31:0] pcPlusImm_o,
  output logic [31:0] regOp2_o,
  output logic [4:0]  rd_o
);

always_ff @(posedge clk_i) begin
  EQ_o <= EQ_i;
  ALUout_o <= ALUout_i;

  RegWrite_o <= RegWrite_i;
  WriteSrc_o <= WriteSrc_i;
  Branch_o <= Branch_i;
  Jump_o <= Jump_i;
  Ret_o <= Ret_i;
  MemWrite_o <= MemWrite_i;
  ImmOp_o <= ImmOp_i;
  pcPlus4_o <= pcPlus4_i;
  pcPlusImm_o <= pcPlusImm_i;
  regOp2_o <= regOp2_i;
  rd_o <= rd_i;
end

endmodule
