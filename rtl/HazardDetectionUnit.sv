module HazardDetectionUnit (
  input logic       MemRead_ID_EX_i,
  input logic [4:0] rd_ID_EX_i,
  input logic [4:0] rd_EX_MEM_i,
  input logic [4:0] rd_MEM_WB_i,
  input logic [4:0] rs1_IF_ID_i,
  input logic [4:0] rs2_IF_ID_i,
//  input logic [1:0] PCsrc_i,
  input logic       Branch_i,
  input logic       Jump_i,
  input logic       Ret_i,
  input logic       EQ_i,

  output logic IF_Flush_o,
  output logic PCEn_o,
  output logic IF_ID_En_o,
  output logic controlZeroSel_o
);

always_comb begin
  if ((MemRead_ID_EX_i == 1'b1 && (rd_ID_EX_i == rs1_IF_ID_i || rd_ID_EX_i == rs2_IF_ID_i))) begin
    PCEn_o = 1'b0;
    IF_ID_En_o = 1'b0;
    controlZeroSel_o = 1'b1;
    IF_Flush_o = 1'b0;
  end
  // stall for 2 cycles if branch depends on result from previous
  // instruction (also for jalr but not for jal)
  else if ((Branch_i == 1'b1
      && ((rs1_IF_ID_i == rd_ID_EX_i || rs2_IF_ID_i == rd_ID_EX_i)
      || (rs1_IF_ID_i == rd_EX_MEM_i || rs2_IF_ID_i == rd_EX_MEM_i)
      || (rs1_IF_ID_i == rd_MEM_WB_i || rs2_IF_ID_i == rd_MEM_WB_i)))
    || (Ret_i == 1'b1 && (rs1_IF_ID_i == rd_ID_EX_i || rs1_IF_ID_i == rd_EX_MEM_i || rs1_IF_ID_i == rd_MEM_WB_i))) begin
        PCEn_o = 1'b0;
        IF_ID_En_o = 1'b0;
        controlZeroSel_o = 1'b1;
        IF_Flush_o = 1'b0;
    end
  else if ((Branch_i == 1'b1 && EQ_i == 1'b0) || Jump_i == 1'b1 || Ret_i == 1'b1) begin // do this only if branch taken
    controlZeroSel_o = 1'b0;
    IF_Flush_o = 1'b1;
    PCEn_o = 1'b1;
    IF_ID_En_o = 1'bx;
  end
  else begin
    PCEn_o = 1'b1;
    IF_ID_En_o = 1'b1;
    controlZeroSel_o = 1'b0;
    IF_Flush_o = 1'b0;
  end
end
endmodule
