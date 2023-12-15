SRCPATH = "../rtl"

all: gtkwave

clean:
	rm -rf obj_dir
	rm -rf riscvpipe.vcd

%.hex: %.s
	riscv64-unknown-elf-as -R -march=rv32im -mabi=ilp32 -o ins.out $^
	@riscv64-unknown-elf-ld -melf32lriscv -e 0xBFC00000 -Ttext 0xBFC00000 -o ins.out.reloc ins.out
	@riscv64-unknown-elf-objcopy -O binary -j .text ins.out.reloc ins.bin
	@od -v -An -t x4 -w4 ins.bin | tr -s '\n' | sed "s/ //g" > $@ #| sed "s/^ //" | rev | sed "s/ /\n/g" | rev | paste -d" " - - - - | sed "s/ //g" > $@
	@echo "" >> $@
	cp $@ instructions.mem

warnings:
	verilator -Wall -I$(SRCPATH) --cc --trace $(SRCPATH)/mem_pkg.sv $(SRCPATH)/riscvpipe.sv

%_tb.cpp: clean
	verilator -Wall -Wno-UNUSED -Wno-UNOPTFLAT -Wno-SELRANGE -Wno-ALWCOMBORDER -Wno-WIDTH -I$(SRCPATH) --cc --trace $(SRCPATH)/mem_pkg.sv $(SRCPATH)/riscvpipe.sv --top-module riscvpipe --exe $@
	make -j -C obj_dir/ -f Vriscvpipe.mk Vriscvpipe

%.mem: pdf.hex riscvpipe_dist_tb.cpp
	cp $@ data.mem
	../utilscripts/mem_to_block.py 16 data.mem data.mem
	obj_dir/Vriscvpipe

f1: f1_light.hex riscvpipe_f1_tb.cpp
	cp f1_light.hex instructions.mem
	obj_dir/Vriscvpipe

gtkwave: riscvpipe_simple_tb.cpp
	obj_dir/Vriscvpipe
	gtkwave riscvpipe.vcd


.PHONY: clean all f1 gtkwave warnings
