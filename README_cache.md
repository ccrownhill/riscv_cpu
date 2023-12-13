# Caching

## initial design choices

This is the overall design we have chosen.

Cache size: 128 Words total capacity which is 512 bytes.
4 degrees of associative: Tracking least used by splitting the ways into two groups, tracking the least used group and randomly eliminating a way within the least used group when necessary.
16 Bytes in a block 
8 Sets total
4 blocks in a set
total number of blocks = 32
We will only have one level of cache. (To begin)
We will initially have a writethrough cache.

This is an example of a cache. For our purposes the 32 bit input to the mux will be 8 bit and our mux will be much larger to enable every byte to be individually addressed.
![Alt text](cache_address.png)

Inputs and outputs names:
Top Level Memory:  Memory.sv
on startup all data should be wiped and all V bits set to 0
inputs: 
- clk
- Addr_i [31:0]
- WriteD_i [31:0]
- Mwrite_i
- Mread_i
- funct3_i [2:0]
- ReadD_o [31:0]
- Mready_o

The cache itself: Cache.sv
- Valid_i
- Wen_i
- funct3_i [2:0]
- Addr_i [31:0] // this will form the various parts of the address such as tag and byte offset.
- WordData_i[31:0]
- HalfData_i [15:0]
- ByteData_i [7:0] 
- clk
- WordData_o [31:0]
- HalfData_o [15:0]
- ByteData_o [7:0] 
- Cready_o

The main memory: MainMemory.sv
- Valid_i
- Wen_i
- clk
- Addr_i [31:0]
- WriteD_i [127:0]
- ReadD_o [127:0] // on a miss the cache is updated with the missing block. Then the cache will read the desired byte and output it back to the cpu
- Ready_o

The 16 mux: Mux16.sv
Follows conventions of previous Muxs

Sign extender for the byte and half word outputs: MemExtend.sv
- WordData_i[31:0]
- HalfData_i [15:0]
- ByteData_i [7:0] 
- funct3_i [2:0]
- ExtD_o [31:0]

To split up this task we have done:
Constantin will be integrating the modules into the CPU.
Orlan will create Cache.sv
Pan will create MainMemory.sv and MemExtend.sv
Seb will create Mux16.sv and helping others with any issues

Introducing caching into our CPU was a very large task and because of the nature of the task it was very important to have set variable names. This would make connecting it in the top level much easier. It was a very fun but challenging task and we worked well as a team to achieve it. We decided to only implement l1 cache as this would be enough for our purposes.

The largest design choice we made was certainly making the cache byte addressed. We realised that the test program only used LB and SB instructions. This means that we could make better use of a cache by making it byte addressable. In this way we increased the amount of data our cache could store without increasing the size of it. We picked the size of our cache to be a reasonable size that could theoretically be implemented in a real CPU. Our block size was chosen to be quite large as we realised for the programs we will be running spatial locality would be very helpful in increasing the hit rate.

Testing the cache is difficult as we cannot simulate different delay times with fetching values from memory very easily. However assuming that our cache allows us to fetch form l1 in 2 cycle and form main memory in 100 cycles our cache should enable a significant speed increase in a real CPU. This is probably the single biggest improvement to our CPU we have made as pipelining our CPU with 5 stage could cause between a 3-5 times increase in clock frequency, but the cache could be 10 times faster assuming a decent hit rate.

The cache is 4 way set associative which should allow it to hold a large amount of data for plotting different distributions but in the case where some data must be replaced it selects the last used way using a shift register which allows us to make use of temporal locality. In these ways we take advantage of the principles of both spatial and temporal locality which again should improve our hit rate.

The cache itself was implemented using a state machine which tracks what needs to be done by moving through the stages before outputting the correctly fetched value or writing the correct block in memory and awaiting the next instruction. There is logic in the hazard detection to make sure that if there is a delay, from not getting a cache hit or from a write instruction, the pipeline is stalled until this instruction is executed fully. We have not implemented out of order execution.

## Next Steps

If given more time there are two features that would be very interesting to implement. Including out of order execution would certainly speed up the CPU as we could have the cache operating somewhat independently of the main CPU. For example if a write instruction was followed by many register instructions we would not have to stall as the cache could write memory while the register instructions happen in parallel. Another very interesting feature would be pre-fetching instructions. This would be a huge speedup as it would allow us to massively improve our hit rate. With the sample program in particular this would be an 100% hit rate as the plotting of the distribution is massively predictable. This would be the most intersting feature as writing an effective algorithm would be a fascinating challenge.

# Proof

Here is a video showing that the cache CPU will work for both the f1 program and distributions.

[Distribution](../../../../Downloads/IMG_9483.HEIC)

[F1](../../../../Downloads/IMG_9484.mov)