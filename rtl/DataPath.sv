module DataPath #(
    parameter   ADDR_WIDTH = 5
)(
    input logic 									clk,
    input logic [ADDR_WIDTH-1:0] 	rs1,
    input logic [ADDR_WIDTH-1:0] 	rs2,
    input logic [ADDR_WIDTH-1:0] 	rd,
    input logic 									RegWrite,
    input logic                   MemWrite_i,
    input logic [1:0] 						WriteSrc,
    input logic [1:0] 						PCsrc_i,
    input logic 									ALUsrc,
    input logic [2:0]							ALUctrl,
    input logic [2:0] 						ImmSrc_i,
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
logic [7:0]  RAMout;
logic [31:0] RAMoutExt;
logic [31:0] WD3;
logic [31:0] pcPlus4;
logic [31:0] pcPlusImm;
logic [31:0] InternalImmOp;




// ----
// WB stage
// ----



endmodule
