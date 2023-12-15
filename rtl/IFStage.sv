module IFStage (
	input logic         clk_i,
  input logic         flush_i,
  input logic         IF_ID_En_i,
  input logic         PCEn_i,
	input logic         rst_i,
  input logic [1:0]   PCsrc_i,
  input logic [31:0]  pcPlusImm_i,
  input logic [31:0]  regPlusImm_i,
  input logic         IMemReady_i,
  input logic [31:0]  IMemInstr_i,
  input logic [31:0]  ALUout_EX_i,
  input logic         MemWrite_EX_i,
  input logic         MemWrite_beforeID_i,
  input logic         DMemReady_i,
	
	output logic [4:0]  rs1_o,
	output logic [4:0]  rs2_o,
	output logic [4:0]  rd_o,
  output logic [31:7] Instr31_7_o,
  output logic [6:0]  op_o,
  output logic [2:0]  funct3_o,
  output logic        funct7_5_o,
  output logic [31:0] PCbeforeReg_o,
  output logic        validReq_o,
  output logic [31:0] PC_o,
  output logic [31:0] pcPlus4_o,
  output logic        forbiddenRead_o,
  output logic        IMemReady_o
);


logic [31:0]  pcPlus4;
logic [31:0]	nextPC;

Mux3 #(32) nextPCMux (
  .sel_i (PCsrc_i),
  .in0_i (pcPlus4),
  .in1_i (pcPlusImm_i),
  .in2_i (regPlusImm_i), // for jalr: PC = rs1 + Imm

  .out_o (nextPC)
);

logic forbiddenRead;

always_latch begin
  if (PCbeforeReg_o[31:2] == regPlusImm_i[31:2] && MemWrite_beforeID_i && !(ALUout_EX_i == regPlusImm_i && MemWrite_EX_i && DMemReady_i)) begin
    forbiddenRead = 1'b1;
    nextPC = PCbeforeReg_o;
    validReq_o = 1'b0;
  end
  else begin
    forbiddenRead = 1'b0;
    validReq_o = 1'b1;
  end
end

RegAsyncEnR #(32) PCreg (
  .d (nextPC),
  .en (PCEn_i && (IMemReady_i || flush_i) && !forbiddenRead),
  .rst (rst_i),
  .clk (clk_i),
  .q (PCbeforeReg_o)
);

Adder adder4 (PCbeforeReg_o, 32'd4, pcPlus4);


always_ff @(posedge clk_i) begin
  if (IF_ID_En_i && IMemReady_i) begin
    rs1_o <= IMemInstr_i[19:15];
    rs2_o <= IMemInstr_i[24:20];
    rd_o <= IMemInstr_i[11:7];
    PC_o <= PCbeforeReg_o;
    Instr31_7_o <= IMemInstr_i[31:7];
    op_o <= IMemInstr_i[6:0];
    funct3_o <= IMemInstr_i[14:12];
    funct7_5_o <= IMemInstr_i[30];
    pcPlus4_o <= pcPlus4;
    forbiddenRead_o <= forbiddenRead;
    IMemReady_o <= IMemReady_i;
  end
  if (flush_i) begin
    rs1_o <= 5'b0;
    rs2_o <= 5'b0;
    rd_o <= 5'b0;
    PC_o <= 32'b0;
    Instr31_7_o <= 25'b0;
    op_o <= 7'b0;
    funct3_o <= 3'b0;
    funct7_5_o <= 1'b0;
    pcPlus4_o <= 32'b0;
    IMemReady_o <= 1'b0;
  end
end
endmodule
