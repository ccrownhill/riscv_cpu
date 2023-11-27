module EX_MEMReg (
	input logic					clk_i,
  input logic [31:0] 	ALUout_i,

  input logic        	RegWrite_i,
  input logic [1:0]  	WriteSrc_i,
  input logic        	MemWrite_i,
  input logic [31:0]  ImmOp_i,
  input logic [31:0]  pcPlus4_i,
  input logic [31:0]  regOp2_i,
  input logic [4:0]   rd_i,
        
  output logic [31:0] ALUout_o,

  output logic        RegWrite_o,
  output logic [1:0]  WriteSrc_o,
  output logic        MemWrite_o,
  output logic [31:0] ImmOp_o,
  output logic [31:0] pcPlus4_o,
  output logic [31:0] regOp2_o,
  output logic [4:0]  rd_o
);

always_ff @(posedge clk_i) begin
  ALUout_o <= ALUout_i;

  RegWrite_o <= RegWrite_i;
  WriteSrc_o <= WriteSrc_i;
  MemWrite_o <= MemWrite_i;
  ImmOp_o <= ImmOp_i;
  pcPlus4_o <= pcPlus4_i;
  regOp2_o <= regOp2_i;
  rd_o <= rd_i;
end

endmodule
