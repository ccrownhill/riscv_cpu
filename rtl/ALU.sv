module ALU (
    input logic [31:0]    ALUop1_i,
    input logic [31:0]    ALUop2_i,
    input logic [3:0]     ALUctrl_i,
    output logic  [31:0]  ALUout_o
);

always_comb
    case (ALUctrl_i)
        4'b0000:     ALUout_o = ALUop1_i + ALUop2_i; // add
        4'b0001:     ALUout_o = ALUop1_i - ALUop2_i; // subtract
        4'b0010:     ALUout_o = ALUop1_i << ALUop2_i; // sll
        4'b0100:     ALUout_o = {{31{1'b0}},($signed(ALUop1_i) < $signed(ALUop2_i))}; // slt
        4'b0110:     ALUout_o = {{31{1'b0}},(ALUop1_i < ALUop2_i)}; // sltu
        4'b1000:     ALUout_o = ALUop1_i ^ ALUop2_i; // xor
        4'b1010:     ALUout_o = ALUop1_i >> ALUop2_i; // srl
        4'b1011:     ALUout_o = ALUop1_i >>> ALUop2_i; // sra
        4'b1100:     ALUout_o = ALUop1_i | ALUop2_i; // or
        4'b1110:     ALUout_o = ALUop1_i & ALUop2_i; // and
        default:    ALUout_o = 0;
    endcase
endmodule
