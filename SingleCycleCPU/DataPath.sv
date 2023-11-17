module DataPath #(
    parameter   ADDR_WIDTH = 5,
                DATA_WIDTH = 32
)(
    input logic clk,
    input logic [ADDR_WIDTH-1:0] rs1,
    input logic [ADDR_WIDTH-1:0] rs2,
    input logic [ADDR_WIDTH-1:0] rd,
    input logic RegWrite,
    input logic ALUsrc,
    input logic ALUctrl,
    input logic [DATA_WIDTH-1:0] ImmOp,

    output logic EQ,
    output logic [DATA_WIDTH-1:0] a0
);

logic [DATA_WIDTH-1:0] regOp2;
logic [DATA_WIDTH-1:0] ALUop1;
logic [DATA_WIDTH-1:0] ALUop2;
logic [DATA_WIDTH-1:0] ALUout;

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

Mux2 #(DATA_WIDTH) regMux(
    .in0(regOp2),
    .in1(ImmOp),
    .sel(ALUsrc),
    .out(ALUop2)
);

ALU ALU(
    .ALUop1(ALUop1),
    .ALUop2 (ALUop2),
    .ALUctrl (ALUctrl),
    .EQ (EQ),
    .ALUout (ALUout)
);

endmodule
