module DirectMappedCache #(
  parameter ADDRESS_WIDTH = 32,
            DATA_WIDTH    = 32,
            CACHE_SIZE    = 1024 //cache capacity size in bytes
)(
  input logic  clk_i,
  input logic [ADDRESS_WIDTH-1:0] AddressPort_i,
  input logic [DATA_WIDTH-1:0]    WriteData_i,
  input logic  MemRead_i,
  input logic  MemWrite_i,
  
  output logic [DATA_WIDTH-1:0] ReadData_o,
  output logic  hit_o //Cache hit signal
);

localparam BLOCK_SIZE = DATA_WIDTH / 8; //one word per cache block 
localparam NUM_BLOCKS = CACHE_SIZE / BLOCK_SIZE; //derive cache lines
localparam INDEX_SIZE = $clog2(NUM_BLOCKS); // Size of index
localparam OFFSET_SIZE = $clog2(BLOCK_SIZE); // SIze of byte offset
localparam TAG_SIZE = ADDRESS_WIDTH - INDEX_SIZE - OFFSET_SIZE; // Size of tag

// Cache line structure
typedef struct {
  logic Valid;
  logic [TAG_SIZE-1:0] Tag;
  logic [DATA_WIDTH-1:0] data;
} cache_line_t;

cache_line_t cache [NUM_LINES]; // Cache memory

always_ff @(posedge clk_i) begin
  logic [OFFSET_SIZE-1:0] offset = AddressPort_i[OFFSET_SIZE-1:0];
  logic [INDEX_SIZE-1:0] index = AddressPort_i[OFFSET_SIZE + INDEX_SIZE-1:OFFSET_SIZE];
  logic [TAG_SIZE-1:0] tag = AddressPort_i[ADDRESS_WIDTH-1: OFFSET_SIZE+INDEX_SIZE];
  hit_o = 0; //Default to miss
  ReadData_o = 0;

  if (MemRead_i)begin
    if(cache[index].valid && cache[index].Tag == tag)begin
      hit = 1;
      ReadData_o = cache[index].data
    end
    else begin
      //fetch to the main memory
    end
  end
  if(MemWrite_i && hit)begin
    cache[index].data = WriteData_i
    //Write-through policy: simultaneously write to the main memory
  end
  else begin
    //miss so write to main memory
  end
end

endmodule
