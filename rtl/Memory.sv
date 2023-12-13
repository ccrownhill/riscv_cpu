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
  input logic           validInsReq_i,
  input logic [31:0]    PC_i,


	output logic [31:0]   ReadD_o,
  output logic [31:0]   Instr_o,
	output logic          DMemReady_o,
  output logic          IMemReady_o
);

L1DataIn_t L1DataIn;
L1DataOut_t L1DataOut;

L1InstrIn_t L1InstrIn;
L1InstrOut_t L1InstrOut;

CacheToMem_t L1DataL2In;
CacheToMem_t L1InstrL2In;

MemToCache_t L1DataL2Out;
MemToCache_t L1InstrL2Out;

Ins2Dat_t ins2Dat;
Dat2Ins_t dat2Ins;

CacheToMem_t L2CacheToMem;
MemToCache_t MemToL2Cache;

CacheToMem_t L1ToL2;
MemToCache_t L2ToL1;

assign L1InstrIn.Valid = validInsReq_i;
assign L1InstrIn.Addr = PC_i;

assign L1DataIn.Valid = (Mwrite_i || Mread_i);
assign L1DataIn.Wen = Mwrite_i;
assign L1DataIn.Addr = Addr_i;
assign L1DataIn.ByteData = WriteD_i[7:0];

L1Data L1Data (
  .clk_i  (clk_i),
  .CPUD_i (L1DataIn),
  .MemD_i (L1DataL2Out),
  .FromIns_i (ins2Dat),

  .CPUD_o (L1DataOut),
  .MemD_o (L1DataL2In),
  .ToIns_o (dat2Ins)
);

L1Instr L1Instr (
  .clk_i (clk_i),
  .CPUD_i (L1InstrIn),
  .MemD_i (L1InstrL2Out),
  .FromDat_i (dat2Ins),

  .CPUD_o (L1InstrOut),
  .MemD_o (L1InstrL2In),
  .ToDat_o (ins2Dat)
);

assign DMemReady_o = L1DataOut.Ready;
assign IMemReady_o = L1InstrOut.Ready;
assign Instr_o = L1InstrOut.ReadD;

L1_L2interface L1_L2interface (
  .l1Dat_i (L1DataL2In),
  .l1Ins_i (L1InstrL2In),
  .L2Out_i (L2ToL1),

  .l1Dat_o (L1DataL2Out),
  .l1Ins_o (L1InstrL2Out),
  .L2In_o (L1ToL2)
);

L2Cache L2Cache (
  .clk_i (clk_i),
  .l1_i (L1ToL2),
  .MemD_i (MemToL2Cache),

  .l1_o (L2ToL1),
  .MemD_o (L2CacheToMem)
);

MainMemory MainMemory (
  .clk_i (clk_i),
  .Mem_i (L2CacheToMem),
  .Mem_o (MemToL2Cache)
);

MemExtend MemExtend (
  .ByteData_i (L1DataOut.ByteOut),
  .funct3_i   (funct3_i),
  .ExtD_o     (ReadD_o)
);

endmodule
