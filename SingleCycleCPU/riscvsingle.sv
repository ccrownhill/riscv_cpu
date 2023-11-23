module riscvsingle (
	input logic clk,
	input logic rst,
	
	output logic [31:0] a0
);

logic [31:0] ImmOp;
logic EQ;
logic RegWrite;
logic ALUsrc;
logic ALUctrl;
logic WriteSrc;

logic [4:0] rs1;
logic [4:0] rs2;
logic [4:0] rd;


ControlPath ControlPath (
	.clk (clk),
	.rst (rst),
	.EQ (EQ),

	.ImmOp (ImmOp),
	.rs1 (rs1),
	.rs2 (rs2),
	.rd (rd),

	.RegWrite (RegWrite),
	.ALUsrc (ALUsrc),
	.ALUctrl (ALUctrl),
	.WriteSrc (WriteSrc)
);


DataPath DataPath (
    .clk (clk),
    .ImmOp (ImmOp),
    .rs1 (rs1),
    .rs2 (rs2),
    .rd (rd),
    .RegWrite (RegWrite),
    .ALUsrc (ALUsrc),
    .ALUctrl (ALUctrl),
    .WriteSrc (WriteSrc),

    .EQ(EQ),
    .a0(a0)
);

endmodule
