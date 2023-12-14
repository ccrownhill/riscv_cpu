module SetAssociativeCache #(
  parameter ADDRESS_WIDTH = 32,
            DATA_WIDTH    = 32,
            CACHE_SIZE    = 512, //cache capacity size in bytes
            NUM_WAYS = 4
)(
  input logic  clk_i,
  input logic [ADDRESS_WIDTH-1:0] AddressPort_i,
  input logic [DATA_WIDTH-1:0]    WriteData_i,
  input logic  MemRead_i,
  input logic  MemWrite_i,
  
  output logic [DATA_WIDTH-1:0] ReadData_o,
  output logic  hit_o //Cache hit signal
);

localparam BLOCK_SIZE = DATA_WIDTH / 16; //one word per cache block 
localparam NUM_BLOCKS = CACHE_SIZE / BLOCK_SIZE; //derive cache lines
localparam SET_NUM = NUM_BLOCKS/NUM_WAYS;
localparam INDEX_SIZE = $clog2(SET_NUM); // Size of index = 3
localparam OFFSET_SIZE = $clog2(BLOCK_SIZE); // Size of byte offset = 1
localparam TAG_SIZE = ADDRESS_WIDTH - INDEX_SIZE - OFFSET_SIZE; // Size of tag  = 28

// Cache line structure
typedef struct {
  logic Valid;
  logic [TAG_SIZE-1:0] Tag;
  logic [DATA_WIDTH-1:0] data;
} cache_line_t;

cache_line_t cache [NUM_LINES][NUM_WAYS]; // Cache memory

always_ff @(posedge clk_i) begin
  logic [OFFSET_SIZE-1:0] offset = AddressPort_i[OFFSET_SIZE-1:0];
  logic [INDEX_SIZE-1:0] index = AddressPort_i[OFFSET_SIZE + INDEX_SIZE-1:OFFSET_SIZE];
  logic [TAG_SIZE-1:0] tag = AddressPort_i[ADDRESS_WIDTH-1: OFFSET_SIZE+INDEX_SIZE];
  hit_o = 0; //Default to miss
  ReadData_o = 0;

  for(int i = 0, i < NUM_WAYS; i++) begin
    if(cache[index][i].valid && (cache[index][i].Tag == tag))begin
      hit = 0;
      if(MemRead_i)begin
        ReadData_o = cache[index][i].data;
      end
      if(MemWrite_i)begin
        cache[index][i].data = write_data;
      end
    end
    if(!hit_o) begin
      // handle with miss
    end
  end
end

endmodule
