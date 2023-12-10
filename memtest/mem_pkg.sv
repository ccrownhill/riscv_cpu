package mem_pkg;

parameter   CACHESIZE = 4096;
parameter   TAGSIZE = 25;
parameter   BLOCKSIZE = 128;
parameter   SETNUM = 8;
parameter   BLOCKNUM = 32;
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
} CInput;

// this is the data recieved from the memory and the enables to allow this
typedef struct packed {
	logic 			    Ready; // when the data is not being changed valid is low. Valid is high for Load/Store
	logic 	[127:0] ReadD;
} MOutput;

// this is for sending data to the CPU after it is found
typedef struct packed { 
	logic 	[7:0]	  ByteOut;
  logic           Ready;
} COutput;

// This is the data sent to the memory to be written and the enables to do so
typedef struct packed {
	logic 			Valid;
	logic 			Wen;
	logic 	[127:0]	WriteD;
	logic 	[31:0] 	Addr;
} MInput;

endpackage
