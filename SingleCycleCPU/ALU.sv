module ALU #(
    parameter DATA_WIDTH = 32
)(
    input logic [DATA_WIDTH-1:0]   ALUop1,
    input logic [DATA_WIDTH-1:0]    ALUop2,
    input logic     ALUctrl,
    output logic    EQ,
    output logic  [DATA_WIDTH-1:0]  ALUout
);

always_comb begin
    if (ALUctrl)
	EQ = (ALUop1 == ALUop2) ? 1'b1 : 1'b0;
    else
        ALUout = ALUop1 + ALUop2; // add if aluctrl is 0
end
endmodule
