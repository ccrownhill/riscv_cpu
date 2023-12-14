package mem_pkg;

parameter   MAINMEM_SIZE = 18'h20000;
parameter   INSTRMEM_SIZE = 4096;
parameter   BLOCKSIZE = 128;
parameter   MAINMEM_BLOCKS = MAINMEM_SIZE/(BLOCKSIZE/8);
parameter   INSTRMEM_BLOCKS = INSTRMEM_SIZE/(BLOCKSIZE/8);
parameter   CACHESIZE = 4096;
parameter   BYTE_ADDR_BITS = $clog2(BLOCKSIZE/8);
parameter   SETNUM = CACHESIZE/(4*(BLOCKSIZE/8));
parameter   TAGSIZE = 32 - $clog2(SETNUM) - BYTE_ADDR_BITS;
parameter   DEGREES = 4;

typedef struct packed {
	logic Valid;
	logic Dirty;
	logic [TAGSIZE-1:0] Tag;
	logic [BLOCKSIZE-1:0] Data;
} cache_entry;

// this is the data recieved from the cpu
typedef struct packed {
	logic 			    Valid; // when the data is not being changed valid is low. Valid is high for Load/Store
	logic 			    Wen;
	logic 	[31:0]	Addr; // this will form the various parts of the address such as tag and byte_off offset.
	logic 	[7:0]	  ByteData;
} L1DataIn_t;

typedef struct packed {
	logic 			    Valid; // when the data is not being changed valid is low. Valid is high for Load/Store
	logic 	[31:0]	Addr; // this will form the various parts of the address such as tag and byte_off offset.
} L1InstrIn_t;

typedef struct packed {
  logic         Ready;
  logic [31:0]  ReadD;
} L1InstrOut_t;

// this is for sending data to the CPU after it is found
typedef struct packed { 
  logic           Ready;
	logic 	[7:0]	  ByteOut;
} L1DataOut_t;

typedef struct packed {
  logic           Valid;
  logic           Wen;
  logic           Src;
  logic [31:0]    Addr;
  logic [127:0]   WriteD;
} L1ToL2_t;

typedef struct packed {
  logic           Valid;
  logic           Wen;
  logic [31:0]    Addr;
  logic [127:0]   WriteD;
} CacheToMem_t;

typedef struct packed {
  logic           Ready;
  logic           Dst;
  logic [127:0]   ReadD;
} L2ToL1_t;

typedef struct packed {
  logic           Ready;
  logic [127:0]   ReadD;
} MemToCache_t;

// This is the data sent to the memory to be written and the enables to do so
typedef struct packed {
	logic 			    Valid;
	logic 			    Wen;
	logic 	[31:0] 	rAddr1;
  logic   [31:0]  rAddr2;
  logic   [31:0]  wAddr;
	logic 	[127:0]	WriteD;
} MInput_t;

// this is the data recieved from the memory and the enables to allow this
typedef struct packed {
	logic 			    Ready; // when the data is not being changed valid is low. Valid is high for Load/Store
	logic 	[127:0] ReadD1;
  logic   [127:0] ReadD2;
} MOutput;

typedef struct packed {
  logic         Invalidate;
  logic         Written;
  logic [31:0]  Addr;
} Dat2Ins_t;

typedef struct packed {
  logic         WriteBack;
  logic [31:0]  Addr;
} Ins2Dat_t;

endpackage
