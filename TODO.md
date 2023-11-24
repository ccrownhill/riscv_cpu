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
slli
srli
andi
xor
```

* Set memory sizes as in given memory map

* For Control Unit:
	* ALUControl now 3 bits (see table from Harris and Harris for which values to use)
		* xor: 100 (rest as in Harris&Harris p. 409)
		* sll: 110
		* srl: 111
	* ImmSrc now 2 bits (see table from Harris and Harris)
