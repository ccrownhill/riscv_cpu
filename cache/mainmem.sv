module mainmem
  import mem_pkg::*;
(
  input logic clk_i,
  input mem_input_t mem_i,

  output mem_output_t mem_o
);

// use block addressing
logic [BLOCK_SIZE-1:0] mem_arr[MAIN_MEM_SIZE/4:0];

initial
  $readmemh("data.mem", mem_arr, 17'h10000/4);

always_ff @(posedge clk_i) begin
  if (mem_i.Valid) begin
    if (mem_i.Write) begin
      mem_arr[mem_i.Addr[31:2]] <= mem_i.Wdata;
      mem_o.Rdata <= {BLOCK_SIZE{1'bx}};
    end
    else begin
      mem_o.Rdata <= mem_arr[mem_i.Addr[31:2]]; // convert byte address to block address
    end
    mem_o.Ready <= 1'b1;
  end
  else begin
    mem_o.Rdata <= {BLOCK_SIZE{1'bx}};
    mem_o.Ready <= 1'b0;
  end
end

endmodule
