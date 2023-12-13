module MEMStage (
	input logic					clk_i,
  input logic         reset_i,
  input logic [31:0] 	ALUout_i,

  input logic        	RegWrite_i,
  input logic [1:0]  	WriteSrc_i,
	input logic [31:0]	regOp2_i,
  input logic        	MemWrite_i,
  input logic         MemRead_i,
  input logic [31:0] 	pcPlus4_i,
  input logic [31:0] 	ImmOp_i,
  input logic [4:0]   rd_i,
  input logic [2:0]   funct3_i,

	output logic 				RegWrite_o,
  output logic [1:0] 	WriteSrc_o,
  output logic [31:0] ALUout_o, // input for WB stage
  output logic [31:0] DataMemOut_o,
  output logic [31:0] pcPlus4_o,
  output logic [31:0] ImmOp_o,
  output logic [4:0]  rd_o,
  output logic        Mready_o
);

logic [31:0] 	MemOut;

Memory DataMem (
  .clk (clk_i),
	.Addr_i (ALUout_i),
  .WriteD_i (regOp2_i),
  .Mwrite_i (MemWrite_i),
  .Mread_i (MemRead_i),
  .funct3_i (funct3_i),

	.ReadD_o (MemOut),
  .Mready_o (Mready_o)
);

always_ff @(posedge clk_i) begin
  RegWrite_o <= (!reset_i) ? RegWrite_i : 1'b0;
  WriteSrc_o <= WriteSrc_i;
  ALUout_o <= ALUout_i;
  DataMemOut_o <= MemOut;
  pcPlus4_o <= pcPlus4_i;
  ImmOp_o <= ImmOp_i;
  rd_o <= rd_i;
end
endmodule
