# IAC Coursework Autumn 2023

## Personal Statement

## Main Work
SignExtend.sv
cache.sv
InstrMem.sv
README.md (all)
solving merge conflicts
Testing
Ofpipe

cache.sv:
  I was in charge of making the cache for our caching version. This required a lot of planning and communication. Overall I had to come up with a deisgn for the cache based on our agreed specification which I suggested and we discussed as a team. I implemented structs in system verilog for a cache line and for inputs and outputs in the cache module. This was to make it easier to keep track of signals and where they would be coming on. The design of the cache as a whole was almost entirely my own deisgn. The only final input from Constantin was some bug fixes and adding a shift register to track the last used way instead of using a pseudo random approach. However the byte addressing idea was entirely my own work and the implementation of this using a mux 16 and decoded was my own work. The state machine design was also mine which involves using 4 states to split the work of the cache into 4 stages. This means that accessing data in the cache is incredibly fast but writing data takes slightly longer with a maximum of 4 cycles as our largest delay. This is still massively faster than main memory and so should allow a large improvement. The design took a large amount of time to plan out and implement. After a lot of revisement and testing I was able to create a fully working byte addressable version. 

Testing/Conflicts:  
  I was involved in the testing of the cached version as a whole. I worked closely with Constantin towards the end to obtain the proof videos and correct some last mistakes. We also together implemented some improvements to the final cache design to hopefully make it faster and reduce the amount of cycles it takes to write and read from the cache. Throughout the design process there were times where conflicts occured and had to be sorted. I was mainly the one doing this and fixing any issues from multiple people editing the same files. These were usually small changes but some required larger levels of input.

OfPipe:
  as Constantin completed most of the pipelining work mostly I felt that I should make my own version to further my understanding. Ofpipe is included as a branch in the repo. It contain my version of a pipelined CPU that can deal with forwarding however I decided to move on to caching before implementing stalls into my pipeline. I was happy with the results of this and it worked with nop instructions in my testing. Since it was not going to be included in the final design extensive testing was not done so there will be bugs. But I was happy with the results I achieved and I learnt lots about pipelining from implementing my own.
  

SignExtend.sv:
  decoding of the instruction word. 
  There were 5 cases where immediates where formed differently. Namely I S B J U Instruction types. 
  These all formed the immediate from different bits of the word which needed to be concatenated together. 
  The sign extending was achieved by repeating the most significant bit of the immediate an appropriate amount of times to form a 32 bit value. This value is then outputted by the module.
		Note: I was not aware at the start that we would be using U instructions so this was implemented by Constantin.

InstrMem.sv:
  There were some issues with this module that required fixing. I found them while doing some testing of the design and fixed some small mistakes in this and a couple other modules. However these were minor errors such as selecting the wrong bits from a signal.

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
