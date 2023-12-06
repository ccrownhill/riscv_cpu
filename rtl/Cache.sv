// this is the data recieved from the cpu
typedef struct packed {
	input logic 	Valid_i, // when the data is not being changed valid is low. Valid is high for Load/Store
	input logic 	Wen_i,
	input logic 	Addr_i [31:0], // this will form the various parts of the address such as tag and byte offset.
	input logic 	funct3_i [2:0],
	input logic 	WordData_i[31:0],
	input logic 	HalfData_i [15:0],
	input logic 	ByteData_i [7:0]
} CInput;

// this is the data recieved from the memory and the enables to allow this
typedef struct packed {
	input logic 	Valid_i, // when the data is not being changed valid is low. Valid is high for Load/Store
	input logic 	Wen_i,
	input logic 	Addr_i [31:0],
	input logic 	WriteD_i [127:0]
} MInput;

// this is for sending data to the CPU after it is found
typedef struct packed { 
	output logic 	WordData_o [31:0],
	output logic 	HalfData_o [15:0],
	output logic 	ByteData_o [7:0]
} COutput;

// This is the data sent to the memory to be written and the enables to do so
typedef struct packed {
	input logic 	Valid_i, 
	input logic 	Wen_i,
	output logic 	WriteD_o [127:0],
	output logic 	Addr_o
} MOutput;


module Cache #(
	parameter		CACHESIZE = 4096;
	parameter		TAGSIZE = 23; // 32 - 4 - 2 - 3 
	parameter		BLOCKSIZE = 128;
)(
input CInput	CPUD_i,
input CInput 	MemD_i,
input logic 	clk,

output COutput  CPUD_o,
output MOutput  MemD_o,
output logic 	Cready_o
);

typedef struct packed {
    logic Valid;
    logic [TAGSIZE-1:0] Tag;
    logic [BLOCKSIZE-1:0] Data;
} cache_entry_t;
/*
Steps for the cache:
1. It recieves a request for a load with an address from the CPU requesting Data (Addr_i) and so Cready goes low and Valid goes high
NOTE: For an instruction not a Load/Store valid will be set low unless we have a miss
2. It takes this address and compares the set bits to detect which set to check
3. It checks the block offset to determine which block 
4. It checks the byte offset to determine which byte
5. It checks the tag of this byte
6. Now the tree splits into two paths on either a HIT or a MISS

HIT:
7. This byte is outputted in ByteData_o along with relevant half word and word
8. The cache is now finished with this request and Cready goes high on the cycle it outputs the data 

MISS:
NOTE: if the instruction was not load/store but a miss occurs valid must go high as we are changing cache data
7. The data must be fetched from main memory so MOutput must be configured
8. The data is returned from main memory and this must be written to the correct block
9. finally the data must be outputted
10. The cache is now finished so Cready goes high on the cycle it outputs
*/

logic [7:0] ram_arr[MEMSIZE-1:0];


initial begin
	// this needs to set all valid bits to 0 
	// it should also make sure the cache is completely empty
end
	
endmodule
