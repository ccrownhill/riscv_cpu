module DataPath #(
    parameter   ADDR_WIDTH = 5
)(
    input logic clk,
    input logic [ADDR_WIDTH-1:0] rs1,
    input logic [ADDR_WIDTH-1:0] rs2,
    input logic [ADDR_WIDTH-1:0] rd,
    input logic RegWrite,
    input logic WriteSrc,
    input logic ALUsrc,
    input logic ALUctrl,
    input logic [31:0] ImmOp,

    output logic EQ,
    output logic [31:0] a0
);

logic [31:0] regOp2;
logic [31:0] ALUop1;
logic [31:0] ALUop2;
logic [31:0] ALUout;
logic [31:0] RAMout;
logic [31:0] WD3;

RegFile RegFile(
    .clk (clk),
    .AD1 (rs1),
    .AD2 (rs2),
    .AD3 (rd),
    .WE3 (RegWrite),
    .WD3 (WD3),
    .RD1 (ALUop1),
    .RD2 (regOp2),
    .a0 (a0)
);

Mux2 #(32) regMux(
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

ram ram (
	.addr (ALUout),

	.dout (RAMout)
);

Mux2 #(32) ramMux (
	.in0 (ALUout),
	.in1 (RAMout),
	.sel (WriteSrc),

	.out (WD3)
);

endmodule
