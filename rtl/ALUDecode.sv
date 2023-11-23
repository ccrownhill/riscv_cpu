module ALUDecode (
  input logic [1:0] AlUop_i,
  input logic [2:0] funct3_i,

  output logic [2:0] ALUctrl
);

always_comb
  case (ALUop_i)
    2'b00: ALUctrl = 3'b000; // load and store
    2'b01: ALUctrl = 3'b001; // sub for bne
    2'b10:
      case (funct3_i)
        3'b001: ALUctrl = 3'b010;
        default: ALUctrl = funct3_i;
      endcase
    endcase

endmodule
