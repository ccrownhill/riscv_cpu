module ALU (
    input logic [31:0]    ALUop1_i,
    input logic [31:0]    ALUop2_i,
    input logic [2:0]     ALUctrl_i,
    output logic  [31:0]  ALUout_o
);

always_comb
    case (ALUctrl_i)
        3'b000:     ALUout_o = ALUop1_i + ALUop2_i; // add
        3'b001:     ALUout_o = ALUop1_i - ALUop2_i; // subtract
        3'b010:     ALUout_o = ALUop1_i << ALUop2_i; // and
        3'b011:     ALUout_o = ALUop1_i | ALUop2_i; //or
        3'b100:     ALUout_o = ALUop1_i ^ ALUop2_i; //xor
        3'b101:     ALUout_o = ALUop1_i << ALUop2_i; // sll
        3'b111:     ALUout_o = ALUop1_i & ALUop2_i; // srl
        default:    ALUout_o = 0;
    endcase
endmodule
