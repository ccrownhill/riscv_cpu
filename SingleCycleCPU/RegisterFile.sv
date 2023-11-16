module RegisterFile #(
    parameter   A_WIDTH = 5,
                D_WIDTH = 32
)(
    input logic clk,
    input logic rs1,
    input logic rs2,
    input logic rd,
    input logic RegWrite,
    input logic ALUsrc,
    input logic ALUctrl,
    input logic ImmOp,
    output logic EQ,
    output logic  a0
);

logic regOp2 [D_WIDTH-1:0],
logic ALUop1 [D_WIDTH-1:0],
logic ALUop2 [D_WIDTH-1:0],
logic ALUout [D_WIDTH-1:0]

RegFile RegFile(
    .clk (clk),
    .AD1 (rs1),
    .AD2 (rs2),
    .AD3 (rd),
    .WE3 (RegWrite),
    .WD3 (ALUout),
    .RD1 (ALUop1),
    .RD2 (regOp2),
    .a0 (a0)
);

RegMux regMux(
    .regOp2(regOp2),
    .ImmOp(ImmOp),
    .ALUsrc(ALUsrc),
    .MuxOut(ALUop2),
);

ALU ALU(
    .ALUop1(ALUop1),
    .ALUop2 (ALUop2),
    .ALUctrl (ALUctrl),
    .EQ (EQ),
    .ALUout (ALUout)
)

endmodule