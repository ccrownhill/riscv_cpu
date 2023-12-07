module MainMemory  # (
  parameter BLOCK_SIZE = 128;
            BLOCK_ADDR_BIT = 6;
)(
  input logic clk_i,
  input logic Valid_i,
  input logic Wen_i,
  input logic [31:0] Addr_i,
  input logic [127:0] WriteD_i,
  output logic [127:0] ReadD_o,
  output logic Ready_o
);

logic [BLOCK_SIZE-1:0] mem_arr[(17'h10000/(BLOCK_SIZE/8))-1:0];

initial
	$readmemh("data.mem", mem_arr, 17'h10000/(BLOCK_SIZE/8));

always_ff @(posedge clk_i)begin
  if(Valid_i) begin
    if(Wen_i) begin
      mem_arr[Addr_i[31:BLOCK_ADDR_BIT]] <= WriteD_i;
      ReadD_o <= {BLOCK_SIZE{1'bx}}
    end
    else begin
      ReadD_o <= mem_arr[Addr_i[31:BLOCK_ADDR_BIT]];
    end
    Ready_o <= 1'b1;
  end
  else begin
    ReadD_o <= {BLOCK_SIZE{1'bx}};
    Ready_o <= 1'b0;
  end
end

endmodule