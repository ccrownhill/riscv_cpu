`define UPDATE_SHIFT_REG(SHIFT_REG, NEWVAL) \
  for (int i = 1; i < DEGREES; i++) begin \
    SHIFT_REG[i] = SHIFT_REG[i-1]; \
  end \
  SHIFT_REG[0] = NEWVAL;

// `define WRITE_BYTE(CACHE_BLOCK, OFFSET, BYTE) \
//   for (int i = 0; i < BLOCKSIZE/8; i++) begin \
//     CACHE_BLOCK[i*8 + 7:i*8] = (OFFSET == i) ? BYTE : CACHE_BLOCK[i*8 + 7:i*8]; \
//   end
// 
// `define WRITE_HALF(CACHE_BLOCK, OFFSET, HALF) \
//   for (int i = 0; i < BLOCKSIZE/8; i++) begin \
//     CACHE_BLOCK[i*8 + 15:i*8] = (OFFSET == i) ? HALF : CACHE_BLOCK[i*8 + 15:i*8]; \
//   end

`define UPDATE_DEGREE_HIT(CACHE_ARR, TAG, SET, DEGREE, HIT) \
	if (CACHE_ARR[0][SET].Valid && CACHE_ARR[0][SET].Tag == TAG) begin \
    DEGREE = 2'd0; \
    HIT = 1'b1; \
	end \
	else if (CACHE_ARR[1][SET].Valid && CACHE_ARR[1][SET].Tag == TAG) begin \
    DEGREE = 2'd1; \
    HIT = 1'b1; \
	end \
	else if (CACHE_ARR[2][SET].Valid && CACHE_ARR[2][SET].Tag == TAG) begin \
    DEGREE = 2'd2; \
    HIT = 1'b1; \
	end \
	else if (CACHE_ARR[3][SET].Valid && CACHE_ARR[3][SET].Tag == TAG) begin \
    DEGREE = 2'd3; \
    HIT = 1'b1; \
	end \
	else \
    HIT = 1'b0;


`define WRITE(CACHE_BLOCK, OFFSET, DATA, DATA_LEN) \
    CACHE_BLOCK[0*8 + (DATA_LEN-1):0*8] = (OFFSET == 0) ? DATA : CACHE_BLOCK[0*8 + (DATA_LEN-1):0*8]; \
    CACHE_BLOCK[1*8 + (DATA_LEN-1):1*8] = (OFFSET == 1) ? DATA : CACHE_BLOCK[1*8 + (DATA_LEN-1):1*8]; \
    CACHE_BLOCK[2*8 + (DATA_LEN-1):2*8] = (OFFSET == 2) ? DATA : CACHE_BLOCK[2*8 + (DATA_LEN-1):2*8]; \
    CACHE_BLOCK[3*8 + (DATA_LEN-1):3*8] = (OFFSET == 3) ? DATA : CACHE_BLOCK[3*8 + (DATA_LEN-1):3*8]; \
    CACHE_BLOCK[4*8 + (DATA_LEN-1):4*8] = (OFFSET == 4) ? DATA : CACHE_BLOCK[4*8 + (DATA_LEN-1):4*8]; \
    CACHE_BLOCK[5*8 + (DATA_LEN-1):5*8] = (OFFSET == 5) ? DATA : CACHE_BLOCK[5*8 + (DATA_LEN-1):5*8]; \
    CACHE_BLOCK[6*8 + (DATA_LEN-1):6*8] = (OFFSET == 6) ? DATA : CACHE_BLOCK[6*8 + (DATA_LEN-1):6*8]; \
    CACHE_BLOCK[7*8 + (DATA_LEN-1):7*8] = (OFFSET == 7) ? DATA : CACHE_BLOCK[7*8 + (DATA_LEN-1):7*8]; \
    CACHE_BLOCK[8*8 + (DATA_LEN-1):8*8] = (OFFSET == 8) ? DATA : CACHE_BLOCK[8*8 + (DATA_LEN-1):8*8]; \
    CACHE_BLOCK[9*8 + (DATA_LEN-1):9*8] = (OFFSET == 9) ? DATA : CACHE_BLOCK[9*8 + (DATA_LEN-1):9*8]; \
    CACHE_BLOCK[10*8 + (DATA_LEN-1):10*8] = (OFFSET == 10) ? DATA : CACHE_BLOCK[10*8 + (DATA_LEN-1):10*8]; \
    CACHE_BLOCK[11*8 + (DATA_LEN-1):11*8] = (OFFSET == 11) ? DATA : CACHE_BLOCK[11*8 + (DATA_LEN-1):11*8]; \
    CACHE_BLOCK[12*8 + (DATA_LEN-1):12*8] = (OFFSET == 12) ? DATA : CACHE_BLOCK[12*8 + (DATA_LEN-1):12*8]; \
    CACHE_BLOCK[13*8 + (DATA_LEN-1):13*8] = (OFFSET == 13) ? DATA : CACHE_BLOCK[13*8 + (DATA_LEN-1):13*8]; \
    CACHE_BLOCK[14*8 + (DATA_LEN-1):14*8] = (OFFSET == 14) ? DATA : CACHE_BLOCK[14*8 + (DATA_LEN-1):14*8]; \
    CACHE_BLOCK[15*8 + (DATA_LEN-1):15*8] = (OFFSET == 15) ? DATA : CACHE_BLOCK[15*8 + (DATA_LEN-1):15*8]; \

