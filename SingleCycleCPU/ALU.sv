module ALU(
    parameter DATA_WIDTH = 32,
)(
    logic input [DATA_WIDTH-1:0]   ALUop1,
    logic input [DATA_WIDTH-1:0]    ALUop2,
    logic input     ALUctrl,
    logic output    EQ,
    logic output  [DATA_WIDTH-1:0]  ALUout
);

always begin
    if (ALUctrl) begin
        assign ALUout <= ALUop1 - ALUop2;
        if (ALUop1 == ALUop2)begin //see if two input of alu is equal
            assign EQ <= 1;  
        end
    end
    else begin
        assign ALUout <= ALUop1 + ALUop2; //add if aluctrl is 0
    end
end
endmodule
