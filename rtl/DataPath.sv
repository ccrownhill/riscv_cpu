module DataPath #(
    parameter   ADDR_WIDTH = 5
)(
    input logic 									clk,
    input logic [ADDR_WIDTH-1:0] 	rs1,
    input logic [ADDR_WIDTH-1:0] 	rs2,
    input logic [ADDR_WIDTH-1:0] 	rd,
    input logic 									RegWrite,
    input logic [1:0] 						WriteSrc,
    input logic [1:0] 						PCsrc_i,
    input logic 									ALUsrc,
    input logic 									ALUctrl,
    input logic [1:0] 						ImmSrc_i,
    input logic [31:0] 						PC_i,
    input logic [31:7]            Instr31_7_i,

    output logic 									EQ_o,
    output logic [31:0] 					nextPC_o,
    output logic [31:0] 					a0_o
);

logic [31:0] regOp2;
logic [31:0] ALUop1;
logic [31:0] ALUop2;
logic [31:0] ALUout;
logic [31:0] RAMout;
logic [31:0] WD3;
logic [31:0] pcPlus4;
logic [31:0] pcPlusImm;
logic [31:0] InternalImmOp;

RegFile RegFile(
    .clk (clk),
    .AD1 (rs1),
    .AD2 (rs2),
    .AD3 (rd),
    .WE3 (RegWrite),
    .WD3 (WD3),
    .RD1 (ALUop1),
    .RD2 (regOp2),

    .a0_o (a0_o)
);

SignExtend SignExtend(
  .Instr31_7 (Instr31_7_i),
  .ImmSrc (ImmSrc_i),

  .ImmOp (InternalImmOp)
);

Mux2 #(32) regMux(
    .in0(regOp2),
    .in1(InternalImmOp),
    .sel(ALUsrc),
    .out(ALUop2)
);

ALU ALU(
    .ALUop1(ALUop1),
    .ALUop2 (ALUop2),
    .ALUctrl (ALUctrl),
    .EQ (EQ_o),
    .ALUout (ALUout)
);

ram ram (
	.addr (ALUout),

	.dout (RAMout)
);

Adder adder4 (PC_i, 4, pcPlus4);
Adder adderImm (PC_i, InternalImmOp, pcPlusImm);

Mux3 #(32) regWriteMux (
	.sel_i (WriteSrc),
	.in0_i (ALUout),
	.in1_i (RAMout),
  .in2_i (pcPlus4),

	.out_o (WD3)
);

Mux3 #(32) nextPCMux (
  .sel_i (PCsrc_i),
  .in0_i (pcPlus4),
  .in1_i (pcPlusImm),
  .in2_i (ALUout), // for jalr: PC = rs1 + Imm

  .out_o (nextPC_o)
);

endmodule
