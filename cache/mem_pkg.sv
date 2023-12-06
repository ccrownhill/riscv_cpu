package mem_pkg;
  parameter MAIN_MEM_BYTE_SIZE = 18'h20000;
  parameter BLOCK_SIZE = 128;
  parameter OFFSET_BITS = $clog2(BLOCK_SIZE) - 3;
  parameter MAIN_MEM_BLOCK_SIZE = MAIN_MEM_BYTE_SIZE/(BLOCK_SIZE/8);
  parameter NON_BLOCK_ADDR_BITS = $clog2(BLOCK_SIZE) - 3;
  parameter CACHE_BLOCKS = 16; // means 2^CACHE_INDEX_SIZE blocks
  parameter WAYS = 4;
  parameter CACHE_INDEX_SIZE = $clog2(CACHE_BLOCKS/WAYS); // means 2^CACHE_INDEX_SIZE blocks
  parameter TAG_SIZE = 32 - CACHE_INDEX_SIZE - NON_BLOCK_ADDR_BITS;

  typedef struct packed {
    logic Valid;
    logic Dirty;
    logic [TAG_SIZE-1:0] Tag;
    logic [BLOCK_SIZE-1:0] Data;
  } cache_entry_t;

  typedef struct packed {
    logic Write;
    logic Valid; // 0 if there is no read or write operation
    logic [31:0] Addr;
    logic [BLOCK_SIZE-1:0] Wdata;
    logic [BLOCK_SIZE-1:0] Mask;
  } mem_input_t;

  typedef struct packed {
    logic [BLOCK_SIZE-1:0] Rdata;
    logic Ready;
  } mem_output_t;

endpackage
