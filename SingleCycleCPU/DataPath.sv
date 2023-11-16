module DataPath #(
    parameter   A_WIDTH = 5,
                D_WIDTH = 32
)(
    input logic clk,
    input logic [A_WIDTH-1:0] rs1,
    input logic [A_WIDTH-1:0] rs2,
    input logic [A_WIDTH-1:0] rd,
    input logic RegWrite,
    input logic ALUsrc,
    input logic ALUctrl,
    input logic [D_WIDTH-1:0] ImmOp,
    output logic EQ,
    output logic [D_WIDTH-1:0] a0
);

logic [D_WIDTH-1:0] regOp2 ;
logic [D_WIDTH-1:0] ALUop1;
logic [D_WIDTH-1:0] ALUop2;
logic [D_WIDTH-1:0] ALUout;

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
    .MuxOut(ALUop2)
);

ALU ALU(
    .ALUop1(ALUop1),
    .ALUop2 (ALUop2),
    .ALUctrl (ALUctrl),
    .EQ (EQ),
    .ALUout (ALUout)
);

endmodule
