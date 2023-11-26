module IFStage (
	input logic         clk_i,
  input logic         IF_ID_En_i,
  input logic         PCEn_i,
	input logic         rst_i,
  input logic [1:0]   PCsrc_i,
  input logic [31:0]  pcPlusImm_i,
  input logic [31:0]  ALUout_i,
	
	output logic [4:0]  rs1_o,
	output logic [4:0]  rs2_o,
	output logic [4:0]  rd_o,
  output logic [31:7] Instr31_7_o,
  output logic [6:0]  op_o,
  output logic [2:0]  funct3_o,
  output logic [31:0] PC_o,
  output logic [31:0] pcPlus4_o
);

logic [4:0] rs1;
logic [4:0] rs2;
logic [4:0] rd;
logic [31:0] PC;
logic [31:7] Instr31_7;
logic [6:0] op;
logic [2:0] funct3;

logic [31:0]  Instr;
logic [31:0]  pcPlus4;
logic [31:0]	nextPC;

Mux3 #(32) nextPCMux (
  .sel_i (PCsrc_i),
  .in0_i (pcPlus4),
  .in1_i (pcPlusImm_i),
  .in2_i (ALUout_i), // for jalr: PC = rs1 + Imm

  .out_o (nextPC)
);

RegAsyncEnR #(32) PCreg (
  .d (nextPC),
  .en (PCEn_i),
  .rst (rst_i),
  .clk (clk_i),
  .q (PC)
);

Adder adder4 (PC, 32'd4, pcPlus4);

InstrMem InstrMem (
  .A (PC),

  .RD (Instr)
);

assign rs1 = Instr[19:15];
assign rs2 = Instr[24:20];
assign rd = Instr[11:7];
assign Instr31_7 = Instr[31:7];
assign op = Instr[6:0];
assign funct3 = Instr[14:12];

IF_IDReg IF_IDReg (
  .clk_i (clk_i),
  .en_i (IF_ID_En_i),
  .rs1_i (rs1),
  .rs2_i (rs2),
  .rd_i (rd),
  .PC_i (PC),
  .Instr31_7_i (Instr31_7),
  .op_i (op),
  .funct3_i (funct3),
  .pcPlus4_i (pcPlus4),

  .rs1_o (rs1_o),
  .rs2_o (rs2_o),
  .rd_o (rd_o),
  .PC_o (PC_o),
  .Instr31_7_o (Instr31_7_o),
  .op_o (op_o),
  .funct3_o (funct3_o),
  .pcPlus4_o (pcPlus4_o)
);
endmodule
