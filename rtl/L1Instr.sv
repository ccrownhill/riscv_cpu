`define UPDATE_SHIFT_REG(SHIFT_REG, NEWVAL) \
  for (int i = 1; i < DEGREES; i++) begin \
    SHIFT_REG[i] <= SHIFT_REG[i-1]; \
  end \
  SHIFT_REG[0] <= NEWVAL;

module L1Instr
  import mem_pkg::*;
(
	input logic 	      clk_i,
	input L1InstrIn_t   CPUD_i,
	input MemToCache_t	MemD_i,
  input Dat2Ins_t     FromDat_i,

  output Ins2Dat_t    ToDat_o,
	output L1InstrOut_t  CPUD_o,
	output CacheToMem_t MemD_o
);

typedef enum {COMP_TAG, ALLOCATE} cache_state;

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
	set = (FromDat_i.Invalidate) ? FromDat_i.Addr[31-TAGSIZE:BYTE_ADDR_BITS] : CPUD_i.Addr[31-TAGSIZE:BYTE_ADDR_BITS]; 
	tag = (FromDat_i.Invalidate) ? FromDat_i.Addr[31:32-TAGSIZE] : CPUD_i.Addr[31:32-TAGSIZE];
	byte_off = (FromDat_i.Invalidate) ? FromDat_i.Addr[BYTE_ADDR_BITS-1:0] : CPUD_i.Addr[BYTE_ADDR_BITS-1:0];
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
      if (FromDat_i.Invalidate) begin
        if (hit)
          cache_arr[degree][set].Valid = 1'b0;
        CPUD_o.Ready = 1'b0;
        N_State = C_State;
      end
      else if (CPUD_i.Valid && hit) begin // hit
        CPUD_o.Ready = 1'b1;
        N_State = C_State;
      end
      else if (CPUD_i.Valid) begin // no hit
        N_State = ALLOCATE;
        CPUD_o.Ready = 1'b0;
      end
      else begin
        N_State = C_State;
        CPUD_o.Ready = 1'b0;
      end
      MemD_o.Valid = 1'b0;
      ToDat_o.WriteBack = 1'b0;
      ToDat_o.Addr = 32'bx;
    end

    ALLOCATE: begin
      // make sure other cache does its write backs first
      ToDat_o.WriteBack = 1'b1;
      ToDat_o.Addr = CPUD_i.Addr;
      if (FromDat_i.Written) begin
        degree = last_used_shift_reg[DEGREES-1];
        MemD_o.Wen = 1'b0;
        MemD_o.Valid = 1'b1;
        MemD_o.Addr = CPUD_i.Addr;
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
endmodule
