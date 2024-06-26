`define UPDATE_SHIFT_REG(SHIFT_REG, NEWVAL) \
  for (int i = 1; i < DEGREES; i++) begin \
    SHIFT_REG[i] <= SHIFT_REG[i-1]; \
  end \
  SHIFT_REG[0] <= NEWVAL;

module L2Cache
  import mem_pkg::*;
(
	input logic 	      clk_i,
	input L1ToL2_t    	l1_i,
	input MemToCache_t	MemD_i,

	output L2ToL1_t     l1_o,
	output CacheToMem_t MemD_o
);

typedef enum {COMP_TAG, ALLOCATE, WRITE_BACK} cache_state;

logic 			hit;

logic [$clog2(DEGREES)-1:0] 	degree;
logic [$clog2(SETNUM)-1:0] 	set;
logic [TAGSIZE-1:0] 	tag;

cache_state	C_State;
cache_state	N_State;

cache_entry [SETNUM-1:0] cache_arr[(DEGREES)-1:0]; // need to rethink blocks in set

logic [$clog2(DEGREES)-1:0] last_used_shift_reg[DEGREES-1:0];

// format of address == tag[31:7]->set[6:4]->byte_off[3:0]

initial begin
	// this will set all valid bits to 0 
	for (int i = 0; i < SETNUM; i++)
    for (int j = 0; j < DEGREES; j++) begin
      cache_arr[j][i].Valid = 1'b0;
      cache_arr[j][i].Dirty = 1'b0;
    end

  for (int i = 0; i < DEGREES; i++) begin
    last_used_shift_reg[i] = i;
  end
	C_State = COMP_TAG;
end 

always_ff @(posedge clk_i) begin
	C_State <= N_State;
  if (degree != last_used_shift_reg[0])
    `UPDATE_SHIFT_REG(last_used_shift_reg, degree);
end


always_comb begin // logic for state machine and outputs
	set = l1_i.Addr[31-TAGSIZE:BYTE_ADDR_BITS]; 
	tag = l1_i.Addr[31:32-TAGSIZE];
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
      if (l1_i.Valid && hit) begin // hit
        if (l1_i.Wen) begin
          cache_arr[degree][set].Dirty = 1'b1;
          cache_arr[degree][set].Data = l1_i.WriteD;
        end
        l1_o.Dst = l1_i.Src;
        l1_o.ReadD = cache_arr[degree][set].Data;
        l1_o.Ready = 1'b1;
        N_State = C_State;
      end
      else if (l1_i.Valid) begin // no hit
        if (cache_arr[last_used_shift_reg[DEGREES-1]][set].Dirty)
          N_State = WRITE_BACK;
        else
          N_State = ALLOCATE;
        l1_o.Ready = 1'b0;
      end
      else begin
        l1_o.Ready = 1'b0;
      end
      MemD_o.Valid = 1'b0;
    end

    ALLOCATE: begin
      MemD_o.Wen = 1'b0;
      MemD_o.Valid = 1'b1;
      MemD_o.Addr = l1_i.Addr;
      MemD_o.WriteD = {BLOCKSIZE{1'bx}};
      if (MemD_i.Ready) begin
        N_State = COMP_TAG;
        cache_arr[last_used_shift_reg[DEGREES-1]][set].Data = MemD_i.ReadD;
        cache_arr[last_used_shift_reg[DEGREES-1]][set].Tag = tag;
        cache_arr[last_used_shift_reg[DEGREES-1]][set].Valid = 1'b1;
        cache_arr[last_used_shift_reg[DEGREES-1]][set].Dirty = 1'b0;
      end
      else
        N_State = C_State;
      l1_o.Ready = 1'b0;
    end

    WRITE_BACK: begin
      MemD_o.Wen = 1'b1;
      MemD_o.Valid = 1'b1;
      MemD_o.Addr = {cache_arr[last_used_shift_reg[DEGREES-1]][set].Tag, set, {BYTE_ADDR_BITS{1'bx}}};
      MemD_o.WriteD = cache_arr[last_used_shift_reg[DEGREES-1]][set].Data;
      if (MemD_i.Ready) begin
        N_State = ALLOCATE;
        MemD_o.Valid = 1'b0;
      end
      else
        N_State = C_State;
      l1_o.Ready = 1'b0;
    end
	endcase
end
	
endmodule
