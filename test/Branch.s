main:
  li t0, 6
  li t1, 5
  li t4, 10
  li t5, 0

  blt t0, t1, Smaller
  li t2, 0
  bge t0, t1, Bigger_or_Equal
  bne t0, t4, not_EQ
  j end_test

Bigger_or_Equal:
  li t2, 1
  beq t0, t1, EQ
  li t3, 1 
  j end_test
Smaller:
  li t3, 0
EQ:
  li t3, 0
not_EQ:
  li t5, 1

end_test:
# t2,t3,t5 = 001 if t0 smaller than t1
# t2,t3,t5 = 100 if t0 equal to t1
# t2,t3,t5 = 111 if t0 is bigger than t1
  