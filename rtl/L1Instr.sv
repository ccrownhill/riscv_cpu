`define UPDATE_SHIFT_REG(SHIFT_REG, NEWVAL) \
  for (int i = 1; i < DEGREES; i++) begin \
    SHIFT_REG[i] <= SHIFT_REG[i-1]; \
  end \
  SHIFT_REG[0] <= NEWVAL;

module L1Instr
  import mem_pkg::*;
(
	input logic 	      clk_i,
	input logic [31:0]  PC_i,
	input MemToCache_t	MemD_i,

	output L1InstrOut_t  CPUD_o,
	output CacheToMem_t MemD_o
);

typedef enum {COMP_TAG, ALLOCATE, WRITE_BACK} cache_state;

logic 			hit;

logic [$clog2(DEGREES)-1:0] 	degree;
logic [$clog2(SETNUM)-1:0] 	  set;
logic [BYTE_ADDR_BITS-1:0]	  byte_off;
logic [TAGSIZE-1:0] 	tag;


cache_state	C_State;
cache_state	N_State;

cache_entry [SETNUM-1:0] cache_arr[(DEGREES)-1:0]; // need to rethink blocks in set

logic [$clog2(DEGREES)-1:0] last_used_shift_reg[DEGREES-1:0];

// format of address == tag[31:7]->set[6:4]->byte_off[3:0]

initial begin
	// this will set all valid bits to 0 
	for (int i = 0; i < SETNUM; i++)
    for (int j = 0; j < DEGREES; j++)
      cache_arr[j][i].Valid = 1'b0;
  for (int i = 0; i < DEGREES; i++) begin
    last_used_shift_reg[i] = {$clog2(DEGREES){1'b1}};
  end
	C_State = COMP_TAG;
end 

always_ff @(posedge clk_i) begin
	C_State <= N_State;
  if (degree != last_used_shift_reg[0])
    `UPDATE_SHIFT_REG(last_used_shift_reg, degree);
end


always_comb begin // logic for state machine and outputs
	set = PC_i[31-TAGSIZE:BYTE_ADDR_BITS]; 
	tag = PC_i[31:32-TAGSIZE];
	byte_off = PC_i[BYTE_ADDR_BITS-1:0];
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
      if (hit) begin // hit
        CPUD_o.Ready = 1'b1;
        N_State = C_State;
      end
      else begin // no hit
        if (cache_arr[last_used_shift_reg[DEGREES-1]][set].Dirty)
          N_State = WRITE_BACK;
        else
          N_State = ALLOCATE;
        CPUD_o.Ready = 1'b0;
      end
      MemD_o.Valid = 1'b0;
    end

    ALLOCATE: begin
      degree = last_used_shift_reg[DEGREES-1];
      MemD_o.Wen = 1'b0;
      MemD_o.Valid = 1'b1;
      MemD_o.Addr = PC_i;
      MemD_o.WriteD = {BLOCKSIZE{1'bx}};
      if (MemD_i.Ready) begin
        N_State = COMP_TAG;
        cache_arr[degree][set].Data = MemD_i.ReadD;
        cache_arr[degree][set].Tag = tag;
        cache_arr[degree][set].Valid = 1'b1;
        cache_arr[degree][set].Dirty = 1'b0;
      end
      else
        N_State = C_State;
      CPUD_o.Ready = 1'b0;
    end

    WRITE_BACK: begin
      MemD_o.Wen = 1'b1;
      MemD_o.Valid = 1'b1;
      MemD_o.Addr = {cache_arr[last_used_shift_reg[DEGREES-1]][set].Tag, set, byte_off};
      MemD_o.WriteD = cache_arr[last_used_shift_reg[DEGREES-1]][set].Data;
      if (MemD_i.Ready) begin
        N_State = ALLOCATE;
        MemD_o.Valid = 1'b0;
      end
      else
        N_State = C_State;
      CPUD_o.Ready = 1'b0;
    end
	endcase
end

Mux4 #(32) ByteSelect(
	.sel_i  (byte_off[BYTE_ADDR_BITS-1:2]),
	.in0_i  (cache_arr[degree][set].Data[31:0]),
	.in1_i  (cache_arr[degree][set].Data[63:32]),
	.in2_i  (cache_arr[degree][set].Data[95:64]),
	.in3_i  (cache_arr[degree][set].Data[127:96]),

	.out_o  (CPUD_o.ReadD)
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
