# What we need to do

## Single Cycle processor

* Instructions to implement (from `pdf.asm`)

```
jal
jalr
addi
add
sb
bne
lui
lbu
```

* Set memory sizes as in given memory map
* Create F1 assembly program; ideas:
	* subroutine for random number generation

* For Control Unit:
	* ALUControl now 3 bits (see table from Harris and Harris for which values to use)
	* ImmSrc now 2 bits (see table from Harris and Harris)

* Possible division into 4 parts:
	1. Modify control unit for new instructions
	1. Modify branching logic to implement JAL
	1. Change memory to allow byte loading
	1. Integrate and test it
