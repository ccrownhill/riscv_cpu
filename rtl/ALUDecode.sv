module ALUDecode (
  input logic [1:0] ALUOp_i,
  input logic [2:0] funct3_i,
  input logic       funct7_5_i,

  output logic [3:0] ALUctrl_o
);

always_comb
  case (ALUOp_i)
    2'b00: ALUctrl_o = 4'b0000; // load and store -> add
    2'b01: ALUctrl_o = 4'b0001; // sub for bne
    2'b10: ALUctrl_o = {funct3_i, funct7_5_i};
    2'b11:
      case (funct3_i)
        3'b101: ALUctrl_o = {funct3_i, funct7_5_i};
        default: ALUctrl_o = {funct3_i, 1'b0};
      endcase
    default: ALUctrl_o = 4'bxxx;
    endcase

endmodule
