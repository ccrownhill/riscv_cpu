package mem_pkg;
  parameter MAIN_MEM_SIZE = 18'h20000;
  parameter BLOCK_SIZE = 32;
  parameter CACHE_INDEX_SIZE = 10; // means 2^CACHE_INDEX_SIZE blocks

  typedef struct packed {
    logic Valid;
    logic Dirty;
    logic [31-CACHE_INDEX_SIZE-2:0] Tag;
    logic [BLOCK_SIZE-1:0] Data;
  } cache_entry_t;

  typedef struct packed {
    logic Write;
    logic Valid; // 0 if there is no read operation
    logic [31:0] Addr;
    logic [31:0] Wdata;
  } mem_input_t;

  typedef struct packed {
    logic [31:0] Rdata;
    logic Ready;
  } mem_output_t;

endpackage
