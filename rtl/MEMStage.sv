module MEMStage (
	input logic					clk_i,
  input logic [31:0] 	ALUout_i,

  input logic        	RegWrite_i,
  input logic [1:0]  	WriteSrc_i,
	input logic [31:0]	regOp2_i,
  input logic        	MemWrite_i,
  input logic [31:0] 	pcPlus4_i,
  input logic [31:0] 	ImmOp_i,
  input logic [4:0]   rd_i,

	output logic 				RegWrite_o,
  output logic [1:0] 	WriteSrc_o,
  output logic [31:0] ALUout_o, // input for WB stage
  output logic [31:0] DataMemOut_o,
  output logic [31:0] pcPlus4_o,
  output logic [31:0] ImmOp_o,
  output logic [4:0]  rd_o
);

logic [7:0] 	MemByteOut;
logic [31:0] 	MemWordOut;

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

always_ff @(posedge clk_i) begin
  RegWrite_o <= RegWrite_i;
  WriteSrc_o <= WriteSrc_i;
  ALUout_o <= ALUout_i;
  DataMemOut_o <= MemWordOut;
  pcPlus4_o <= pcPlus4_i;
  ImmOp_o <= ImmOp_i;
  rd_o <= rd_i;
end
endmodule
