module ForwardUnit (
  input logic [4:0] rs1,
  input logic [4:0] rs2,
  input logic [4:0] EX_MEM_rd,
  input logic [4:0] MEM_WB_rd,
  input logic       EX_MEM_RegWrite,
  input logic [1:0] EX_MEM_WriteSrc,
  input logic       MEM_WB_RegWrite,

  // Sel signal value meanings: 00 -> from register; 01 -> from ALUout; 10 ->
  // from WB output
  output logic [1:0]  F1Sel, // MUX sel signal to choose first register operand
  output logic [1:0]  F2Sel,  // MUX sel signal to choose second register operand
  output logic        EX_ImmOpSel // whether to forward ImmOp for LUI instruction
);

always_comb begin
  // IMPORTANT: EX stage forwarding needs to be checked first because it has
  // priority over MEM stage forwarding since it contains even more recent
  // register values
  // Note that we also check that the write would not be to the zero register
  // since the zero register needs to stay constant 0
  if (EX_MEM_rd == rs1 && EX_MEM_RegWrite == 1'b1 && EX_MEM_rd != 5'b0) begin
    F1Sel = 2'b01;
  end
  else if (MEM_WB_rd == rs1 && MEM_WB_RegWrite == 1'b1 && MEM_WB_rd != 5'b0) begin
    F1Sel = 2'b10;
  end
  else
    F1Sel = 2'b00;


  if (EX_MEM_rd == rs2 && EX_MEM_RegWrite == 1'b1 && EX_MEM_rd != 5'b0)
    F2Sel = 2'b01;
  else if (MEM_WB_rd == rs2 && MEM_WB_RegWrite == 1'b1 && MEM_WB_rd != 5'b0)
    F2Sel = 2'b10;
  else
    F2Sel = 2'b00;
  
  EX_ImmOpSel = (EX_MEM_WriteSrc == 2'b11) ? 1'b1 : 1'b0;
end
endmodule
