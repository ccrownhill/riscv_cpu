# Make file to assembly RISC-V assembly language program(s) in myprog folder
#   ... relocate instruction to start at 0xBFC00000
#   ... output hex file ready to be read into instruction memory

clean:
	@rm -f *.hex *.asm *.out *.bin

reference: pdf.s
	@riscv64-unknown-elf-as -R -march=rv32im -mabi=ilp32 -o pdf.out pdf.s
	@riscv64-unknown-elf-ld -melf32lriscv -e 0xBFC00000 -Ttext 0xBFC00000 -o pdf.out.reloc pdf.out
	@riscv64-unknown-elf-objcopy -O binary -j .text pdf.out.reloc pdf.bin
	@riscv64-unknown-elf-objdump -D -S -l -F -Mno-aliases pdf.out.reloc > pdf.asm
	@set -euo pipefail
	@od -v -An -t x1 pdf.bin | tr -s '\n' | awk '{pdf=pdf};1' > pdf.hex
	@rm pdf.out
	@rm pdf.out.reloc
	@rm pdf.bin
