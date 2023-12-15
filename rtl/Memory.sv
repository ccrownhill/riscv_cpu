module Memory
  import mem_pkg::*;
(
	input logic 	        clk_i,
	input logic [31:0]    Addr_i,
	input logic [31:0]    WriteD_i,
	input logic           Mwrite_i,
	input logic 	        Mread_i,
	input logic [2:0]     funct3_i,
  input logic           flush_i,

  // for reading instructions
  input logic           validInsReq_i,
  input logic [31:0]    PC_i,


	output logic [31:0]   ReadD_o,
  output logic [31:0]   Instr_o,
	output logic          DMemReady_o,
  output logic          IMemReady_o
);

// between CPU and split L1 caches
L1DataIn_t L1DataIn;
L1DataOut_t L1DataOut;

L1InstrIn_t L1InstrIn;
L1InstrOut_t L1InstrOut;

// between split L1 caches and L2
L1ToL2_t L1ToL2Bus_L1side;
L1ToL2_t L1ToL2Bus_L2side;
L2ToL1_t L2ToL1Bus;


// between L2 and MainMemory
CacheToMem_t L2CacheToMem;
MemToCache_t MemToL2Cache;

assign L1InstrIn.Valid = validInsReq_i;
assign L1InstrIn.Addr = PC_i + 32'hbfc00000;

assign L1DataIn.Valid = (Mwrite_i || Mread_i);
assign L1DataIn.Wen = Mwrite_i;
assign L1DataIn.Addr = Addr_i;
assign L1DataIn.ByteData = WriteD_i[7:0];

L1Data L1Data (
  .clk_i  (clk_i),
  .CPUD_i (L1DataIn),
  .MemD_i (L2ToL1Bus),
  .MemBus_i (L1ToL2Bus_L1side),

  .CPUD_o (L1DataOut),
  .MemBus_o (L1ToL2Bus_L1side)
);

L1Instr L1Instr (
  .clk_i (clk_i),
  .flush_i (flush_i),
  .CPUD_i (L1InstrIn),
  .MemD_i (L2ToL1Bus),
  .MemBus_i (L1ToL2Bus_L1side),

  .CPUD_o (L1InstrOut),
  .MemBus_o (L1ToL2Bus_L1side)
);

assign DMemReady_o = L1DataOut.Ready;
assign IMemReady_o = L1InstrOut.Ready;
assign Instr_o = L1InstrOut.ReadD;

always_ff @(posedge clk_i) begin
  L1ToL2Bus_L2side <= L1ToL2Bus_L1side;
end

L2Cache L2Cache (
  .clk_i (clk_i),
  .l1_i (L1ToL2Bus_L2side),
  .MemD_i (MemToL2Cache),

  .l1_o (L2ToL1Bus),
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
