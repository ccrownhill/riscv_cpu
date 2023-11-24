# Contribution Report

This includes the individual contributions.

## Xiaoyang Xu (X454XU)

Coauthoring:

* `MainDecoder`

I assigned the value to RegWrite_o, ImmSrc_o, ALUsrc_o, WriteSrc_o, ALUOp_o, MemWrite_o, Branch_o, Jump_o, Ret_o according to the indices from the book Digital Design and Computer Architecture by S. Harris & D. Harris. I did enconter difficulties while dealing with the U-type instructions. I solved this with the help from my teammate Constantin, and the solution is add extra bits to distinguish it from others.  

## Constantin Kronbichler (ccrownhill)

Modules mainly edited:

* `ControlPath`
* `ALUDecoder`
* `InstrLoad`
* `DataPath`
* `Mux2/3/4`
* `Adder`
* `PCsrcDecode`
* `RegAsyncR`
* `ZeroExtend`

Coauthoring

* `MainDecode`
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
