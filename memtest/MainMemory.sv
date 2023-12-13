module MainMemory
  import mem_pkg::*;
#(
  parameter BLOCK_SIZE = 128,
            MEM_SIZE = 18'h20000,
            BLOCK_ADDR_BIT = 4
)(
  input logic clk,
  input MInput CacheData_i,
  output MOutput MemOut_o
);

logic [BLOCK_SIZE-1:0] mem_arr[(MEM_SIZE/(BLOCK_SIZE/8))-1:0];

initial
	$readmemh("data.mem", mem_arr, 17'h10000/(BLOCK_SIZE/8));

always_ff @(posedge clk) begin
  if(CacheData_i.Valid) begin
    if(CacheData_i.Wen) begin
      mem_arr[CacheData_i.Addr[31:BLOCK_ADDR_BIT]] <= CacheData_i.WriteD;
      MemOut_o.ReadD <= {BLOCK_SIZE{1'bx}};
    end
    else begin
      MemOut_o.ReadD <= mem_arr[CacheData_i.Addr[31:BLOCK_ADDR_BIT]];
    end
    MemOut_o.Ready <= 1'b1;
  end
  else begin
    MemOut_o.ReadD <= {BLOCK_SIZE{1'bx}};
    MemOut_o.Ready <= 1'b0;
  end
end

endmodule
