module top
  import mem_pkg::*;
(
  input logic clk,
  input logic [31:0]  AddressPort_i,
  input logic [31:0]  WriteData_i,
  input logic         MemWrite_i,
  input logic         MemRead_i,
  
  output logic [31:0] ReadData_o,
  output logic        MemReady_o
);

mem_input_t cache_in;
mem_output_t cache_out;

mem_input_t mainmem_in;
mem_output_t mainmem_out;

assign cache_in.Valid = (MemRead_i || MemWrite_i) ? 1'b1 : 1'b0;
assign cache_in.Write = MemWrite_i;
assign cache_in.Addr = AddressPort_i;
assign cache_in.Wdata = WriteData_i;

assign ReadData_o = cache_out.Rdata;
assign MemReady_o = cache_out.Ready;

cache cache (
  .clk_i (clk),
  .cache_i (cache_in),
  .from_mem_i (mainmem_out),
  
  .to_mem_o (mainmem_in),
  .cache_o (cache_out)
);

mainmem mainmem (
  .clk_i (clk),
  .mem_i (mainmem_in),

  .mem_o (mainmem_out)
);

endmodule
