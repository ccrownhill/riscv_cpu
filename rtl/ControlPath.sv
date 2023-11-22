module ControlPath (
	input logic clk,
	input logic rst,
	input logic EQ,
	
	output logic [31:0] ImmOp,
	output logic [4:0] rs1,
	output logic [4:0] rs2,
	output logic [4:0] rd,

	output logic RegWrite,
	output logic ALUsrc,
	output logic ALUctrl,
	output logic WriteSrc
);

logic [31:0] Instr;
logic [31:0] PC;
logic PCsrc;
logic ImmSrc;
logic [31:0] InternalImmOp;

InstrLoad InstrLoad (
    .clk (clk),
    .rst (rst),
    .ImmOp (InternalImmOp),
    .PCsrc (PCsrc),

    .PC (PC)
);

InstrMem InstrMem (
    .A (PC),

    .RD (Instr)
);

MainDecode MainDecode (
    .op(Instr[6:0]),
    .EQ(EQ),

    .RegWrite (RegWrite),
    .ALUsrc (ALUsrc),
    .ALUctrl (ALUctrl),
    .ImmSrc (ImmSrc),
    .PCsrc (PCsrc),
    .WriteSrc (WriteSrc)
);

SignExtend SignExtend(
    .Instr31_7 (Instr[31:7]),
    .ImmSrc (ImmSrc),

    .ImmOp (InternalImmOp)
);

assign ImmOp = InternalImmOp;
assign rs1 = Instr[19:15];
assign rs2 = Instr[24:20];
assign rd = Instr[11:7];

endmodule
