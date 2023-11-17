module RiscVCPU #(
	parameter DATA_WIDTH = 32
)(
	input logic clk,
	input logic rst,
	
	output logic [DATA_WIDTH-1:0] a0,
	output logic [DATA_WIDTH-1:0] PC
);

logic [DATA_WIDTH-1:0] ImmOp;
logic [DATA_WIDTH-1:0] next_PC;
logic [DATA_WIDTH-1:0] Instr;
logic EQ;
logic ImmSrc;
logic RegWrite;
logic ALUsrc;
logic ALUctrl;
logic PCsrc;

PCtop PCtop (
    .clk (clk),
    .rst (rst),
    .ImmOp (ImmOp),
    .PCsrc (PCsrc),

    .PC (PC)
);

InstrMem InstrMem (
    .A (PC),

    .RD (Instr)
);

ControlUnit ControlUnit(
    .Instr(Instr),
    .EQ(EQ),

    .RegWrite(RegWrite),
    .ALUsrc(ALUsrc),
    .ALUctrl(ALUctrl),
    .ImmSrc(ImmSrc),
    .PCsrc(PCsrc)
);

SignExtend SignExtend(
    .Instr(Instr),
    .ImmSrc(ImmSrc),

    .ImmOp(ImmOp)
);

DataPath DataPath(
    .clk(clk),
    .ImmOp(ImmOp),
    .rs1(Instr[19:15]),
    .rs2(Instr[24:20]),
    .rd(Instr[11:7]),
    .RegWrite(RegWrite),
    .ALUsrc(ALUsrc),
    .ALUctrl(ALUctrl),

    .EQ(EQ),
    .a0(a0)
);

endmodule
