module ControlPath (
	input logic         clk_i,
	input logic         rst_i,
	input logic         EQ_i,
  input logic [31:0]  nextPC_i,
	
	output logic [4:0]  rs1_o,
	output logic [4:0]  rs2_o,
	output logic [4:0]  rd_o,

	output logic        RegWrite_o,
  output logic        MemWrite_o,
	output logic        ALUsrc_o,
	output logic [2:0]  ALUctrl_o,
	output logic [1:0]  WriteSrc_o,
  output logic [2:0]  ImmSrc_o,
  output logic [1:0]  PCsrc_o,
  output logic [31:7] Instr31_7_o,
  output logic [31:0] PC_o
);

logic [31:0]  Instr;
logic [1:0]   ALUOp;
logic         Branch;
logic         Jump;

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
  .op_i (Instr[6:0]),

  .RegWrite_o (RegWrite_o),
  .ImmSrc_o (ImmSrc_o),
  .ALUsrc_o (ALUsrc_o),
  .WriteSrc_o (WriteSrc_o),
  .Branch_o (Branch),
  .ALUOp_o (ALUOp),
  .Jump_o (Jump),
  .MemWrite_o (MemWrite_o)
);



ALUDecode ALUDecode (
  .ALUOp_i (ALUOp),
  .funct3_i (Instr[14:12]),

  .ALUctrl_o (ALUctrl_o)
);


assign rs1_o = Instr[19:15];
assign rs2_o = Instr[24:20];
assign rd_o = Instr[11:7];
assign Instr31_7_o = Instr[31:7];
assign PCsrc_o = {1'b0, (EQ_i & Branch)} << Jump;

endmodule
