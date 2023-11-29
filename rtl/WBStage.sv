module WBStage (
	input logic 				RegWrite_i,
  input logic [1:0] 	WriteSrc_i,
  input logic [31:0] 	ALUout_i, // input for WB stage
  input logic [31:0] 	DataMemOut_i,
  input logic [31:0] 	pcPlus4_i,
  input logic [31:0] 	ImmOp_i,
  input logic [4:0]  	rd_i,

  output logic        RegWrite_o,
	output logic [4:0]	rd_o,
	output logic [31:0]	WD3_o
);

Mux4 #(32) regWriteMux (
	.sel_i (WriteSrc_i),
	.in0_i (ALUout_i),
	.in1_i (DataMemOut_i),
  .in2_i (pcPlus4_i),
  .in3_i (ImmOp_i),

	.out_o (WD3_o)
);

assign RegWrite_o = RegWrite_i;
assign rd_o = rd_i;

endmodule
