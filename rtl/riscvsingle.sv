module riscvsingle (
	input logic clk,
	input logic rst,
	
	output logic [31:0] a0
);

logic [31:0] ImmOp;
logic [31:7] Instr31_7;
logic EQ;
logic RegWrite;
logic ALUsrc;
logic ALUctrl;
logic WriteSrc;
logic PCsrc;
logic [1:0] ImmSrc;
logic [31:0] PC;
logic [31:0] nextPC;

logic [4:0] rs1;
logic [4:0] rs2;
logic [4:0] rd;


ControlPath ControlPath (
	.clk_i (clk),
	.rst_i (rst),
	.EQ_i (EQ),
  .nextPC_i (nextPC),

	.rs1_o (rs1),
	.rs2_o (rs2),
	.rd_o (rd),

	.RegWrite_o (RegWrite),
	.ALUsrc_o (ALUsrc),
	.ALUctrl_o (ALUctrl),
	.WriteSrc_o (WriteSrc),
  .ImmSrc_o (ImmSrc),
  .Instr31_7_o (Instr31_7),
  .PCsrc_o (PCsrc),
  .PC_o (PC)
);


DataPath DataPath (
	.clk (clk),
	.rs1 (rs1),
	.rs2 (rs2),
	.RegWrite (RegWrite),
	.WriteSrc (WriteSrc),
	.rd (rd),
  .PCsrc_i (PCsrc),
	.ALUsrc (ALUsrc),
	.ALUctrl (ALUctrl),
	.ImmSrc_i (ImmSrc),
  .PC_i (PC),
  .Instr31_7_i (Instr31_7),

  .EQ_o (EQ),
  .nextPC_o (nextPC),
  .a0_o (a0)
);

endmodule
