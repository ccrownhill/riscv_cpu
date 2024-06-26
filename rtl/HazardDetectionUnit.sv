module HazardDetectionUnit (
  input logic       MemRead_ID_EX_i,
  input logic [4:0] rd_ID_EX_i,
  input logic [4:0] rd_EX_MEM_i,
  input logic [4:0] rs1_IF_ID_i,
  input logic [4:0] rs2_IF_ID_i,
  input logic       RegWrite_ID_EX_i,
  input logic       RegWrite_EX_MEM_i,
  input logic       Branch_i,
  input logic       Jump_i,
  input logic       Ret_i,
  input logic       BranchCond_i,
  input logic       MemRead_EX_MEM_i,
  input logic       MemWrite_EX_MEM_i,
  input logic       Mready_i,

  output logic IF_Flush_o,
  output logic PCEn_o,
  output logic IF_ID_En_o,
  output logic controlZeroSel_o,
  output logic ID_EX_En_o,
  output logic EX_MEM_En_o,
  output logic MEM_reset_o
);

always_comb begin
  // stall when waiting for memory output
  if ((MemRead_EX_MEM_i || MemWrite_EX_MEM_i) && !Mready_i) begin
    PCEn_o = 1'b0;
    IF_ID_En_o = 1'b0;
    controlZeroSel_o = 1'b0;
    IF_Flush_o = 1'b0;
    ID_EX_En_o = 1'b0;
    EX_MEM_En_o = 1'b0;
    MEM_reset_o = 1'b1;
  end
  else if (MemRead_ID_EX_i == 1'b1 && ((rd_ID_EX_i == rs1_IF_ID_i || rd_ID_EX_i == rs2_IF_ID_i) && rd_ID_EX_i != 5'b0)) begin
    PCEn_o = 1'b0;
    IF_ID_En_o = 1'b0;
    controlZeroSel_o = 1'b1;
    IF_Flush_o = 1'b0;
    ID_EX_En_o = 1'b1;
    EX_MEM_En_o = 1'b1;
    MEM_reset_o = 1'b0;
  end
  // stall for 2 cycles if branch depends on result from previous
  // instruction (also for jalr but not for jal)
  // also for jalr because we need to jump to output from ALU which depends on
  // register value
  else if ((Branch_i == 1'b1 || Ret_i == 1'b1) // check if it is branch or jalr
      // check whether instruction in EX stage will write to register file
      && ((((rs1_IF_ID_i == rd_ID_EX_i || rs2_IF_ID_i == rd_ID_EX_i) && rd_ID_EX_i != 5'b0) && RegWrite_ID_EX_i == 1'b1)
      // check whether instruction in MEM stage will write to register file
      || (((rs1_IF_ID_i == rd_EX_MEM_i || rs2_IF_ID_i == rd_EX_MEM_i) && rd_EX_MEM_i != 5'b0) && RegWrite_EX_MEM_i == 1'b1))) begin
//     || (Ret_i == 1'b1
//       && ((rs1_IF_ID_i == rd_ID_EX_i && Reg || rs1_IF_ID_i == rd_EX_MEM_i))) begin
        PCEn_o = 1'b0;
        IF_ID_En_o = 1'b0;
        controlZeroSel_o = 1'b1;
        IF_Flush_o = 1'b0;
        ID_EX_En_o = 1'b1;
        EX_MEM_En_o = 1'b1;
        MEM_reset_o = 1'b0;
    end
  else if ((Branch_i == 1'b1 && BranchCond_i == 1'b1) || Jump_i == 1'b1 || Ret_i == 1'b1) begin // do this only if branch taken
    controlZeroSel_o = 1'b0;
    IF_Flush_o = 1'b1;
    PCEn_o = 1'b1;
    IF_ID_En_o = 1'bx;
    ID_EX_En_o = 1'b1;
    EX_MEM_En_o = 1'b1;
    MEM_reset_o = 1'b0;
  end
  else begin
    PCEn_o = 1'b1;
    IF_ID_En_o = 1'b1;
    controlZeroSel_o = 1'b0;
    IF_Flush_o = 1'b0;
    ID_EX_En_o = 1'b1;
    EX_MEM_En_o = 1'b1;
    MEM_reset_o = 1'b0;
  end
end
endmodule
