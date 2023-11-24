all: f1

clean:
	rm -rf obj_dir
	rm -rf riscvsingle.vcd

%.mem: clean riscvsingle_dist_tb.cpp
	cp ../test/pdf.mem instructions.mem
	cp $@ data.mem
	verilator -Wall -Wno-UNUSED -Wno-WIDTH --cc --trace riscvsingle.sv --exe riscvsingle_dist_tb.cpp
	make -j -C obj_dir/ -f Vriscvsingle.mk Vriscvsingle
	obj_dir/Vriscvsingle

f1: clean riscvsingle_f1_tb.cpp
	cp ../test/f1light.mem instructions.mem
	verilator -Wall -Wno-UNUSED -Wno-WIDTH --cc --trace riscvsingle.sv --exe riscvsingle_f1_tb.cpp
	make -j -C obj_dir/ -f Vriscvsingle.mk Vriscvsingle
	obj_dir/Vriscvsingle


.PHONY: clean all distrib f1
