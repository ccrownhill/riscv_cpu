# Contribution Report

This includes the individual contributions.

## Xiaoyang Xu (X454XU)

Modules mainly edited:

* `Mux8`
* `Mux16`

Coauthoring:

* `MainDecoder`

I assigned the value to RegWrite_o, ImmSrc_o, ALUsrc_o, WriteSrc_o, ALUOp_o, MemWrite_o, Branch_o, Jump_o, Ret_o according to the indices from the book Digital Design and Computer Architecture by S. Harris & D. Harris. I did enconter difficulties while dealing with the U-type instructions. I solved this with the help from my teammate Constantin, and the solution is add extra bits to distinguish it from others.  

## Constantin Kronbichler (ccrownhill)

Modules mainly edited:

* `ControlPath`
* `ALUDecoder`
* `InstrLoad`
* `Mux2/3/4`
* `Adder`
* `PCsrcDecode`
* `RegAsyncR`
* `ZeroExtend`

Coauthoring

* `MainDecode`
* `DataPath`
* `SignExtend`
* `riscvsingle.sv`
* `riscvsingle_dist_tb.cpp`/`riscvsingle_f1_tb.cpp`

Also responsible for:

* Creating `Makefile` to run both F1 light and PDF test in more automated fashion
* Create Python scripts for converting memory files to CSV for plotting PDFs in Excel and other uses

Summary of my involvement:

* In the initial Lab 4 I wrote the ControlUnit
* Later I created the top level file `ControlPath` to include the PC register, the instruction memory and the decoding logic
* To properly decode functions I wrote the `ALUDecode` and `PCsrcDecode` modules to further decode the output from `MainDecode` (I also supported Xiaoyang to write this file by discussing its requirements according the ISA specification)
* The other big thing I worked on was changing all the top level modules (`ControlPath`, `DataPath`, etc.) for the JAL and JALR instructions.
I did this by adding more MUXes to make sure the right data was written to the register file
(for example when saving PC+4 as the return address) or to enable loading
the next value for PC from the ALUout (for JALR)
* Smaller co-authoring edits:
	* added immediate encoding for U-type instructions to `SignExtend`
	* worked together with rest of Team to debug our code and run the tests


## Orlan Forshaw (ManofRenown)
Main Modules:
* `SignExtend.sv` (fully my work)
* `Cache.sv` (fully my design and work)
* `ofpipe` (all not found in single cycle) (available in ofpipe branch)

	
Other Contributions:
	I generated the final excel diagrams which demonstrate the expected values of the distributions. 
  This required calculating the frequency of each value between 0 and 255 and then plotting these as line graphs.
  I also created the section of the README with links and brief descriptions of these images. 
		NOTE: Constantins script to convert the data into one long column was very helpful in doing this.

  I also created a formatting script `TabRemove.py` which is to help keep formatting consistent across the project. 
  This script takes in any number of files as arguments and then formats them so that no tab characters are used in the whole document. 
  It also removes all trailing whitespace and replaces any instances of leading 4 spaces with leading 2 spaces as this was the formatting the team agreed upon.
  
  I was also involved in resolving merge conflicts across the project when the arose. 
  However these were usually minor issues and we managed to work together effectively as a team to prevent them.

  I was also involved with testing and making sure the project was actually working throughout the design.


## Yixu Pan (YixuPan)

Responsible for:

* `Mainmemory.sv`
  I wrote was for the data cache design. For reading data once cache miss, it fetch data from the main memory to the cache and replace some original data of cache. And for writing data, as we apply both the write-back policy and write-through policy in different version, the write instruction will only happen when data replaced or modified in the cache for write-back and always write in write through. The code was designed to control with cache valid bit and write enable signal, It will return the block size read out and a ready signal to tell whether the memory data is ready for another read or write operation.
* `MemExtend.sv`
  I wrote are used for the Main memory to be able to do the load and store instructions which apply basicly the same principle with the data memory we have for the single-cycle and the pipelined RISC-V. However unfortunately, as our cache use load byte only on design purpose, some of my code has been deleted didn't include all the load and store RV32I instruction in this data cache design.
* `DataMem.sv`
  I was responsible for the data memory which enables the data to be store and access. It was designed to have synchronous writting operation and asynchronous reading operation, which controled by the MemWrite and addressport. The write instruction only take 1 byte to store in the data memory and read instruction also take 1 byte to the register file every cycle. The data memory enable all the store and load RV32I instructions.
* `ALU.sv`
  I was responsable for the ALU of the datapath. It was initially designed to only deal add and sub operations in lab 4 but later project requies more, so I edit it to deal with several operations which are arithmetic, logical, comparision bit shifting. These operations are controled by the 3 bit ALUctrl and differents operations are allocated according to the RV32I:RISC-V integer instructions.
* `Regfile.sv`
  I was responsible for the register file of the datapath. This was designed with synchonous writting and asyhconous reading operations. It assign output a0 with the x10 register and simply work as a temporary storage with fast access.
* `DirectMappedCache.sv` and `SetAssociativeCache.sv`
  (only at branch Pan)
  I have wrote the basic structure with both Direct-mapped and set-associative cache before our group work out our final design and this two file can be partly referrence of the structure of the cache and it shows my initial and general understanding before our group discussion. As they are design of general structure of cache, these two version of cache have not build connection with main memory on the code.

Partly Responsable for:

* `DataPath`
  I was initially designed the datapath module as a top level and improve integrity includeds register file, ALU, MUX and later data memory, thus to generate a more clear design hierarchy. This part is later used in the risc-v top level same as the controlpath. (Constantin later edit it to handle more instructions.)
* `Mux2`
  This is simply involved in the datapath and Constantin later unified format for all Mux.

Other contributions:

* Lab 4: I made the DataPath part and it was imported to the project with more edited features such as datamemory and 3-bit ALU.
* I wrote explanation and comments of the F1-FSM assembly language program wroted by our group, and this illustrate how each function works and logic behind them. 
* Test all the RV32I: RISC-V integer instructions with assembly testing program.
