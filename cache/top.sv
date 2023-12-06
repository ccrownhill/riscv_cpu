module top
  import mem_pkg::*;
(
  input logic clk,
  input logic [31:0]  AddressPort_i,
  input logic [31:0]  WriteData_i,
  input logic         MemWrite_i,
  input logic         MemRead_i,
  input logic [2:0]   funct3_i,
  
  output logic [31:0] ReadData_o,
  output logic        MemReady_o
);

mem_input_t cache_in;
mem_output_t cache_out;

mem_input_t mainmem_in;
mem_output_t mainmem_out;

logic [OFFSET_BITS-1:0] offset;

assign cache_in.Valid = (MemRead_i || MemWrite_i) ? 1'b1 : 1'b0;
assign cache_in.Write = MemWrite_i;
assign cache_in.Addr = AddressPort_i;

LoadStoreUnit LoadStoreUnit (
  .addr (AddressPort_i),
  .funct3_10_i (funct3_i[1:0]),
  .wData_i (WriteData_i),

  .Offset_o (offset),
  .mask_o (cache_in.Mask),
  .wData_o (cache_in.Wdata)
);

cache cache (
  .clk_i (clk),
  .cache_i (cache_in),
  .from_mem_i (mainmem_out),
  
  .to_mem_o (mainmem_in),
  .cache_o (cache_out)
);

assign MemReady_o = cache_out.Ready;

mainmem mainmem (
  .clk_i (clk),
  .mem_i (mainmem_in),

  .mem_o (mainmem_out)
);

MemConv MemConv (
  .data_i (cache_out.Rdata),
  .funct3_i (funct3_i),
  .Offset_i (offset),

  .ExtData_o (ReadData_o)
);

endmodule
