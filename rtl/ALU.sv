module ALU (
    input logic [31:0]   ALUop1,
    input logic [31:0]    ALUop2,
    input logic     ALUctrl,
    output logic    EQ,
    output logic  [31:0]  ALUout
);

always_comb begin
	if (ALUctrl == 1'b1)
		ALUout = ALUop1 - ALUop2;
	else
		ALUout = ALUop1 + ALUop2; // add if aluctrl is 0
	EQ = (ALUout == 32'b0) ? 1'b1 : 1'b0;
end
endmodule
