module ALUDecode (
  input logic [1:0] ALUOp_i,
  input logic [2:0] funct3_i,

  output logic [2:0] ALUctrl_o
);

always_comb
  case (ALUOp_i)
    2'b00: ALUctrl_o = 3'b000; // load and store
    2'b01: ALUctrl_o = 3'b001; // sub for bne
    2'b10:
      case (funct3_i)
        3'b001: ALUctrl_o = 3'b010;
        default: ALUctrl_o = funct3_i;
      endcase
    default: ALUctrl_o = 3'bxxx;
    endcase

endmodule
