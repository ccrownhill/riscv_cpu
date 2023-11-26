module HazardDetectionUnit (
  input logic       MemRead_ID_EX_i,
  input logic [4:0] rd_ID_EX_i,
  input logic [4:0] rs1_IF_ID_i,
  input logic [4:0] rs2_IF_ID_i,

  output logic PCEn_o,
  output logic IF_ID_En_o,
  output logic controlZeroSel_o
);

always_comb begin
  if (MemRead_ID_EX_i == 1'b1 && (rd_ID_EX_i == rs1_IF_ID_i || rd_ID_EX_i == rs2_IF_ID_i)) begin
    PCEn_o = 1'b0;
    IF_ID_En_o = 1'b0;
    controlZeroSel_o = 1'b1;
  end
  else begin
    PCEn_o = 1'b1;
    IF_ID_En_o = 1'b1;
    controlZeroSel_o = 1'b0;
  end
end

endmodule
