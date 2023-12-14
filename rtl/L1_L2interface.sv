module L1_L2interface
  import mem_pkg::*;
(
  input logic         clk_i,
  input CacheToMem_t  l1Dat_i,
  input CacheToMem_t  l1Ins_i,
  input MemToCache_t  L2Out_i,

  output MemToCache_t l1Dat_o,
  output MemToCache_t l1Ins_o,
  output CacheToMem_t L2In_o
);

logic l1InsValid;

initial
  l1InsValid = 1'b0;

always_ff @(posedge clk_i) begin
  if (l1InsValid) begin
    L2In_o <= l1Ins_i;
    l1Ins_o <= L2Out_i;
    l1Dat_o.Ready <= 1'b0;
    l1Dat_o.ReadD <= {BLOCKSIZE{1'bx}};
  end
  else begin
    L2In_o <= l1Dat_i;
    l1Dat_o <= L2Out_i;
    l1Ins_o.Ready <= 1'b0;
    l1Ins_o.ReadD <= {BLOCKSIZE{1'bx}};
  end
  l1InsValid <= l1Ins_i.Valid;
end


endmodule
