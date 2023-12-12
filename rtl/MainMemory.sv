`define WRITE_MAINMEM(ADDR, DATA) \
  if (ADDR >= 32'hbfc00000/(BLOCKSIZE/8)) \
    mem_arr_ins[ADDR-32'hbfc00000/(BLOCKSIZE/8)] <= DATA; \
  else \
    mem_arr_data[ADDR] <= DATA;

`define READ_MAINMEM(ADDR) \
  (ADDR >= 32'hbfc00000/(BLOCKSIZE/8)) ? mem_arr_ins[ADDR-32'hbfc00000/(BLOCKSIZE/8)] : mem_arr_data[ADDR]

module MainMemory
  import mem_pkg::*;
(
  input logic           clk_i,
  input logic           Valid1_i,
  input logic           Valid2_i,
  input logic           Wen_i,
  input logic [31:0]    rAddr1_i,
  input logic [31:0]    rAddr2_i,
  input logic [31:0]    wAddr_i,
  input logic [127:0]   WriteD_i,

  output logic          Ready1_o,
  output logic          Ready2_o,
  output logic [127:0]  ReadD1_o,
  output logic [127:0]  ReadD2_o
);

logic [BLOCKSIZE-1:0] mem_arr_data[MAINMEM_BLOCKS-1:0];
logic [BLOCKSIZE-1:0] mem_arr_ins[INSTRMEM_BLOCKS-1:0];

initial begin
	$readmemh("data.mem", mem_arr_data, 17'h10000/(BLOCKSIZE/8));
  $readmemh("instructions.mem", mem_arr_ins);
end

always_ff @(posedge clk_i) begin
  if(Valid1_i) begin
    if(Wen_i) begin
      `WRITE_MAINMEM(wAddr_i[31:BYTE_ADDR_BITS], WriteD_i);
      ReadD1_o <= {BLOCKSIZE{1'bx}};
    end
    else begin
      ReadD1_o <= `READ_MAINMEM(rAddr1_i[31:BYTE_ADDR_BITS]);
    end
    Ready1_o <= 1'b1;
  end
  else begin
    ReadD1_o <= {BLOCKSIZE{1'bx}};
    Ready1_o <= 1'b0;
  end

  if (Valid2_i) begin
    ReadD2_o <= `READ_MAINMEM(rAddr2_i[31:BYTE_ADDR_BITS]);
    Ready2_o <= 1'b1;
  end
  else begin
    ReadD2_o <= {BLOCKSIZE{1'bx}};
    Ready2_o <= 1'b0;
  end
end

endmodule
