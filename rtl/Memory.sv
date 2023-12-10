module Memory
  import mem_pkg::*;
(
	input logic 	      clk,
	input logic [31:0]  Addr_i,
	input logic [31:0]  WriteD_i,
	input logic         Mwrite_i,
	input logic 	      Mread_i,
	input logic [2:0]   funct3_i,
	output logic [31:0]  ReadD_o,
	output logic         Mready_o
);

CInput cacheIn;
COutput cacheOut;
MInput memIn;
MOutput memOut;

assign cacheIn.Valid = (Mwrite_i || Mread_i);
assign cacheIn.Wen = Mwrite_i;
assign cacheIn.Addr = Addr_i;
assign cacheIn.ByteData = WriteD_i[7:0];

Cache Cache (
  .clk (clk),
  .CPUD_i (cacheIn),
  .MemD_i (memOut),
  .CPUD_o (cacheOut),
  .MemD_o (memIn)
);

assign Mready_o = cacheOut.Ready;

MainMemory MainMemory (
  .clk (clk),
  .CacheData_i (memIn),
  .MemOut_o (memOut)
);

MemExtend MemExtend (
  .ByteData_i (cacheOut.ByteOut),
  .funct3_i   (funct3_i),
  .ExtD_o     (ReadD_o)
);

endmodule
