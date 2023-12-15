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
	input L2ToL1_t	    MemD_i,
  input L1ToL2_t      MemBus_i,

	output L1DataOut_t  CPUD_o,
	output L1ToL2_t     MemBus_o
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
  end

	for (int i = 0; i < SETNUM; i++)
    for (int j = 0; j < DEGREES; j++)
      cache_arr[j][i].Valid = 1'b0;
	C_State = COMP_TAG;
end 

always_ff @(posedge clk_i) begin
	C_State <= N_State;
  if (degree != last_used_shift_reg[0])
    `UPDATE_SHIFT_REG(last_used_shift_reg, degree);
end


always_comb begin // logic for state machine and outputs
	set = CPUD_i.Addr[31-TAGSIZE:BYTE_ADDR_BITS]; 
	tag = CPUD_i.Addr[31:32-TAGSIZE];
	byte_off = CPUD_i.Addr[BYTE_ADDR_BITS-1:0];
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
      if (CPUD_i.Valid && hit) begin // hit
        if (CPUD_i.Wen) begin
          N_State = WRITE_THROUGH;
        end
        else begin
          N_State = OUTPUT;
        end
      end
      else if (CPUD_i.Valid) begin // no hit
        degree = last_used_shift_reg[DEGREES-1];
        N_State = ALLOCATE;
      end
      CPUD_o.Ready = 1'b0;
    end

    ALLOCATE: begin
      if (MemBus_i.Valid == 1'b0 || MemBus_i.Src == 1'b1) begin
        MemBus_o.Wen = 1'b0;
        MemBus_o.Valid = 1'b1;
        MemBus_o.Src = 1'b1;
        MemBus_o.Addr = CPUD_i.Addr;
        MemBus_o.WriteD = {BLOCKSIZE{1'bx}};
        if (MemD_i.Ready && MemD_i.Dst == 1'b1) begin
          if (CPUD_i.Wen) begin
            N_State = WRITE_THROUGH;
          end
          else begin
            N_State = OUTPUT;
          end
          cache_arr[degree][set].Data = MemD_i.ReadD;
          cache_arr[degree][set].Tag = tag;
          cache_arr[degree][set].Valid = 1'b1;
        end
        else
          N_State = C_State;
      end
      else
        N_State = C_State;
      CPUD_o.Ready = 1'b0;
    end

    WRITE_THROUGH: begin
      if (MemBus_i.Valid == 1'b0 || MemBus_i.Src == 1'b1) begin
        MemBus_o.Wen = 1'b1;
        MemBus_o.Valid = 1'b1;
        MemBus_o.Src = 1'b1;
        MemBus_o.Addr = {cache_arr[degree][set].Tag, set, byte_off};
				`WRITE(cache_arr[degree][set].Data, byte_off, CPUD_i.ByteData);
        MemBus_o.WriteD = cache_arr[degree][set].Data;
        if (MemD_i.Ready && MemD_i.Dst == 1'b1) begin
          N_State = OUTPUT;
        end
        else begin
          N_State = C_State;
        end
      end
			else begin
				N_State = C_State;
			end
      CPUD_o.Ready = 1'b0;
    end

    OUTPUT: begin
      CPUD_o.Ready = 1'b1;
      N_State = COMP_TAG;
      degree = last_used_shift_reg[0];
      MemBus_o.Valid = 1'b0;
      MemBus_o.Wen = 1'b0;
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

endmodule
