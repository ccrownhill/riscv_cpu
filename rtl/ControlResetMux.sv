module ControlResetMux (
	input logic					controlZeroSel_i,
	input logic        	RegWrite_i,
	input logic        	ALUsrc_i,
	input logic [1:0]  	WriteSrc_i,
	input logic [1:0]  	ALUOp_i,
  input logic        	MemRead_i,
  input logic        	MemWrite_i,

	output logic        RegWrite_o,
	output logic        ALUsrc_o,
	output logic [1:0]  WriteSrc_o,
	output logic [1:0]  ALUOp_o,
  output logic        MemRead_o,
  output logic        MemWrite_o
);

always_comb begin
  if (controlZeroSel_i == 1'b1)
    {RegWrite_o, ALUsrc_o, WriteSrc_o, ALUOp_o, MemRead_o, MemWrite_o} = 8'b0;
  else
    {RegWrite_o, ALUsrc_o, WriteSrc_o, ALUOp_o, MemRead_o, MemWrite_o} = {RegWrite_i, ALUsrc_i, WriteSrc_i, ALUOp_i, MemRead_i, MemWrite_i};
end
	

endmodule
