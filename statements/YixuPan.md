# IAC Coursework Autumn 2023
## Personal statement of  contribution
Yixu Pan(Yixu Pan) 
## Overview

* `MainMemory`
* `DataMem`
* `ALU`
* `RegFile`
* `Memextend`
* `DataPath`
* `DirectMappedCache`(In Branch Pan only)
* `SetAssociativeCache`(In Branch Pan only)
* Test and write report for all RV32I instruction
* Write comments for F1 light program

## MainMemory
The `MainMemory.sv` I wrote was for the data cache design. It stand as one lower level than cache memory in memory hierarchy and will interact with cache frequently. For reading data once cache miss, it fetch data from the main memory to the cache and replace some original data of cache. And for writing data, as we apply both the write-back policy and write-through policy in different version, the write instruction will only happen when data replaced or modified in the cache for write-back and always write in write through. 
The code was designed to control with cache valid bit and write enable signal, It will return the block size read out and a ready signal to tell whether the memory data is ready for another read or write operation. This design can be shown by part of the code below:
```
always_ff @(posedge clk) begin
  if(CacheData_i.Valid) begin
    if(CacheData_i.Wen) begin
      mem_arr[CacheData_i.Addr[31:BLOCK_ADDR_BIT]] <= CacheData_i.WriteD;
      MemOut_o.ReadD <= {BLOCK_SIZE{1'bx}};
    end
    else begin
      MemOut_o.ReadD <= mem_arr[CacheData_i.Addr[31:BLOCK_ADDR_BIT]];
    end
    MemOut_o.Ready <= 1'b1;
  end
  else begin
    MemOut_o.ReadD <= {BLOCK_SIZE{1'bx}};
    MemOut_o.Ready <= 1'b0;
  end
end
```

## DataMem
The `DataMem.sv` I wrote work as the data memory block inside the datapath for single-cycle design and work as Memory stage for Pipelined RV32I stage. It was designed to have synchronous writting operation and asynchronous reading operation, which controled by the MemWrite and addressport. The write instruction only take 1 byte to store in the data memory and read instruction also take 1 byte to the register file every cycle.
My design goal is to provide all RV32I load and store instructions for our CPU through this data memory(lb, lh, lw, lbu, lhu, sb, sh, sw). The certain instruction used should be simply depends on the funct3 provide by the instruction line. This design approch can be proved by the following part of my code:

```
// READ instruction
always_comb
	case(funct3_i)
		3'b000:		ReadData_o = {{24{ram_arr[AddressPort_i][7]}}, ram_arr[AddressPort_i]}; //lb
		3'b001:		ReadData_o = {{16{ram_arr[AddressPort_i+1][7]}}, ram_arr[AddressPort_i+1], ram_arr[AddressPort_i]}; //lh
		3'b010:		ReadData_o = {ram_arr[AddressPort_i+3], ram_arr[AddressPort_i+2], ram_arr[AddressPort_i+1], ram_arr[AddressPort_i]}; //lw
		3'b100:		ReadData_o = {24'b0, ram_arr[AddressPort_i]};//lbu
		3'b101:		ReadData_o = {16'b0, ram_arr[AddressPort_i+1], ram_arr[AddressPort_i]};//lhu
    default: ReadData_o = 32'bx;
	endcase

// WRITE instruction
always_ff @(posedge clk_i) begin
	if(MemWrite_i) begin
		case(funct3_i)
			3'b000: ram_arr[AddressPort_i] <= WriteData_i[7:0]; //sb
			3'b001: {ram_arr[AddressPort_i+1], ram_arr[AddressPort_i]} <= {WriteData_i[15:8], WriteData_i[7:0]}; //sh
			3'b010: {ram_arr[AddressPort_i+3], ram_arr[AddressPort_i+2], ram_arr[AddressPort_i+1], ram_arr[AddressPort_i]} <= {WriteData_i[31:24], WriteData_i[23:16], WriteData_i[15:8], WriteData_i[7:0]}; //sw
      default: ram_arr[AddressPort_i] <= ram_arr[AddressPort_i];
		endcase
	end
end
```

