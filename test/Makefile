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

%.hex: %.dist
	../utilscripts/mem_to_block.py 16 $^ $@
	@echo "" >> $@ # insert newline

warnings:
	verilator -Wall -I$(SRCPATH) --cc --trace $(SRCPATH)/mem_pkg.sv $(SRCPATH)/riscvpipe.sv

%_tb.cpp: clean
	verilator -Wall -Wno-UNUSED -Wno-UNOPTFLAT -Wno-SELRANGE -Wno-ALWCOMBORDER -Wno-WIDTH -I$(SRCPATH) --cc --trace $(SRCPATH)/mem_pkg.sv $(SRCPATH)/riscvpipe.sv --top-module riscvpipe --exe $@
	make -j -C obj_dir/ -f Vriscvpipe.mk Vriscvpipe

gaussian: distributions/gaussian.hex riscvpipe_dist_tb.cpp
	cp distributions/gaussian.hex data.mem
	obj_dir/Vriscvpipe

sine: distributions/sine.hex riscvpipe_dist_tb.cpp
	cp distributions/gaussian.hex data.mem
	obj_dir/Vriscvpipe

noisy: distributions/noisy.hex riscvpipe_dist_tb.cpp
	cp distributions/gaussian.hex data.mem
	obj_dir/Vriscvpipe

triangle: distributions/triangle.hex riscvpipe_dist_tb.cpp
	cp distributions/gaussian.hex data.mem
	obj_dir/Vriscvpipe

f1: f1_light.hex riscvpipe_f1_tb.cpp
	cp f1_light.hex instructions.mem
	obj_dir/Vriscvpipe

gtkwave: riscvpipe_simple_tb.cpp
	obj_dir/Vriscvpipe
	gtkwave riscvpipe.vcd


.PHONY: clean all gaussian sine noisy triangle f1 gtkwave warnings
