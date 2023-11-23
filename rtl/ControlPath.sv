module ControlPath (
	input logic         clk_i,
	input logic         rst_i,
	input logic         EQ_i,
  input logic [31:0]  nextPC_i,
	
	output logic [4:0]  rs1_o,
	output logic [4:0]  rs2_o,
	output logic [4:0]  rd_o,

	output logic        RegWrite_o,
	output logic        ALUsrc_o,
	output logic        ALUctrl_o,
	output logic        WriteSrc_o,
  output logic        ImmSrc_o,
  output logic        PCsrc_o,
  output logic [31:7] Instr31_7_o,
  output logic [31:0] PC_o
);

logic [31:0] Instr;

RegAsyncR #(32) PCreg (
  .d (nextPC_i),
  .rst (rst_i),
  .clk (clk_i),
  .q (PC_o)
);


InstrMem InstrMem (
  .A (PC_o),

  .RD (Instr)
);

MainDecode MainDecode (
  .op (Instr[6:0]),
  .EQ (EQ_i),

  .RegWrite (RegWrite_o),
  .ALUsrc (ALUsrc_o),
  .ALUctrl (ALUctrl_o),
  .ImmSrc (ImmSrc_o),
  .PCsrc (PCsrc_o),
  .WriteSrc (WriteSrc_o)
);


assign rs1_o = Instr[19:15];
assign rs2_o = Instr[24:20];
assign rd_o = Instr[11:7];
assign Instr31_7_o = Instr[31:7];

endmodule
