`define UPDATE_SHIFT_REG(SHIFT_REG, NEWVAL) \
  for (int i = 1; i < DEGREES; i++) begin \
    SHIFT_REG[i] <= SHIFT_REG[i-1]; \
  end \
  SHIFT_REG[0] <= NEWVAL;


// this implements a 2 input MUX for every byte choosing either the old or the
// new data
`define WRITE(CACHE_BLOCK, OFFSET, DATA) \
	case (OFFSET) \
		4'b0000: CACHE_BLOCK[7:0] = DATA; \
		4'b0001: CACHE_BLOCK[15:8] = DATA; \
		4'b0010: CACHE_BLOCK[23:16] = DATA; \
		4'b0011: CACHE_BLOCK[31:24] = DATA; \
		4'b0100: CACHE_BLOCK[39:32] = DATA; \
		4'b0101: CACHE_BLOCK[47:40] = DATA; \
		4'b0110: CACHE_BLOCK[55:48] = DATA; \
		4'b0111: CACHE_BLOCK[63:56] = DATA; \
		4'b1000: CACHE_BLOCK[71:64] = DATA; \
		4'b1001: CACHE_BLOCK[79:72] = DATA; \
		4'b1010: CACHE_BLOCK[87:80] = DATA; \
		4'b1011: CACHE_BLOCK[95:88] = DATA; \
		4'b1100: CACHE_BLOCK[103:96] = DATA; \
		4'b1101: CACHE_BLOCK[111:104] = DATA; \
		4'b1110: CACHE_BLOCK[119:112] = DATA; \
		4'b1111: CACHE_BLOCK[127:120] = DATA; \
	endcase

module L1Data
  import mem_pkg::*;
(
	input logic 	      clk_i,
	input L1DataIn_t	  CPUD_i,
	input MemToCache_t	MemD_i,
  input Ins2Dat_t     FromIns_i,

	output L1DataOut_t  CPUD_o,
	output CacheToMem_t MemD_o,
  output Dat2Ins_t    ToIns_o
);

typedef enum {COMP_TAG, ALLOCATE, WRITE_THROUGH, OUTPUT} cache_state;

logic 			hit;

logic [$clog2(DEGREES)-1:0] 	degree;
logic [$clog2(SETNUM)-1:0] 	set;
logic [BYTE_ADDR_BITS-1:0]		byte_off;
logic [TAGSIZE-1:0] 	tag;


cache_state	C_State;
cache_state	N_State;

cache_entry [SETNUM-1:0] cache_arr[(DEGREES)-1:0]; // need to rethink blocks in set

logic [$clog2(DEGREES)-1:0] last_used_shift_reg[DEGREES-1:0];

// format of address == tag[31:7]->set[6:4]->byte_off[3:0]

initial begin
	// this will set all valid bits to 0 
  for (int i = 0; i < DEGREES; i++) begin
    last_used_shift_reg[i] = i;

	for (int i = 0; i < SETNUM; i++)
    for (int j = 0; j < DEGREES; j++)
      cache_arr[j][i].Valid = 1'b0;
  end
	C_State = COMP_TAG;
end 

