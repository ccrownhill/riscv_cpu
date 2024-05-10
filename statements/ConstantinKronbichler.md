# Personal Statement: Constantin Kronbichler

This personal statement does not contain that much info on how I designed certain
parts because this is mostly covered in

* [root directory README](../README.md) (where I explain my pipelining and multilevel caching implementation)
* [rtl directory README](../rtl/README.md#constantin-kronbichler-ccrownhill) (where I list which modules I mainly designed.

## Summary of my involvement

### SystemVerilog

While working on some part of the CPU like every one else I was usually mostly
responsible for integrating everything and fixing bugs to make it work.

I really liked to do this because finding mistakes across all modules gave me a
very deep understanding of the whole CPU.

My biggest contributions were: (see [root directory README](../README.md) for documentation of how I approached them)

* implementation of pipelining with forwarding and hazard detection (includes stalls and simple branch prediction)
* implementation of write back cache
* implementation of multilevel caching with unified instruction and data main memory/L2 cache and split L1 cache (one for instructions and one for data); The most challenging aspect was to keep the two L1 caches coherent.

### Git

Other than that my knowledge of git and Github made me responsible for teaching everyone how to best contribute.

For this purpose I also wrote the [CONTRIBUTING.md](../CONTRIBUTING.md) to give everyone a quick lookup resource on how to do basic things with git.

### Scripting and Makefile

I wrote almost all of the Python scripts in `utilscripts` (to convert hex data in the correct block size format or check distribution outputs exactly).

Moreover, I was the creator of our `Makefile` (in `test` directory) used for testing the CPU in all scenarios.

Note that the usage of the Makefile is also documented in the [root directory README](../README.md#running-with-the-makefile).

## Single Cycle CPU contributions


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


## Pipelining, Single Level Caching, and Multilevel caching as von Neumann architecture

I described all of this in the [root directory README](../README.md)

Note that I also wrote a test bench for testing the cache and main memory separately in the `memtest` directory.

The SystemVerilog files in there are now outdated but it was very useful to have a simplified testing environment to find all problems in the memory modules before integrating them with the rest of the CPU.