`define WRITE_BLOCK(CACHE_BLOCK, OFFSET, BYTE, HALF, WORD, FUNCT3) \
	case (FUNCT3) \
    3'b000: begin \
      `WRITE(CACHE_BLOCK, OFFSET, BYTE, 8) \
    end \
    3'b001: begin \
      `WRITE(CACHE_BLOCK, OFFSET, HALF, 16) \
    end \
    3'b010: begin \
      `WRITE(CACHE_BLOCK, OFFSET, WORD, 32) \
    end\
		default: CACHE_BLOCK = CACHE_BLOCK; \
	endcase

module Cache
  import mem_pkg::*;
(
	input CInput	CPUD_i,
	input MOutput	MemD_i,
	input logic 	clk,

	output COutput  CPUD_o,
	output MInput  MemD_o,
	output logic 	Cready_o
);

typedef enum {COMP_TAG, ALLOCATE, WRITE_MEM, WRITE_THROUGH, OUTPUT} cache_state;

logic 			hit;

logic [1:0] 	degree;
logic [2:0] 	set;
logic [3:0]		byte_off;
logic [24:0] 	tag;


cache_state	C_State;
cache_state	N_State;

cache_entry [SETNUM-1:0] cache_arr[(DEGREES)-1:0]; // need to rethink blocks in set

logic [$clog2(DEGREES)-1:0] last_used_shift_reg[DEGREES-1:0];

// format of address == tag[31:7]->set[6:4]->byte_off[3:0]

initial begin
	// this needs to set all valid bits to 0 
	// hopefully this for loop is acceptable for initialisation
	for (int i=0; i<SETNUM; ++i) begin
		cache_arr[0][i].Valid = 1'b0;
		cache_arr[1][i].Valid = 1'b0;
		cache_arr[2][i].Valid = 1'b0;
		cache_arr[3][i].Valid = 1'b0;
	end
	C_State = COMP_TAG;
end 

always_ff @(posedge clk) begin
	C_State <= N_State;
end


always_comb begin // logic for state machine and outputs
	set = CPUD_i.Addr	[6:4]; 
	tag = CPUD_i.Addr	[31:7];
	byte_off = CPUD_i.Addr	[3:0];
	case(C_State)
    COMP_TAG: begin
      `UPDATE_DEGREE_HIT(cache_arr, tag, set, degree, hit)
      if (CPUD_i.Valid && hit) begin
        if (degree != last_used_shift_reg[0])
            `UPDATE_SHIFT_REG(last_used_shift_reg, degree);

        if (CPUD_i.Wen) begin
          N_State = WRITE_THROUGH;
        end
        else begin
          N_State = OUTPUT;
        end
      end
      else if (CPUD_i.Valid && !hit && !CPUD_i.Wen) begin
        N_State = ALLOCATE;
      end
      else if (CPUD_i.Valid && !hit && CPUD_i.Wen) begin
        N_State = WRITE_MEM;
      end
      MemD_o.Valid = 1'b0;
      Cready_o = 1'b0;
    end
    WRITE_THROUGH: begin
      degree = last_used_shift_reg[0];
      // write to cache
      cache_arr[degree][set].Valid = 1'b1;
      `WRITE_BLOCK(cache_arr[degree][set].Data, byte_off, CPUD_i.ByteData, CPUD_i.HalfData,
                    CPUD_i.WordData, CPUD_i.funct3);
      // write to main memory
      MemD_o.Valid = 1'b1;		
      MemD_o.Wen = 1'b1;
      MemD_o.WriteD = cache_arr[degree][set].Data;
      MemD_o.Addr = CPUD_i.Addr;
      if (MemD_i.Ready)
        N_State = OUTPUT;
      else
        N_State = C_State;
      Cready_o = 1'b0;
    end
    ALLOCATE: begin
      degree = last_used_shift_reg[DEGREES-1];
      //`UPDATE_SHIFT_REG(last_used_shift_reg, degree);
      MemD_o.Wen = 1'b0;
      MemD_o.Valid = 1'b1;
      MemD_o.Addr = CPUD_i.Addr;
      MemD_o.WriteD = {BLOCKSIZE{1'bx}};
      if (MemD_i.Ready) begin
        N_State = OUTPUT;
        cache_arr[degree][set].Data = MemD_i.ReadD;
        cache_arr[degree][set].Tag = tag;
        cache_arr[degree][set].Valid = 1'b1;
      end
      else
        N_State = C_State;
      Cready_o = 1'b0;
    end
    WRITE_MEM: begin
      degree = last_used_shift_reg[DEGREES-1];
      //`UPDATE_SHIFT_REG(last_used_shift_reg, degree);
      cache_arr[degree][set].Tag = tag;
      N_State = WRITE_THROUGH;
      MemD_o.Valid = 1'b0;
      Cready_o = 1'b0;
    end
    OUTPUT: begin
      `UPDATE_DEGREE_HIT(cache_arr, tag, set, degree, hit)
      N_State = COMP_TAG;
      Cready_o = 1'b1;	
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

	.out_o  (CPUD_o.ByteData)
);

Mux16 #(16) HalfSelect (
	.sel_i  (byte_off),
	.in0_i  (cache_arr[degree][set].Data[15:0]),
	.in1_i  (cache_arr[degree][set].Data[23:8]),
	.in2_i  (cache_arr[degree][set].Data[31:16]),
	.in3_i  (cache_arr[degree][set].Data[39:24]),
	.in4_i  (cache_arr[degree][set].Data[47:32]),
	.in5_i  (cache_arr[degree][set].Data[55:40]),
	.in6_i  (cache_arr[degree][set].Data[63:48]),
	.in7_i  (cache_arr[degree][set].Data[71:56]),
	.in8_i  (cache_arr[degree][set].Data[79:64]),
	.in9_i  (cache_arr[degree][set].Data[87:72]),
	.in10_i (cache_arr[degree][set].Data[95:80]),
	.in11_i (cache_arr[degree][set].Data[103:88]),
	.in12_i (cache_arr[degree][set].Data[111:96]),
	.in13_i (cache_arr[degree][set].Data[119:104]),
	.in14_i (cache_arr[degree][set].Data[127:112]),
	.in15_i (cache_arr[degree][set].Data[135:120]),

	.out_o  (CPUD_o.HalfData)
);

Mux16 #(32) WordSelect (
	.sel_i  (byte_off),
	.in0_i  (cache_arr[degree][set].Data[31:0]),
	.in1_i  (cache_arr[degree][set].Data[39:8]),
	.in2_i  (cache_arr[degree][set].Data[47:16]),
	.in3_i  (cache_arr[degree][set].Data[55:24]),
	.in4_i  (cache_arr[degree][set].Data[63:32]),
	.in5_i  (cache_arr[degree][set].Data[71:40]),
	.in6_i  (cache_arr[degree][set].Data[79:48]),
	.in7_i  (cache_arr[degree][set].Data[87:56]),
	.in8_i  (cache_arr[degree][set].Data[95:64]),
	.in9_i  (cache_arr[degree][set].Data[103:72]),
	.in10_i (cache_arr[degree][set].Data[111:80]),
	.in11_i (cache_arr[degree][set].Data[119:88]),
	.in12_i (cache_arr[degree][set].Data[127:96]),
	.in13_i (cache_arr[degree][set].Data[135:104]),
	.in14_i (cache_arr[degree][set].Data[143:112]),
	.in15_i (cache_arr[degree][set].Data[150:120]),

	.out_o  (CPUD_o.WordData)
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