always_ff @(posedge clk_i) begin
	C_State <= N_State;
  if (degree != last_used_shift_reg[0])
    `UPDATE_SHIFT_REG(last_used_shift_reg, degree);
end


always_comb begin // logic for state machine and outputs
	set = (FromIns_i.WriteBack) ? FromIns_i.Addr[31-TAGSIZE:BYTE_ADDR_BITS] : CPUD_i.Addr[31-TAGSIZE:BYTE_ADDR_BITS]; 
	tag = (FromIns_i.WriteBack) ? FromIns_i.Addr[31:32-TAGSIZE] : CPUD_i.Addr[31:32-TAGSIZE];
	byte_off = (FromIns_i.WriteBack) ? FromIns_i.Addr[BYTE_ADDR_BITS-1:0] : CPUD_i.Addr[BYTE_ADDR_BITS-1:0];
	case(C_State)
    COMP_TAG: begin
      if (cache_arr[0][set].Valid && cache_arr[0][set].Tag == tag) begin
        degree = 2'd0;
        hit = 1'b1;
      end
      else if (cache_arr[1][set].Valid && cache_arr[1][set].Tag == tag) begin
        degree = 2'd1;
        hit = 1'b1;
      end
      else if (cache_arr[2][set].Valid && cache_arr[2][set].Tag == tag) begin
        degree = 2'd2;
        hit = 1'b1;
      end
      else if (cache_arr[3][set].Valid && cache_arr[3][set].Tag == tag) begin
        degree = 2'd3;
        hit = 1'b1;
      end
      else
        hit = 1'b0;
      if (CPUD_i.Valid && hit) begin
        N_State = OUTPUT;
      end
      else if (CPUD_i.Valid) begin
        degree = last_used_shift_reg[DEGREES-1];
        N_State = ALLOCATE;
      end
      MemD_o.Valid = 1'b0;
      CPUD_o.Ready = 1'b0;
    end

    WRITE_THROUGH: begin
      // write to cache
      cache_arr[degree][set].Valid = 1'b1;
      `WRITE(cache_arr[degree][set].Data, byte_off, CPUD_i.ByteData);
      // write to main memory
      MemD_o.Valid = 1'b1;		
      MemD_o.Wen = 1'b1;
      MemD_o.WriteD = cache_arr[degree][set].Data;
      MemD_o.Addr = CPUD_i.Addr;
      if (MemD_i.Ready)
        N_State = OUTPUT;
      else
        N_State = C_State;
      end
    end

    ALLOCATE: begin
      MemD_o.Wen = 1'b0;
      MemD_o.Valid = 1'b1;
      MemD_o.Addr = CPUD_i.Addr;
      MemD_o.WriteD = {BLOCKSIZE{1'bx}};
      if (MemD_i.Ready) begin
        if (CPUD_i.Wen)
          N_State = WRITE_THROUGH;
        else
          N_State = OUTPUT;
        cache_arr[degree][set].Data = MemD_i.ReadD;
        cache_arr[degree][set].Tag = tag;
        cache_arr[degree][set].Valid = 1'b1;
        cache_arr[degree][set].Dirty = 1'b0;
      end
      else
        N_State = C_State;
      CPUD_o.Ready = 1'b0;
    end

    OUTPUT: begin
      N_State = COMP_TAG;
      CPUD_o.Ready = 1'b1;	
      MemD_o.Valid = 1'b0;
    end
	endcase
end

Mux16 #(8) ByteSelect(
	.sel_i  (byte_off),
	.in0_i  (cache_arr[degree][set].Data[7:0]),
	.in1_i  (cache_arr[degree][set].Data[15:8]),
	.in2_i  (cache_arr[degree][set].Data[23:16]),
	.in3_i  (cache_arr[degree][set].Data[31:24]),
	.in4_i  (cache_arr[degree][set].Data[39:32]),
	.in5_i  (cache_arr[degree][set].Data[47:40]),
	.in6_i  (cache_arr[degree][set].Data[55:48]),
	.in7_i  (cache_arr[degree][set].Data[63:56]),
	.in8_i  (cache_arr[degree][set].Data[71:64]),
	.in9_i  (cache_arr[degree][set].Data[79:72]),
	.in10_i (cache_arr[degree][set].Data[87:80]),
	.in11_i (cache_arr[degree][set].Data[95:88]),
	.in12_i (cache_arr[degree][set].Data[103:96]),
	.in13_i (cache_arr[degree][set].Data[111:104]),
	.in14_i (cache_arr[degree][set].Data[119:112]),
	.in15_i (cache_arr[degree][set].Data[127:120]),

	.out_o  (CPUD_o.ByteOut)
);

// feel free to delete this it was for mapping out the steps
// could be left to document how was designed or added to README

/*
for the cache:
It recieves a request for a load with an address from the CPU requesting Data (Addr) and so Cready goes low and Valid goes high
NOTE: For an instruction not a Load/Store valid will be set low unless we have a miss
2. It takes this address and compares the set bits to detect which set to check
3. It checks the block offset to determine which block 
4. It checks the byte_off offset to determine which byte_off
5. It checks the tag of this byte_off
6. Now the tree splits into two paths on either a HIT or a MISS

HIT:
7. This byte_off is outputted in ByteData along with relevant half word and word
8. The cache is now finished with this request and Cready goes high on the cycle it outputs the data 

MISS:
NOTE: if the instruction was not load/store but a miss occurs valid must go high as we are changing cache data
7. The data must be fetched from main memory so MOutput must be configured
8. The data is returned from main memory and this must be written to the correct block
9. finally the data must be outputted
10. The cache is now finished so Cready goes high on the cycle it outputs
*/
	
endmodule
