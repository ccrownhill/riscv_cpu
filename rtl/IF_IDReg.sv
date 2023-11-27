module IF_IDReg (
  input logic   clk_i,
  input logic   en_i,
  input logic   flush_i,
  input logic [4:0] rs1_i,
  input logic [4:0] rs2_i,
  input logic [4:0] rd_i,
  input logic [31:0] PC_i,
  input logic [31:7] Instr31_7_i,
  input logic [6:0] op_i,
  input logic [2:0] funct3_i,
  input logic [31:0] pcPlus4_i,

  output logic [4:0] rs1_o,
  output logic [4:0] rs2_o,
  output logic [4:0] rd_o,
  output logic [31:0] PC_o,
  output logic [31:7] Instr31_7_o,
  output logic [6:0] op_o,
  output logic [2:0] funct3_o,
  output logic [31:0] pcPlus4_o
);

always_ff @(posedge clk_i) begin
  if (en_i == 1'b1) begin
    rs1_o <= rs1_i;
    rs2_o <= rs2_i;
    rd_o <= rd_i;
    PC_o <= PC_i;
    Instr31_7_o <= Instr31_7_i;
    op_o <= op_i;
    funct3_o <= funct3_i;
    pcPlus4_o <= pcPlus4_i;
  end
  if (flush_i == 1'b1) begin
    rs1_o <= 5'b0;
    rs2_o <= 5'b0;
    rd_o <= 5'b0;
    PC_o <= 32'b0;
    Instr31_7_o <= 25'b0;
    op_o <= 7'b0;
    funct3_o <= 3'b0;
    pcPlus4_o <= 32'b0;
  end
end

endmodule
