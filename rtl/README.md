# Contribution Report

This includes the individual contributions.

## Xiaoyang Xu (X454XU)

Mainly responsible for the MainDecoder. I assigned the value to RegWrite_o, ImmSrc_o, ALUsrc_o, WriteSrc_o, ALUOp_o, MemWrite_o, Branch_o, Jump_o, Ret_o according to the indices from the book Digital Design and Computer Architecture by S. Harris & D. Harris. I did enconter difficulties while dealing with the U-type instructions. I solved this with the help from my teammate Constantin, and the solution is add extra bits to distinguish it from others.  

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


## Orlan Forshaw (ManofRenown)
Main Modules:
SignExtend.sv:
	This was almost entirely my own work. It involved handling the 5 instruction types we were going to be using and forming a 32 bit immediate value from the decoding of the instruction word. 
  There were 5 cases where immediates where formed differently. Namely I S B J U Instruction types. 
  These all formed the immediate from different bits of the word which needed to be concatenated together. 
  The sign extending was achieved by repeating the most significant bit of the immediate an appropriate amount of times to form a 32 bit value. This value is then outputted by the module.
		Note: I was not aware at the start that we would be using U instructions so this was implemented by Constantin.
Lab 4: I made the Program Counter 
	this was used in Lab 4 but could not be imported to the larger coursework as a whole unfortunately.
	
Other Contributions:
	I generated the final excel diagrams which demonstrate the expected values of the distributions. 
  This required calculating the frequency of each value between 0 and 255 and then plotting these as line graphs.
  I also created the section of the README with links and brief descriptions of these images. 
		NOTE: Constantins script to convert the data into one long column was very helpful in doing this.

	I also created a formatting script <TabRemove.py> which is to help keep formatting consistent across the project. 
  This script takes in any number of files as arguments and then formats them so that no tab characters are used in the whole document. 
  It also removes all trailing whitespace and replaces any instances of leading 4 spaces with leading 2 spaces as this was the formatting the team agreed upon.
  
  I was also involved in resolving merge conflicts across the project when the arose. 
  However these were usually minor issues and we managed to work together effectively as a team to prevent them.


