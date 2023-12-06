SRCPATH = "../rtl"

all: gtkwave

clean:
	rm -rf obj_dir
	rm -rf riscvpipe.vcd

warnings:
	verilator -Wall -I$(SRCPATH) --cc --trace $(SRCPATH)/riscvpipe.sv

%_tb.cpp: clean
	verilator -Wall -Wno-UNUSED -Wno-WIDTH -I$(SRCPATH) --cc --trace $(SRCPATH)/riscvpipe.sv --exe $@
	make -j -C obj_dir/ -f Vriscvpipe.mk Vriscvpipe
	obj_dir/Vriscvpipe

%.mem: clean riscvpipe_dist_tb.cpp
	cp pdf.mem instructions.mem
	cp $@ data.mem
	obj_dir/Vriscvpipe

f1: clean riscvpipe_f1_tb.cpp
	cp f1light.mem instructions.mem
	obj_dir/Vriscvpipe

gtkwave: clean riscvpipe_simple_tb.cpp
	obj_dir/Vriscvpipe
#	gtkwave riscvpipe.vcd


.PHONY: clean all f1 gtkwave warnings
