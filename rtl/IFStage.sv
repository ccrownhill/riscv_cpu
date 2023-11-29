module IFStage (
	input logic         clk_i,
  input logic         flush_i,
  input logic         IF_ID_En_i,
  input logic         PCEn_i,
	input logic         rst_i,
  input logic [1:0]   PCsrc_i,
  input logic [31:0]  pcPlusImm_i,
  input logic [31:0]  regPlusImm_i,
	
	output logic [4:0]  rs1_o,
	output logic [4:0]  rs2_o,
	output logic [4:0]  rd_o,
  output logic [31:7] Instr31_7_o,
  output logic [6:0]  op_o,
  output logic [2:0]  funct3_o,
  output logic        funct7_5_o,
  output logic [31:0] PC_o,
  output logic [31:0] pcPlus4_o
);

logic [31:0] PC;

logic [31:0]  Instr;
logic [31:0]  pcPlus4;
logic [31:0]	nextPC;

Mux3 #(32) nextPCMux (
  .sel_i (PCsrc_i),
  .in0_i (pcPlus4),
  .in1_i (pcPlusImm_i),
  .in2_i (regPlusImm_i), // for jalr: PC = rs1 + Imm

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

always_ff @(posedge clk_i) begin
  if (IF_ID_En_i == 1'b1) begin
    rs1_o <= Instr[19:15];
    rs2_o <= Instr[24:20];
    rd_o <= Instr[11:7];
    PC_o <= PC;
    Instr31_7_o <= Instr[31:7];
    op_o <= Instr[6:0];
    funct3_o <= Instr[14:12];
    funct7_5_o <= Instr[30];
    pcPlus4_o <= pcPlus4;
  end
  if (flush_i == 1'b1) begin
    rs1_o <= 5'b0;
    rs2_o <= 5'b0;
    rd_o <= 5'b0;
    PC_o <= 32'b0;
    Instr31_7_o <= 25'b0;
    op_o <= 7'b0;
    funct3_o <= 3'b0;
    funct7_5_o <= 1'b0;
    pcPlus4_o <= 32'b0;
  end
end
endmodule
