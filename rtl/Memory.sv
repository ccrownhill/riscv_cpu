module Memory
  import mem_pkg::*;
(
	input logic 	        clk_i,
	input logic [31:0]    Addr_i,
	input logic [31:0]    WriteD_i,
	input logic           Mwrite_i,
	input logic 	        Mread_i,
	input logic [2:0]     funct3_i,

  // for reading instructions
  input logic [31:0]    PC_i,


	output logic [31:0]   ReadD_o,
  output logic [31:0]   Instr_o,
	output logic          DMemReady_o,
  output logic          IMemReady_o
);

L1DataIn_t L1DataIn;
L1DataOut_t L1DataOut;

L1InstrOut_t L1InstrOut;

CacheToMem_t L1DataMemIn;
CacheToMem_t L1InstrMemIn;

MemToCache_t L1DataMemOut;
MemToCache_t L1InstrMemOut;

assign L1DataIn.Valid = (Mwrite_i || Mread_i);
assign L1DataIn.Wen = Mwrite_i;
assign L1DataIn.Addr = Addr_i;
assign L1DataIn.ByteData = WriteD_i[7:0];

L1Data L1Data (
  .clk_i  (clk_i),
  .CPUD_i (L1DataIn),
  .MemD_i (L1DataMemOut),
  .CPUD_o (L1DataOut),
  .MemD_o (L1DataMemIn)
);

L1Instr L1Instr (
  .clk_i (clk_i),
  .PC_i (PC_i),
  .MemD_i (L1InstrMemOut),
  .CPUD_o (L1InstrOut),
  .MemD_o (L1InstrMemIn)
);

assign DMemReady_o = L1DataOut.Ready;
assign IMemReady_o = L1InstrOut.Ready;
assign Instr_o = L1InstrOut.ReadD;

MainMemory MainMemory (
  .clk_i (clk_i),
  .Valid1_i (L1DataMemIn.Valid),
  .Valid2_i (L1InstrMemIn.Valid),
  .Wen_i (L1DataMemIn.Wen),
  .rAddr1_i (L1DataMemIn.Addr),
  .rAddr2_i (L1InstrMemIn.Addr),
  .wAddr_i (L1DataMemIn.Addr),
  .WriteD_i (L1DataMemIn.WriteD),
  .Ready1_o (L1DataMemOut.Ready),
  .Ready2_o (L1InstrMemOut.Ready),
  .ReadD1_o (L1DataMemOut.ReadD),
  .ReadD2_o (L1InstrMemOut.ReadD)
);

MemExtend MemExtend (
  .ByteData_i (L1DataOut.ByteOut),
  .funct3_i   (funct3_i),
  .ExtD_o     (ReadD_o)
);

endmodule
