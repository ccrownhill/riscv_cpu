`define WRITE_MAINMEM(ADDR, DATA) \
  if (ADDR >= {32'hbfc00000}[31:BYTE_ADDR_BITS]) \
    mem_arr_ins[ADDR-{32'hbfc00000}[31:BYTE_ADDR_BITS]] <= DATA; \
  else \
    mem_arr_data[ADDR] <= DATA;

`define READ_MAINMEM(ADDR) \
  (ADDR >= {32'hbfc00000}[31:BYTE_ADDR_BITS]) ? mem_arr_ins[ADDR-{32'hbfc00000}[31:BYTE_ADDR_BITS]] : mem_arr_data[ADDR]

module MainMemory
  import mem_pkg::*;
(
  input logic           clk_i,
  input CacheToMem_t    Mem_i,
  output MemToCache_t   Mem_o
);

logic [BLOCKSIZE-1:0] mem_arr_data[MAINMEM_BLOCKS-1:0];
logic [BLOCKSIZE-1:0] mem_arr_ins[INSTRMEM_BLOCKS-1:0];

initial begin
	$readmemh("data.mem", mem_arr_data, 17'h10000/(BLOCKSIZE/8));
  $readmemh("instructions.mem", mem_arr_ins);
end

always_ff @(posedge clk_i) begin
  if(Mem_i.Valid) begin
    if(Mem_i.Wen) begin
      `WRITE_MAINMEM(Mem_i.Addr[31:BYTE_ADDR_BITS], Mem_i.WriteD);
      Mem_o.ReadD <= {BLOCKSIZE{1'bx}};
    end
    else begin
      Mem_o.ReadD <= `READ_MAINMEM(Mem_i.Addr[31:BYTE_ADDR_BITS]);
    end
    Mem_o.Ready <= 1'b1;
  end
  else begin
    Mem_o.ReadD <= {BLOCKSIZE{1'bx}};
    Mem_o.Ready <= 1'b0;
  end
end

endmodule
