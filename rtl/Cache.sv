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
	input logic 	Ready_i, // when the data is not being changed valid is low. Valid is high for Load/Store
	input logic 	Wen_i, 	// this is not necessary but left in case is implemented in main mem
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
	output logic 	Addr_o	 [31:0]
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
logic 			from_mem;
logic 			group_least_used;
logic 			random_select;

logic [1:0] 	Degree;
logic [2:0] 	set;
logic [3:0]		byte;
logic [22:0] 	tag;

logic [7:0]		byte_out;
logic [15:0]	half_out;
logic [31:0]	word_out;
logic [127:0]	block_out;
logic [127:0]	block_in;


STATE 			C_State;
STATE		 	N_STATE;

cache_entry [SETNUM-1:0] cache_arr[(DEGREES)-1:0]; // need to rethink blocks in set

// format of address == tag[31:7]->set[6:4]->byte[3:0]
// currently block is not used and it should be // it actually needs removing
initial begin
	// this needs to set all valid bits to 0 
	
	C_State <= IDLE;
end 

always_ff @(posedge clk) begin
	C_State <= N_STATE;
end


always_comb
	set = CPUD_i.Addr_i		[6:4]; 
	tag = CPUD_i.Addr_i		[31:7];
	byte = CPUD_i.Addr_i	[3:0];
	case(C_State)
		COMP: begin
			if(cache_arr[0][set].Valid && cache_arr[0][set].Tag == tag) begin
				hit = 1'b1;
				Degree = 2'b00;
				group_least_used = 1;
				random_select = !random_select;
			end
			else if(cache_arr[1][set].Valid && cache_arr[1][set].Tag == tag) begin
				hit = 1'b1;
				Degree = 2'b01;
				group_least_used = 1;
				random_select = !random_select;
			end
			if(cache_arr[2][set].Valid && cache_arr[2][set].Tag == tag) begin
				hit = 1'b1;
				Degree = 2'b10;
				group_least_used = 0;
				random_select = !random_select;
			end
			if(cache_arr[3][set].Valid && cache_arr[3][set].Tag == tag) begin
				hit = 1'b1;
				Degree = 2'b11;
				group_least_used = 0;
				random_select = !random_select;
			end
			else 
				hit = 1'b0;
			if (CPUD_i.Wen_i && hit) begin // writing mem and block in cache
				N_STATE = WRITE; 
			end 
			else if (CPUD_i.Wen_i && !hit) begin // writing mem but block not in cache
				N_STATE = REQUEST;				 // I am aware this second statement is not necessary but it is for readability
			end 
			else if (CPUD_i.valid && hit) begin  // reading value and block in cache -- yay :)
				N_STATE = IDLE;
			end 
			else begin // reading but block not in cache
				N_STATE = REQUEST;
			end
		end

		REQUEST: begin
			if (CPUD_i.Wen_i && hit) begin // this is if coming from write stage
				// edited cache and sending block to memory to be written through
				
				MOutput.Wen_o = CPUD_i.Wen_i;
				MOutput.Addr_o = CPUD_i.Addr_i;
				MOutput.Valid_o = CPUD_i.Valid_i;
				MOutput.WriteD_o = block_out;

				if(MInput.Ready_i) // goes high when data is outputted
					N_STATE = IDLE;
				else 
					N_STATE = REQUEST;
			end 
			else if (CPUD_i.Wen_i && !hit) begin
				// writing but block not in cache

				MOutput.Wen_o = 1'b0;
				MOutput.Addr_o = CPUD_i.Addr_i;
				MOutput.Valid_o = CPUD_i.Valid_i;
				MOutput.WriteD_o = block_out; // not relevant as Wen is low
				if(MInput.Ready_i) // must go high to confirm data is outputted
					N_STATE = WRITE;
					block_in = MInput.WriteD_i;
					from_mem = 1'b1; // tells WRITE that data is from mem not CPU
				else 
					N_STATE = REQUEST;
			end 
			if (!CPUD_i.Wen_i && !hit) begin
				// reading but not in cache

				MOutput.Wen_o = 1'b0;
				MOutput.Addr_o = CPUD_i.Addr_i;
				MOutput.Valid_o = CPUD_i.Valid_i;
				MOutput.WriteD_o = block_out; // not relevant as Wen is low
				if(MInput.Ready_i) // must go high to confirm data is outputted
					N_STATE = WRITE;
					block_in = MInput.WriteD_i;
					from_mem = 1'b1; // tells WRITE that data is from mem not CPU
				else 
					N_STATE = REQUEST;
			end
		end

		WRITE: begin 
			if (from_mem) begin // need to put block in cache
				if(!cache_arr[0][set].Valid) begin
					cache_arr[0][set].Valid = 1'b1;
					cache_arr[0][set].Data = block_in;
				end
				else if(!cache_arr[1][set].Valid) begin
					cache_arr[1][set].Valid = 1'b1;
					cache_arr[1][set].Data = block_in;
				end
				else if(!cache_arr[2][set].Valid) begin
					cache_arr[2][set].Valid = 1'b1;
					cache_arr[2][set].Data = block_in;
				end
				else if(!cache_arr[3][set].Valid) begin
					cache_arr[3][set].Valid = 1'b1;
					cache_arr[3][set].Data = block_in;
				end
				else begin 
					Degree = {group_least_used, random_select};
					case({Degree})
						2'b00: 	cache_arr[0][set].Data = block_in;
						2'b01:	cache_arr[1][set].Data = block_in;
						2'b10:	cache_arr[2][set].Data = block_in;
						2'b11: 	cache_arr[3][set].Data = block_in;
					endcase
					group_least_used = !group_least_used;
					random_select = !random_select;
				end

			end
			if (CPUD_i.Wen_i && hit) begin
				case (byte)
					// editing correct bit of block for byte case
					4'b0000: cache_arr[Degree][set].Data[7:0] = CPUD_i.ByteData_i;
					4'b0001: cache_arr[Degree][set].Data[15:8] = CPUD_i.ByteData_i;
					4'b0010: cache_arr[Degree][set].Data[23:16] = CPUD_i.ByteData_i;
					4'b0011: cache_arr[Degree][set].Data[31:24] = CPUD_i.ByteData_i;
					4'b0100: cache_arr[Degree][set].Data[39:32] = CPUD_i.ByteData_i;
					4'b0101: cache_arr[Degree][set].Data[47:40] = CPUD_i.ByteData_i;
					4'b0110: cache_arr[Degree][set].Data[55:48] = CPUD_i.ByteData_i;
					4'b0111: cache_arr[Degree][set].Data[63:56] = CPUD_i.ByteData_i;
					4'b1000: cache_arr[Degree][set].Data[71:64] = CPUD_i.ByteData_i;
					4'b1001: cache_arr[Degree][set].Data[79:72] = CPUD_i.ByteData_i;
					4'b1010: cache_arr[Degree][set].Data[87:80] = CPUD_i.ByteData_i;
					4'b1011: cache_arr[Degree][set].Data[95:88] = CPUD_i.ByteData_i;
					4'b1100: cache_arr[Degree][set].Data[103:96] = CPUD_i.ByteData_i;
					4'b1101: cache_arr[Degree][set].Data[111:104] = CPUD_i.ByteData_i;
					4'b1110: cache_arr[Degree][set].Data[119:112] = CPUD_i.ByteData_i;
					4'b1111: cache_arr[Degree][set].Data[127:120] = CPUD_i.ByteData_i;
				endcase
				N_STATE = REQUEST;
				block_out = cache_arr[Degree][set].Data
			end 
			else begin 
				N_STATE = IDLE
			end
			
		end

		IDLE: begin
			if(CPUD_i.Valid_i && !hit) begin // this may cause issues and require changing
				N_STATE <= COMP;
			end
			else begin
				N_STATE <= IDLE;
				hit = 1'b0;
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

	
endmodule
