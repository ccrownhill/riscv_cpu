# Pipelining without hazard detection unit

Add pipeline registers to create five stages:

* Instruction Fetch (IF)
* Instruction Decode (ID)
* Execute (EX)
* Memory (MEM)
* Write Back (WB)

How to make `pdf.s` run with inserting nops:

* 3 `nop`s after normal arithmetic instruction
* 4 `nop`s after branching instructions
