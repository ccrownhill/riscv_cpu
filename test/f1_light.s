.text
.equ NORMAL_DELAY, 10
.equ NLIGHTS, 0xff
.equ SREG_INIT, 0b1111

main:
	jal ra, init
forever:
	j forever

init:
	li a0, 0
	li s1, NLIGHTS
	bne s0, zero, light_on
	li s0, SREG_INIT
	j light_on

light_on:
	li a1, NORMAL_DELAY
	jal ra, count_down
	slli a0, a0, 1
	addi a0, a0, 1
	bne a0, s1, light_on
	jal ra, lfsr
	add a1, s0, zero
	jal ra, count_down
	li a0, 0
	ret

count_down:
	addi a1, a1, -1
	bne zero, a1, count_down
	ret

lfsr:
	slli s0, s0, 1
	srli t0, s0, 4 # get bit 3
	srli t1, s0, 3 # get bit 2
	andi t1, t1, 1
	xor t0, t1, t0
	add s0, s0, t0
	andi s0, s0, SREG_INIT
	ret
