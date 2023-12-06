
`define UPDATE_SHIFT_REG(SHIFT_REG, NEWVAL) \
  for (int i = 1; i < WAYS; i++) begin \
    SHIFT_REG[i] = SHIFT_REG[i-1]; \
  end \
  SHIFT_REG[0] = NEWVAL;

module cache
  import mem_pkg::*;
(
  input logic clk_i,
  input mem_input_t cache_i,
  input mem_output_t from_mem_i,

  output mem_input_t to_mem_o,
  output mem_output_t cache_o
);

typedef enum {COMP_TAG, ALLOCATE, WRITE_BACK} CacheState;

CacheState cur_state, next_state;

initial begin
  cur_state = COMP_TAG;
  next_state = COMP_TAG;
end

cache_entry_t [CACHE_BLOCKS/WAYS-1:0] cache_arr[WAYS-1:0];
logic [$clog2(WAYS)-1:0] last_used_shift_reg[WAYS-1:0];// shift register for stack of last used

logic [CACHE_INDEX_SIZE-1:0] idx; // index into cache_arr
logic [TAG_SIZE-1:0] tag;
logic hit;
logic [$clog2(WAYS)-1:0] way;

always_ff @(posedge clk_i) begin
  cur_state <= next_state; 
end

// next state and output logic
// the two are combined together to avoid double checking of certain
// conditions
always_comb begin
  idx = cache_i.Addr[CACHE_INDEX_SIZE+NON_BLOCK_ADDR_BITS-1:NON_BLOCK_ADDR_BITS];
  tag = cache_i.Addr[31:32 - TAG_SIZE];
  case (cur_state)
//     IDLE: begin
//       if (cache_i.Valid == 1'b1)
//         next_state = COMP_TAG;
//       else
//         next_state = cur_state;
//       cache_o.Rdata = {BLOCK_SIZE{1'bx}};
//       cache_o.Ready = 1'b0;
//       to_mem_o.Valid = 1'b0;
//     end
    COMP_TAG: begin
      if (cache_arr[0][idx].Valid && cache_arr[0][idx].Tag == tag) begin
        way = 2'd0;
        hit = 1'b1;
      end
      else if (cache_arr[1][idx].Valid && cache_arr[1][idx].Tag == tag) begin
        way = 2'd1;
        hit = 1'b1;
      end
      else if (cache_arr[2][idx].Valid && cache_arr[2][idx].Tag == tag) begin
        way = 2'd2;
        hit = 1'b1;
      end
      else if (cache_arr[3][idx].Valid && cache_arr[3][idx].Tag == tag) begin
        way = 2'd3;
        hit = 1'b1;
      end
      else
        hit = 1'b0;
      if (hit && cache_i.Valid) begin
        next_state = cur_state;
        cache_o.Ready = 1'b1;
        if (way != last_used_shift_reg[0]) begin
          `UPDATE_SHIFT_REG(last_used_shift_reg, way);
        end
        if (cache_i.Write) begin
          cache_arr[way][idx].Data =
            (cache_arr[way][idx].Data & ~cache_i.Mask)
            | (cache_i.Wdata & cache_i.Mask);
          cache_arr[way][idx].Dirty = 1'b1;
        end
        else begin
          cache_o.Rdata = cache_arr[way][idx].Data & cache_i.Mask;
        end
      end
      else if (cache_i.Valid) begin
        way = last_used_shift_reg[WAYS-1];
        if (cache_arr[way][idx].Dirty)
          next_state = WRITE_BACK;
        else
          next_state = ALLOCATE;
        cache_o.Rdata = {BLOCK_SIZE{1'bx}};
        cache_o.Ready = 1'b0;
      end
      to_mem_o.Valid = 1'b0;
    end
    ALLOCATE: begin
      way = last_used_shift_reg[WAYS-1];
      to_mem_o.Write = 1'b0;
      to_mem_o.Valid = 1'b1;
      to_mem_o.Mask = {BLOCK_SIZE{1'b1}};
      to_mem_o.Addr = cache_i.Addr;
      to_mem_o.Wdata = {BLOCK_SIZE{1'bx}};
      if (from_mem_i.Ready) begin
        next_state = COMP_TAG;
        cache_arr[way][idx].Tag = tag;
        cache_arr[way][idx].Data = from_mem_i.Rdata;
        cache_arr[way][idx].Dirty = 1'b0;
        cache_arr[way][idx].Valid = 1'b1;
      end
      else
        next_state = cur_state;
      cache_o.Rdata = {BLOCK_SIZE{1'bx}};
      cache_o.Ready = 1'b0;
    end
    WRITE_BACK: begin
      way = last_used_shift_reg[WAYS-1];
      to_mem_o.Write = 1'b1;
      to_mem_o.Valid = 1'b1;
      to_mem_o.Addr = {cache_arr[way][idx].Tag, idx, {OFFSET_BITS{1'b0}}};
      to_mem_o.Wdata = cache_arr[way][idx].Data;
      to_mem_o.Mask = {BLOCK_SIZE{1'b1}};
      
      cache_o.Rdata = {BLOCK_SIZE{1'bx}};
      cache_o.Ready = 1'b0;
    end
  endcase
end

endmodule
