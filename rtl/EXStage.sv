module EXStage (
  input logic         clk_i,
  input logic         en_i,
  input logic         RegWrite_i,
  input logic         ALUsrc_i,
  input logic [1:0]   WriteSrc_i,
  input logic [1:0]   ALUOp_i,
  input logic         MemWrite_i,
  input logic         MemRead_i,

  input logic [31:0]  pcPlus4_i,
  input logic [31:0]  ALUop1_i,
  input logic [31:0]  regOp2_i,
  input logic [31:0]  ImmOp_i,

  input logic [4:0]   rd_i,
  input logic [2:0]   funct3_i,
  input logic         funct7_5_i,


  output logic [31:0] ALUout_o,

  output logic        RegWrite_o,
  output logic [1:0]  WriteSrc_o,
  output logic        MemWrite_o,
  output logic        MemRead_o,
  output logic [31:0] pcPlus4_o,
  output logic [31:0] ImmOp_o,
  output logic [31:0] regOp2_o,
  output logic [4:0]  rd_o,
  output logic [2:0]  funct3_o,
  output logic [31:0] ALUout_beforeEX_o
);

logic [31:0] ALUop2;
logic [3:0] ALUctrl;

// store these in EX_MEMReg
logic [31:0] ALUout;


Mux2 #(32) regMux (
	.in0(regOp2_i),
	.in1(ImmOp_i),
	.sel(ALUsrc_i),
	.out(ALUop2)
);

ALUDecode ALUDecode (
  .ALUOp_i (ALUOp_i),
  .funct3_i (funct3_i),
  .funct7_5_i (funct7_5_i),

  .ALUctrl_o (ALUctrl)
);

ALU ALU (
	.ALUop1_i (ALUop1_i),
	.ALUop2_i (ALUop2),
	.ALUctrl_i (ALUctrl),
	.ALUout_o (ALUout_beforeEX_o)
);

always_ff @(posedge clk_i) begin
  if (en_i) begin
    ALUout_o <= ALUout_beforeEX_o;
    RegWrite_o <= RegWrite_i;
    WriteSrc_o <= WriteSrc_i;
    MemWrite_o <= MemWrite_i;
    MemRead_o <= MemRead_i;
    ImmOp_o <= ImmOp_i;
    pcPlus4_o <= pcPlus4_i;
    regOp2_o <= regOp2_i;
    rd_o <= rd_i;
    funct3_o <= funct3_i;
  end
end

endmodule
