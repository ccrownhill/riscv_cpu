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
    if (ALUctrl) begin
        ALUout = ALUop1 - ALUop2;
        if (ALUop1 == ALUop2)begin //see if two input of alu is equal
            EQ = 1'b1;  
        end
        else begin
            EQ = 1'b0;
        end
    end
    else begin
        EQ = 1'b0;
        ALUout = ALUop1 + ALUop2; //add if aluctrl is 0
    end
end
endmodule
