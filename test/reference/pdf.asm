
pdf.out.reloc:     file format elf32-littleriscv


Disassembly of section .text:

bfc00000 <main> (File Offset: 0x1000):
main():
bfc00000:	010000ef          	jal	ra,bfc00010 <init> (File Offset: 0x1010)
bfc00004:	020000ef          	jal	ra,bfc00024 <build> (File Offset: 0x1024)

bfc00008 <forever> (File Offset: 0x1008):
forever():
bfc00008:	050000ef          	jal	ra,bfc00058 <display> (File Offset: 0x1058)
bfc0000c:	ffdff06f          	jal	zero,bfc00008 <forever> (File Offset: 0x1008)

bfc00010 <init> (File Offset: 0x1010):
init():
bfc00010:	10000593          	addi	a1,zero,256

bfc00014 <_loop1> (File Offset: 0x1014):
_loop1():
bfc00014:	fff58593          	addi	a1,a1,-1
bfc00018:	10058023          	sb	zero,256(a1)
bfc0001c:	fe059ce3          	bne	a1,zero,bfc00014 <_loop1> (File Offset: 0x1014)
bfc00020:	00008067          	jalr	zero,0(ra)

bfc00024 <build> (File Offset: 0x1024):
build():
bfc00024:	000105b7          	lui	a1,0x10
bfc00028:	00000613          	addi	a2,zero,0
bfc0002c:	10000693          	addi	a3,zero,256
bfc00030:	0c800713          	addi	a4,zero,200

bfc00034 <_loop2> (File Offset: 0x1034):
_loop2():
bfc00034:	00c587b3          	add	a5,a1,a2
bfc00038:	0007c283          	lbu	t0,0(a5)
bfc0003c:	00d28833          	add	a6,t0,a3
bfc00040:	00084303          	lbu	t1,0(a6)
bfc00044:	00130313          	addi	t1,t1,1
bfc00048:	00680023          	sb	t1,0(a6)
bfc0004c:	00160613          	addi	a2,a2,1
bfc00050:	fee312e3          	bne	t1,a4,bfc00034 <_loop2> (File Offset: 0x1034)
bfc00054:	00008067          	jalr	zero,0(ra)

bfc00058 <display> (File Offset: 0x1058):
display():
bfc00058:	00000593          	addi	a1,zero,0
bfc0005c:	0ff00613          	addi	a2,zero,255

bfc00060 <_loop3> (File Offset: 0x1060):
_loop3():
bfc00060:	1005c503          	lbu	a0,256(a1) # 10100 <base_data+0x100> (File Offset: 0xffffffff40411100)
bfc00064:	00158593          	addi	a1,a1,1
bfc00068:	fec59ce3          	bne	a1,a2,bfc00060 <_loop3> (File Offset: 0x1060)
bfc0006c:	00008067          	jalr	zero,0(ra)

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes> (File Offset: 0x1070):
   0:	1e41                	.2byte	0x1e41
   2:	0000                	.2byte	0x0
   4:	7200                	.2byte	0x7200
   6:	7369                	.2byte	0x7369
   8:	01007663          	bgeu	zero,a6,14 <max_count-0xb4> (File Offset: 0x1084)
   c:	0014                	.2byte	0x14
   e:	0000                	.2byte	0x0
  10:	7205                	.2byte	0x7205
  12:	3376                	.2byte	0x3376
  14:	6932                	.2byte	0x6932
  16:	7032                	.2byte	0x7032
  18:	5f30                	.2byte	0x5f30
  1a:	326d                	.2byte	0x326d
  1c:	3070                	.2byte	0x3070
	...
