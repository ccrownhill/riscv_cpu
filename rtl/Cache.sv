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
	output logic 	Valid_o, 
	output logic 	Wen_o,
	output logic 	WriteD_o [127:0],
	output logic 	Addr_o
} MOutput;


module Cache #(
	parameter		CACHESIZE = 4096;
	parameter		TAGSIZE = 23; // 32 - 4 - 2 - 3 
	parameter		BLOCKSIZE = 128;
	parameter		SETNUM = 8;
	parameter		BLOCKNUM = 32;
	parameter		DEGREES = 4;
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
	logic [SETNUM-1:0]
    logic [TAGSIZE-1:0] Tag;
    logic [BLOCKSIZE-1:0] Data;
} cache_entry;

typedef enum {COMP, REQUEST, WRITE, IDLE} STATE
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
logic 			hit;
logic [1:0] 	Degree;
logic [2:0] 	set;
logic [3:0]		byte;
logic [22:0] 	tag;
logic [7:0]		byte_out;
logic [15:0]	half_out;
logic [31:0]	word_out;
STATE 			C_State;
STATE		 	N_STATE;

cache_entry [SETNUM-1:0] cache_arr[DEGREES-1:0];

// format of address == tag[31:9]->set[8:6]->block[5:4]->byte[3:0]
initial begin
	// this needs to set all valid bits to 0 
	// it should also make sure the cache is completely empty
	C_State <= IDLE;
end 

//READ Instructions
always_comb
	set = CPUD_i.Addr_i[8:6]; 
	tag = CPUD_i.Addr_i[31:9];
	case(C_State)
		COMP: begin
			if(cache_arr[0][set].Valid && cache_arr[0][set].Tag == tag) begin
				hit = 1'b1;
				Degree = 2'b00;
			end
			else if(cache_arr[1][set].Valid && cache_arr[1][set].Tag == tag) begin
				hit = 1'b1;
				Degree = 2'b01;
			end
			if(cache_arr[2][set].Valid && cache_arr[2][set].Tag == tag) begin
				hit = 1'b1;
				Degree = 2'b10;
			end
			if(cache_arr[3][set].Valid && cache_arr[3][set].Tag == tag) begin
				hit = 1'b1;
				Degree = 2'b11;
			end
			else 
				hit = 1'b0;
			if (CPUD_i.valid && hit) begin
				N_STATE = IDLE;
			end
		end

		REQUEST:

		WRITE:

		IDLE: begin
			if(valid) begin
				N_STATE <= COMP;
			end
			else begin
				N_STATE <= IDLE;
			end
			case (CPUD_i.funct3_i[1:0])
				2'b00: begin
				Mux16 #(DATA_WIDTH = 8) ByteSelect(
					.sel_i  (byte),
					.in0_i  (cache_arr[Degree][set].Data[7:0]),
					.in1_i  (cache_arr[Degree][set].Data[15:8]),
					.in2_i  (cache_arr[Degree][set].Data[23:16]),
					.in3_i  (cache_arr[Degree][set].Data[31:24]),
					.in4_i  (cache_arr[Degree][set].Data[39:32]),
					.in5_i  (cache_arr[Degree][set].Data[47:40]),
					.in6_i  (cache_arr[Degree][set].Data[55:48]),
					.in7_i  (cache_arr[Degree][set].Data[63:56]),
					.in8_i  (cache_arr[Degree][set].Data[71:64]),
					.in9_i  (cache_arr[Degree][set].Data[79:72]),
					.in10_i (cache_arr[Degree][set].Data[87:80]),
					.in11_i (cache_arr[Degree][set].Data[95:88]),
					.in12_i (cache_arr[Degree][set].Data[103:96]),
					.in13_i (cache_arr[Degree][set].Data[111:104]),
					.in14_i (cache_arr[Degree][set].Data[119:112]),
					.in15_i (cache_arr[Degree][set].Data[127:120]),

					.out_o  (byte_out)
				);
				CPUD_o.ByteData_o = byte_out;
				end
				2'b01: begin
				Mux8 #(DATA_WIDTH = 16) HalfSelect(
					.sel_i  (byte[3:1]),
					.in0_i  (cache_arr[Degree][set].Data[15:0]),
					.in1_i  (cache_arr[Degree][set].Data[31:16]),
					.in2_i  (cache_arr[Degree][set].Data[47:32]),
					.in3_i  (cache_arr[Degree][set].Data[63:48]),
					.in4_i  (cache_arr[Degree][set].Data[79:64]),
					.in5_i  (cache_arr[Degree][set].Data[95:80]),
					.in6_i  (cache_arr[Degree][set].Data[111:96]),
					.in7_i  (cache_arr[Degree][set].Data[127:112]),

					.out_o  (half_out)
				);
				CPUD_o.HalfData_o = half_out;
				end
				2'b10: begin
				Mux4 #(DATA_WIDTH = 32) WordSelect(
					.sel_i  (byte[3:2]),
					.in0_i  (cache_arr[Degree][set].Data[31:0]),
					.in1_i  (cache_arr[Degree][set].Data[63:32]),
					.in2_i  (cache_arr[Degree][set].Data[95:64]),
					.in3_i  (cache_arr[Degree][set].Data[127:96]),

					.out_o  (word_out)
				);
				CPUD_o.WordData_o = word_out;
				end
				default: begin
					CPUD_o.ByteData_o = byte_out;
				end
			endcase
			
		end
	endcase

//WRITE Instructions
	
endmodule