I have also do the testing for all of load and read instruction and the test assembly code is provided as `load_store_test.s`

## ALU
The `ALU.sv` I wrote initially only deal add and sub operations in lab 4 but later project requies more, thus I edit it to work for all I and R type arthmetic, logic, shifting and comparision instructions of RV32I: RISC-V integer instructions. All the instructions are controlled by the ALUctrl signal but for the I type instruction as they can not be identify by the 6th bit of the funct5 signal, so we have to deal with I type and R type instructions differently and this design approch can be see at the ALUdecode and this is why our ALUctrl is 4 bit rather than 3.
The instructions that are included in this ALU are: add, sub, sll, slt, sltu, xor, srl, sra, or, and, addi, slli, slti, sltiu, xori, srli, srai, ori and andi.

## RegFile
The `RegFile.sv` I wrote was designed with synchonous writting and asyhconous reading operations. It assign output a0 with the x10 register and simply work as a temporary storage with fast access. This part is maly used for the single-cycle design.

## MemExtend
The `MemExtend.sv` I wrote are used for the Main memory to be able to do the load and store instructions which apply basicly the same principle with the data memory we have for the single-cycle and the pipelined RISC-V. However unfortunately, as our cache use load byte only on design purpose, some of my code has been deleted didn't include all the load and store RV32I instruction in this data cache design.

## DataPath
The `DataPath.sv` was mainly used on our single-cycle design, it was initially created by me to include register file, mux, ALU and data memory to be inside a top level datapath file and more easy to be used with the controlpath to generate the entire top level of cpu. This datapath are further design by Constandin.

## Two type of basic cache design in branch Pan
I have wrote the basic structure with both Direct-mapped and set-associative cache before our group work out our final design and this two file can be partly referrence of the structure of the cache and it shows my initial and general understanding before our group discussion. As they are design of general structure of cache, these two version of cache have not build connection with main memory on the code.

### DirectMappedCache
The `DirectMappedCache.sv` I wrote have use the design of setting local parameter to initialize the block size, number of block, index size, offset size and also tag size. These local parameter are calculated by pre-set variables and below are the code for identify these local parameter:
```
localparam BLOCK_SIZE = DATA_WIDTH / 8; //one word per cache block 
localparam NUM_BLOCKS = CACHE_SIZE / BLOCK_SIZE; //derive cache lines
localparam INDEX_SIZE = $clog2(NUM_BLOCKS); // Size of index
localparam OFFSET_SIZE = $clog2(BLOCK_SIZE); // SIze of byte offset
localparam TAG_SIZE = ADDRESS_WIDTH - INDEX_SIZE - OFFSET_SIZE; // Size of tag
```
The other design I use is to initialize the cache block line with the certain structure and make this structure to form cache memory array like the below code:
```
// Cache line structure
typedef struct {
  logic Valid;
  logic [TAG_SIZE-1:0] Tag;
  logic [DATA_WIDTH-1:0] data;
} cache_line_t;

cache_line_t cache [NUM_LINES]; // Cache memory
```
With the cache memory ready, The rest are handle with the writing and reading instruction in the cache and I also add a hit signal to enable the fetch from main memory to happen and also handle with the writing instructions.
### SetAssociativeCache
The `SetAssociativeCache.sv` I wrote is a 2-way design but the way number can be modified with variable. This cache have simillar srtucture with the direct but I have change the cache memory array with different way size like below but however as a general structural cache I did not connect it with mux and mainmemory.
```
cache_line_t cache [NUM_LINES][NUM_WAYS]; // Cache memory
```

## Testing of all RV32I: RISC-V integer instructions and comments on our F1 assembly program
I have write all the testing assembly code for all RV32I: RISC-V interger instructions included in our CPU design, program are inside the test file and the result with prove are also included in the readme, they are seperated into:
* load and store instructions `load_store_test.s`
* Instructions with ALU `ALUtest.s`
* Branch instructions `Branchs.s`
The explaination and comments of the F1 assembly code are shown on the readme of test file.
