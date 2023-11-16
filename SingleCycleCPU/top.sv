module top(
    input logic clk,
    input logic rst,
    output logic [31:0] a0
);

logic [31:0] ImmOp;
logic [31:0] PC;
logic [31:0] Instr;
logic EQ;
logic ImmSrc;
logic RegWrite;
logic ALUsrc;
logic ALUctrl;

PCReg PCReg (
    .clk (clk),
    .rst (rst),
    .ImmOp (ImmOp),
    .PC (PC)
);

InstrMem InstrMem (
    .A (PC),
    .RD (Instr)
);

ControlUnit ControlUnit(
    .Instr(Instr),
    .EQ(EQ),
)

SignExtend SignExtend(
    .Instr(Instr),
    .ImmSrc(ImmSrc)
)

RegisterFile RegisterFile(
    .clk(clk),
    .ImmOp(ImmOp),
    .EQ(EQ),
    .rs1(Instr[19:15]),
    .rs2(Instr[24:20]),
    .rd(Instr[11:7]),
    .RegWrite(RegWrite),
    .ALUsrc(ALUsrc),
    .ALUctrl(ALUctrl),
    .a0(a0)
)

endmodule
