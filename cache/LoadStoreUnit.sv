module LoadStoreUnit
  import mem_pkg::*;
(
  input logic [31:0]  addr,
  input logic [1:0]   funct3_10_i,
  input logic [31:0]  wData_i,

  output logic [OFFSET_BITS-1:0] Offset_o,
  output logic [BLOCK_SIZE-1:0] mask_o,
  output logic [BLOCK_SIZE-1:0] wData_o
);

always_comb begin
  Offset_o = addr[OFFSET_BITS-1:0];
  case (funct3_10_i)
    2'b00: mask_o = {BLOCK_SIZE{1'b0}} | (128'hff << (Offset_o*8)); // lb / sb
    2'b01: mask_o = {BLOCK_SIZE{1'b0}} | (128'hff_ff << (Offset_o*8)); // lh / sh
    2'b10: mask_o = {BLOCK_SIZE{1'b0}} | (128'hff_ff_ff_ff << (Offset_o*8)); // lw / sw
    default: mask_o = {BLOCK_SIZE{1'b1}};
  endcase
  wData_o = ({96'b0, wData_i} << (Offset_o*8)) & mask_o;
end

endmodule
