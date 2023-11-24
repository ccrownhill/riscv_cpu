# Team 11 repo

## Lab 4 - Reduced-RISC-V

We successfully conquered the challenge and displayed a sine wave on the Vbuddy as shown below.

![WechatIMG404](https://github.com/ccrownhill/Team11/assets/109323873/705e8ab0-2214-4310-bf9a-81d820b735e8)


# Team Project Logbook

## Objectives

1. To learn RISC-V 32-bit integer instruction set architecture
2. To implememnt a single-cycle RV32I instruction set in a microarchitecture
3. To implemententing the F1 starting light algorithm in RV32I assembly language
4. To verify your RV32I design by executing the F1 light program
5. As stretched goal, to implement a simple pipelined version of the microarchitecutre with hazard detection and mitigation
6. As a further stretched goal, add data cache to the pipelined RV32I

## Learning the RV32I Instrction Set

Before Hardware design, Our team creat the assembly language program to implement the F1 starting light algorithms:

```
.text
.equ NORMAL_DELAY, 24
.equ NLIGHTS, 0xff
.equ SREG_INIT, 0b1111111

main:
	jal ra, init              # jump to init, ra and save position to ra
forever:
	j forever

init:        # function for initialise the output a0 and delay buffer
	li a0, 0
	li s1, NLIGHTS
	bne s0, zero, light_on    # if random delay = zero
	li s0, SREG_INIT          # then initial the delay 
	j light_on                # jump to light_on

light_on:   # function for modify the output a0 and reset
	li a1, NORMAL_DELAY
	jal ra, count_down
	slli a0, a0, 1            # left shift to make the next light on
	addi a0, a0, 1            # add 1 to make sure first light on after shift
	bne a0, s1, light_on      # check if all lights is on 
	jal ra, lfsr              # jump to lfsr if all lights on
	add a1, s0, zero          # assign the a1 count down buffer with random delay s0
	jal ra, count_down
	li a0, 0
	ret

count_down: # function for countdown the delay of each light goes on
	addi a1, a1, -1
	bne zero, a1, count_down  # count down until 0
	ret

lfsr:       # function for modify the random delay of lights off
	slli s0, s0, 1            # shift left by 1
	srli t0, s0, 7            # get bit 6 of s0
	srli t1, s0, 3            # get bit 2 of s0
	andi t1, t1, 1            # make the t1 to 1 bit
	xor t0, t1, t0            
	add s0, s0, t0            # add the xor result to the last bit
	andi s0, s0, SREG_INIT    # make the s0 back to 7 bits
	ret
```

The program firstly initial a delay between each light on and start the light_on function to allow lights on continuously by using shift left 1 bit and add 1 bit until all lights is on and then countdown a random delay s1 to turn off all lights. 