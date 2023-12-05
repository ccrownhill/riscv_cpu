module cache
  import mem_pkg::*;
(
  input logic clk_i,
  input mem_input_t cache_i,
  input mem_output_t from_mem_i,

  output mem_input_t to_mem_o,
  output mem_output_t cache_o
);

typedef enum {IDLE, COMP_TAG, ALLOCATE, WRITE_BACK} CacheState;

CacheState cur_state, next_state;

cache_entry_t [2**CACHE_INDEX_SIZE-1:0] cache_arr;

logic [CACHE_INDEX_SIZE-1:0] idx; // index into cache_arr
logic [TAG_SIZE-1:0] tag;
logic hit;

always_ff @(posedge clk_i) begin
  cur_state <= next_state; 
end

// next state and output logic
// the two are combined together to avoid double checking of certain
// conditions
always_comb begin
  idx = cache_i.Addr[CACHE_INDEX_SIZE+2-1:2];
  tag = cache_i.Addr[31:32 - TAG_SIZE];
  case (cur_state)
    IDLE: begin
      if (cache_i.Valid == 1'b1)
        next_state = COMP_TAG;
      else
        next_state = cur_state;
      cache_o.Rdata = {BLOCK_SIZE{1'bx}};
      cache_o.Ready = 1'b0;
      to_mem_o.Valid = 1'b0;
    end
    COMP_TAG: begin
      hit = (cache_arr[idx].Tag == tag) ? 1'b1 : 1'b0;
      if (hit && cache_arr[idx].Valid && cache_i.Valid) begin
        next_state = IDLE;
        cache_o.Ready = 1'b1;
        if (cache_i.Write) begin
          cache_arr[idx].Data =
            (cache_arr[idx].Data & ~cache_i.Mask)
            | (cache_i.Wdata & cache_i.Mask);
          cache_arr[idx].Dirty = 1'b1;
        end
        else begin
          cache_o.Rdata = cache_arr[idx].Data & cache_i.Mask;
        end
      end
      else if (cache_i.Valid) begin
        if (cache_arr[idx].Dirty)
          next_state = WRITE_BACK;
        else
          next_state = ALLOCATE;
        cache_o.Rdata = {BLOCK_SIZE{1'bx}};
        cache_o.Ready = 1'b0;
      end
      to_mem_o.Valid = 1'b0;
    end
    ALLOCATE: begin
      to_mem_o.Write = 1'b0;
      to_mem_o.Valid = 1'b1;
      to_mem_o.Mask = {BLOCK_SIZE{1'b1}};
      to_mem_o.Addr = cache_i.Addr;
      to_mem_o.Wdata = {BLOCK_SIZE{1'bx}};
      if (from_mem_i.Ready) begin
        next_state = COMP_TAG;
        cache_arr[idx].Tag = tag;
        cache_arr[idx].Data = from_mem_i.Rdata;
        cache_arr[idx].Dirty = 1'b0;
        cache_arr[idx].Valid = 1'b1;
      end
      else
        next_state = cur_state;
      cache_o.Rdata = {BLOCK_SIZE{1'bx}};
      cache_o.Ready = 1'b0;
    end
    WRITE_BACK: begin
      to_mem_o.Write = 1'b1;
      to_mem_o.Valid = 1'b1;
      to_mem_o.Addr = {cache_arr[idx].Tag, idx, {OFFSET_BITS{1'b0}}};
      to_mem_o.Wdata = cache_arr[idx].Data;
      to_mem_o.Mask = {BLOCK_SIZE{1'b1}};
      
      cache_o.Rdata = {BLOCK_SIZE{1'bx}};
      cache_o.Ready = 1'b0;
    end
  endcase
end

endmodule
